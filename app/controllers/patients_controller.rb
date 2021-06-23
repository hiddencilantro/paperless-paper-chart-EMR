class PatientsController < ApplicationController
    before_action :verify_if_logged_in, only: [:index, :show]
    before_action :verify_provider, only: [:index]

    def index
        @patients = current_user.patients
    end

    def search
        @patient = Patient.find_by(name: params[:name])
        if @patient
            render :show
        else
            redirect_to provider_patients_path(current_user), flash: {message: "Patient record not found!"}
        end
    end
    
    def new
        @patient = Patient.new
    end

    def create
        @patient = Patient.new(patient_params)
        if current_user.provider?
            @patient.providers << current_user
            if @patient.save
                redirect_to @patient
            else
                render :new
            end
        else
            if @patient.save
                session[:patient_id] = @patient.id
                redirect_to @patient
            else
                render :new
            end
        end
    end

    def show
        @patient = Patient.find_by(id: params[:id])
        if !current_user.provider? && !current_user?(@patient)
            redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You do not have access to other patient files."}
        end
    end

    private

    def patient_params
        params.require(:patient).permit(:name, :sex, :dob)
    end
end
