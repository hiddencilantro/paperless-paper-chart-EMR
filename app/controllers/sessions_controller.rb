class SessionsController < ApplicationController
    def provider_login
        render :login
    end
    
    def provider_authenticate
        provider = Provider.find_by(username: params[:username])
        if provider && provider.authenticate(params[:password])
            session[:provider_id] = provider.id
            redirect_to provider
        else
            render :login
        end
    end

    def logout
        if current_user.provider?
            session.delete(:provider_id)
        elsif current_user.patient?
            session.delete(:patient_id)
        end
        @current_user = nil
        redirect_to root_path
    end
end
