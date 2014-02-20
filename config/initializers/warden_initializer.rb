Warden::Manager.after_authentication do |user, auth, opts|
  Devise::MultiAuth::CaptureSuccessfulExternalAuthentication.call(user, auth.request.env['omniauth.auth'])
end
