class Category < ::ActiveRecord::Base
  validates :name, :length => { :minimum => 5 }

  has_many :products
end
