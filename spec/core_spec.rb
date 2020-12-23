require 'spec_helper'
require 'alite'

describe Alite::Core do
  before do
    config = Util.get_profile("spec/data/alite.yml", "default")
    @core = Core.new(config)
  end

  it "core not nil" do
    expect(@core).not_to eq(nil)
  end

  after do
  end
end
