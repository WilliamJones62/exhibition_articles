require 'rails_helper'

RSpec.describe "Exhibitions", type: :request do
  describe "GET /exhibitions" do
    it "returns a successful response" do
      get exhibitions_path
      expect(response).to have_http_status(:ok)
    end
    it "assigns all exhibitions" do
      user = create(:user)
      exhibition1 = create(:exhibition, user: user)
      exhibition2 = create(:exhibition, user: user)
      get exhibitions_path
      expect(assigns(:exhibitions)).to match_array([exhibition1, exhibition2])
    end
  end
end
