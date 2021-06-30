class ProvidersController < ApplicationController
    before_action :verify_if_logged_in, only: [:show, :destroy]
    before_action :authorize_provider, only: [:show, :destroy]

    def new
        @provider = Provider.new
        redirect_to current_user, flash: {message: "You must log out to create a new account."} if logged_in?
    end

    #create action is easily accessible for the sake of project demo,
    #but live version would operate in a closed environment,
    #only allowing creation of a provider account either on the backend
    #or by requiring a key and/or some sort of additional layer of security
    #to prevent patients or other parties from gaining access to private information
    def create
        provider = Provider.new(provider_params)
        if provider.save
            session[:provider_id] = provider.id
            redirect_to provider
        else
            render :new
        end
    end

    def show
        @provider = Provider.find_by(id: params[:id])
        redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You cannot access another provider's account."} if !current_user?(@provider)
    end

    def destroy
        @provider = Provider.find_by(id: params[:id])
        @provider.destroy
        redirect_to root_path
    end

    private

    def provider_params
        params.require(:provider).permit(:first_name, :last_name, :username, :password, :password_confirmation)
    end
end
