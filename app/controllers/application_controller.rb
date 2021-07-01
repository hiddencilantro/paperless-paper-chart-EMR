class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :current_user?, :current_path, :logged_in_as_provider, :logged_in_as_patient

    private

    def log_in_provider
        session[:provider_id] = @provider.id
    end

    def log_in_patient
        session[:patient_id] = @patient.id
    end

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

    def verify_if_logged_in
        unless logged_in?
            redirect_to root_path, flash: {message: "You must log in."}
        end
    end

    def authorize_provider
        unless current_user.provider?
            redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You must be a provider to access this page."}
        end
    end

    def logged_in_as_provider
        logged_in? && current_user.provider?
    end

    def logged_in_as_patient
        logged_in? && current_user.patient?
    end

    def not_authorized(user)
        !current_user.provider? && !current_user?(user)
    end

    def current_path
        request.env['PATH_INFO']
    end
end
