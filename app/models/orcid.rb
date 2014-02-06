module Orcid
  module_function
  def register_application!(config = {})
  end

  def profile_for(object)
  end

  def enqueue(object)
    object.run
  end

end