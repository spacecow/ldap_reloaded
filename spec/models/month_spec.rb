require 'spec_helper'

describe Month do
  before(:each) do
    @today = Date.parse("2012-06-01")
  end

  it "a month" do
    lambda{FactoryGirl.create(:month,date:@today)
    }.should change(Month,:count).by(1)
  end

  it "two months of the same date cannot exist" do
    FactoryGirl.create(:month,date:@today)
    lambda{FactoryGirl.create(:month,date:@today)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "a month must have a value" do
    lambda{FactoryGirl.create(:month,date:nil)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

end
