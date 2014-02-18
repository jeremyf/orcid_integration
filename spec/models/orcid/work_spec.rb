require 'spec_helper'

module Orcid
  describe Work do
    let(:attributes) { {title: 'Hello', work_type: 'journal-article' }}
    subject { described_class.new(attributes) }

    its(:title) { should eq attributes[:title] }
    its(:work_type) { should eq attributes[:work_type] }
    its(:valid?) { should eq true }

    context '#to_xml' do
      it 'should return an XML document' do
        rendered = subject.to_xml
        expect(rendered).to have_tag('orcid-profile orcid-activities orcid-works orcid-work') do
          with_tag('work-title title', text: subject.title)
          with_tag('work-type', text: subject.work_type)
        end
      end
    end
  end

  describe Work::XmlRenderer do
    let(:work) { Orcid::Work.new(title: 'Hello', work_type: 'journal-article') }
    subject { described_class.new(work) }

    context '#call' do
      it 'should return an XML document' do
        rendered = subject.call
        expect(rendered).to have_tag('orcid-profile orcid-activities orcid-works orcid-work') do
          with_tag('work-title title', text: work.title)
          with_tag('work-type', text: work.work_type)
        end
      end
    end
  end
end
