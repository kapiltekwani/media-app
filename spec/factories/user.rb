FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) { |n| "kapil#{n}@tekwani.com"}
    u.username "kapiltekwani"
    u.password "kapiltekwani123"
    u.password_confirmation "kapiltekwani123"
  end
end
