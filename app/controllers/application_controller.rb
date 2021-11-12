class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :current_user?, :current_path, :logged_in_as_provider, :logged_in_as_patient
    before_action :set_breadcrumbs

    private

    def log_in(user)
        if user.provider?
            session[:provider_id] = user.id
        elsif user.patient?
            session[:patient_id] = user.id
        end
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
            redirect_to root_path, alert: "Please log in."
        end
    end

    def authorize_provider
        unless current_user.provider?
            redirect_back fallback_location: current_user, allow_other_host: false, alert: "You must be a provider to access that page."
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

    def set_breadcrumbs
        @breadcrumbs = []
    end

    def add_breadcrumb(name, path = nil)
        @breadcrumbs << {
            name: name,
            path: path
        }
    end

    def add_patient_index_bc
        add_breadcrumb("My Patients", provider_patients_path(current_user)) if logged_in_as_provider
    end

    def add_patient_directory_bc
        add_breadcrumb("Patient Directory", patients_path) if logged_in_as_provider
    end

    def add_patient_show_bc
        add_breadcrumb(helpers.full_name(@patient), @patient) if logged_in_as_provider && @patient # needed when requests are made to nonexistant patient ids
        add_breadcrumb("Main", current_user) if logged_in_as_patient
    end
end
