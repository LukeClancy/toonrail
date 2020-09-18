class CommentsController < ApplicationController
    before_action only: [:edit, :update, :new, :create, :destroy, :up_vote, :down_vote] do
        if not user_signed_in?
            head :forbidden
        end
    end
    before_action only: [:destroy, :show, :edit, :update, :up_vote, :down_vote] do
        @comment = Comment.find_by(id: params[:id])
    end
    before_action only: [:destroy, :update, :edit] do
        if ( not user_signed_in? or not current_user == @comment.user ) and (not helpers.is_admin?)
            head :forbidden
        end
    end

    def user_comments_index
        @user = User.find(params[:id])
        render 'comments/index'
    end

    def up_vote
        user = current_user
        if @comment.voted_up_by? user
            @comment.unliked_by user
        else
            @comment.liked_by user
        end
        respond_to do |format|
            format.json { render json: { 
                    liked: user.voted_as_when_voted_for(@comment),
                    vote_count: @comment.weighted_score
                }
            }
        end
    end

    def down_vote
        user = current_user
        if @comment.voted_down_by? user
            @comment.undisliked_by user
        else
            @comment.disliked_by user
        end
        respond_to do |format|
            format.json { render json: { 
                    liked: user.voted_as_when_voted_for(@comment),
                    vote_count: @comment.weighted_score
                } 
            }
        end
    end

    def show
        #offset = 0 if not params[:offset].defined?
        #num = 20 if not params[:num].defined? 
        #orderby = 'date' if not params[:orderby].defined?
        render 'comments/show'
    end
   
    #new is only as partial
    def create
        if comment_params[:target_class] == "Page"
            cls = Page
        elsif comment_params[:target_class] == "Comment"
            cls = Comment
        else
            head :error
        end
        father = cls.find(comment_params[:target_id].to_i)
        @comment = father.comments.create
        @comment.comment = comment_params[:comment]
        @comment.user = current_user
        respond_to do |format|
            if @comment.save
                if cls == Page
                    format.html { redirect_to page_url(father), notice: "comment created" }
                else
                    format.html { redirect_to comment_url(father), notice: "comment created" }
                end
            else
                if cls == Page
                    format.html { redirect_to page_url(father), notice: "comment creation failed" }
                else
                    format.html { redirect_to comment_url(father), notice: "comment creation failed" }
                end
            end
        end
    end
   
    def edit

        render 'comments/edit'
    end
   
    def update
        respond_to do |format|
            if @comment.update(comment_params)
                format.html { redirect_back fallback_location: root_path, notice: "edited succesfully" }
            else
                format.html { redirect_back fallback_location: root_path, notice: "editing failed" }
            end
        end
    end

    def destroy
        respond_to do |format|
            if @comment.destroy
                format.html { redirect_back fallback_location: root_path, notice: "destroyed" }
            else
                format.html { redirect_back fallback_location: root_path, notice: "failed to destroy" }
            end
        end
    end

    def comment_params
        params.require(:comment).permit(:title, :comment, :target_id, :target_class)
    end
end