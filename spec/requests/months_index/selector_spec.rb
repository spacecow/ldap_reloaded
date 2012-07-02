require 'spec_helper'

describe "Months index, selector", focus:true do
  before(:each) do
    Day.generate_userlist(Date.parse('2012-07-02'),'two_ldap_info.txt')
    Day.generate_userlist(Date.parse('2012-06-26'),'two_ldap_info.txt')
    Day.generate_userlist(Date.parse('2012-05-26'),'two_ldap_info.txt')
    @may  = Month.last
    @july = Month.first
  end

  it "both start and end selected" do
    visit months_path(start_month:@may.id, end_month:@july.id)
    selected_value("Start month").should eq(@may.id.to_s) 
    selected_value("End month").should eq(@july.id.to_s) 
  end

  it "start but no end selected" do
    visit months_path(start_month:@may.id)
    selected_value("Start month").should eq(@may.id.to_s) 
    selected_value("End month").should eq(@may.id.to_s) 
  end

  it "end but no start selected" do
    visit months_path(end_month:@july.id)
    selected_value("Start month").should eq(@july.id.to_s) 
    selected_value("End month").should eq(@july.id.to_s) 
  end

  it "end selected ahead of start" do
    visit months_path(start_month:@july.id, end_month:@may.id)
    selected_value("Start month").should eq(@may.id.to_s) 
    selected_value("End month").should eq(@may.id.to_s) 
  end

  it "none selected shows the current month" do
    visit months_path
    selected_value("Start month").should eq(@july.id.to_s) 
    selected_value("End month").should eq(@july.id.to_s) 
  end
end

