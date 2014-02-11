require 'spec_helper'

module Orcid
  describe AppendWorkMapper do
    let(:work) { double('Work', work_type: 'book', title: 'A Fantastic Book')}
    subject { described_class.new(work) }

    it 'should return an XML document' do
      rendered = subject.call
      expect(rendered).to have_tag('orcid-profile orcid-activities orcid-works orcid-work') do
        with_tag('work-title title', text: work.title)
        with_tag('work-type', text: work.work_type)
      end
    end
  end
end
