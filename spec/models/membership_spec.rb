require 'spec_helper'

describe Membership do
  describe "#has_monthlystat_for?" do
    before(:each) do
      @membership = FactoryGirl.create(:membership) 
      today = Date.parse('2012-06-01')
      @june = FactoryGirl.create(:month,date:today)
    end

    it "false, if none" do
      @membership.has_monthlystat_for?(@june).should be_false      
    end
    it "true, if there are" do
      @membership.months << @june
      @membership.has_monthlystat_for?(@june).should be_true      
    end
  end

  context "create" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      @group   = FactoryGirl.create(:group)
    end

    it "one on unique account and group" do
      lambda{ @account.groups << @group
      }.should change(Membership, :count).by(1)
    end

    it "none, for the same account and group" do
      @account.groups << @group
      lambda{ @group.accounts << @account
      }.should raise_error(ActiveRecord::RecordInvalid) 
    end
  end
end
