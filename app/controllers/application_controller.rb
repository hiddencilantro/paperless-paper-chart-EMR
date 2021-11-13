class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :current_user?, :current_path, :logged_in_as_provider, :logged_in_as_patient, :add_bc_patients_new, :add_bc_patients_edit
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

    def add_bc_patients_directory
        add_breadcrumb("My Patients", provider_patients_path(current_user))
        add_breadcrumb("Patient Directory")
    end

    def add_bc_patients_new
        add_breadcrumb("My Patients", provider_patients_path(current_user)) if logged_in_as_provider
        add_breadcrumb("Patient Directory", patients_path) if logged_in_as_provider
        add_breadcrumb("Create New Patient Record") if logged_in_as_provider
    end

    def add_bc_patients_show
        add_breadcrumb("My Patients", provider_patients_path(current_user)) if logged_in_as_provider
        add_breadcrumb("Patient Directory", patients_path) if logged_in_as_provider
        add_breadcrumb(helpers.full_name(@patient)) if logged_in_as_provider && @patient
    end

    def add_bc_patients_edit
        if logged_in_as_provider
            add_breadcrumb("My Patients", provider_patients_path(current_user))
            add_breadcrumb("Patient Directory", patients_path)
            add_breadcrumb(helpers.full_name(@patient), @patient) if @patient
            add_breadcrumb("Edit Patient Info")
        elsif logged_in_as_patient
            add_breadcrumb("Main", current_user)
            add_breadcrumb("Edit Profile")
        end
    end

    def add_bc_encounters_index
        if logged_in_as_provider
            add_breadcrumb("My Patients", provider_patients_path(current_user))
            add_breadcrumb("Patient Directory", patients_path)
            add_breadcrumb(helpers.full_name(@patient), @patient) if @patient
        elsif logged_in_as_patient
            add_breadcrumb("Main", current_user)
        end
            add_breadcrumb("Encounters")
    end

    def add_bc_encounters_new
        add_breadcrumb("My Patients", provider_patients_path(current_user))
        add_breadcrumb("Patient Directory", patients_path)
        add_breadcrumb(helpers.full_name(@patient), @patient) if @patient
        add_breadcrumb("Encounters", patient_encounters_path(@patient)) if @patient
        add_breadcrumb(helpers.new_encounter_text)
    end

    def add_bc_encounters_show
        if logged_in_as_provider
            add_breadcrumb("My Patients", provider_patients_path(current_user))
            add_breadcrumb("Patient Directory", patients_path)
            add_breadcrumb(helpers.full_name(@patient), @patient) if @patient
        elsif logged_in_as_patient
            add_breadcrumb("Main", current_user)
        end
        add_breadcrumb("Encounters", patient_encounters_path(@patient)) if @patient
        add_breadcrumb("#{helpers.formatted_date(@encounter.created_at)} [#{@encounter.encounter_type.titleize}]") if @encounter
    end

    def add_bc_encounters_edit
        add_breadcrumb("My Patients", provider_patients_path(current_user))
        add_breadcrumb("Patient Directory", patients_path)
        add_breadcrumb(helpers.full_name(@patient), @patient) if @patient
        add_breadcrumb("Encounters", patient_encounters_path(@patient)) if @patient
        add_breadcrumb("#{helpers.formatted_date(@encounter.created_at)} [#{@encounter.encounter_type.titleize}]", patient_encounter_path(@patient, @encounter)) if @patient && @encounter
        add_breadcrumb(helpers.edit_encounter_text) if @encounter
    end

    def load_breadcrumbs
        if params[:controller] == "patients"
            case params[:action]
            when "directory"
                add_bc_patients_directory
            when "show"
                add_bc_patients_show
            end
        elsif params[:controller] == "encounters"
            case params[:action]
            when "index"
                add_bc_encounters_index
            when "new"
                add_bc_encounters_new
            when "show"
                add_bc_encounters_show
            when "edit"
                add_bc_encounters_edit
            end
        end
    end
end
