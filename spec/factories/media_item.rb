FactoryGirl.define do
  factory :media_item do |m|
    m.user {FactoryGirl.create(:user)}
    m.name "Applift"
    m.url "www.appift.com"
  end
end
