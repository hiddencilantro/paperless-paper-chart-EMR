class PatientsController < ApplicationController
    def index
        @provider = Provider.find_by(id: params[:provider_id])
        @patients = @provider.patients
    end
end
