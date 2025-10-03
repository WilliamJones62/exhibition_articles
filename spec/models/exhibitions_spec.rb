require 'rails_helper'

RSpec.describe Exhibition, type: :model do
  let(:exhibition) { create(:exhibition) }

  # Test validations
  it "is valid with valid attributes" do
    expect(exhibition).to be_valid
  end

  it "is not valid without a name" do
    exhibition.name = nil
    expect(exhibition).not_to be_valid
  end

  # Test associations
  it "belongs to a user" do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end
end