class SessionsController < ApplicationController
    def login
    end

    def provider_authenticate
        @provider = Provider.find_by(username: params[:username])
        if @provider
            if @provider.authenticate(params[:password])
                session[:provider_id] = @provider.id
                redirect_to @provider
            else
                redirect_to providers_login_path, flash: {message: "Incorrect password."}
            end
        else
            redirect_to providers_login_path, flash: {message: "Username doesn't exist."}
        end
    end

    def patient_authenticate
        @patient = Patient.find_by(username: params[:username])
        if @patient
            if @patient.authenticate(params[:password])
                session[:patient_id] = @patient.id
                redirect_to @patient
            else
                redirect_to patients_login_path, flash: {message: "Incorrect password."}
            end
        else
            redirect_to patients_login_path, flash: {message: "Username doesn't exist."}
        end
    end

    def logout
        if current_user.provider?
            session.delete(:provider_id)
        elsif current_user.patient?
            session.delete(:patient_id)
        end
        @current_user = nil
        redirect_to root_path
    end
end
