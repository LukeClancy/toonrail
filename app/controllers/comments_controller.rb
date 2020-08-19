class CommentsController < ApplicationController
    def show
    end
    def index
        offset = 0 if not params[:offset].defined?
        num = 20 if not params[:num].defined? 
        orderby = 'date' if not params[:orderby].defined?
    end
    def create
    end
    def update
    end
    def destroy
    end
end