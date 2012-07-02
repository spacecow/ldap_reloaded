class MonthsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @months = Month.order('date desc')

    @start_month = Month.find(params[:start_month]) if params[:start_month].present?
    @end_month = Month.find(params[:end_month]) if params[:end_month].present?

    if !@start_month && !@end_month
      @start_month = Month.find_by_date(Date.current.beginning_of_month)
    end

    @start_month = @end_month if !@start_month and @end_month 
    @end_month = @start_month if !@end_month and @start_month 

    if @start_month && @end_month
      @start_month = @end_month if @start_month.date > @end_month.date

      hash = Hash[*@start_month.monthlystats.map{|e| [e.path, e]}.flatten]
      step_date = @start_month.date + 1.month
      while step_date <= @end_month.date
        Month.find_by_date(step_date).monthlystats.each do |mstat|
          if hash[mstat.path].nil?
            hash[mstat.path] = mstat
          else
            mstat = hash[mstat.path]
            mstat.day_count += mstat.day_count
            hash[mstat.path] = mstat
          end
        end
        step_date += 1.month
      end

      @mstats = hash.values.sort_by{|e| e.send(sort_column)}
      @mstats = @mstats.reverse if params[:direction] == 'desc' 
       
      #@mstats = @start_month.monthlystats.order(sort_column+" "+sort_direction).includes({:membership => [:account,:group]}) if @start_month
    end
  end

  private

    def sort_column
      %w(username path gid gidname day_count day_of_registration).include?(params[:sort]) ? params[:sort] : 'username'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
