class ProvidersController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_provider, only: [:show, :destroy]

    def new
        redirect_to current_user, alert: "You must log out to create a new account." if logged_in?
        @provider = Provider.new
    end

    #providers#create is easily accessible for the sake of project demo,
    #but in production it would operate in a closed environment,
    #only allowing creation of a provider account either on the backend
    #or by requiring a key and/or some sort of additional layer of security
    #in order to prevent patients or other parties from gaining access to private information
    def create
        @provider = Provider.new(provider_params)
        if @provider.save
            log_in(@provider)
            redirect_to @provider
        else
            render :new
        end
    end

    def show
        redirect_back fallback_location: current_user, allow_other_host: false, alert: "You cannot access another provider's account." if !current_user?(@provider)
    end

    def destroy
        redirect_back fallback_location: current_user, allow_other_host: false, alert: "You cannot delete another provider's account." if !current_user?(@provider)
        @provider.destroy
        redirect_to root_path, notice: "Account was successfully deleted!"
    end

    private

    def provider_params
        params.require(:provider).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def set_provider
        @provider = Provider.find_by(id: params[:id])
    end
end
