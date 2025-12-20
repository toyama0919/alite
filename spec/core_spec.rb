# frozen_string_literal: true

require 'spec_helper'
require 'alite'

describe Alite::Core do
  before do
    config = Util.get_profile('spec/data/alite.yml', 'default')
    @core = Core.new(config)
  end

  it 'core not nil' do
    expect(@core).not_to eq(nil)
  end

  it 'returns script filter results for search query' do
    result = @core.make_script_filter('myword')
    expect(result).to have_key(:items)
    expect(result[:items]).to be_an(Array)
    expect(result[:items].length).to be > 0
  end

  it 'returns items with required keys' do
    result = @core.make_script_filter('myword')
    item = result[:items].first
    expect(item).to have_key('title')
    expect(item).to have_key('subtitle')
    expect(item).to have_key('arg')
    expect(item).to have_key('valid')
    expect(item).to have_key('autocomplete')
  end

  it 'filters results based on search term' do
    result = @core.make_script_filter('myword2')
    expect(result[:items].length).to eq(1)
    expect(result[:items].first['title']).to eq('myword2')
  end

  it 'returns empty results for non-existent keyword' do
    result = @core.make_script_filter('nonexistent_keyword_xyz')
    expect(result[:items]).to be_empty
  end
end
