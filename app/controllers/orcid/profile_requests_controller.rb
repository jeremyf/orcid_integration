module Orcid
  class ProfileRequestsController < ApplicationController
    respond_to :html
    before_filter :authenticate_user!

    attr_reader :profile_request
    helper_method :profile_request

    def show
      respond_with(existing_profile_request)
    end

    def new
      assign_attributes(new_profile_request)
      respond_with(new_profile_request)
    end

    def create
      assign_attributes(new_profile_request)
      create_profile_request(new_profile_request)
      respond_with(new_profile_request)
    end

    protected
    def existing_profile_request
      @profile_request ||= Orcid::ProfileRequest.find_by_user_and_id(current_user, params[:id])
    end

    def new_profile_request
      @profile_request ||= Orcid::ProfileRequest.new(user: current_user)
    end

    def assign_attributes(profile_request)
      profile_request.attributes = profile_request_params
    end

    def create_profile_request(profile_request)
      profile_request.save && Orcid.enqueue(profile_request)
    end

    def profile_request_params
      return {} unless params.has_key?(:profile_request)
      params[:profile_request].permit(:given_names, :family_name, :primary_email, :primary_email_confirmation)
    end
  end
end
