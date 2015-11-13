class Category < ::ActiveRecord::Base
  validates :name, :length => { :minimum => 5 }

  has_many :products

  belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
  has_many :subcategories, :class_name => self.name, :foreign_key => :parent_id
end
