# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence(word_count: 3) }
    author { Faker::Name.name }
    favorability { 'FAVORABLE' }
    publication_date { '1792-01-01' }
    association :user
    association :exhibition
    association :publication
  end
end
