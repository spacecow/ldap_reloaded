require 'spec_helper'

describe Dailystat do
  context "create" do
    before(:each) do
      @day = FactoryGirl.create(:day)
      @member = FactoryGirl.create(:member)
    end

    it "one on unique day and member" do
      lambda{ @member.days << @day
      }.should change(Dailystat, :count).by(1)
    end

    it "none, for the same day and member" do
      @member.days << @day
      lambda{ @member.days << @day
      }.should raise_error(ActiveRecord::RecordInvalid) 
    end
  end
end
