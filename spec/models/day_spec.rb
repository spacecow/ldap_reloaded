require 'spec_helper'

describe Day do
  context "delete" do
    before(:each) do
      @day        = FactoryGirl.create(:day)
      membership = FactoryGirl.create(:membership)
      @day.memberships << membership
    end

    it "day from database" do
      lambda{ @day.destroy
      }.should change(Day,:count).by(-1)
    end
      
    it "day and associated dailystats should be deleted too" do
      lambda{ @day.destroy
      }.should change(Dailystat,:count).by(-1)
    end
  end

  context "create" do
    before(:each) do
      @today = Date.parse("2012-06-22")
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
      @tomorrow = Date.parse("2012-06-23")
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

    it "creates accounts and memberships" do
      lambda{
        lambda{ 
          Day.generate_userlist(@today, 'small_ldap_info.txt')
        }.should change(Account, :count).by(1)
      }.should change(Membership, :count).by(1)
    end

    it "creates dailystats" do
      lambda{ Day.generate_userlist(@today, 'small_ldap_info.txt')
      }.should change(Dailystat, :count).by(1)
    end

    it "creates accounts and memberships for full ldap info", slow:true do
      lambda do
        lambda do
          Day.generate_userlist(@today, 'ldap_info.txt')
        end.should change(Account, :count).by(529)
      end.should change(Membership, :count).by(529)
    end
    it "creates accounts and memberships for second ldap info", slow:true do
      Day.generate_userlist(@today, 'ldap_info.txt')
      lambda{
        lambda{ 
          Day.generate_userlist(@tomorrow, 'second_ldap_info.txt')
        }.should change(Account, :count).by(2) #2 new accounts
        Account.find_by_username('m-yama').memberships.count.should be(2)
      }.should change(Membership, :count).by(3) #1 membership switch
    end

    it "creates groups for full ldap info", slow:true do
      lambda do
        Day.generate_userlist(@today, 'ldap_info.txt')
      end.should change(Group, :count).by(55)
    end
    it "creates groups for second ldap info", slow:true do
      Day.generate_userlist(@today, 'ldap_info.txt')
      lambda do
        Day.generate_userlist(@tomorrow, 'second_ldap_info.txt')
      end.should change(Group, :count).by(0)
    end


    it "creates dailystats for full ldap info", slow:true do
      lambda{ 
        Day.generate_userlist(@today, 'ldap_info.txt')
      }.should change(Dailystat, :count).by(529)
    end
    it "creates dailystats for second ldap info", slow:true do
      Day.generate_userlist(@today, 'ldap_info.txt')
      lambda{ 
        Day.generate_userlist(@tomorrw, 'second_ldap_info.txt')
      }.should change(Dailystat, :count).by(530)
    end
  end
end
