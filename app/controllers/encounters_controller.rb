class EncountersController < ApplicationController
    before_action :verify_if_logged_in, :authorize_provider, :set_patient_by_id
    before_action :set_encounter_by_id, except: [:index, :new, :create]
    
    def index
        @encounters = @patient.encounters.ordered_by_most_recent
    end

    def new
        redirect_back fallback_location: patient_encounters_path(@patient), allow_other_host: false, alert: "Choose a type of encounter" if params[:encounter_type].blank?
        @encounter = Encounter.new
        if params[:encounter_type] == "soap"
            @encounter.build_soap
        end
    end

    def create
        @encounter = Encounter.new(encounter_params)
        @encounter.provider = current_user
        @encounter.patient = @patient
        if @encounter.save
            @encounter.patient.providers << current_user if !@encounter.patient.providers.include?(current_user)
            redirect_to patient_encounter_path(@patient, @encounter), notice: "New #{@encounter.encounter_type.titleize} record created!"
        else
            render :new
        end
    end

    def show
    end

    def edit
        redirect_back fallback_location: patient_encounter_path(@patient, @encounter), allow_other_host: false, alert: "You can't edit another provider's encounter record." if @encounter.provider != current_user
    end

    def update
        @encounter.assign_attributes(encounter_params)
        if @encounter.save
            redirect_to patient_encounter_path(@patient, @encounter), notice: "Record successfully updated"
        else
            render :edit
        end
    end

    def destroy
        if @encounter.provider != current_user
            redirect_back fallback_location: patient_encounter_path(@patient, @encounter), allow_other_host: false, alert: "You can't delete another provider's encounter record."
        else
            @encounter.destroy
            redirect_to patient_encounters_path(@patient, @encounter), notice: "#{@encounter.encounter_type.titleize} successfully deleted"
        end
    end

    private

    def set_patient_by_id
        @patient = Patient.find_by(id: params[:patient_id])
    end

    def encounter_params
        params.require(:encounter).permit(:encounter_type, soap_attributes: [:chief_complaint, :subjective, :objective, :assessment_and_plan])
    end

    def set_encounter_by_id
        @encounter = Encounter.find_by(id: params[:id])
    end
end
