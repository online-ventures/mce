module ApplicationHelper

  # Extend time classes
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

  # Return the template text if the variable has a value.
  # http://stackoverflow.com/a/1697919/1893290
  def show_if(template, variable, condition = nil, &block)
    # if no condition, use variable, optionally, use condition instead
    if (condition.nil? && variable) || (!condition.nil? && !!condition)
      # if we pass a block, give that instead
      if block_given?
        yield block
      else
        raw template.gsub('$1', variable)
      end
    else
      ''
    end
  end
end
