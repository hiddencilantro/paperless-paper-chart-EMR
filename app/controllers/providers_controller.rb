class ProvidersController < ApplicationController
    before_action :verify_if_logged_in, only: [:show, :destroy]
    before_action :authorize_provider, only: [:show, :destroy]
    before_action :set_provider, only: [:show, :destroy]

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
        @provider = Provider.new(provider_params)
        if @provider.save
            log_in_provider
            redirect_to @provider
        else
            render :new
        end
    end

    def show
        redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You cannot access another provider's account."} if !current_user?(@provider)
    end

    def destroy
        redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You cannot delete another provider's account."} if !current_user?(@provider)
        @provider.destroy
        redirect_to root_path
    end

    private

    def provider_params
        params.require(:provider).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def set_provider
        @provider = Provider.find_by(id: params[:id])
    end
end
