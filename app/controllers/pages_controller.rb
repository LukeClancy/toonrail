class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  after_action :fillGaps, only: [:destroy, :update, :edit]
  before_action only: [:edit, :update, :new, :create, :destroy] do
    helpers.is_admin!
  end
  
  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.order( order: :desc ).limit(20)
  end

  def latest
    @page = Page.order(created_at: :desc).first
    if @page == nil
      if helpers.is_admin? and Chapter.first == nil
        logger.info "1"
        redirect_to new_chapter_path
      elsif helpers.is_admin?
        logger.info "2"
        redirect_to new_page_path
      else
        logger.info "1"
        redirect_to "/pages", notice: "no pages found, and you are not admin! Please sign_up and set admin privledges backend to make the website exciting!" 
      end
    else
      render 'show'
    end
  end
  
  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    logger.info("page new_____________________________________")
    logger.info("pas: ram#{params}")
    @page = Page.new
    @page.chapter_id = params[:chapter] if not params[:chapter].nil?
    @page.order = 0
    if Chapter.first.nil?
      redirect_to "/pages", notice: "make a chapter first"
    end
    #default renders new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    logger.info("________________CREATE________________")
    logger.info("params: #{params}")
    @page = Page.new(page_params)
    @page.user = current_user
    ActiveRecord::Base.transaction do
      translateOrder
      respond_to do |format|
        if @page.save
          format.html { redirect_to helpers.sequential_page_url(@page), notice: 'Page was successfully created.' }
          format.json { render :show, status: :created, location: @page }
        else
          format.html { render :new }
          format.json { render json: @page.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    ActiveRecord::Base.transaction do 
      translateOrder
      respond_to do |format|
        if @page.update(page_params)
          format.html { redirect_to helpers.sequential_page_url(@page), notice: 'Page was successfully updated.' }
          format.json { render :show, status: :ok, location: @page }
        else
          format.html { render :edit }
          format.json { render json: @page.errors, status: :unprocessable_entity }
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def post_by_order(chapter_order, page_order)
      chap = Chapter.find_by(order: chapter_order)
      return Page.find_by(chapter: chap, order: page_order)
    end

    def fillGaps
      #assumes that there are no stacked pages (taken care of in edit, update, add)
      #this function enforces sequential page orders for a chapter ex: 1,2,3,5 -> 1,2,3,4
      chap = @page.chapter
      helpers._fillGaps(chap.pages)
    end

    def bumpMe(movedPage)
      helpers._bumpMe(movedPage)
    end

    def translateOrder(page = @page)
      logger.info(ChaptersController.methods)
      helpers._translateOrder(page)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      if params[:chapter_order]
        @page = post_by_order(params[:chapter_order], params[:order])
      else
        @page = Page.find_by(id: params[:id])
      end
    end
    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:title, :text, :chapter_id, :order, :media, :chapter_order)
    end
  
end
