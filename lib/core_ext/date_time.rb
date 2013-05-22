class DateTime
  def short
    self.strftime '%b %e, %Y'
  end

  def long
    self.strftime '%B %e, %Y'
  end

  def weekday
    self.strftime '%A'
  end

  def time
    self.strftime '%l:%M%P'
  end
end