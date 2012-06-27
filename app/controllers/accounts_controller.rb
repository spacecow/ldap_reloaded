class AccountsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    @account = Account.find(params[:id])
    @memberships = @account.memberships.order(sort_column+" "+sort_direction).includes(:group)
  end
  
  private

    def sort_column
      %w(path groups.gid groups.gidname).include?(params[:sort]) ? params[:sort] : 'path'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
