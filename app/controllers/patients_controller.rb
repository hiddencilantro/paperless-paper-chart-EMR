class PatientsController < ApplicationController
    before_action :verify_if_logged_in, except: [:create, :update], unless: :path_exception
    before_action :authorize_provider, only: [:index, :directory, :search, :destroy]
    before_action :set_patient_by_id, only: [:edit, :show, :destroy]

    def index
        @patients = current_user.patients.five_most_recent
    end

    def directory
        @patients = Patient.order(:last_name, :first_name).group_by{|p| p.last_name[0].capitalize}
        @alphabet_array = [*'A'..'Z']
    end

    def search
        if patient_search_params.blank?
            redirect_back fallback_location: provider_patients_path(current_user), allow_other_host: false, alert: "Search fields are empty"
        else
            @patient_search = Patient.where(patient_search_params.transform_values(&:capitalize))
            if @patient_search.length == 1
                redirect_to @patient_search.first
            elsif @patient_search.length > 1
                @patients = current_user.patients.five_most_recent
                render :index
            else
                redirect_back fallback_location: provider_patients_path(current_user), allow_other_host: false, alert: "Patient record not found"
            end
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
            create_new_account
            #in production phase: require additional key (provided by physician) for initial signup
            #when setting up e-mail/password
        end
    end

    def edit
        if not_authorized(@patient)
            redirect_to current_user, alert: "You can't edit another patient's information."
        elsif session[:oauth_user]
            redirect_to current_user, alert: "You can't edit your email and/or password when logged in using third-party credentials."
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
            create_new_account
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
        current_path == new_patient_path
    end

    def patient_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :email, :password, :password_confirmation).compact_blank #Rails 6.1 -> remove blank values from params hash
    end

    def patient_file_params
        params.require(:patient).permit(:first_name, :last_name, :sex, :dob, :is_provider_or_using_oauth)
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

    def create_new_account
        find_patient_by_attributes
        if @patient && @patient.email.blank?
            @patient.assign_attributes(patient_edit_params)
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
                Date.new(patient_file_params["dob(1i)"].to_i, patient_file_params["dob(2i)"].to_i, patient_file_params["dob(3i)"].to_i)
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
        @patient = Patient.find_by(first_name: capitalized_first_name, last_name: capitalized_last_name, sex: patient_params[:sex], dob: parsed_date)
    end

    def capitalized_first_name
        patient_params[:first_name].capitalize unless patient_params[:first_name].blank?
    end

    def capitalized_last_name
        patient_params[:last_name].capitalize unless patient_params[:last_name].blank?
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

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:id])
    end

    def update_as_provider
        begin
            @patient.assign_attributes(patient_file_params)
            @patient.valid?
            Date.new(patient_file_params["dob(1i)"].to_i, patient_file_params["dob(2i)"].to_i, patient_file_params["dob(3i)"].to_i)
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
        @patient.assign_attributes(patient_edit_params)
        if @patient.save
            redirect_to @patient, notice: "Account was successfully updated"
        else
            render :edit
        end
    end
end