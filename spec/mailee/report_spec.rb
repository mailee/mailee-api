require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailee::MessageStatistic" do
  let(:fixtures) { JSON.parse(File.read("./spec/fixtures.json"))}
  before do
    stub_api_for(Mailee::MessageStatistic) do |stub|
      stub.get("/v2/reports/1") { |env| [200, {}, fixtures["reports"]["default"].to_json] }
      stub.get("/v2/reports/1/unsubscribes") { |env| [200, {}, fixtures["reports"]["unsubscribes"].to_json] }
    end
  end
  let(:ms) { Mailee::MessageStatistic.find(1) }
  describe :find do
    it { expect(ms.attributes).to eq(clear(fixtures["reports"]["default"])) }
  end
  describe :unsubscribes do
    it { expect(ms.unsubscribes).to eq(clear(fixtures["reports"]["unsubscribes"])) }
  end
end
