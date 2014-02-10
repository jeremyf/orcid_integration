require 'spec_helper'

module Orcid
  describe ProfileConnection do
    let(:email) { 'test@hello.com'}
    subject { Orcid::ProfileConnection.new(email: email) }

    its(:email) { should eq email }
    its(:persisted?) { should eq false }
    its(:orcid_profile_id) { should be_nil }

    context '#with_orcid_profile_candidates' do
      let(:querier) { double("Querier") }
      before(:each) do
        subject.orcid_profile_querier = querier
      end
      context 'with an email' do
        it 'should yield the query response' do
          subject.email = email
          querier.stub(:call).and_return(:query_response)
          expect {|b| subject.with_orcid_profile_candidates(&b) }.to yield_with_args(:query_response)
        end
      end

      context 'without an email' do
        it 'should not yield' do
          subject.email = nil
          querier.stub(:call).and_return(:query_response)
          expect {|b| subject.with_orcid_profile_candidates(&b) }.to_not yield_control
        end
      end

    end
  end
end
