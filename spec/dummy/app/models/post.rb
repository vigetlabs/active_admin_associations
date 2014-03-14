class Post < ActiveRecord::Base
  attr_accessible :title, :body, :published_at, :featured, :creator_id
  
  belongs_to :creator, :class_name => "User"
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
  
  validates_presence_of :title, :body
  
  autocomplete :title
end
