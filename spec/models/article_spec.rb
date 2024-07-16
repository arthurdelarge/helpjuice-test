require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    it { expect(Article.new).to validate_presence_of(:text) }
  end

  describe 'scopes' do
    context '.by_text' do
      let(:query) { 'query' }

      before do
        Article.create(text: 'This is a query')
        Article.create(text: 'This is another query')
        Article.create(text: 'This is a test')
      end

      subject { Article.by_text(query) }

      it 'returns the articles that match the query' do
        expect(subject.count).to eq(2)
        expect(subject).to eq(Article.where('LOWER(text) LIKE ?', "%#{query.downcase}%").order(created_at: :desc))
      end
    end
  end
end
