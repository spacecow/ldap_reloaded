require 'spec_helper'

describe Day do
  context "create" do
    before(:each) do
      today = Date.parse("2012-06-22")
    end

    it "a day" do
      lambda{FactoryGirl.create(:day, date:@today)
      }.should change(Day,:count).by(1)
    end

    it "two days of the same date cannot exist" do
      FactoryGirl.create(:day, date:@today)
      lambda{FactoryGirl.create(:day, date:@today)
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#generate_userlist" do
    before(:each) do
      @today = Date.parse("2012-06-22")
    end

    it "raises an error if day already exists" do
      FactoryGirl.create(:day, date:@today)
      lambda{Day.generate_userlist(@today)
      }.should raise_error(DayExistsException)
    end

    it "creates a day if none exists" do
      lambda{ Day.generate_userlist(@today, 'small_ldap_info.txt')
      }.should change(Day, :count).by(1)
      Day.last.date.should eq @today
    end

    it "creates accounts and members" do
      lambda{
        lambda{ 
          Day.generate_userlist(@today, 'small_ldap_info.txt')
        }.should change(Account, :count).by(1)
      }.should change(Member, :count).by(1)
    end

    it "creates dailystats" do
      lambda{ Day.generate_userlist(@today, 'small_ldap_info.txt')
      }.should change(Dailystat, :count).by(1)
    end

    it "creates accounts and members for full ldap info", slow:true do
      lambda{
        lambda{ 
          Day.generate_userlist(@today, 'ldap_info.txt')
        }.should change(Account, :count).by(529)
      }.should change(Member, :count).by(529)
    end

    it "creates dailystats for full ldap info", slow:true do
        lambda{ 
        Day.generate_userlist(@today, 'ldap_info.txt')
      }.should change(Dailystat, :count).by(529)
    end
  end
end
