require 'spec_helper'

describe Membership do
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
