require "spec_helper"

describe ApplicationHelper do
  describe "#service_name_by_id" do
    let(:service_id) { 1 }
    let(:service_name) { FFaker::Company.name }

    it "when there is no matching service it returns the id" do
      session[:services] = []
      expect(helper.service_name_by_id(service_id)).to eq service_id
    end

    it "when there is a matching service it returns the service name" do
      session[:services] = [{ 'id' => service_id, 'name' => service_name } ]
      expect(helper.service_name_by_id(service_id)).to eq service_name
    end
  end

  describe "#service_id_by_name" do
  let(:service_id) { 1 }
  let(:service_name) { FFaker::Company.name }

  it "when there is no matching service it returns nil" do
    session[:services] = []
    expect(helper.service_id_by_name(service_id)).to eq nil
  end

  it "when there is a matching service it returns the service id" do
    session[:services] = [{ 'id' => service_id, 'name' => service_name } ]
    expect(helper.service_id_by_name(service_name)).to eq service_id
  end
end
end
