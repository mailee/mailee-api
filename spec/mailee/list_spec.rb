require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailee::List" do
  before do
    stub_api_for(Mailee::Contact) do |stub|
      stub.get("/v2/contacts/1") { |env| [200, {}, fixtures["contacts"]["default"].to_json] }
      stub.put("/v2/contacts/1/list_subscribe") { |env| [200, {}, fixtures["lists"]["error"].to_json] }
    end
  end
  let(:fixtures) { JSON.parse(File.read("./spec/fixtures.json"))}
  before do
    stub_api_for(Mailee::List) do |stub|
      stub.get("/v2/lists/1") { |env| [200, {}, fixtures["lists"]["default"].to_json] }
      stub.post("/v2/lists") { |env| [200, {}, fixtures["lists"]["default"].to_json] }
    end
  end
  describe :find do
    let(:contact) { Mailee::List.find(1).attributes }
    it { expect(contact).to eq(clear(fixtures["lists"]["default"])) }
  end
  describe :create do
    let(:contact) { Mailee::List.create(name: "Bar").attributes }
    it { expect(contact).to eq(clear(fixtures["lists"]["default"])) }
  end
end
