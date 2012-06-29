require 'spec_helper'

describe "Days show" do
  context "without dailystats" do
    before(:each) do
      day = FactoryGirl.create(:day, date:Date.parse('2012-06-26'))
      visit day_path(day)
    end

    it "has a title" do
      page.should have_title('2012-06-26')
    end

    it "has no user table" do
      page.should have_no_table('users')
    end
  end

  context "with dailystats" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-06-26'),'two_ldap_info.txt')
      visit day_path(Day.last)
    end

    it "has a user table" do
      page.should have_a_table('users')
    end

    it "has a table header" do
      tableheader.should eq ['Username', 'Path', 'UID', 'Name', 'GID', 'Group name']
    end

    it "has one row in the table" do
      tablemaps.should eq [[['a-satou', '/home/otsuji/a-satou', '15540', 'Akira Sato', '155', 'otsuji'],['a-suzu', '/home/ohno/a-suzu', '13113', 'Atsushi Muzuki', '131', 'ohno']]]
    end

    it "has a link to the user's show page" do
      page.should have_link('a-satou')
      click_link('a-satou')
      page.current_path.should eq account_path(Account.first) 
    end
    it "has a link to the membership's show page" do
      page.should have_link('/home/otsuji/a-satou')
      click_link('/home/otsuji/a-satou')
      page.current_path.should eq membership_path(Membership.first) 
    end
    it "has a link to the group's show page" do
      page.should have_link('155')
      click_link('155')
      page.current_path.should eq group_path(Group.first) 
    end
  end

  context "sort on columns" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-06-26'),'two_ldap_info.txt')
      visit day_path(Day.last)
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

    it "GID asc" do
      table('users').click_link('GID')
      tablecell(0,4).should have_content("131")
      tablecell(1,4).should have_content("155")
    end
    it "GID desc" do
      table('users').click_link('GID')
      table('users').click_link('GID')
      tablecell(0,4).should have_content("155")
      tablecell(1,4).should have_content("131")
    end

    it "Group name asc" do
      table('users').click_link('Group name')
      tablecell(0,5).should have_content("ohno")
      tablecell(1,5).should have_content("otsuji")
    end
    it "Group name desc" do
      table('users').click_link('Group name')
      table('users').click_link('Group name')
      tablecell(0,5).should have_content("otsuji")
      tablecell(1,5).should have_content("ohno")
    end
  end
end
