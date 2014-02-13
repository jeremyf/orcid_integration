require 'spec_helper'

describe AuthenticationsController do
  let(:provider) { :github }
  let(:uid) { '12345' }
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    OmniAuth.config.add_mock(provider, {uid: uid, credentials: {}})
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  end

  context 'GET provider (as callback)' do
    context 'without a registered user' do
      before(:each) do
        User.should_receive(:find_by_provider_and_uid).with(provider.to_s, uid).and_return(nil)
      end
      it 'should redirect to signup' do
        get provider
        expect(response).to redirect_to('/users/sign_up')
      end
    end

    context 'with a registered user' do
      before(:each) do
        User.should_receive(:find_by_provider_and_uid).with(provider.to_s, uid).and_return(user)
      end
      let(:user) { User.new }
      it 'should assign the user and redirect to home' do
        get provider
        expect(assigns(:user)).to eq(user)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
