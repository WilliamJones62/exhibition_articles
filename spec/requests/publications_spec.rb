# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Publications', type: :request do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  let!(:publication1) { create(:publication, user: user) }
  let!(:publication2) { create(:publication, user: user) }
  describe 'GET /publications' do
    it 'returns a successful response' do
      get publications_path
      expect(response).to have_http_status(:ok)
    end
    it 'assigns all publications' do
      get publications_path
      expect(assigns(:publications)).to match_array([publication1, publication2])
    end
  end

  describe 'GET /publication/:id/edit' do
    it 'renders a successful response' do
      get edit_publication_path(publication1)
      expect(response).to be_successful
    end

    it 'assigns the requested resource to @publication' do
      get edit_publication_path(publication1)
      expect(assigns(:publication)).to eq(publication1)
    end
  end

  describe 'DELETE /publication/:id' do
    context 'when the resource exists' do
      it 'destroys the specified resource' do
        expect do
          delete publication_path(publication1)
        end.to change(Publication, :count).by(-1)
      end
    end
  end
end
