require 'spec_helper'

module Orcid
  describe Profile do
    let(:orcid_profile_id) { '0001-0002-0003-0004' }
    let(:remote_service) { double('Service') }
    let(:mapper) { double("Mapper") }
    let(:non_orcid_work) { double("A non-ORCID Work") }
    let(:orcid_work) { double("Orcid::Work", to_xml: 'Look I am XML') }

    subject { described_class.new(orcid_profile_id, mapper: mapper) }

    def should_map(source, target)
      mapper.should_receive(:map).with(source, target: 'orcid/work').and_return(target)
    end

    context '#append_new_work' do
      it 'should transform the input work to xml and deliver to the remote_service' do
        remote_service.should_receive(:call).with(orcid_profile_id, orcid_work.to_xml, :post)
        should_map(non_orcid_work, orcid_work)

        subject.append_new_work(non_orcid_work, remote_service: remote_service)
      end
    end

    context '#replace_works_with' do
      let(:xml) { double("XML Payload")}
      let(:xml_renderer) { double("Renderer") }
      it 'should transform the input work to xml and deliver to the remote_service' do
        xml_renderer.should_receive(:call).with(orcid_work).and_return(xml)
        remote_service.should_receive(:call).with(orcid_profile_id, xml, :put)
        should_map(non_orcid_work, orcid_work)

        subject.replace_works_with(non_orcid_work, remote_service: remote_service, xml_renderer: xml_renderer)
      end
    end
  end
end
