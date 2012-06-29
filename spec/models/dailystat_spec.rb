require 'spec_helper'

describe Dailystat do

  context "create" do
    before(:each) do
      @day = FactoryGirl.create(:day)
      @membership = FactoryGirl.create(:membership)
    end

    it "one on unique day and membership" do
      lambda{ @membership.days << @day
      }.should change(Dailystat, :count).by(1)
    end

    it "none, for the same day and membership" do
      @membership.days << @day
      lambda{ @membership.days << @day
      }.should raise_error(ActiveRecord::RecordInvalid) 
    end
  end
end
