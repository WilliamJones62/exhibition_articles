# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Reports", type: :request do
    let!(:user) { create(:user) }
    let!(:exhibition1) { create(:exhibition, name: 'Ex 1', year: 1800, user: user) }
    let!(:exhibition2) { create(:exhibition, name: 'Ex 2', year: 1800, user: user) }
    let!(:publication) { create(:publication, user: user) }
    let!(:article1) { create(:article, user: user, exhibition: exhibition1, publication: publication) }
    let!(:article2) { create(:article, user: user, exhibition: exhibition2, publication: publication) }
    let!(:article3) { create(:article, favorability: 'NEUTRAL', user: user, exhibition: exhibition1, publication: publication) }
    let!(:article4) { create(:article, favorability: 'UNFAVORABLE', user: user, exhibition: exhibition2, publication: publication) }

    describe "GET /api/v1/reports/barchart.json" do
                            
      before do
        get "/api/v1/reports/barchart.json?year=1800"
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
  
      it "returns a list of X and Y axis data" do
        json_response = JSON.parse(response.body)
        expect(json_response['xvalues'].count).to eq(2)
        expect(json_response['xvalues']).to eq(['Ex 1', 'Ex 2'])
        expect(json_response['yvalues']).to eq([75, 50])
      end
    end

    describe "GET /api/v1/reports/piechart.json" do
                            
        before do
          get "/api/v1/reports/piechart.json?year=1800"
        end
  
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
    
        it "returns a list of X and Y axis data" do
          json_response = JSON.parse(response.body)
          expect(json_response['xvalues'].count).to eq(2)
          expect(json_response['xvalues']).to eq(['Ex 1', 'Ex 2'])
          expect(json_response['yvalues']).to eq([2, 2])
        end
      end

      describe "GET /api/v1/reports/linegraph.json" do
                            
        before do
          get "/api/v1/reports/linegraph.json?exhibitions=Ex%201&exhibitions=Ex%202"
        end
  
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
    
        it "returns a list of X and Y axis data" do
          json_response = JSON.parse(response.body)
          expect(json_response['xvalues'].count).to eq(112)
          expect(json_response['yvalues'][8]).to eq(2)
        end
      end
  end