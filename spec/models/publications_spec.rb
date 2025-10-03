require 'rails_helper'

RSpec.describe Publication, type: :model do
  let(:publication) { create(:publication) }

  # Test validations
  it "is valid with valid attributes" do
    expect(publication).to be_valid
  end

  it "is not valid without a name" do
    publication.name = nil
    expect(publication).not_to be_valid
  end

  # Test associations
  it "belongs to a user" do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end
end