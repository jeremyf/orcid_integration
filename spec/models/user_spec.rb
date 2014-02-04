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

  context '.new_with_session' do
    let(:parameters) { {} }
    let(:provider) { 'twitter' }
    let(:uid) { '1234' }
    subject { User.new_with_session(parameters, session) }
    context 'with devise.auth_data' do
      let(:session) {
        {'devise.auth_data' => { 'provider' => provider, 'uid' => uid}}
      }
      its(:persisted?) { should be_false }
      it 'should have a non-persisted authentication' do
        expect(subject.authentications.size).to eq(1)
        expect(subject.authentications.first).to_not be_persisted
      end
    end

    context 'without devise.auth_data' do
      let(:session) { {} }
      its(:persisted?) { should be_false }
      it 'should not build an associated authentication' do
        expect(subject.authentications.size).to eq(0)
      end
    end
  end
end
