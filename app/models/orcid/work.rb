module Orcid
  # A well-defined data structure that coordinates with its :template in order
  # to generate XML that can be POSTed/PUT as an Orcid Work.
  class Work
    VALID_WORK_TYPES = [
      "artistic-performance","book-chapter","book-review","book","conference-abstract","conference-paper","conference-poster","data-set","dictionary-entry","disclosure","dissertation","edited-book","encyclopedia-entry","invention","journal-article","journal-issue","lecture-speech","license","magazine-article","manual","newsletter-article","newspaper-article","online-resource","other","patent","registered-copyright","report","research-technique","research-tool","spin-off-company","standards-and-policy","supervised-student-publication","technical-standard","test","translation","trademark","website","working-paper",
    ].freeze

    include Virtus.model
    include ActiveModel::Validations
    extend ActiveModel::Naming

    attribute :title, String
    validates :title, presence: true

    attribute :work_type, String
    validates :work_type, presence: true, inclusion: { in: VALID_WORK_TYPES }

    def to_xml
      XmlRenderer.call(self)
    end

    class XmlRenderer
      def self.call(works, options = {})
        new(works, options).call
      end

      attr_reader :works, :template
      def initialize(works, options = {})
        self.works = works
        @template = options.fetch(:template_path) { File.read(Rails.root.join('app/templates/orcid/work.template.v1.1.xml.erb')) }
      end

      def call
        ERB.new(template).result(binding)
      end

      protected
      def works=(thing)
        @works = Array(thing)
      end

    end
  end
end
