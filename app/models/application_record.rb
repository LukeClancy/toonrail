class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def _persist_order_save
    Rails.logger.info("IN PERSIST SAVE")
    Rails.logger.info("IN PERSIST ORDER")
    #get the class, if the object exists allready, and its order in the database.
    cls = self.class
    allready_existed = cls.exists?(self.id)
    allready_existed ? before_order = self.attribute_in_database('order') : before_order = nil
    
    #if nothing changed, return
    if ( allready_existed and before_order == self.order )
        Rails.logger.info("RET")
        return
    end

    #get its family, these orders should increase sequentially
    if cls == Page
        family = self.chapter.pages.where.not(id: self.id)
    elsif cls == Chapter
        family = Chapter.where.not(id: self.id)
    end

    #get the last in the family, skip
    last = family.order(order: :desc).first
    Rails.logger.info("LAST #{last.inspect}")
    if self.order < 0 or self.order % 1 != 0
        raise StandardError.new("#{cls} order cant be negative and has to be an integer.")
    elsif last.nil?
        #default to 1 if no Chapters
        self.order = 1
    elsif self.order == 0 or self.order > last.order
        #0 or over last will just append to end.
        #0 is for view convenience.
        self.order = last.order + 1
    elsif self.order <= last.order
        #pushes other pages up the order to make room for the page
        #to occupy the position
        family.where('"order" >= ?', self.order).update_all('"order" = "order" + 1')
    end
    if allready_existed
        #if it allready existed and we self it, fill the gap.
        family.where('"order" >= ?', before_order).update_all('"order" = "order" -1')
    end
  end

  def _persist_order_destroy
    Rails.logger.info("IN PERSIST DESTROY")
    if self.class == Page
        family = self.chapter.pages.where.not(id: self.id)
    elsif self.class == Chapter
        family = Chapter.where.not(id: self.id)
    end
    family.where('"order" > ?', self.order).update_all('"order" = "order" - 1')
  end
end
