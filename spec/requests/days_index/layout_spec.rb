require 'spec_helper'

describe "Days index" do
  context "without dailystats" do
    before(:each) do
      visit days_path
    end

    it "has a title" do
      page.should have_title('Days')
    end

    it "has no table" do
      page.should_not have_a_table('days')
    end 
  end

  context "with dailystats" do
    before(:each) do
      Day.generate_userlist(Date.parse('2012-06-26'),'small_ldap_info.txt')
      visit days_path
    end

    it "has a table" do
      page.should have_a_table('days')
    end 

    it "has a table header" do
      tableheader.should eq ['Date', 'User count']
    end

    it "has one row in the table" do
      tablemaps.should eq [[['2012-06-26','1']]]
    end

    it "has a link to the day's show page" do
      page.should have_link('2012-06-26')
      click_link('2012-06-26')
      page.current_path.should eq day_path(Day.last) 
    end
  end
end
