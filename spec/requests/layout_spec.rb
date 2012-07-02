require 'spec_helper'

describe "General layout" do
  before(:each) do
    visit root_path
  end

  it "has a link to the schema" do
    div('site_nav').should have_link('Schema')
    div('site_nav').click_link('Schema')
    page.current_path.should eq days_path
  end

  it "has a link to the reports" do
    div('site_nav').should have_link('Reports')
    div('site_nav').click_link('Reports')
    page.current_path.should eq months_path
  end
end
