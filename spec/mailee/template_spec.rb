require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailee::Template" do
  let(:fixtures) { JSON.parse(File.read("./spec/fixtures.json"))}
  before do
    stub_api_for(Mailee::Template) do |stub|
      stub.post("/v2/templates") { |env| [200, {}, fixtures["templates"]["default"].to_json] }
      stub.get("/v2/templates/1") { |env| [200, {}, fixtures["templates"]["default"].to_json] }
      stub.get("/v2/templates") { |env| [200, {}, [fixtures["templates"]["default"]].to_json] }
    end
  end
  describe :find do
    let(:template) { Mailee::Template.find(1).attributes }
    it { expect(template).to eq(clear(fixtures["templates"]["default"])) }
  end
  describe :create do
    let(:template) { Mailee::Template.create(title: "New Template").attributes }
    it { expect(template).to eq(clear(fixtures["templates"]["default"])) }
  end
  describe :get do
    let(:template) { Mailee::Template.all[0].attributes }
    it { expect(template).to eq(clear(fixtures["templates"]["default"])) }
  end
end
