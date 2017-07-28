Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, Rails.application.secrets[:facebook][:app_id], Rails.application.secrets[:facebook][:token]
end
