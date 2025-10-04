# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { create(:article) }

  # Test validations
  it 'is valid with valid attributes' do
    expect(article).to be_valid
  end

  it 'is not valid without a name' do
    article.title = nil
    expect(article).not_to be_valid
  end

  it 'belongs to a user' do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end

  it 'belongs to a publication' do
    association = described_class.reflect_on_association(:publication)
    expect(association.macro).to eq(:belongs_to)
  end

  it 'belongs to an exhibition' do
    association = described_class.reflect_on_association(:exhibition)
    expect(association.macro).to eq(:belongs_to)
  end
end
