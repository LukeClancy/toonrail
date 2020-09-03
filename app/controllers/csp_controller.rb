class CspController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
        logger.info(params)
        head 200
    end
end