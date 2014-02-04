require 'spec_helper'

describe User do
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
