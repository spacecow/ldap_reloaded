require 'spec_helper'

describe Account do

  describe "#realname" do
    it "last name is saved first" do
      FactoryGirl.create(:account,realname:"Atsushi Suzuki").save
      Account.last.realname.should eq 'Atsushi Suzuki'
    end
  end
end
