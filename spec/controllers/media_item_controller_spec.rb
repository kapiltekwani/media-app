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
    end

    it "should not create a new media-item record when name field is blank" do
      post :create, :media_item => {:name => "", :url => "www.applift.com", :user_id => @user.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end

    it "should not create a new media-item record when url field is blank" do
      post :create, :media_item => {:name => "applift", :url => "", :user_id => @user.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
    end

    it "should not create a new media-item record when user_id field is blank" do
      post :create, :media_item => {:name => "applift", :url => "www.applift.com", :user_id => ""}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/new')
      expect(assigns(:media_item)).to be_new_record
      expect(assigns(:media_item)).not_to be_nil
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

    it "should render media_item/index with actual media-item instance if does not exits" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      get :edit, {:id => media_item.id}
      expect(response.status).to eq(200)
      expect(response).to render_template('media_items/edit')
      expect(assigns(:media_item)).to be_nil
    end
  end

  context "on invoke of update method" do
    it "should update the media-item instance and redirect to media_item#index" do
      media_item = FactoryGirl.create(:media_item, :user_id => @user.id)
      put :update, {:id => media_item.id, :media_item => {:name => "APPLIFT", :url => "www.applift.com", :user_id => @user.id}}
      expect(response.status).to eq(302)
      expect(response).to redirect_to(media_items_path)
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
end
