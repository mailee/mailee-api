require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailee::Contact" do
  let(:fixtures) { JSON.parse(File.read("./spec/fixtures.json"))}
  before do
    stub_api_for(Mailee::Contact) do |stub|
      stub.get("/v2/contacts/1") { |env| [200, {}, fixtures["contacts"]["default"].to_json] }
      stub.post("/v2/contacts") { |env| [200, {}, fixtures["contacts"]["created"].to_json] }
      stub.get("/v2/contacts") { |env| [200, {}, [fixtures["contacts"]["default"]].to_json] }
      stub.put("/v2/contacts/1/list_subscribe") { |env| [200, {}, fixtures["lists"]["default"].to_json] }
      stub.put("/v2/contacts/1/list_unsubscribe") { |env| [200, {}, fixtures["lists"]["default"].to_json] }
    end
  end

  describe :find do
    let(:contact) { Mailee::Contact.find(1).attributes }
    it { expect(contact).to eq(clear(fixtures["contacts"]["default"])) }
  end

  describe :find_by do
    let(:contact) { Mailee::Contact.find_by(email: "pedro@mailee.me")[0].attributes }
    it { expect(contact).to eq(clear(fixtures["contacts"]["default"])) }
  end

  describe :create do
    let(:contact) { Mailee::Contact.create(email: "t1@mailee.me").attributes }
    it { expect(contact).to eq(clear(fixtures["contacts"]["created"])) }
  end

  describe :all do
    let(:contact) { Mailee::Contact.all }
    it { expect(contact.first.attributes).to eq(clear(fixtures["contacts"]["default"])) }
  end

  describe :list_subscribe do
    let(:contact) { Mailee::Contact.find(1) }
    context "by list_id" do
      subject { contact.list_subscribe list_id: 1 }
      it { should be(true) }
    end
    context "by name" do
      subject { contact.list_subscribe list_name: "AAAA" }
      it { should be(true) }
    end
    context "by id" do
      subject { contact.list_subscribe 1 }
      it { should be(true) }
    end
    context "with errors" do
      before do
        stub_api_for(Mailee::Contact) do |stub|
          stub.get("/v2/contacts/1") { |env| [200, {}, fixtures["contacts"]["default"].to_json] }
          stub.put("/v2/contacts/1/list_subscribe") { |env| [200, {}, fixtures["lists"]["error"].to_json] }
        end
      end
      subject { contact.list_subscribe list_id: 1 }
      it { expect{subject}.to raise_error(RuntimeError, fixtures["lists"]["error"]["error"]) }
    end
  end
  describe :list_unsubscribe do
    let(:contact) { Mailee::Contact.find(1) }
    context "by list_id" do
      subject { contact.list_unsubscribe list_id: 1 }
      it { should be(true) }
    end
    context "by name" do
      subject { contact.list_unsubscribe list_name: "AAAA" }
      it { should be(true) }
    end
    context "by id" do
      subject { contact.list_unsubscribe 1 }
      it { should be(true) }
    end
  end
  describe :unsubscribe do
    before do
      stub_api_for(Mailee::Contact) do |stub|
        stub.get("/v2/contacts/1") { |env| [200, {}, fixtures["contacts"]["default"].to_json] }
        stub.put("/v2/contacts/1/unsubscribe") { |env| [200, {}, fixtures["contacts"]["unsubscribe"].to_json] }
      end
    end
    let(:contact) { Mailee::Contact.find(1) }
    subject { contact.unsubscribe }
    it { should be(true) }
  end
end
