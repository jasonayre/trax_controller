class Widget < ::ActiveRecord::Base
  validates :name, :length => { :minimum => 5 }
  validates :quantity, :numericality => { :greater_than => 0 }
end
