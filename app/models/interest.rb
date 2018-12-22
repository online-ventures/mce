class Interest < ApplicationRecord
  #Relationships
  belongs_to :vehicle
  belongs_to :subscriber

  # Rules
  validates :purchase_price, presence: true, numericality: true, if: :purchased_at?
  validates :profit, numericality: true, if: :profit?

  # Callbacks
  before_save :update_purchased_at
  def update_purchased_at
    if purchase_price.blank?
      purchased_at = nil
    elsif purchase_price.present? and purchased_at.blank?
      self.purchased_at = DateTime.now
    end
  end

  def remove_buyer!
    self.purchase_price = nil
    self.profit = nil
    self.purchased_at = nil
    save
  end
end
