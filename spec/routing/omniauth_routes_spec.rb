require 'spec_helper'

describe 'omniauth routes' do
  Devise.omniauth_providers.each do |provider|
    it "routes authorize for #{provider.inspect}" do
      expect(get: "users/auth/#{provider}").to(
        route_to(
          controller: 'authentications',
          action: 'passthru',
          provider: provider.to_s
        )
      )
    end

    it "routes to #{provider.inspect} for callback" do
      expect(get: "users/auth/#{provider}/callback").to(
        route_to(
          controller: 'authentications',
          action: provider.to_s,
        )
      )
    end
  end

  it "does not route to authorize an unregistered provider" do
    expect(get: "users/auth/no_such_provider").to_not be_routable
  end

  it "does not route to callback for an unregistered provider" do
    expect(get: "users/auth/no_such_provider/callback").to_not be_routable
  end

end
