class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]
  after_action :fillGaps, only: [:destroy, :update, :edit]
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
    ActiveRecord::Base.transaction do 
      translateOrder #<- we need transaction for this
      respond_to do |format|
        if @chapter.save
          format.html { redirect_to new_page_path, notice: 'Chapter was successfully created.' }
          format.json { render :show, status: :created, location: @chapter }
        else
          format.html { render :new }
          format.json { render json: @chapter.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback #signals to undo transaction without upstream error trigger
        end
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    ActiveRecord::Base.transaction do 
      translateOrder #<- we need transaction for this
      respond_to do |format|
        if @chapter.update(chapter_params)
          format.html { redirect_to helpers.sequential_chapter_url(@chapter), notice: 'Chapter was successfully updated.' }
          format.json { render :show, status: :ok, location: @chapter }
        else
          format.html { render :edit }
          format.json { render json: @chapter.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback #signals to undo transaction without upstream error trigger
        end
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    for page in @chapter.pages
      page.destroy
    end
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to chapters_url, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find_by(order: params[:order])
    end

    def translateOrder(chap = @chapter)
      helpers._translateOrder(chap)
    end

    def fillGaps
      #ex: order of 1,2,3,5 -> 1,2,3,4
      helpers._fillGaps(Chapter.all)
    end

    def bumpMe(movedChapter = @chapter)
      helpers._bumpMe(movedChapter)
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:is_meta, :media, :title, :order, :chapter_order)
      #params.fetch(:chapter, {})
    end
end
