module ApplicationHelper
    def is_admin?
        if user_signed_in?
            if current_user.role == "admin"
                return true
            end
        end
        return false
    end
    def is_admin!
        if is_admin?
            return true
        else
            raise StandardError.new("not an admin!")
        end
    end
    def get_meta_chapters()
        Chapter.where(is_meta: true)
    end
    def get_norm_chapters()
        Chapter.where(is_meta: false).order(order: :desc)
    end
    def sequential_page_url(page)
        if page.nil?
            return nil
        else
            return "/chapters/#{page.chapter.order}/pages/#{page.order}"
        end
    end
    def sequential_chapter_url(chapter)
        if chapter.nil?
            return nil
        else            
            return "/chapters/#{chapter.order}"
        end
    end    
    def page_surroundings(page)
        lastChapter = Chapter.order(order: :desc).first
        lastChapterLastPage = lastChapter.pages.order(order: :desc).first
        firstChapter = Chapter.find_by(order: 1)
        firstChapterFirstPage = Page.find_by(chapter: firstChapter, order: 1)
        logger.info "___________surroundings__________"
        logger.info "lc #{lastChapter.inspect} \n fc #{firstChapter.inspect}"
        logger.info "pc #{page.chapter}"
        returns = {
          #will break at end of chapter
          next: Page.find_by(chapter: page.chapter, order: page.order + 1),
          #will break at start of chapter
          last: Page.find_by(chapter: page.chapter, order: page.order - 1),
          start: firstChapterFirstPage == page ? nil : firstChapterFirstPage,
          end: lastChapterLastPage == page ? nil : lastChapterLastPage
        }
        logger.info "returns #{returns.inspect}"
        #check if nextpage jumps a chapter
        if returns[:next].nil? and page.chapter != lastChapter
          returns[:next] = Page.find_by(order: 1, chapter: Chapter.find_by(order: page.chapter.order + 1))
        end
        #check if firstpage jumps a chapter
        if returns[:last].nil? and page.chapter != firstChapter
          returns[:last] = Chapter.find_by(order: page.chapter.order - 1).pages.order(order: :desc).first
        end
        logger.info "returns #{returns.inspect}"
        returns[:next] = sequential_page_url(returns[:next])
        returns[:last] = sequential_page_url(returns[:last])
        returns[:start] = sequential_page_url(returns[:start])
        returns[:end] = sequential_page_url(returns[:end])
        logger.info "returns #{returns.inspect}"
        return returns
    end

    def _fillGaps(sequens)
        #utilized by PagesController and ChaptersController
        sequens.order(order: :asc)
        sequens = sequens.map{|p| [p.order, p]}.to_h
        modifier = 0
        x = 1
        while x <= sequens.keys.max
          if not sequens[x]
            #there is a gap, make sure subsequent pages are decreased by the right amount
            modifier -= 1
          else
            sequens[x].order += modifier
            sequens[x].save
          end
          x += 1
        end
      end
    
      def _translateOrder(moved)
        #utilized by PagesController and ChaptersController
        cls = moved.class
        if cls == Page
          family = moved.chapter.pages
        elsif cls == Chapter
          family = Chapter.all
        end
        last = family.order(order: :desc).first
        if moved.order < 0 or moved.order % 1 != 0
          raise StandardError.new("#{cls} order cant be neggggggative and has to be an INTEGER.")
        elsif last.nil?
          moved.order = 1
        elsif moved.order == 0 or moved.order > last.order
          moved.order = last.order + 1
        elsif moved.order <= last.order
          #pushes other pages up the order to make room for the page
          #to occupy the position
          _bumpMe(moved)
        end
      end
    
      def __bumpMe(moved)
        #utilized by PagesController and ChaptersController
        #note: recursive
        if moved.class == Page
          conflict = Page.where(order: moved.order, chapter: moved.chapter).where.not(id: moved.id).first
        elsif moved.class == Chapter
          conflict = Chapter.where(order: moved.order).where.not(id: moved.id).first
        end
        if not conflict.nil?
          __bumpMe(conflict)
          conflict.order += 1
          conflict.save
        end
    end

      def _bumpMe(moved)
        #utilized by PagesController and ChaptersController
        ActiveRecord::Base.transaction do
          __bumpMe(moved)
        end
      end
end