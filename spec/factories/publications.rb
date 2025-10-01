# frozen_string_literal: true

FactoryBot.define do
  factory :publication do
    name { Faker::Company.name }
    publication_type { 'NEWSPAPER' }
    association :user
  end
end
