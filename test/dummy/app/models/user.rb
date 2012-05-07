class User < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :posts
  
  validates_presence_of :name, :email
  
  autocomplete :name
end
