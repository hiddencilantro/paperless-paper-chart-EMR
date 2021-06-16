class PatientsController < ApplicationController
    def index
        @provider = Provider.find_by(id: params[:provider_id])
        @patients = @provider.patients
        if params[:name]
            @patient = Patient.find_by(name: params[:name])
            if @patient
                render :show
            else
                redirect_to provider_patients_path(@provider), flash: {message: "Patient record not found!"}
            end
        end
    end

    def show
        @patient = Patient.find_by(id: params[:id])
    end
end
