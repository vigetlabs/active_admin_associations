class Tag < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :taggings
  has_many :posts, :through => :taggings, :source_type => "Post", :source => :taggable
  
  autocomplete :name
  
  private
  
  def format_label_for_autocomplete
    "#{name}: #{taggings.count}"
  end
end
