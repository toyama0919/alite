# frozen_string_literal: true

require 'spec_helper'
require 'alite'

describe Alite::Sql do
  let(:core) do
    config = Util.get_profile('spec/data/alite.yml', 'sql_profile')
    Sql.new(config)
  end

  it 'builds without error from a sql profile' do
    expect(core).not_to be_nil
  end

  it 'returns script filter results using the custom sql' do
    result = core.make_script_filter('myword')
    expect(result).to have_key(:items)
    expect(result[:items]).to be_an(Array)
    expect(result[:items].length).to be > 0
  end

  it 'injects the match query into the where clause' do
    result = core.make_script_filter('myword2')
    expect(result[:items].length).to eq(1)
    expect(result[:items].first['title']).to eq('myword2')
  end

  it 'returns all rows when the query is empty' do
    result = core.make_script_filter('')
    expect(result[:items].length).to eq(2)
  end

  it 'returns empty results for a non-matching query' do
    result = core.make_script_filter('nonexistent_xyz')
    expect(result[:items]).to be_empty
  end

  it 'adds a uid to items when the uid option is enabled' do
    config = Util.get_profile('spec/data/alite.yml', 'sql_uid_profile')
    result = Sql.new(config).make_script_filter('myword2')
    expect(result[:items].first).to have_key('uid')
  end
end
