require 'spec_helper'

describe User do
  context '.find_by_provider_and_uid' do
    let(:provider) { 'twitter' }
    let(:uid) { '1234' }
    let(:user) { FactoryGirl.create(:user) }
    let!(:authentication) { FactoryGirl.create(:authentication, user: user) }

    it 'returns the authentication object' do
      expect(described_class.find_by_provider_and_uid(provider, uid)).to eq(user)
    end

    it 'returns nil if provider and UID is not found' do
      expect(described_class.find_by_provider_and_uid('1','2')).to be_nil
    end

  end

end
