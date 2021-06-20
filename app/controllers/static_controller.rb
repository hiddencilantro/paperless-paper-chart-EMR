class StaticController < ApplicationController
    def main
        redirect_to current_user if logged_in?
    end
end
