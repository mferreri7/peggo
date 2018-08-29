class OwnersController < ApplicationController
  before_action :set_building, only: %i[index show new create]
  before_action :set_owner, only: [:show]

  def index
    @owners = policy_scope(@building.owners)
  end

  def show
    authorize @owner
  end

  def new
    @owner = Owner.new
    authorize @owner
  end

  def create
    @owner = Owner.new(owner_params)
    @owner.user = current_user
    authorize @owner
    if @owner.save
      redirect_to building_owner_path(@building, @owner)
    else
      render :new
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :card_number, :phone, :email, :building_id)
  end

  def set_building
    @building = Building.find(params[:building_id])
  end

  def set_owner
    @owner = Owner.find(params[:id])
  end
end
