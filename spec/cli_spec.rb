# frozen_string_literal: true

require 'spec_helper'
require 'alite'

describe Alite::CLI do
  it 'shows help message' do
    output = capture_stdout do
      Alite::CLI.start(['help'])
    end
    expect(output).not_to be_nil
    expect(output).to include('Commands:')
  end

  it 'shows script_filter command help' do
    output = capture_stdout do
      Alite::CLI.start(%w[help script_filter])
    end
    expect(output).to include('--query')
    expect(output).to include('-w')
  end

  it 'script_filter returns valid JSON' do
    output = capture_stdout do
      Alite::CLI.start([
                         'script_filter',
                         '--query', 'myword',
                         '--config', 'spec/data/alite.yml',
                         '--profile', 'default'
                       ])
    end
    expect(output).not_to be_empty
    result = JSON.parse(output)
    expect(result).to have_key('items')
    expect(result['items']).to be_an(Array)
  end
end
