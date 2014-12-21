class MediaItemsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @media_items  = MediaItem.all
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
    end
  end

  def share_media_item
    @media_item = MediaItem.find(params[:media_item_id])
    render 'share_media_item'
  end

  def add_users_to_media_item
    @media_item = MediaItem.find(params[:media_item_id])
    @user_ids = params[:user_ids]
    @user_ids.each {|user_id| MediaItemUser.create(user_id:user_id, media_item_id: @media_item.id)}
    redirect_to media_items_path
  end
end


