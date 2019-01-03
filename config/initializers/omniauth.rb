

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "339097496842083", "1ed893262162a4df9502efebd3aaa0b2",
  :scope => 'email,user_birthday,user_hometown,user_location', :display => 'popup', :provider_ignores_state => true

  provider :google_oauth2, '1005587551187-u9auhmpj1q07megad4r40739mmirprc8.apps.googleusercontent.com', 'WXiIcuzTThwadQdS5PZh2U06', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end


