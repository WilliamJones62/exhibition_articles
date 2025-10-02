# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParentCreationService, type: :service do
  let!(:user) { create(:user) }

  #   before do
  #     sign_in user
  #   end

  describe 'test_new_parents' do
    context 'with valid parameters for both Exhibition and Publication' do
      before do
        @params = {
          'authenticity_token' => 'Az63-cZWrn3XZ-urXVhxrb8rCWBTWc7V07BSPRRHp1TS3pEkzcsJbUnGljtW22b1mBQU1d7dWhL-BQ737OY4hA', 'article' => {
            'exhibition_id' => '1', 'exhibition_name' => 'New Exhibition name', 'exhibition_year' => '1799', 'publication_id' => '1', 'publication_name' => 'New Publication name', 'publication_type' => 'PERIODICAL', 'title' => 'Rspec test 2', 'author' => 'Rspec Author', 'favorability' => 'FAVORABLE', 'publication_date' => '1903-12-21'
          }
        }
      end

      it 'creates a new exhibition' do
        expect do
          ParentCreationService.new(@params, user.id).call
        end.to change(Exhibition, :count).by(1)
        expect(Exhibition.last.name).to eq('New Exhibition name')
      end
      it 'creates a new publication' do
        expect do
          ParentCreationService.new(@params, user.id).call
        end.to change(Publication, :count).by(1)
        expect(Publication.last.name).to eq('New Publication name')
      end
    end
    context 'with invalid parameters for both Exhibition and Publication' do
      before do
        @params = {
          'authenticity_token' => 'Az63-cZWrn3XZ-urXVhxrb8rCWBTWc7V07BSPRRHp1TS3pEkzcsJbUnGljtW22b1mBQU1d7dWhL-BQ737OY4hA', 'article' => {
            'exhibition_id' => '1', 'exhibition_name' => nil, 'exhibition_year' => '1799', 'publication_id' => '1', 'publication_name' => nil, 'publication_type' => 'PERIODICAL', 'title' => 'Rspec test 2', 'author' => 'Rspec Author', 'favorability' => 'FAVORABLE', 'publication_date' => '1903-12-21'
          }
        }
      end
      let(:expected_result) { [false, false] }
      subject { described_class.new(@params, user.id).call }
      it 'returns false for a new exhibition and new publication' do
        expect(subject).to eq(expected_result)
      end
    end
  end
end
