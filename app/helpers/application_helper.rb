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
    #assumes that there is a page, and this is contained within that page element.
    lastChapter = Chapter.order(order: :desc).first
    lastChapterLastPage = lastChapter.pages.order(order: :desc).first
    firstChapter = Chapter.find_by(order: 1)
    firstChapterFirstPage = Page.find_by(chapter: firstChapter, order: 1)
    #logger.info "___________surroundings__________"
    #logger.info "lc #{lastChapter.inspect} \n fc #{firstChapter.inspect}"
    #logger.info "pc #{page.chapter}"
    returns = {
      #will break at end of chapter
      next: Page.find_by(chapter: page.chapter, order: page.order + 1),
      #will break at start of chapter
      last: Page.find_by(chapter: page.chapter, order: page.order - 1),
      start: firstChapterFirstPage == page ? nil : firstChapterFirstPage,
      end: lastChapterLastPage == page ? nil : lastChapterLastPage
    }
    #logger.info "returns #{returns.inspect}"
    #check if nextpage jumps a chapter
    if returns[:next].nil? and not lastChapter.nil? and page.chapter_id != lastChapter.id
      returns[:next] = Page.find_by(order: 1, chapter: Chapter.find_by(order: page.chapter.order + 1))
    end
    #check if firstpage jumps a chapter
    #logger.info "#{page.chapter}, #{firstChapter}"
    if returns[:last].nil? and page.chapter_id != firstChapter.id
      returns[:last] = Chapter.find_by(order: page.chapter.order - 1).pages.order(order: :desc).first
    end
    #logger.info "returns #{returns.inspect}"
    returns[:next] = sequential_page_url(returns[:next])
    returns[:last] = sequential_page_url(returns[:last])
    returns[:start] = sequential_page_url(returns[:start])
    returns[:end] = sequential_page_url(returns[:end])
    logger.info "surroundings returns #{returns.inspect}"
    return returns
  end


  class SpecificScrubber < Rails::Html::PermitScrubber
    #allows you to whitelist html elements along with attributes white-listed from loofah
    #or allows yout to whitelist html elements, and specific attributes with specific guidelines for those elements.
    #see SummernoteScrubber for how the @specific_elements variable should be inputted. Relies heavily on lambdas.
    def initialize(specific_elements, logger=nil)
      super()
      @specific_elements = specific_elements
      @logger = logger
    end

    def keep_node?(node)        
      if not @specific_elements[node.name.to_sym].nil?
        true #we are handling scrubbing this one and its attributes
      else
        Loofah::HTML5::Scrub.allowed_element?(node.name)
      end
    end

    def scrub_attributes(node)
      if not @specific_elements[node.name.to_sym].nil?
        specific_el = @specific_elements[node.name.to_sym]
        @logger.info("processing the: #{node} node with #{specific_el[:type]}") if @logger
        node.attribute_nodes.each do |attr|
          #if dont have a lambda handling scrubbing this attribute or that lambda returns false
          @logger.info(attr.inspect)
          if specific_el[:type].nil?
            raise StandardError.new("please set element type to \"strict\" or \"general\"")
          elsif specific_el[:type] == 'general'
            scrub_attribute(node, attr)
          elsif specific_el[:type] == 'strict'
            attr_sym = attr.name.to_sym
            if specific_el[:attr][attr_sym].nil? or not specific_el[:attr][attr_sym].call(attr.value)
              attr.remove
              @logger.info("#{attr.name} removed with value #{attr.value}") if @logger
            end
          else
            raise StandardError.new("please set element type to \"strict\" or \"general\"")
          end
        end
        scrub_css_attribute(node) #not actually sure what this does, but the last guy had it so.
      else
        Loofah::HTML5::Scrub.scrub_attributes(node)
      end
    end
  end

    #the general idea is that when PermitScrubber asks wheather to skip something, we do a very specific check, and if it fits
    #our specific needs, it does so. The main advantage we are working with here is that we only care about summernote, and there
    #is a very specific subset that is possible utilizing summernotes UI.
    #
    #attributes will be checked using their attribute lambdas, any child elements will be recursively checked using the same element
    #list 
    #

  def sanitize_summernote(dirty)
    #lg = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    #LAMBDA HELPERS
    number_or_percent_lambda = lambda { |val| 
      chars = val.chars
      numP = 0
      for c in chars
        if numP > 0 #ensures % at end
          return false
        elsif c == "%"
          numP += 1
        elsif c < "0" or c > "9"
          return false
        end
      end
      return true
    }
    number_lambda = lambda { |val|
      for c in val.chars
        if c < "0" or c > "9"
          return false
        end
      end
      return true
    }
    any_value_lambda = lambda { |val| true }
    nil_or_empty_lambda = lambda { |val| val.nil? or val == "" }
    starts_with_lambda = lambda { |val, compare | val[0...compare.length] == compare }

    #ELEMENT LIST
    specific_elements = {
      iframe: {
        attr: {
          src: lambda { |url|
            val = starts_with_lambda.call(url, "//www.youtube.com/embed/") or
            starts_with_lambda.call(url, "//player.vimeo.com/video/") or
            (starts_with_lambda.call(url, "https://instagram.com/p/") and
              url.include?("/embed") ) or
            starts_with_lambda.call(url, "//www.dailymotion.com/embed/video/")
          },
          width: number_or_percent_lambda, #all
          height: number_or_percent_lambda, #all
          class: lambda { |val|
            val == "note-video-clip"
          }, #all
          webkitallowfullscreen: nil_or_empty_lambda,
          mozallowfullscreen: nil_or_empty_lambda,
          allowfullscreen: nil_or_empty_lambda,
          frameborder: lambda {|val| val == "0"},
          scrolling: lambda { |val| val == "no"},
          #<iframe webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" src="//player.vimeo.com/video/451005534" class="note-video-clip" width="640" height="360" frameborder="0"></iframe>
        },
        type: "strict"
      },
      td: {
        type: "general"
      },
      tr: {
        type: "general"
      }
    }
    summer_scrubber = SpecificScrubber.new(specific_elements, logger)
    logger.info("comment scrubber: #{SpecificScrubber.inspect()}")
    return sanitize(dirty, scrubber: summer_scrubber)
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
      conflict.order += 1
      conflict.save
      __bumpMe(conflict)
    end
  end
  def _bumpMe(moved)
    #utilized by PagesController and ChaptersController
    ActiveRecord::Base.transaction do
      __bumpMe(moved)
    end
  end
end