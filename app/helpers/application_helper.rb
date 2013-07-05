module ApplicationHelper

  time_class = lambda do |a|
    def short
      self.strftime '%b %e, %Y'
    end

    def long
      self.strftime '%B %e, %Y'
    end

    def weekday
      self.strftime '%A'
    end
  end

  Time.class_eval &time_class

  DateTime.class_eval &time_class


end
