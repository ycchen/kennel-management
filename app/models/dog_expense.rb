class DogExpense < ActiveRecord::Base
  belongs_to :dog
  belongs_to :charge
  # belongs_to :show
  belongs_to :show_entry

  validates :dog_id, :charge_id, presence:true
  validates :amount, presence: true, numericality: true
  
  scope :tw_dollars, -> {where(currency: 'TW')} # scope without passing arguments
  # scope :tw_dollars, lambda{|dog_id = nil| where(currency: 'TW', dog_id: dog_id)} # scope accepting arguments
  scope :us_dollars, lambda{where(currency: 'USD')}
  # scope :us_dollars, lambda{|dog_id = nil| where(currency: 'USD', dog_id: dog_id)} # scope accepting arguments

  #scope :total_charge_by_dog, lambda{ |currency, dog_id| where(currency: currency, dog_id: dog_id) }
  scope :total_charge_by_dog, -> (currency, dog_id){ where(currency: currency, dog_id: dog_id) }
  
  def self.to_csv(options ={})
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |dog_expense|
				csv << dog_expense.attributes.values_at(*column_names)
			end
		end
	end
end