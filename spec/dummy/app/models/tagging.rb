class Tagging < ActiveRecord::Base
  attr_accessible :tag, :tag_id, :taggable_id, :taggable_type, :taggable
  validates_presence_of :tag_id, :taggable_id, :taggable_type
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
end
