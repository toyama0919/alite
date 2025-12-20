# frozen_string_literal: true

require 'spec_helper'
require 'alite'

describe Alite do
  it 'has a VERSION constant' do
    expect(subject.const_get('VERSION')).to_not be_empty
    expect(subject::VERSION).to match(/\d+\.\d+\.\d+/)
  end

  it 'provides suggest method' do
    expect(Alite).to respond_to(:suggest)
  end

  it 'suggest method returns script filter format' do
    result = Alite.suggest(
      'myword',
      config: 'spec/data/alite.yml',
      profile: 'default'
    )
    expect(result).to have_key(:items)
    expect(result[:items]).to be_an(Array)
  end
end
