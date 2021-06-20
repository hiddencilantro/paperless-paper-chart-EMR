class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def current_user
        if session[:provider_id]
            @current_user ||= Provider.find_by(id: session[:provider_id])
        elsif session[:patient_id]
            @current_user ||= Patient.find_by(id: session[:patient_id])
        end
    end

    def logged_in?
        !current_user.nil?
    end

    def current_user?(user)
        user == current_user
    end

    private

    def check_if_logged_in
        unless logged_in?
            redirect_to root_path, flash: {message: "Please log in."}
        end
    end

    def check_if_provider
        unless current_user.provider?
            redirect_back fallback_location: current_user, allow_other_host: false
        end
    end

    def check_if_patient
        unless current_user.patient?
            redirect_back fallback_location: current_user, allow_other_host: false
        end
    end
end
