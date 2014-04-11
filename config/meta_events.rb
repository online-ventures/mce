global_events_prefix ''

version 1, '2014-04-05' do
  category :click do
    event :featured_details, '2014-03-20', 'Visitor clicked the featured vehicle more details link'
    event :featured_inventory, '2014-03-20', 'Visitor clicked the featured vehicle inventory link'
    event :top_nav_phone, '2014-03-20', 'Visitor clicked the top nav phone number'
  end
  categoy :vehicle do
    event :phone_number, '2014-04-05', 'Visitor clicked the phone number on the vehicle page'
  end
end
