module Orcid
  class ProfileRequestsController < ApplicationController
    def new
      Orcid::ProfileRequest.new
    end
  end
end