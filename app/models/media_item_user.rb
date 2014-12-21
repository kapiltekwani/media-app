class MediaItemUser < ActiveRecord::Base
  attr_accessible :user_id, :media_item_id
  belongs_to :viewer, :class_name => 'User', :foreign_key => :user_id
  belongs_to :shared_media_item, :class_name => 'MediaItem', :foreign_key => :media_item_id
end
