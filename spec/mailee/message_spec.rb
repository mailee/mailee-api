require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailee::Message" do
  let(:fixtures) { JSON.parse(File.read("./spec/fixtures.json"))}
  describe :create do
    context "without errors" do
      before do
        stub_api_for(Mailee::Message) do |stub|
          stub.post("/v2/messages") { |env| [200, {}, fixtures["messages"]["default"].to_json] }
          stub.get("/v2/messages/551700") { |env| [200, {}, fixtures["messages"]["default"].to_json] }
        end
      end
      let(:message) { Mailee::Message.create title: "test1", subject:  "test1", from_name: "test1", from_email: "hello@test.com", html: "<h1>Hello World</h1>", list_ids: 26171 }
      it { expect(message.id).to eq(551700) }
      it { expect(message.errors).to eq({}) }

    end
    context "with errors" do
      before do
        stub_api_for(Mailee::Message) do |stub|
          stub.post("/v2/messages") { |env| [200, {}, fixtures["messages"]["error"].to_json] }
        end
      end
      let(:message) { Mailee::Message.create title: "test1", subject:  "test1", from_name: "test1", from_email: "hello@test.com", html: "<h1>Hello World</h1>" }
      it { expect(message.errors).to eq(lists: ["can't be blank"]) }
    end
  end
  describe :send_tests do
    before do
      stub_api_for(Mailee::Message) do |stub|
        stub.get("/v2/messages/551700") { |env| [200, {}, fixtures["messages"]["default"].to_json] }
        stub.put("/v2/messages/551700/test") { |env| [200, {}, fixtures["messages"]["send_tests"].to_json] }

      end
    end
    let(:message) { Mailee::Message.find(551700) }
    subject { message.send_tests 1 }
    it { should_not be_empty  }
  end
  describe :ready do
    context "send now" do
      before do
        stub_api_for(Mailee::Message) do |stub|
          stub.get("/v2/messages/551700") { |env| [200, {}, fixtures["messages"]["default"].to_json] }
          stub.put("/v2/messages/551700/ready") { |env| [200, {}, fixtures["messages"]["sent"].to_json] }
        end
      end
      let(:message) { Mailee::Message.find(551700).ready }
      it { expect(message["id"]).to eq(551700) }
      it { expect(message["status"]).to eq(4) }
      it { expect(message["send_when"]).to eq('now') }
    end
    context "send after" do
      before do
        stub_api_for(Mailee::Message) do |stub|
          stub.get("/v2/messages/551700") { |env| [200, {}, fixtures["messages"]["default"].to_json] }
          stub.put("/v2/messages/551700/ready") { |env| [200, {}, fixtures["messages"]["scheduled"].to_json] }
        end
      end
      let(:message) { Mailee::Message.find(551700).ready "2014-06-11", "20:44" }
      it { expect(message["id"]).to eq(551700) }
      it { expect(message["status"]).to eq(4) }
      it { expect(message["send_when"]).to eq('after') }
    end
  end
end
