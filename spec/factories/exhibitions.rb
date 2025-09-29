# frozen_string_literal: true

FactoryBot.define do
    factory :exhibition do
      name { Faker::Company.name }
      year { Random.rand(1792..1903) }
      association :user
    end
  end
  