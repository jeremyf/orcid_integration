require 'spec_helper'

module Orcid
  describe Profile do
    let(:orcid_profile_id) { '0001-0002-0003-0004' }
    subject { described_class.new(orcid_profile_id) }

    context '#append_new_work' do
      let(:non_orcid_work) { double("A non-ORCID Work") }
      let(:orcid_work) { double("Orcid::Work", to_xml: 'Look I am XML') }
      let(:remote_service) { double('Service') }
      let(:mapper) { double("Mapper") }

      it 'should transform the input work to xml and deliver to the remote_service' do
        remote_service.should_receive(:call).with(orcid_profile_id, orcid_work.to_xml)
        mapper.should_receive(:map).with(non_orcid_work, target: 'orcid/work').and_return(orcid_work)

        subject.append_new_work(non_orcid_work, remote_service: remote_service, mapper: mapper)
      end
    end
  end
end
