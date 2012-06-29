require 'spec_helper'

describe "Groups show" do
  before(:each) do
    @group = FactoryGirl.create(:group, gid:777, gidname:'testgroup')
  end

  context "without users" do
    before(:each) do
      visit group_path(@group)
    end

    it "has a title" do
      page.should have_title('Group: testgroup(777)')
    end

    it "has no user table" do
      page.should_not have_a_table('users')
    end
  end #without users

  context "with users" do
    before(:each) do
      @account = FactoryGirl.create(:account, username:'testuser', realname:'Test User', uid:666)
      @membership = FactoryGirl.create(:membership, account_id:@account.id, group_id:@group.id, path:'/home/test/user') 
      visit group_path(@group)
    end

    it "has a user table" do
      page.should have_a_table('users')
    end

    it "has a table header" do
      tableheader.should eq ['Username', 'Path', 'UID', 'Name']
    end

    it "has one row in the table" do
      tablemaps.should eq [[['testuser', '/home/test/user', '666', 'Test User']]]
    end

    it "has a link to the user's group page" do
      page.should have_link('testuser')
      click_link('testuser')
      page.current_path.should eq account_path(@account) 
    end
    it "has a link to the membership's show page" do
      page.should have_link('/home/test/user')
      click_link('/home/test/user')
      page.current_path.should eq membership_path(@membership) 
    end
  end
end

describe "Groups show" do
  context "sort on columns" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-06-26'),'group_ldap_info.txt')
      visit group_path(Group.last)
    end

    it "Username asc (default)" do
      tablecell(0,0).should have_content("a-satou")
      tablecell(1,0).should have_content("a-suzu")
    end
    it "Username desc" do
      table('users').click_link('Username')
      tablecell(0,0).should have_content("a-suzu")
      tablecell(1,0).should have_content("a-satou")
    end

    it "Path asc" do
      table('users').click_link('Path')
      tablecell(0,1).should have_content("/home/ohno/a-suzu")
      tablecell(1,1).should have_content("/home/otsuji/a-satou")
    end
    it "Path desc" do
      table('users').click_link('Path')
      table('users').click_link('Path')
      tablecell(0,1).should have_content("/home/otsuji/a-satou")
      tablecell(1,1).should have_content("/home/ohno/a-suzu")
    end

    it "UID asc" do
      table('users').click_link('UID')
      tablecell(0,2).should have_content("13113")
      tablecell(1,2).should have_content("15540")
    end
    it "UID desc" do
      table('users').click_link('UID')
      table('users').click_link('UID')
      tablecell(0,2).should have_content("15540")
      tablecell(1,2).should have_content("13113")
    end

    it "Name asc" do
      table('users').click_link('Name')
      tablecell(0,3).should have_content("Atsushi Muzuki")
      tablecell(1,3).should have_content("Akira Sato")
    end
    it "Name desc" do
      table('users').click_link('Name')
      table('users').click_link('Name')
      tablecell(0,3).should have_content("Akira Sato")
      tablecell(1,3).should have_content("Atsushi Muzuki")
    end
  end
end
