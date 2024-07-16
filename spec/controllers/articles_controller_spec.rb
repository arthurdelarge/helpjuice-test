require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:article) { Article.create(text: 'This is a query') }

  describe 'GET #index' do
    before { get :index }

    it 'assigns @articles' do
      expect(assigns(:articles)).to eq(Article.by_text(nil))
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    before { post :create, params: { text: 'This is a test' } }

    it 'creates a new article' do
      expect(Article.count).to eq(2)
    end

    it 'redirects to the articles path' do
      expect(response).to redirect_to(articles_path)
    end
  end

  describe 'POST #search' do
    let(:query) { 'query' }

    before { post :search, params: { query: query } }

    it 'sets the query' do
      expect(Search.last.query).to eq(query)
    end

    it 'redirects to the articles path' do
      expect(response).to redirect_to(articles_path(query: query))
    end
  end
end
