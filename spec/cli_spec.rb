require 'spec_helper'
require 'alite'

describe Alite::CLI do
  before do
  end

  it "should stdout sample" do
    output = capture_stdout do
      Alite::CLI.start(['help'])
    end
    expect(output).not_to eq(nil)
  end

  it "include" do
    output = capture_stdout do
      Alite::CLI.start(['help', 'sample'])
    end
    expect(output).to include('--fields')
  end

  after do
  end
end
