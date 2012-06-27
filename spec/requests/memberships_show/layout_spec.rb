require 'spec_helper'

describe "Days show" do
  before(:each) do
    account = FactoryGirl.create(:account, username:'testuser', realname:'Test User', uid:666)
    group = FactoryGirl.create(:group, gid:777, gidname:'testgroup')
    FactoryGirl.create(:membership, account_id:account.id, group_id:group.id, path:'/home/test/user') 
  end

  context "with dailystats" do
    before(:each) do
      Day.generate_userlist('2012-06-26','two_ldap_info.txt')
      visit membership_path(Membership.last)
    end

    it "has a days table" do
      page.should have_a_table('days')
    end
  end

  context "without dailystats" do
    before(:each) do
      visit membership_path(Membership.last)
    end

    it "has a title" do
      page.should have_title('Member')
    end

    it "has no days table" do
      page.should_not have_a_table('days')
    end

    it "has an info box" do
      page.should have_div('info')
    end

    it "displays the username" do
      div('info').should have_div('username')
      div('info').div('username').should have_content('Username: testuser')
    end

    it "displays the user's id" do
      div('info').should have_div('uid')
      div('info').div('uid').should have_content('UID: 666')
    end

    it "displays the user's real name" do
      div('info').should have_div('realname')
      div('info').div('realname').should have_content('Name: Test User')
    end

    it "displays the user's path" do
      div('info').should have_div('path')
      div('info').div('path').should have_content('Path: /home/test/user')
    end

    it "displays the user's gid" do
      div('info').should have_div('gid')
      div('info').div('gid').should have_content('GID: 777')
    end

    it "displays the user's gidname" do
      div('info').should have_div('gidname')
      div('info').div('gidname').should have_content('Group name: testgroup')
    end

    it "has a link to the group's show page" do
      page.should have_link('testgroup')
      click_link('testgroup')
      page.current_path.should eq group_path(Group.last) 
    end

    it "has a link to the user's show page" do
      page.should have_link('testuser')
      click_link('testuser')
      page.current_path.should eq account_path(Account.last) 
    end
  end
end
