class Status < ApplicationRecord
  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end

  def to_phrase
    case name.to_s
      when 'Arrived'
        'Newly Arrived Vehicles'
      when 'Repairable'
        'Repairable Vehicles'
      when 'Ready'
        'Ready to Buy Vehicles'
      else
        'Vehicles'
    end
  end
end
