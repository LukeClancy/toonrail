class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :update, :new, :create, :destroy] do
    helpers.is_admin!
  end
  # GET /chapters
  # GET /chapters.json
  def index
    
  end
  # GET /chapters/1
  # GET /chapters/1.json
  def show
  end

  # GET /chapters/new
  def new
    @chapter = Chapter.new
    #set order as default to last chapter
    @lastChapterPlusOne = Chapter.order(order: :desc).first
    if @lastChapterPlusOne.nil?
      @lastChapterPlusOne = 1
    else
      @lastChapterPlusOne = @lastChapterPlusOne[:order] + 1
    end
    @chapter[:is_meta] = false
    @chapter[:order] = @lastChapterPlusOne
  end

  # GET /chapters/1/edit
  def edit
    #renders the view, does not actually edit, like new.
  end

  # POST /chapters
  # POST /chapters.json
  def create
    logger.info("chapter_params: #{chapter_params}")
    @chapter = Chapter.new(chapter_params)
    @chapter.user_id = current_user.id
    respond_to do |format|
      if @chapter.save
        format.html { redirect_to new_page_path, notice: 'Chapter was successfully created.' }
        format.json { render :show, status: :created, location: @chapter }
      else
        format.html { render :new, status: :internal_server_error }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to helpers.sequential_chapter_url(@chapter), notice: 'Chapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit, status: :internal_server_error }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    ActiveRecord::Base.transaction do
      for page in @chapter.pages
        page.destroy
      end
      respond_to do |format|
        if @chapter.destroy
          format.html { redirect_to chapters_url, notice: 'Chapter was successfully destroyed.' }
          format.json { head :no_content }
        else
          format.html { redirect_to chapters_url, status: :internal_server_error, notice: 'Please try again, the chapter failed to destroy in our database!'}
          format.json { head :error }
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find_by(order: params[:order])
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:is_meta, :media, :title, :order, :chapter_order)
      #params.fetch(:chapter, {})
    end
end
