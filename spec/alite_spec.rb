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

  it 'suggest substitutes arg vars' do
    result = Alite.suggest(
      'myword2',
      config: 'spec/data/alite.yml',
      profile: 'with_arg_vars',
      arg_vars: { 'id' => '123', 'name' => 'alice' }
    )
    expect(result[:items].first['arg']).to eq('https://example.com/123/alice')
  end

  it 'suggest routes sql profiles through the Sql core' do
    result = Alite.suggest(
      'myword2',
      config: 'spec/data/alite.yml',
      profile: 'sql_profile'
    )
    expect(result[:items].first['title']).to eq('myword2')
  end
end
