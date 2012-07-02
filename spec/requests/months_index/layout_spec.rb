require 'spec_helper'

describe "Months index" do
  context "without reports" do
    before(:each) do
      visit months_path
    end

    it "has a title" do
      page.should have_title("Report")
    end

    it "has a report table" do
      page.should_not have_a_table('report')
    end

    it "has a from-month selector" do
      selected_value("Start month").should be_blank
    end

    it "from-month contains all the reports" do
      options("Start month").should eq "BLANK" 
    end

    it "has a end-month selector" do
      selected_value("End month").should be_blank
    end

    it "end-month contains all the reports" do
      options("End month").should eq "BLANK" 
    end

    it "has a submit button" do
      page.should have_button("Go")
    end
  end

  context "selector, with reports" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-05-26'),'two_ldap_info.txt')
      Day.generate_userlist(Date.parse('2012-06-26'),'two_ldap_info.txt')
      visit months_path
      select "2012-05-01", from:"Start month"
      select "2012-06-30", from:"End month"
      click_button "Go"
    end

    it "has a from-month selector" do
      selected_value("Start month").should eq(Month.first.id.to_s) 
    end

    it "from-month contains all the reports" do
      options("Start month").should eq "BLANK, 2012-06-01, 2012-05-01" 
    end

    it "has a end-month selector" do
      selected_value("End month").should eq(Month.last.id.to_s) 
    end

    it "end-month contains all the reports" do
      options("End month").should eq "BLANK, 2012-06-30, 2012-05-31" 
    end

    it "has one row in the table" do
      tablemaps.should eq [[['a-satou', '/home/otsuji/a-satou', '155', 'otsuji', '2', '0', '2012-05-26'],['a-suzu', '/home/ohno/a-suzu', '131', 'ohno', '2', '0', '2012-05-26']]]
    end
  end

  context "with reports" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-07-02'),'two_ldap_info.txt')
      visit months_path
    end

    it "has a from-month selector" do
      selected_value("Start month").should eq(Month.first.id.to_s) 
    end

    it "from-month contains all the reports" do
      options("Start month").should eq "BLANK, 2012-07-01" 
    end

    it "has a end-month selector" do
      selected_value("End month").should eq(Month.last.id.to_s) 
    end

    it "end-month contains all the reports" do
      options("End month").should eq "BLANK, 2012-07-31" 
    end
    it "has a report table" do
      page.should have_a_table('report')
    end

    it "has a table header" do
      tableheader.should eq ['Username', 'Path', 'GID', 'Group name', 'Days', 'Months', 'Day of registration']
    end

    it "has one row in the table" do
      tablemaps.should eq [[['a-satou', '/home/otsuji/a-satou', '155', 'otsuji', '1', '0', '2012-07-02'],['a-suzu', '/home/ohno/a-suzu', '131', 'ohno', '1', '0', '2012-07-02']]]
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
      visit months_path(start_month:Month.last.id)
    end

    it "Username asc (default)" do
      tablecell(0,0).should have_content("a-satou")
      tablecell(1,0).should have_content("a-suzu")
    end
    it "Username desc" do
      table('report').click_link('Username')
      tablecell(0,0).should have_content("a-suzu")
      tablecell(1,0).should have_content("a-satou")
    end

    it "Path asc" do
      table('report').click_link('Path')
      tablecell(0,1).should have_content("/home/ohno/a-suzu")
      tablecell(1,1).should have_content("/home/otsuji/a-satou")
    end
    it "Path desc" do
      table('report').click_link('Path')
      table('report').click_link('Path')
      tablecell(0,1).should have_content("/home/otsuji/a-satou")
      tablecell(1,1).should have_content("/home/ohno/a-suzu")
    end

    it "GID asc" do
      table('report').click_link('GID')
      tablecell(0,2).should have_content("131")
      tablecell(1,2).should have_content("155")
    end
    it "GID desc" do
      table('report').click_link('GID')
      table('report').click_link('GID')
      tablecell(0,2).should have_content("155")
      tablecell(1,2).should have_content("131")
    end

    it "Group name asc" do
      table('report').click_link('Group name')
      tablecell(0,3).should have_content("ohno")
      tablecell(1,3).should have_content("otsuji")
    end
    it "Group name desc" do
      table('report').click_link('Group name')
      table('report').click_link('Group name')
      tablecell(0,3).should have_content("otsuji")
      tablecell(1,3).should have_content("ohno")
    end

    it "Days asc" do
      table('report').click_link('Days')
      tablecell(0,4).should have_content("1")
      tablecell(1,4).should have_content("1")
    end
    it "Days desc" do
      table('report').click_link('Days')
      table('report').click_link('Days')
      tablecell(0,4).should have_content("1")
      tablecell(1,4).should have_content("1")
    end

    it "Day of registration asc" do
      table('report').click_link('Day of registration')
      tablecell(0,6).should have_content("2012-06-26")
      tablecell(1,6).should have_content("2012-06-26")
    end
    it "Day of registration desc" do
      table('report').click_link('Day of registration')
      table('report').click_link('Day of registration')
      tablecell(0,6).should have_content("2012-06-26")
      tablecell(1,6).should have_content("2012-06-26")
    end
  end
end
