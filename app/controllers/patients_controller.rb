class PatientsController < ApplicationController
    def index
        @provider = Provider.find_by(id: session[:user_id])
        @patients = @provider.patients
        @all_patients = Patient.all
        if params[:name]
            @patient = Patient.find_by(name: params[:name])
            if @patient
                render :show
            else
                redirect_to provider_patients_path(@provider), flash: {message: "Patient record not found!"}
            end
        end
    end
    
    def new
        @patient = Patient.new
    end

    def create
        patient = Patient.new(patient_params)
        if params[:provider_id]
            provider = Provider.find_by(id: params[:provider_id])
            patient.providers << provider
            if patient.save
                redirect_to provider_patient_path(provider, patient)
            else
                render :new, flash: {message: "Patient could not be created"}
            end
        end
        # else
        #     if patient.save
        #         session[:user_id] = patient.id
        #         redirect_to patient_path(patient)
        #     else
        #         render :new
        #     end
        # end
    end

    def show
        @patient = Patient.find_by(id: params[:id])
    end

    private

    def patient_params
        params.require(:patient).permit(:name, :sex, :dob)
    end
end
