require 'spec_helper'

module Orcid
  describe Profile do
    let(:orcid_profile_id) { '0001-0002-0003-0004' }
    subject { described_class.new(orcid_profile_id) }

    context '#append_new_work' do
      let(:work) { double("A Work") }
      let(:payload) { double("A Payload") }
      let(:remote_service) { double('Service') }
      let(:to_orcid_xml_mapper) { double('to_xml Service') }

      it 'should submit a request to the AppendNewWorkService' do
        remote_service.should_receive(:call).with(orcid_profile_id, payload)
        to_orcid_xml_mapper.should_receive(:call).with(work).and_return(payload)

        subject.append_new_work(work, remote_service: remote_service, to_orcid_xml_mapper: to_orcid_xml_mapper)
      end
    end
  end
end
