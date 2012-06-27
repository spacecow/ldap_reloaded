class DaysController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    @day = Day.find(params[:id])
    @memberships = @day.memberships.order(sort_column+" "+sort_direction).includes(:group, :account)
  end

  def index
    @days = Day.all
  end

  private

    def sort_column
      %w(accounts.username path accounts.uid accounts.realname groups.gid groups.gidname).include?(params[:sort]) ? params[:sort] : 'accounts.username'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
