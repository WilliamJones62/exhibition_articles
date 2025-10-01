# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exhibitions', type: :request do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  let!(:exhibition1) { create(:exhibition, user: user) }
  let!(:exhibition2) { create(:exhibition, user: user) }
  describe 'GET /exhibitions' do
    it 'returns a successful response' do
      get exhibitions_path
      expect(response).to have_http_status(:ok)
    end
    it 'assigns all exhibitions' do
      get exhibitions_path
      expect(assigns(:exhibitions)).to match_array([exhibition1, exhibition2])
    end
  end

  describe 'GET /exhibition/:id/edit' do
    it 'renders a successful response' do
      get edit_exhibition_path(exhibition1)
      expect(response).to be_successful
    end

    it 'assigns the requested resource to @exhibition' do
      get edit_exhibition_path(exhibition1)
      expect(assigns(:exhibition)).to eq(exhibition1)
    end
  end

  describe 'DELETE /exhibition/:id' do
    context 'when the resource exists' do
      it 'destroys the specified resource' do
        expect do
          delete exhibition_path(exhibition1)
        end.to change(Exhibition, :count).by(-1)
      end
    end
  end
end
