class ProvidersController < ApplicationController
    before_action :verify_if_logged_in, only: [:show]
    before_action :verify_provider, only: [:show]

    def new
        @provider = Provider.new
    end

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

    private

    def provider_params
        params.require(:provider).permit(:first_name, :last_name, :username, :password, :password_confirmation)
    end
end
