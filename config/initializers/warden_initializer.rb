Warden::Manager.after_authentication do |user, auth, opts|
  CaptureSuccessfulExternalAuthentication.call(user, auth.request.env['omniauth.auth'])
end
