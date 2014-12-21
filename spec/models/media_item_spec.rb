require 'spec_helper'

describe MediaItem do

  it { should belong_to(:user) }
  it { should have_many(:media_item_users) }
  it { should have_many(:viewers).class_name('User').through(:media_item_users)}

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }

  it "should not save the media-item with blank name" do
    media_item = FactoryGirl.build(:media_item, name: "")
    media_item.save.should eq(false)
    MediaItem.count.should eq(0)
  end

  it "should save the media-item with valid name" do
    media_item = FactoryGirl.build(:media_item, name: "app-lift")
    media_item.save.should eq(true)
    MediaItem.count.should eq(1)
  end

  it "should not save the media-item with blank url" do
    media_item = FactoryGirl.build(:media_item, url: "")
    media_item.save.should eq(false)
    MediaItem.count.should eq(0)
  end

  it "should save the media-item with valid url" do
    media_item = FactoryGirl.build(:media_item, url: "www.applift.com")
    media_item.save.should eq(true)
    MediaItem.count.should eq(1)
  end

  it "should not save the media-item with blank user_id" do
    user = FactoryGirl.build(:user)
    media_item = FactoryGirl.build(:media_item, user_id: user.id)
    media_item.save.should eq(false)
    MediaItem.count.should eq(0)
  end

  it "should save the media-item with valid user_id" do
    user = FactoryGirl.create(:user)
    media_item = FactoryGirl.build(:media_item, user_id: user.id)
    media_item.save.should eq(true)
    MediaItem.count.should eq(1)
  end
end