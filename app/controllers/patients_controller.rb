class PatientsController < ApplicationController
    before_action :verify_if_logged_in, except: [:create, :update], unless: :path_exception
    before_action :authorize_provider, only: [:index, :all, :search, :destroy]
    before_action :set_patient, only: [:edit, :show, :destory]

    def index
        @patients = recently_updated_patients(current_user)
    end

    def all
        @patients = Patient.order(:last_name, :first_name).group_by{|p| p.last_name[0]}
        @alphabet_array = [*'A'..'Z']
    end

    def search
        @patient_search = Patient.where(search_params)
        if @patient_search.length == 1
            redirect_to @patient_search.first
        elsif @patient_search.length > 1
            @patients = recently_updated_patients(current_user)
            render :index
        else
            redirect_to provider_patients_path(current_user), flash: {message: "Patient record not found!"}
        end
    end
    
    def new
        @patient = Patient.new
        if logged_in_as_provider
            unless params[:provider_id].to_i == current_user.id || path_exception
                redirect_to provider_patients_path(current_user), flash: {message: "You cannot create a patient file as another provider."}
            end
        elsif logged_in_as_patient
            if path_exception
                redirect_to current_user, flash: {message: "You must log out to create a new patient account."}
            else
                redirect_to current_user, flash: {message: "You must be a provider to access this page."}
            end
        end
    end

    def create
        if logged_in_as_provider
            @patient = Patient.new(patient_file_params)
            @patient.providers << current_user
            if @patient.save
                redirect_to @patient
            else
                render :new
            end
        else
            @patient = Patient.find_by(first_name: patient_account_params[:first_name], last_name: patient_account_params[:last_name], sex: patient_account_params[:sex], dob: parsed_date)
            if @patient && @patient.username.blank?
                @patient.assign_attributes(patient_account_params)
                if @patient.save
                    log_in_patient
                    redirect_to @patient
                else
                    render :edit
                end
            elsif @patient && @patient.username
                redirect_to patients_login_path, flash: {message: "Looks like you already have an account! Please sign in to continue."}
            else
                @patient = Patient.new(patient_account_params)
                if @patient.save
                    log_in_patient
                    redirect_to @patient
                else
                    render :new
                end
            end
        end
    end

    def edit
        redirect_to current_user, flash: {message: "You cannot edit other patients' information."} if not_authorized(@patient)
    end

    def update
        if logged_in_as_provider
            @patient.assign_attributes(patient_file_params)
            if @patient.save
                redirect_to @patient
            else
                render :edit
            end
        else
            @patient.assign_attributes(patient_account_params)
            if @patient.save
                log_in_patient if !logged_in?
                redirect_to @patient
            else
                render :edit
            end
        end
    end

    def show
        redirect_to current_user, flash: {message: "You do not have access to other patient files."} if not_authorized(@patient)
    end

    def destroy
        @patient.destroy
        redirect_to provider_patients_path(current_user)
    end

    private

    def patient_file_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :is_provider)
    end

    def patient_account_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :username, :password, :password_confirmation).compact_blank
    end

    def search_params
        params.require(:patient).permit(:first_name, :last_name).compact_blank #Rails 6.1 -> remove blank values from params hash
    end

    def path_exception
        current_path == patients_signup_path || current_path == new_patient_path
    end

    def parsed_date
        unless patient_account_params["dob(1i)"].blank? || patient_account_params["dob(2i)"].blank? || patient_account_params["dob(3i)"].blank?
            Date.new(patient_account_params["dob(1i)"].to_i, patient_account_params["dob(2i)"].to_i, patient_account_params["dob(3i)"].to_i)
        end
    end

    def recently_updated_patients(provider)
        provider.patients.order(updated_at: :desc).limit(5)
    end

    def set_patient
        @patient = Patient.find_by(id: params[:id])
    end
end