require 'spec_helper'

describe MediaItemsController, :type => 'controller' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in :user, @user
  end

  context "on invoke of index method" do
    it "should return 200 status code and media items " do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/index')
      expect(assigns(:media_items)).not_to be_empty
      expect((assigns(:media_items).count)).to eq(1)
    end

    it "should return 200 status code and no media items if there is nothing in db " do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/index')
      expect(assigns(:media_items)).to be_empty
    end
  end

  context "on invoke of new method" do
    it "should render media_item/new page with build media-item instance" do
      get :new
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(MediaItem.count).to eq(0)
    end
  end

  context "on invoke of create method" do
    it "should create a new media-item record and redirect to media_item#index" do
      post :create, :media_item => {:name => "applift", :url => "www.applift.com", :user_id => @user.id}
      expect(response.status).to eq(302)
      expect(response).to redirect_to(media_items_path)
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
      expect(assigns(:media_item).errors.full_messages).to be_empty
    end

    it "should not create a new media-item record when name field is blank" do
      post :create, :media_item => {:name => "", :url => "www.applift.com", :user_id => @user.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
    end

    it "should not create a new media-item record when url field is blank" do
      post :create, :media_item => {:name => "applift", :url => "", :user_id => @user.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
    end

    it "should not create a new media-item record when user_id field is blank" do
      post :create, :media_item => {:name => "applift", :url => "www.applift.com", :user_id => ""}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
    end
  end

  context "on invoke of edit method" do
    it "should render media_item/edit with actual media-item instance if exists" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      get :edit, {:id => media_item.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/edit')
      expect(assigns(:media_item)).not_to be_new_record
    end
  end

  context "on invoke of update method" do
    it "should update the media-item instance and redirect to media_item#index on successful save" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      put :update, {:id => media_item.id, :media_item => {:name => "APPLIFT", :url => "www.applift.com", :user_id => @user.id}}
      expect(response.status).to eq(302)
      expect(response).to redirect_to(media_items_path)
      expect(assigns(:media_item).errors.full_messages).to be_empty
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end

    it "should render edit page with error messages on unsuccessful update when name is blank" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      put :update, {:id => media_item.id, :media_item => {:name => "", :url => "www.applift.com", :user_id => @user.id}}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/edit')
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end

    it "should render edit page with error messages on unsuccessful update when url  is blank" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      put :update, {:id => media_item.id, :media_item => {:name => "APPLIFT", :url => "", :user_id => @user.id}}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/edit')
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end

    it "should render edit page with error messages on unsuccessful update when user_id is blank" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      put :update, {:id => media_item.id, :media_item => {:name => "APPLIFT", :url => "www.applift.com", :user_id => ""}}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/edit')
      expect(assigns(:media_item).errors.full_messages).not_to be_empty
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end
  end

  context "on invoke of delete method" do
    it "should redirect to media_items#index" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      delete :destroy, {:id => media_item.id }
      expect(response.status).to eq(302)
      expect(MediaItem.find_by_id(media_item.id)).to be_nil
    end
  end

  context "on invoke of share_media_item method" do
    it "should show the pop-up with list of users with whom media-item can be shared" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      xhr :get, :share_media_item, {:media_item_id => media_item.id}

      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/share_media_item')
      expect(assigns(:media_item)).not_to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end
  end

  context "on invoke of add_users_to_media_item" do
    it "should create association records in media_item_users to map which media-item is shared with which user" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)

      get :add_users_to_media_item, {:media_item_id => media_item.id, :user_ids => [@user1.id, @user2.id]}
      expect(MediaItemUser.count).to eq(2)
      expect(@user1.shared_media_items.count).to eq(1)
      expect(@user2.shared_media_items.count).to eq(1)
      expect(@user3.shared_media_items.count).to eq(0)
      expect(response.status).to eq(302)
      expect(response).to redirect_to(media_items_path)
    end
  end
end
