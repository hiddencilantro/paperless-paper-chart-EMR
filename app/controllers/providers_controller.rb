class ProvidersController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_provider, only: [:show]

    def new
        redirect_back fallback_location: current_user, allow_other_host: false, alert: "You must log out to create a new account." if logged_in?
        @provider = Provider.new
    end

    # providers#create uses temp_key[:authorization_key] for the sake of demonstration,
    # in production we would need some sort of product key/software licensing API
    def create
        @provider = Provider.new(provider_params)
        if temp_key[:authorization_key] == '0000' && @provider.save
            log_in(@provider)
            redirect_to @provider
        elsif @provider.valid? && temp_key[:authorization_key] != '0000'
            redirect_to new_provider_path, alert: "Invalid authorization key"
        else
            render :new
        end
    end

    def show
        redirect_back fallback_location: current_user, allow_other_host: false, alert: "You cannot access another provider's account." if !current_user?(@provider)
    end

    # # set an active/inactive attribute for Provider to handle former employees
    # # but in the rare occassion that we must completely remove a Provider from the system:
    # # potential solution: create an Admin and restrict access to everyone else
    # # create a separate action to display a form allowing the admin to select Providers from a list
    # def destroy
    #     redirect_back fallback_location: current_user, allow_other_host: false, alert: "Only the administrator can delete a provider's account." if !current_user?(@admin)

    #     target = Provider.find_by(id: provider_params[:selected_to_remove])
    #     replacement = Provider.find_by(id: provider_params[:selected_to_takeover])
    #     Encounter.where(provider == target).each do |encounter|
    #         encounter.provider = replacement
    #         encounter.save
    #     end
    #     Patient.where(providers.include?(target)).each do |patient|
    #         if patient.providers.length == 1
    #             patient.providers << replacement
    #             patient.providers.destroy_by(id: target.id)
    #         else
    #             patient.providers.destroy_by(id: target.id)
    #         end
    #         #if-statement might be unnecessary because a new provider will be added during new encounter
    #     end
    #     target.destroy
    #     redirect_to current_user, notice: "Provider account has been deleted."
    # end

    private

    def provider_params
        params.require(:provider).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def set_provider
        @provider = Provider.find_by(id: params[:id])
    end

    def temp_key
        params.require(:provider).permit(:authorization_key)
    end
end
