class ProvidersController < ApplicationController
    def new
        @provider = Provider.new
    end

    def create
        provider = Provider.new(provider_params)
        if provider.save
            session[:user_id] = provider.id
            redirect_to provider
        else
            render :new
        end
    end

    private

    def provider_params
        params.require(:provider).permit(:name, :username, :password, :password_confirm)
    end
end
