FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@example.com"}
    password         'password'
  end

  factory :battle do
  end

  factory :turn do
    battle
  end

  factory :turn_action, class: 'Turn::Action' do
    user

    factory :attack do
      damage    6
      piercing  0
      defense   0
    end

    factory :jab do
      damage    0
      piercing  3
      defense   0
    end

    factory :defend do
      damage    0
      piercing  0
      defense   6
    end
  end
end
