FactoryGirl.define do
  factory :account do
    username "abc123"
  end

  factory :day do
    date Date.today
  end

  factory :group do
    gid 999
  end

  factory :membership do
    account
    group
  end
end
