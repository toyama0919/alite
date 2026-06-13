# frozen_string_literal: true

require 'spec_helper'
require 'alite'

describe Alite::Util do
  describe '.get_profile' do
    it 'returns nil when the config file does not exist' do
      expect(Util.get_profile('spec/data/does_not_exist.yml', 'default')).to be_nil
    end

    it 'returns the config hash for an existing profile' do
      config = Util.get_profile('spec/data/alite.yml', 'default')
      expect(config).to be_a(Hash)
      expect(config['database']).to eq('spec/data/alite.db')
      expect(config['table_name']).to eq('keywords')
    end

    it 'returns nil for a non-existent profile' do
      expect(Util.get_profile('spec/data/alite.yml', 'no_such_profile')).to be_nil
    end

    it 'evaluates ERB expressions in the config' do
      config = Util.get_profile('spec/data/alite.yml', 'erb_profile')
      expect(config['database']).to eq('spec/data/alite.db')
    end
  end
end
