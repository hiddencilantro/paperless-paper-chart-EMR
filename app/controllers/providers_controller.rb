class ProvidersController < ApplicationController
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
    end

    private

    def provider_params
        params.require(:provider).permit(:name, :username, :password, :password_confirmation)
    end
end
