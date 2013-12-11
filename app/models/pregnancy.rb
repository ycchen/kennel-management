class Pregnancy < ActiveRecord::Base
  has_many :pictures, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  # belongs_to :attachable, polymorphic: true
  # mount_uploader :file, FileUploader

  belongs_to :dog
  has_many :matings
  has_many :litters

  validates :dog_id, presence: true
  validates :total_puppy, presence: true, numericality: true

  scope :expected, lambda{where('surgery_date >= ?', Date.today.to_s).order('surgery_date')}
  scope :already_due, lambda{where('surgery_date <= ?', Date.today.to_s).order('surgery_date desc')}

  def self.to_csv(options ={})
  	CSV.generate(options) do |csv|
  		csv << column_names
  		all.each do |item|
  			csv << item.attributes.values_at(*column_names)
  		end
  	end
  end
  
  def total_puppies
    litters.size
  end

  
  def self.set_value(data)
    pie_data=[]
    data.each do |key, value|
      pie_data << {:name => "#{key} - #{value}", :value=> value}
    end
  end
  
end
