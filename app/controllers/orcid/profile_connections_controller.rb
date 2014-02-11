module Orcid
  class ProfileConnectionsController < ApplicationController
    respond_to :html
    before_filter :authenticate_user!

    def new
      assign_attributes(new_profile_connection)
      respond_with(new_profile_connection)
    end

    def create
      assign_attributes(new_profile_connection)
      create_profile_connection(new_profile_connection)
      respond_with(new_profile_connection)
    end

    protected

    attr_reader :profile_connection
    helper_method :profile_connection

    def assign_attributes(profile_connection)
      profile_connection.attributes = profile_connection_params
      profile_connection.user = current_user
    end

    def profile_connection_params
      params[:profile_connection] || {}
    end

    def create_profile_connection(profile_connection)
      profile_connection.save
    end

    def new_profile_connection
      @profile_connection ||= Orcid::ProfileConnection.new(params[:profile_connection])
    end

  end
end
