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
  end
end
