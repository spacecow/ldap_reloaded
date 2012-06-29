FactoryGirl.define do
  factory :account do
    username "abc123"
  end

  factory :day do
    date Date.today
  end

  factory :dailystat do
    day
    membership
  end

  factory :group do
    gid 999
  end

  factory :membership do
    account
    group
  end

  factory :monthlystat do
    membership
  end

  factory :month do
  end
end
