require 'spec_helper'

describe Authentication do
  context '.find_by_provider_and_uid' do
    let(:provider) { 'twitter' }
    let(:uid) { '1234' }
    let!(:authentication) { FactoryGirl.create(:authentication) }

    it 'returns the authentication object' do
      expect(described_class.find_by_provider_and_uid(provider, uid)).to eq(authentication)
    end

    it 'returns nil if provider and UID is not found' do
      expect(described_class.find_by_provider_and_uid('1','2')).to be_nil
    end

  end
end
