require 'spec_helper'

module Orcid
  describe Configuration do
    let(:storage) { { 'ORCID_APP_ID' => 'app_id', 'ORCID_APP_SECRET' => 'app_secret', 'ORCID_APP_HOST' => 'app_host'} }

    subject { described_class.new }
    context 'defaults' do
      its(:app_id) { should eq ENV['ORCID_APP_ID'] }
      its(:app_secret) { should eq ENV['ORCID_APP_SECRET'] }
      its(:app_host) { should eq ENV['ORCID_APP_HOST'] }
    end

    context 'custom storage' do
      subject { described_class.new(storage) }
      its(:app_id) { should eq storage['ORCID_APP_ID'] }
      its(:app_secret) { should eq storage['ORCID_APP_SECRET'] }
      its(:app_host) { should eq storage['ORCID_APP_HOST'] }
    end

    context 'over-writing storage' do
      subject { described_class.new(storage) }
      let(:internal_app_id) { 'internal_app_id' }
      let(:internal_app_secret) { 'internal_app_secret' }
      let(:internal_app_host) { 'internal_app_host' }
      before(:each) do
        subject.app_id = internal_app_id
        subject.app_secret = internal_app_secret
        subject.app_host = internal_app_host
      end
      its(:app_id) { should eq internal_app_id }
      its(:app_secret) { should eq internal_app_secret }
      its(:app_host) { should eq internal_app_host }
    end
  end
end
