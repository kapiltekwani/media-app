class MediaItem < ActiveRecord::Base
  attr_accessible :name, :url, :user_id

  #Associations
  belongs_to :user
  has_many :media_item_users
  has_many :viewers, :through => :media_item_users, :class_name => 'User', :inverse_of => :shared_media_items

  #Validations
  validates_presence_of :user_id, :url, :name
  validates_numericality_of :user_id
  validates_associated :user

  #Callbacks

end
