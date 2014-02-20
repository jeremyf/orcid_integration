require 'spec_helper'

module Orcid
  describe ProfileRequestsController do
    def self.it_prompts_unauthenticated_users_for_signin(method, action, parameters = {})
      context 'unauthenticated user' do
        it 'should redirect for sign in' do
          send(method, action, parameters)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
    let(:user) { mock_model('User') }
    let(:profile_request_attributes) { FactoryGirl.attributes_for(:orcid_profile_request) }

    context 'GET #show' do
      it_prompts_unauthenticated_users_for_signin(:get, :show, id: '1234')

      context 'authenticated and authorized user' do
        before { sign_in(user) }
        let(:profile_request_id) { '1234' }
        let(:profile_request) { FactoryGirl.build_stubbed(:orcid_profile_request, user: user)}

        it 'should render the existing profile request' do
          Orcid::ProfileRequest.should_receive(:find_by_user).
            with(user).and_return(profile_request)

          get :show

          expect(response).to be_success
          expect(assigns(:profile_request)).to eq(profile_request)
          expect(response).to render_template('show')
        end

        it 'should redirect to the profile request form if none is found' do
          Orcid::ProfileRequest.should_receive(:find_by_user).
            with(user).and_return(nil)

          get :show

          expect(response).to be_redirect
          expect(flash[:warning]).to eq(I18n.t("orcid.requests.messages.existing_request_not_found"))
          expect(response).to redirect_to(new_orcid_profile_request_path)
        end
      end
    end

    context 'GET #new' do
      it_prompts_unauthenticated_users_for_signin(:get, :new)

      context 'authenticated and authorized user' do
        before { sign_in(user) }

        it 'should render a profile request form' do
          Orcid::ProfileRequest.should_receive(:find_by_user).with(user).and_return(nil)
          get :new
          expect(response).to be_success
          expect(assigns(:profile_request).user).to eq(user)
          expect(response).to render_template('new')
        end

        it 'should guard against duplicate requests' do
          Orcid::ProfileRequest.should_receive(:find_by_user).with(user).and_return(Orcid::ProfileRequest.new)
          get :new
          expect(flash[:warning]).to eq(I18n.t("orcid.requests.messages.existing_request"))
          expect(response).to redirect_to(orcid_profile_request_path)
        end
      end
    end

    context 'POST #create' do
      it_prompts_unauthenticated_users_for_signin(:post, :create)
      context 'authenticated and authorized user' do
        before { sign_in(user) }

        it 'should render a profile request form' do
          Orcid::ProfileRequest.should_receive(:find_by_user).with(user).and_return(nil)
          Orcid.should_receive(:enqueue).with(an_instance_of(Orcid::ProfileRequest))

          post :create, profile_request: profile_request_attributes
          expect(response).to be_redirect
        end

        it 'should guard against duplicate requests' do
          Orcid::ProfileRequest.should_receive(:find_by_user).with(user).and_return(Orcid::ProfileRequest.new)
          post :create, profile_request: profile_request_attributes
          expect(flash[:warning]).to eq(I18n.t("orcid.requests.messages.existing_request"))
          expect(response).to redirect_to(orcid_profile_request_path)
        end

      end
    end
  end
end
