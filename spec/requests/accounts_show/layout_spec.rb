require 'spec_helper'

describe "Account show" do
  before(:each) do
    @account = FactoryGirl.create(:account, username:'testuser', realname:'Test User', uid:666)
  end

  context "without groups" do
    before(:each) do
      visit account_path(@account)
    end

    it "has a title" do
      page.should have_title('User: testuser(666)')
    end

    it "has no days table" do
      page.should_not have_a_table('groups')
    end
  end

  context "with groups" do
    before(:each) do
      @group = FactoryGirl.create(:group, gid:777, gidname:'testgroup')
      @membership = FactoryGirl.create(:membership, account_id:@account.id, group_id:@group.id, path:'/home/test/user') 
      visit account_path(@account)
    end

    it "has a days table" do
      page.should have_a_table('groups')
    end

    it "has a table header" do
      tableheader.should eq ['Path', 'GID', 'Group name']
    end

    it "has one row in the table" do
      tablemaps.should eq [[['/home/test/user', '777', 'testgroup']]]
    end

    it "has a link to the user's membership page" do
      page.should have_link('/home/test/user')
      click_link('/home/test/user')
      page.current_path.should eq membership_path(@membership) 
    end
    it "has a link to the user's group page" do
      page.should have_link('777')
      click_link('777')
      page.current_path.should eq group_path(@group) 
    end
  end
end

describe "Accounts show" do
  context "sort on columns" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-06-26'),'account_ldap_info.txt')
      visit account_path(Account.first)
    end

    it "Path asc (default)" do
      tablecell(0,0).should have_content("/home/ohno/a-suzu")
      tablecell(1,0).should have_content("/home/otsuji/a-satou")
    end
    it "Path desc" do
      table('groups').click_link('Path')
      tablecell(0,0).should have_content("/home/otsuji/a-satou")
      tablecell(1,0).should have_content("/home/ohno/a-suzu")
    end

    it "GID asc" do
      table('groups').click_link('GID')
      tablecell(0,1).should have_content("131")
      tablecell(1,1).should have_content("155")
    end
    it "GID desc" do
      table('groups').click_link('GID')
      table('groups').click_link('GID')
      tablecell(0,1).should have_content("155")
      tablecell(1,1).should have_content("131")
    end

    it "Group name asc" do
      table('groups').click_link('Group name')
      tablecell(0,2).should have_content("ohno")
      tablecell(1,2).should have_content("otsuji")
    end
    it "Group name desc" do
      table('groups').click_link('Group name')
      table('groups').click_link('Group name')
      tablecell(0,2).should have_content("otsuji")
      tablecell(1,2).should have_content("ohno")
    end
  end
end
