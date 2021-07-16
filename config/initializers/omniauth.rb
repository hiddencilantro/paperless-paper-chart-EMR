Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
    {
        scope: 'userinfo.email, userinfo.profile'
        #user.birthday.read, user.gender.read
        #auth hash is not returning all of the user data defined in scope
    }
end
