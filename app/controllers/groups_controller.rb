class GroupsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    @group = Group.find(params[:id])
    @memberships = @group.memberships.order(sort_column+" "+sort_direction).includes(:account)
  end  

  private

    def sort_column
      %w(accounts.username path accounts.uid accounts.realname).include?(params[:sort]) ? params[:sort] : 'accounts.username'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
