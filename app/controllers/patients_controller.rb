class PatientsController < ApplicationController
    before_action :verify_if_logged_in, except: [:create, :update], unless: :path_exception
    before_action :authorize_provider, only: [:index, :directory, :search, :destroy]
    before_action :set_patient_by_id, only: [:edit, :show, :destroy]
    # before_action :add_patient_index_bc, only: [:directory, :new, :edit, :show]
    # before_action :add_patient_directory_bc, only: [:edit, :show]
    # before_action :add_patient_show_bc, only: :edit
    before_action :add_all_breadcrumbs, only: [:directory, :new, :show, :edit]
    add_flash_types :search_alert

    def index
        redirect_to provider_patients_path(current_user), alert: "You cannot access another provider's account." unless verified_provider(params[:provider_id])
        @patients = current_user.patients.five_most_recent
    end

    def directory
        @patients = Patient.ordered_and_grouped_by_last_name
        @alphabet_array = [*'A'..'Z']
        # add_breadcrumb("Patient Directory")
    end

    def search
        if patient_params_splat(:first_name, :last_name).compact_blank.blank?
            redirect_to provider_patients_path(current_user), search_alert: "Search fields are empty"
        else
            @search = Patient.search_records(patient_params_splat(:first_name, :last_name).compact_blank)
            if @search.length == 1
                redirect_to @search.first
            elsif @search.length > 1
                @patients = current_user.patients.five_most_recent
                render :index
            else
                redirect_to provider_patients_path(current_user), search_alert: "Patient record not found"
            end
        end
    end
    
    def new
        @patient = Patient.new
        if logged_in_as_provider
            unless verified_provider(params[:provider_id]) || path_exception
                redirect_to provider_patients_path(current_user), alert: "You cannot create a patient record as another provider."
            end
            # add_breadcrumb("Create New Patient Record")
        elsif logged_in_as_patient
            if path_exception
                redirect_to current_user, alert: "Please log out to create a new patient account."
            else
                redirect_to current_user, alert: "You must be a provider to access this page."
            end
        end
    end

    def create
        if logged_in_as_provider
            create_as_provider
        else
            create_as_patient
            #in production phase: require additional key (provided by physician) for initial signup when setting up e-mail/password
        end
    end

    def edit
        if not_authorized(@patient)
            redirect_to current_user, alert: "You can't edit another patient's information."
        elsif current_user.patient? && session[:oauth_user]
            redirect_to current_user, alert: "You can't edit your email and/or password when logged in with third-party credentials."
        elsif !@patient
            redirect_to provider_patients_path(current_user), alert: "Patient record not found"
        # elsif logged_in_as_provider
        #     add_breadcrumb("Edit Patient Info")
        # elsif logged_in_as_patient
        #     add_breadcrumb("Edit Profile")
        end
    end

    def update
        if logged_in_as_provider
            set_patient_by_id
            update_as_provider
        elsif logged_in_as_patient
            set_patient_by_id
            update_as_patient
        else
            create_as_patient
        end
    end

    def show
        if not_authorized(@patient)
            redirect_to current_user, alert: "You do not have access to another patient's records."
        elsif !@patient
            redirect_to provider_patients_path(current_user), alert: "Patient record not found"
        end
        # add_breadcrumb(helpers.full_name(@patient)) if logged_in_as_provider && @patient
    end

    def destroy
        @patient.destroy
        redirect_to provider_patients_path(current_user), notice: "Patient record was deleted"
    end

    private
    
    def path_exception
        current_path == new_patient_path
    end

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:id])
    end

    def verified_provider(provider_id)
        provider_id.to_i == current_user.id
    end

    def patient_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :email, :password, :password_confirmation).compact_blank #Rails 6.1: remove blank values from params hash (needed in order to sanitize for query)
    end

    def patient_params_splat(*args)
        params.require(:patient).permit(*args)
    end

    def create_as_provider
        find_patient_by_attributes
        if @patient
            @patient_suggestion = @patient
            @patient = Patient.new
            flash.now[:alert] = "There is already a patient that matches this information."
            render :new
        else
            begin
                @patient = Patient.new(patient_params_splat(:first_name, :last_name, :sex, :dob, :as_provider))
                @patient.valid?
                Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i) unless @patient.errors[:dob].any?
                @patient.providers << current_user
                if @patient.save
                    redirect_to @patient, notice: "Patient record created!"
                else
                    render :new
                end
            rescue ArgumentError
                @patient.errors.add(:dob, "must be a valid date")
                @patient.dob = nil
                render :new
            end
        end
    end

    def create_as_patient
        find_patient_by_attributes
        if @patient && @patient.email.blank?
            @patient.assign_attributes(patient_params_splat(:email, :password, :password_confirmation))
            if @patient.save
                log_in(@patient)
                redirect_to @patient, notice: "Account successfully created!"
            else
                render :edit
            end
        elsif @patient && @patient.email
            redirect_to patients_login_path, alert: "Looks like you already have an account! Please sign in to continue."
        else
            begin
                @patient = Patient.new(patient_params)
                @patient.valid?
                Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i) unless @patient.errors[:dob].any?
                if @patient.errors.any?
                    render :new
                else
                    flash.now[:alert] = "We couldn't find you in our database. <br> If you've never visited us before, please return to the main page and click the link to set up an appointment. <br> Otherwise, please make sure the information you entered is correct and try again. <br> If you're still experiencing issues, please give us a call."
                    render :new
                end
            rescue ArgumentError
                @patient.errors.add(:dob, "must be a valid date")
                @patient.dob = nil
                render :new
            end
        end
    end

    def find_patient_by_attributes
        @patient = Patient.find_by(first_name: capitalized(patient_params[:first_name]), last_name: capitalized(patient_params[:last_name]), sex: patient_params[:sex], dob: parsed_dob)
    end

    def capitalized(name)
        name.capitalize unless name.blank?
    end

    def parsed_dob
        unless patient_params["dob(1i)"].blank? || patient_params["dob(2i)"].blank? || patient_params["dob(3i)"].blank?
            begin
                Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i)
            rescue ArgumentError
                nil
            end
        end
    end

    def update_as_provider
        begin
            @patient.assign_attributes(patient_params_splat(:first_name, :last_name, :sex, :dob, :as_provider))
            @patient.valid?
            Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i) unless @patient.errors[:dob].any?
            if @patient.save
                redirect_to @patient, notice: "Patient info was successfully updated"
            else
                render :edit
            end
        rescue ArgumentError
            @patient.errors.add(:dob, "must be a valid date")
            @patient.dob = nil
            render :edit
        end
    end

    def update_as_patient
        @patient.assign_attributes(patient_params_splat(:email, :password, :password_confirmation))
        if @patient.save
            redirect_to @patient, notice: "Account was successfully updated"
        else
            render :edit
        end
    end
end