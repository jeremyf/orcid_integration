require 'spec_helper'

module Orcid
  describe ProfileRequestsController do
    def self.it_prompts_unauthenticated_users_for_signin(method, action, parameters = {})
      context 'unauthenticated user' do
        it "should redirect for sign in" do
          send(method, action, parameters)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    def self.it_redirects_if_user_has_previously_connected_to_orcid_profile(method, action)
      context 'user has existing orcid_profile' do
        it 'should redirect to home_path' do
          sign_in(user)
          orcid_profile = double("Orcid::Profile", orcid_profile_id: '1234-5678-0001-0002')
          Orcid.should_receive(:profile_for).with(user).and_return(orcid_profile)

          send(method, action)

          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq(
            I18n.t("orcid.requests.messages.previously_connected_profile", orcid_profile_id: orcid_profile.orcid_profile_id)
          )
        end
      end
    end
    let(:user) { mock_model('User') }
    let(:profile_request_attributes) { FactoryGirl.attributes_for(:orcid_profile_request) }
    before(:each) do
      Orcid.stub(:profile_for).and_return(nil)
    end
    context 'GET #show' do
      it_prompts_unauthenticated_users_for_signin(:get, :show)
      it_redirects_if_user_has_previously_connected_to_orcid_profile(:get, :show)

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

          expect(flash[:notice]).to eq(I18n.t("orcid.requests.messages.existing_request_not_found"))
          expect(response).to redirect_to(new_orcid_profile_request_path)
        end
      end
    end

    context 'GET #new' do
      it_prompts_unauthenticated_users_for_signin(:get, :new)
      it_redirects_if_user_has_previously_connected_to_orcid_profile(:get, :new)

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
          expect(flash[:notice]).to eq(I18n.t("orcid.requests.messages.existing_request"))
          expect(response).to redirect_to(orcid_profile_request_path)
        end
      end
    end

    context 'POST #create' do
      it_prompts_unauthenticated_users_for_signin(:post, :create)
      it_redirects_if_user_has_previously_connected_to_orcid_profile(:post, :create)
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

          expect(flash[:notice]).to eq(I18n.t("orcid.requests.messages.existing_request"))
          expect(response).to redirect_to(orcid_profile_request_path)
        end

      end
    end
  end
end
