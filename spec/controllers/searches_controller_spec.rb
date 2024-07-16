require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:local_ip_address) { '::1' }
  let(:query) { 'query' }

  describe 'GET #index' do
    before do
      200.times do |i|
        Search.create(query: "query#{i}", ip_address: local_ip_address)
      end
      20.times do |i|
        Search.create(query: "query#{i}", ip_address: "#{i}")
      end
      50.times do |i|
        Search.create(query: query, ip_address: local_ip_address)
      end
      get :index
    end

    it 'assigns @recent_global' do
      expect(assigns(:recent_global)).to eq(Search.recent_global)
    end

    it 'assigns @recent_local' do
      expect(assigns(:recent_local)).to eq(Search.recent_local(request.remote_ip))
    end

    it 'assigns @trending' do
      expect(assigns(:trending)).to eq(Search.trending)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
