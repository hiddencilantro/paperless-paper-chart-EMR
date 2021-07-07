class SessionsController < ApplicationController
    def login
        redirect_back fallback_location: current_user, allow_other_host: false, flash: {message: "You're already logged in! If you'd like to sign in with a different account, you must first log out."} if logged_in?
    end

    def provider_authenticate
        @provider = Provider.find_by(email: params[:email].downcase)
        if @provider
            if @provider.authenticate(params[:password])
                log_in_provider
                redirect_to @provider
            else
                flash.now[:alert] = "Incorrect password."
                render :login
            end
        else
            flash.now[:alert] = "Email doesn't exist."
        end
    end

    def patient_authenticate
        @patient = Patient.find_by(email: params[:email].downcase)
        if @patient
            if @patient.authenticate(params[:password])
                log_in_patient
                redirect_to @patient
            else
                flash.now[:alert] = "Incorrect password."
                render :login
            end
        else
            flash.now[:alert] = "Email doesn't exist."
        end
    end

    def logout
        if current_user.provider?
            session.delete(:provider_id)
        elsif current_user.patient?
            session.delete(:patient_id)
        end
        @current_user = nil
        redirect_to root_path, notice: "You have successfully logged out."
    end
end
