class MembershipsController < ApplicationController
  def show
    @membership = Membership.find(params[:id])
  end
end
