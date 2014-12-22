class MediaItemsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @media_items  = current_user.media_items
    @shared_media_items = current_user.shared_media_items.where("media_items.user_id NOT IN (?)", current_user.id)
  end

  def new
    @media_item = MediaItem.new
  end

  def create
    @media_item = MediaItem.new(params[:media_item])
    if @media_item.save
      flash[:success] = "Media Item created successfully"
      redirect_to media_items_path
    else
      flash[:warning] = @media_item.errors.full_messages
      render :action => :new
    end
  end

  def edit 
    @media_item = MediaItem.find(params[:id])
  end

  def update
    @media_item = MediaItem.find(params[:id])
    if @media_item.update_attributes(params[:media_item])
      flash[:success] = "Media Item updated successfully"
      redirect_to media_items_path
    else
      flash[:warning] = @media_item.errors.full_messages
      render :action => :edit
    end
  end

  def destroy
    @media_item = MediaItem.find(params[:id])
    if @media_item.destroy
      flash[:success] = "Media Item deleted successfully"
      redirect_to media_items_path
    else
      flash[:warning] = "Something gone wrong while deleting the media-item"
      redirect_to media_items_path
    end
  end

  def share_media_item
    @media_item = MediaItem.find(params[:media_item_id])
    shared_user_ids = MediaItemUser.where(media_item_id: @media_item.id).collect(&:user_id)
    @unshared_users = User.where("id NOT IN (?)", (shared_user_ids << @media_item.user_id)).collect{|x| [x.username, x.id] }
    render 'share_media_item'
  end

  def add_users_to_media_item
    @media_item = MediaItem.find(params[:media_item_id])
    @user_ids = params[:user_ids]
    @user_ids.each {|user_id| MediaItemUser.create(user_id:user_id, media_item_id: @media_item.id)}
    redirect_to media_items_path
  end
end


