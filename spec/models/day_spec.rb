require 'spec_helper'

describe Day do
  context "create" do
    before(:each) do
      today = Date.parse("2012-06-22")
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
    end

    it "raises an error if day exists" do
      FactoryGirl.create(:day, date:@today)
      lambda{Day.generate_userlist(@today)
      }.should raise_error(DayExistsException)
    end

    it "creates a day if none exists" do
      lambda{ Day.generate_userlist(@today)
      }.should change(Day, :count).by(1)
      Day.last.date.should eq @today
    end
  end
end
