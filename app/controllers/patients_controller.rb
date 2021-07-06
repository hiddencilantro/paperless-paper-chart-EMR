class PatientsController < ApplicationController
    before_action :verify_if_logged_in, except: [:create, :update], unless: :path_exception
    before_action :authorize_provider, only: [:index, :all, :search, :destroy]
    before_action :set_patient_by_id, only: [:edit, :show, :destroy]

    def index
        @patients = recently_updated_patients(current_user)
    end

    def all
        @patients = Patient.order(:last_name, :first_name).group_by{|p| p.last_name[0].capitalize}
        @alphabet_array = [*'A'..'Z']
    end

    def search
        @patient_search = Patient.where(patient_search_params)
        if @patient_search.length == 1
            redirect_to @patient_search.first
        elsif @patient_search.length > 1
            @patients = recently_updated_patients(current_user)
            render :index
        else
            redirect_to provider_patients_path(current_user), alert: "Patient record not found!"
        end
    end
    
    def new
        @patient = Patient.new
        if logged_in_as_provider
            unless params[:provider_id].to_i == current_user.id || path_exception
                redirect_to provider_patients_path(current_user), alert: "You cannot create a patient file as another provider."
            end
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
            create_new_patient_account
        end
    end

    def edit
        redirect_to current_user, alert: "You can't edit another patient's information." if not_authorized(@patient)
    end

    def update
        if logged_in_as_provider
            set_patient_by_id
            update_as_provider
        elsif logged_in_as_patient
            set_patient_by_id
            update_as_patient
        else
            create_new_patient_account
        end
    end

    def show
        redirect_to current_user, alert: "You do not have access to other patient files." if not_authorized(@patient)
    end

    def destroy
        @patient.destroy
        redirect_to provider_patients_path(current_user)
    end

    private
    
    def path_exception
        current_path == patients_signup_path || current_path == new_patient_path
    end

    def recently_updated_patients(provider)
        provider.patients.order(updated_at: :desc).limit(5)
    end

    def patient_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :email, :password, :password_confirmation).compact_blank #Rails 6.1 -> remove blank values from params hash
    end

    def patient_file_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :is_provider)
    end

    def patient_edit_params
        params.require(:patient).permit(:email, :password, :password_confirmation)
    end

    def patient_search_params
        params.require(:patient).permit(:first_name, :last_name).compact_blank
    end

    def create_as_provider
        begin
            @patient = Patient.new(patient_file_params)
            @patient.valid?
            Date.new(patient_file_params["dob(1i)"].to_i, patient_file_params["dob(2i)"].to_i, patient_file_params["dob(3i)"].to_i)
            @patient.providers << current_user
            if @patient.save
                redirect_to @patient
            else
                render :new
            end
        rescue ArgumentError
            @patient.errors.add(:dob, "must be a valid date")
            @patient.dob = nil
            render :new
        end
    end

    def create_new_patient_account
        set_patient_by_attributes
        if @patient && @patient.username.blank?
            @patient.assign_attributes(patient_edit_params)
            if @patient.save
                log_in_patient
                redirect_to @patient
            else
                render :edit
            end
        elsif @patient && @patient.username
            redirect_to patients_login_path, alert: "Looks like you already have an account! Please sign in to continue."
        else
            create_as_patient
        end
    end

    def set_patient_by_attributes
        @patient = Patient.find_by(first_name: patient_params[:first_name], last_name: patient_params[:last_name], sex: patient_params[:sex], dob: parsed_date)
    end

    def parsed_date
        unless patient_params["dob(1i)"].blank? || patient_params["dob(2i)"].blank? || patient_params["dob(3i)"].blank?
            begin
                Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i)
            rescue ArgumentError
                nil
            end
        end
    end

    def create_as_patient
        begin
            @patient = Patient.new(patient_params)
            @patient.valid?
            Date.new(patient_params["dob(1i)"].to_i, patient_params["dob(2i)"].to_i, patient_params["dob(3i)"].to_i)
            if @patient.save
                log_in_patient
                redirect_to @patient
            else
                render :new
            end
        rescue ArgumentError
            @patient.errors.add(:dob, "must be a valid date")
            @patient.dob = nil
            render :new
        end
    end

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:id])
    end

    def update_as_provider
        begin
            @patient.assign_attributes(patient_file_params)
            @patient.valid?
            Date.new(patient_file_params["dob(1i)"].to_i, patient_file_params["dob(2i)"].to_i, patient_file_params["dob(3i)"].to_i)
            if @patient.save
                redirect_to @patient
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
        @patient.assign_attributes(patient_edit_params)
        if @patient.save
            redirect_to @patient
        else
            render :edit
        end
    end
end