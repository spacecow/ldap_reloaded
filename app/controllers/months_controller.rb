class MonthsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    unless params[:start_month].blank?
      @start_month = Month.find(params[:start_month]) 
      @mstats = @start_month.monthlystats.order(sort_column+" "+sort_direction).includes({:membership => [:account,:group]})
    end
  end

  private

    def sort_column
      %w(accounts.username memberships.path groups.gid groups.gidname day_count day_of_registration).include?(params[:sort]) ? params[:sort] : 'accounts.username'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
