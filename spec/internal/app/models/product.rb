class Product < ::ActiveRecord::Base
  validates_presence_of(:name)

  belongs_to :category
end
