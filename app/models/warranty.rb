class Warranty < ActiveRecord::Base
  attr_accessible :name

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end

  def about(vehicle)
    intro = Page.find_by_slug('disclosure-intro')
    about = intro.body || ''
    if vehicle
      slugs = %W(disclosure-#{vehicle.status.to_s('-')} disclosure-#{vehicle.drivable.to_s('-')} disclosure-#{vehicle.warranty.to_s('-')})
      pages = Page.find_all_by_slug slugs
      pages.each do |page|
        about << page.body if page.body
      end
    end
    outro = Page.find_by_slug('disclosure-conclusion')
    about << outro.body || ''
    about.html_safe
  end
end
