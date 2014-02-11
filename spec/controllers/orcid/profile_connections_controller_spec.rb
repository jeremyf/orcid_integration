require 'spec_helper'

module Orcid
  describe ProfileConnectionsController do
    def self.it_prompts_unauthenticated_users_for_signin(method, action, parameters = {})
      context 'unauthenticated user' do
        it 'should redirect for sign in' do
          send(method, action, parameters)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
    let(:user) { mock_model('User') }

    context 'GET #index' do
      it_prompts_unauthenticated_users_for_signin(:get, :index)
    end

    context 'GET #new' do
      it_prompts_unauthenticated_users_for_signin(:get, :new)

      context 'authenticated and authorized user' do
        before { sign_in(user) }

        it 'should render a profile request form' do
          get :new
          expect(response).to be_success
          expect(assigns(:profile_connection)).to be_an_instance_of(Orcid::ProfileConnection)
          expect(response).to render_template('new')
        end
      end
    end

    context 'POST #create' do
      it_prompts_unauthenticated_users_for_signin(:post, :create)

      context 'authenticated and authorized user' do
        let(:orcid_profile_id) {'0000-0001-8025-637X'}
        before { sign_in(user) }

        it 'should render a profile request form' do
          Orcid::ProfileConnection.any_instance.should_receive(:save)

          post :create, profile_connection: { orcid_profile_id: orcid_profile_id }
          expect(assigns(:profile_connection)).to be_an_instance_of(Orcid::ProfileConnection)
          expect(response).to redirect_to(orcid_profile_connections_path)
        end
      end
    end
  end
end
