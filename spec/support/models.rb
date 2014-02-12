module NotOrcid
  class Article
    include Virtus.model

    attribute :title, String
    attribute :to_mappy_type, String, default: 'article'
  end
end