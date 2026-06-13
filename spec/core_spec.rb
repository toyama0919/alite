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

  it 'deduplicates rows via select distinct' do
    # The fixture has two "myword" rows; distinct collapses them to one.
    result = @core.make_script_filter('myword')
    titles = result[:items].map { |item| item['title'] }
    expect(titles.count('myword')).to eq(1)
  end

  it 'returns all rows when the query is empty' do
    result = @core.make_script_filter('')
    expect(result[:items].length).to eq(2)
  end

  it 'sets autocomplete to the title by default' do
    result = @core.make_script_filter('myword2')
    item = result[:items].first
    expect(item['autocomplete']).to eq(item['title'])
  end

  it 'marks items as valid' do
    result = @core.make_script_filter('myword2')
    expect(result[:items].first['valid']).to eq(true)
  end

  describe 'multi-word query' do
    it 'requires every word to match (AND semantics)' do
      result = @core.make_script_filter('myword foo')
      expect(result[:items]).to be_empty
    end
  end

  describe 'where_base option' do
    it 'restricts results with the configured base condition' do
      config = Util.get_profile('spec/data/alite.yml', 'with_where_base')
      result = Core.new(config).make_script_filter('')
      expect(result[:items].length).to eq(1)
      expect(result[:items].first['title']).to eq('myword2')
    end
  end

  describe 'initial_limit option' do
    it 'limits the number of returned items' do
      config = Util.get_profile('spec/data/alite.yml', 'with_limit')
      result = Core.new(config).make_script_filter('')
      expect(result[:items].length).to eq(1)
    end
  end

  describe 'no order option' do
    it 'still returns results when order is not configured' do
      config = Util.get_profile('spec/data/alite.yml', 'no_order')
      result = Core.new(config).make_script_filter('myword2')
      expect(result[:items].first['title']).to eq('myword2')
    end
  end

  describe 'uid option' do
    it 'adds a uid equal to the arg when enabled' do
      config = Util.get_profile('spec/data/alite.yml', 'with_uid')
      result = Core.new(config).make_script_filter('myword2')
      item = result[:items].first
      expect(item).to have_key('uid')
      expect(item['uid']).to eq(item['arg'])
    end

    it 'does not add a uid when disabled' do
      result = @core.make_script_filter('myword2')
      expect(result[:items].first).not_to have_key('uid')
    end
  end

  describe 'immutable option' do
    it 'opens the database read-only and still returns results' do
      config = Util.get_profile('spec/data/alite.yml', 'immutable_profile')
      result = Core.new(config).make_script_filter('myword2')
      expect(result[:items].first['title']).to eq('myword2')
    end
  end

  describe 'arg_vars substitution' do
    it 'substitutes ${var} placeholders in arg with provided values' do
      config = Util.get_profile('spec/data/alite.yml', 'with_arg_vars')
      result = Core.new(config).make_script_filter('myword2', { 'id' => '123', 'name' => 'alice' })
      expect(result[:items].first['arg']).to eq('https://example.com/123/alice')
    end

    it 'accepts symbol keys for arg vars' do
      config = Util.get_profile('spec/data/alite.yml', 'with_arg_vars')
      result = Core.new(config).make_script_filter('myword2', { id: '123', name: 'alice' })
      expect(result[:items].first['arg']).to eq('https://example.com/123/alice')
    end

    it 'leaves unknown placeholders untouched' do
      config = Util.get_profile('spec/data/alite.yml', 'with_arg_vars')
      result = Core.new(config).make_script_filter('myword2', { 'id' => '123' })
      expect(result[:items].first['arg']).to eq('https://example.com/123/${name}')
    end

    it 'returns the raw arg when no arg vars are given' do
      config = Util.get_profile('spec/data/alite.yml', 'with_arg_vars')
      result = Core.new(config).make_script_filter('myword2')
      expect(result[:items].first['arg']).to eq('https://example.com/${id}/${name}')
    end
  end
end
