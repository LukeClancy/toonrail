class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
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
        redirect_to new_chapter_path
      elsif helpers.is_admin?
        redirect_to new_page_path
      else
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
    @page = Page.new(page_params)
    @page.user = current_user
    respond_to do |format|
      if @page.save
        format.html { redirect_to helpers.sequential_page_url(@page), notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new, status: :internal_server_error, notice: "page not successfully created" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to helpers.sequential_page_url(@page), notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :internal_server_error, notice: "page not successfully updated" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    respond_to do |format|
      if @page.destroy
        format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to pages_url, status: :internal_server_error, notice: 'Please try again, the page failed to destroy in our database!' }
        format.json { head :error }
      end
    end
  end

  private
    def post_by_order(chapter_order, page_order)
      chap = Chapter.find_by(order: chapter_order)
      return Page.find_by(chapter: chap, order: page_order)
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
