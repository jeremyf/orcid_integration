module Orcid
  class ProfileConnectionsController < ApplicationController
    respond_to :html
    before_filter :authenticate_user!

    def new
      respond_with(new_profile_connection)
    end

    protected

    attr_reader :profile_connection
    helper_method :profile_connection

    def new_profile_connection
      @profile_connection ||= Orcid::ProfileConnection.new(params[:profile_connection])
    end

  end
end
