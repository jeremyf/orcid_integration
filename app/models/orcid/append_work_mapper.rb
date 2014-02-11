module Orcid
  class AppendWorkMapper
    attr_reader :work
    def initialize(work)
      @work = work
    end

    def call
      ERB.new(File.read(Rails.root.join('app/templates/append_new_work.template.v1.1.xml.erb'))).result(binding)
    end
  end
end