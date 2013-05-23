class ActionView::Helpers::FormBuilder
  # Returns a selection box that works well with
  # accepts_nested_attributes_for
  def sub_collection_select(method, collection, value_method, text_method, options={})
    id = "#{method}_id"
    name = "#{method}[id]"
    html = "<select id=\"#{id}\" name=\"#{name}\">"
    if options[:prompt]
      html += "<option value="">#{options[:prompt]}</option>"
    end
    collection.each do |object|
      html += "<option value=\"#{object[value_method]}\">#{object[text_method]}</option>"
    end
    html += "</select>"
    html.html_safe
  end

  # Returns a text field that works well with
  # accepts_nested_attributes_for
  def sub_text_field(method)
    id = "#{method}_name"
    name = "#{method}[name]"
    "<input type='text' id='#{id}' name='#{name}' />".html_safe
  end

  def check_box_collection(attribute_name, options, selected)
		attribute_name = attribute_name.singularize
		field_name = "#{@object_name}[#{attribute_name}_ids][]"
		html = '<ul>'
		options.each do |o|
			field_id = "#{model_name}_#{attribute_name}_#{o.id}"
			checked = selected.include?(o.id) ? 'checked="checked"' : ''
			html += "<li><input type='checkbox' id='#{field_id}' name='#{field_name}' value='#{o.id}' #{checked} />"
			html += "<label for='#{field_id}'>#{o.name}</label></li>"
		end
		raw(html + '</ul>')
	end
end