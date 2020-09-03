class UserImagesController < ApplicationController
    before_action do
        raise StandardError.new("user must be signed in") if not user_signed_in?
    end
    before_action only: [:destroy] do
        @user_image = UserImage.find(params[:id])
        #if they are not the user, and are not an admin, block
        if @user_image.user != current_user and not helpers.is_admin?()
            raise StandardError.new("not the right user")
        end
    end
    
    def create()
        @user_image = UserImage.new(image_params)
        @user_image.user = current_user
        respond_to do |format|
            if @user_image.save()
                logger.info("user image image: #{@user_image.image.inspect()}")
                format.json { render :json => { image_id: @user_image.id, url: @user_image.image_url } }
            else
                format.json { render :json => { errors: @page.errors, status: :unprocessable_entity } }
            end
        end
    end
    def destroy()
        @user_image.destroy()
    end
    def image_params
        params.require(:image).permit(:image, :id)
    end
end