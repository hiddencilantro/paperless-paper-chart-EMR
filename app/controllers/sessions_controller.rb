class SessionsController < ApplicationController
    def provider_login
        render :login
    end
    
    def provider_authenticate
        provider = Provider.find_by(username: params[:username])
        if provider && provider.authenticate(params[:password])
            session[:user_id] = provider.id
            redirect_to provider_path(provider)
        else
            render :login
        end
    end
end
