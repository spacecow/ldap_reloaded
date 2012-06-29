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
      @today = Date.parse("2012-06-01")
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

    it "creates no month if already exists" do
      FactoryGirl.create(:month, date:Date.parse('2012-06-01'))
      lambda{Day.generate_userlist(@today, 'small_ldap_info.txt')
      }.should change(Month,:count).by(0) 
    end

    it "creates a month if none exists" do
      lambda{ Day.generate_userlist(@today, 'small_ldap_info.txt')
      }.should change(Month,:count).by(1)
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

    context "monthlystats gets" do
      context "created, if new month for membership" do
        before(:each) do
          @mstat_count = Monthlystat.count
          Day.generate_userlist(@today, 'small_ldap_info.txt')
          @mstat = Monthlystat.last
        end

        it "database count is updated" do
          Monthlystat.count.should be(@mstat_count+1)
        end
        it "month_id is set" do
          @mstat.month_id.should be(Month.last.id) 
        end
        it "membership_id is set" do
          @mstat.membership_id.should be(Membership.last.id) 
        end
        it "dailystat_id is set" do
          Dailystat.last.monthlystat.should eq(@mstat)
        end
        it "day_count is set" do
          @mstat.day_count.should be(1)
        end
        it "day_of_registration is set" do
          @mstat.day_of_registration.should eq(@today)
        end
      end

      context "not created, if it already exists for membership" do
        before(:each) do
          account      = FactoryGirl.create(:account, username:'a-satou')
          group        = FactoryGirl.create(:group, gid:155)
          @membership  = FactoryGirl.create(:membership, account:account, group:group)

          @day         = FactoryGirl.create(:day,date:@today)
          @day.memberships << @membership

          @month       = FactoryGirl.create(:month,date:@today)
          @membership.months << @month

          tomorrow     = @today + 1.day
          @mstat_count = Monthlystat.count
          Day.generate_userlist(tomorrow, 'small_ldap_info.txt')
          @mstat       = Monthlystat.last
        end

        it "database count is updated" do
          Monthlystat.count.should be(@mstat_count)
        end
        it "month_id is set" do
          @mstat.month_id.should be(@month.id) 
        end
        it "membership_id is set" do
          @mstat.membership_id.should be(@membership.id) 
        end
        it "dailystat_id is set" do
          Dailystat.last.monthlystat.should eq(@mstat)
        end
        it "day_count is set" do
          @mstat.day_count.should be(2)
        end
        it "day_of_registration is set" do
          @mstat.day_of_registration.should eq(@today)
        end
      end
    end

    it "full&second ldap info, for accounts, memberships, groups, dailystats", slow:true do
      @account_count    = Account.count
      @membership_count = Membership.count
      @group_count      = Group.count
      @dstat_count      = Dailystat.count
      @day_count      = Day.count
      @mstat_count      = Monthlystat.count
      @month_count      = Month.count
      Day.generate_userlist(@today, 'ldap_info.txt')
      Account.count.should eq(@account_count + 529)
      p "created accounts"
      Membership.count.should eq(@membership_count + 529)
      p "created memberships"
      Group.count.should eq(@group_count + 55)
      p "created groups"
      Dailystat.count.should eq(@dstat_count + 529)
      p "created dailystats"
      Day.count.should eq(@day_count + 1)
      p "created days"
      Monthlystat.count.should eq(@mstat_count + 529)
      p "created monthlystats"
      Month.count.should eq(@month_count + 1)
      p "created months"
      @account_count    = Account.count
      @membership_count = Membership.count
      @group_count      = Group.count
      @dstat_count      = Dailystat.count
      @day_count      = Day.count
      @mstat_count      = Monthlystat.count
      @month_count      = Month.count
      Day.generate_userlist(@tomorrow, 'second_ldap_info.txt')
      Account.count.should eq(@account_count + 2)
      p "created missing accounts"
      # 1 membership switch + 2 accounts
      Membership.count.should eq(@membership_count + 3)
      p "created missing memberships"
      # no new groups
      Group.count.should eq(@group_count)
      p "created missing groups"
      Dailystat.count.should eq(@dstat_count + 530)
      p "created missing dailystats"
      Day.count.should eq(@day_count + 1)
      p "created missing days"
      # no new months
      Monthlystat.count.should eq(@mstat_count + 3)
      p "created missing monthlystats"
      Month.count.should eq(@month_count)
      p "created missing months"
    end
  end
end
