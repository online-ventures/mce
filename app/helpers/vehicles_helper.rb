module VehiclesHelper
  def row_classes(vehicle)
    classes = []
    classes << 'New' if is_new?(vehicle)
    classes << 'featured' if vehicle.featured?
    classes << vehicle.type
    classes.join ' '
  end

  def is_new?(vehicle)
    @recent && vehicle.id.in?(@recent)
  end

  def miles(vehicle=nil)
    vehicle ||= @vehicle
    if vehicle.miles and vehicle.miles > 0
      number_with_delimiter vehicle.miles
    else
      false
    end
  end

  def price(vehicle=nil)
    vehicle ||= @vehicle
    if vehicle.price and vehicle.price > 0
      number_to_currency(vehicle.price, precision: 0)
    else
      false
    end
  end

  def damage(vehicle=nil)
    vehicle ||= @vehicle
    if vehicle.damage and vehicle.damage.name != 'None'
      vehicle.damage.name
    else
      false
    end
  end

  def stock_number(vehicle=nil)
    vehicle ||= @vehicle
    if vehicle.stock_number.present?
      vehicle.stock_number
    else
      false
    end
  end

  def all_the_disclosures!(vehicle=nil)
    vehicle ||= @vehicle
    klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
    all_the_bodies = ''
    vehicle.disclosures.find_each do |d|
      all_the_bodies << d.body+'<br/>' unless d.body.blank?
    end
    content_tag :div, class: klass do
      "#{content_tag(:h3, 'Disclosure Agreement', class: 'centered title')}
      #{content_tag(:p, all_the_bodies.html_safe, class: 'panel list row')}".html_safe
    end
  end

  def warranty_disclosure(vehicle=nil)
    vehicle ||= @vehicle
    klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
    if vehicle.warranty and !vehicle.warranty.body.blank?
      content_tag :div, class: klass do
        "#{content_tag(:h3, 'About The Warranty', class: 'centered title')}
        #{content_tag(:p, vehicle.warranty.body.html_safe, class: 'panel list row')}".html_safe
      end
    end
  end

  def title_disclosure(vehicle=nil)
    vehicle ||= @vehicle
    klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
    if vehicle.title and !vehicle.title.body.blank?
      content_tag :div, class: klass do
        "#{content_tag(:h3, 'About The Title', class: 'centered title')}
        #{content_tag(:p, vehicle.title.body.html_safe, class: 'panel list row')}".html_safe
      end
    end
  end

  def drivable_disclosure(vehicle=nil)
    vehicle ||= @vehicle
    klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
    if vehicle.drivable and !vehicle.drivable.body.blank?
      content_tag :div, class: klass do
        "#{content_tag(:h3, "Drivability Details", class: 'centered title')}
        #{content_tag(:p, vehicle.drivable.body.html_safe, class: 'panel list row')}".html_safe
      end
    end
  end

  def vehicle_type_disclosure(vehicle=nil)
    vehicle ||= @vehicle
    klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
    if vehicle.body_type and !vehicle.body_type.body.blank?
      content_tag :div, class: klass do
        "#{content_tag(:h3, 'About '+vehicle.body_type.name+'s', class: 'centered title')}
        #{content_tag(:p, vehicle.body_type.body.html_safe, class: 'panel list row')}".html_safe
      end
    end
  end

  def new_banner(vehicle=nil)
    vehicle ||= @vehicle
    if @recent && vehicle.id.in?(@recent)
      content_tag :span,
        fa_icon('smile', text: 'New'),
        { class: 'new banner',
          data: { expires: (vehicle.created_at + Vehicle::DAYS_TO_REMAIN_NEW.days).to_i } }
    end
  end

  def sold_banner(vehicle=nil)
    vehicle ||= @vehicle
    content_tag :span, '<b>$</b> Sold&nbsp;&nbsp;'.html_safe, class: 'sold banner' if vehicle.sold
  end

  def featured_banner(vehicle=nil)
    vehicle ||= @vehicle
    content_tag :span, fa_icon('star', text: 'Featured').html_safe, class: 'featured banner' if vehicle.featured
  end

  def photo_url(photo)
    domain = Rails.application.credentials.aws[:cdn]
    "#{domain}/#{photo.file_path}"
  end

  def featured_image_url(vehicle=nil)
    vehicle ||= @vehicle
    return photo_url(vehicle.featured_photo) if vehicle.featured_photo.present?
    asset_path('placeholder.jpg')
  end
end
