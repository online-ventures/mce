class Title < ActiveRecord::Base
  attr_accessible :name

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end

  def about
    if name =~ /clear/i
      page = Page.where(slug: 'title-clear').first
    elsif name =~ /rebuilt salvage/i
      page = Page.where(slug: 'title-rebuilt').first
    elsif name =~ /^salvage/i
      page = Page.where(slug: 'title-salvage').first
    elsif name =~ /reconstructed/i
      page = Page.where(slug: 'title-reconstructed').first
    elsif name =~ /bill of sale/i
      page = Page.where(slug: 'title-bill-of-sale').first
    end

    if page.nil?
      false
    else
      page.body if page.body
    end
  end
end
