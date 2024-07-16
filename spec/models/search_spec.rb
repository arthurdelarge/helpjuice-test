require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:local_ip_address) { '::1' }
  let(:query)            { 'QUERY' }
  let(:search)           { Search.create(query: query, ip_address: local_ip_address) }

  describe 'validations' do
    it { expect(search).to validate_presence_of(:query) }
    it { expect(search).to validate_presence_of(:ip_address) }
    it { expect(search).to validate_presence_of(:times) }
    it { expect(search).to validate_numericality_of(:times).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    context 'before_save' do
      it 'downcases the query' do
        expect(search.query).to eq(query.downcase)
      end
    end

    context 'after_save' do
      before do
        500.times do |i|
          Search.create(query: "query#{i}", ip_address: local_ip_address)
        end
      end

      it 'removes old user searches' do
        expect(Search.where(ip_address: local_ip_address).count).to eq(250)
      end
    end
  end

  describe 'scopes' do
    context '.recent_global' do
      subject { Search.recent_global }

      before do
        200.times do |i|
          Search.create(query: "query#{i}", ip_address: "#{i}")
        end
      end

      it 'returns the 100 most recent searches' do
        expect(subject.count).to eq(100)
        expect(subject.first.query).to eq('query199')
        expect(subject.last.query).to eq('query100')
      end
    end

    context '.recent_local' do
      subject { Search.recent_local(local_ip_address) }

      before do
        200.times do |i|
          Search.create(query: "query#{i}", ip_address: local_ip_address)
        end
      end

      it 'returns the 100 most recent searches from the given ip_address' do
        expect(subject.count).to eq(100)
        expect(subject.first.query).to eq('query199')
        expect(subject.last.query).to eq('query100')
      end
    end

    context '.trending' do
      subject { Search.trending }

      before(:each) do
        200.times do |i|
          Search.create(query: "query#{i}", ip_address: local_ip_address)
        end
        20.times do |i|
          Search.create(query: "query#{i}", ip_address: "#{i}")
        end
        50.times do |i|
          Search.create(query: query, ip_address: local_ip_address)
        end
      end

      it 'returns the 100 most popular searches ordered by times' do
        expect(subject.count).to eq(100)
        expect(subject.first[0]).to eq(query.downcase)
      end

      context 'when the search is older than 5 minutes' do
        before do
          Search.offset(50).update_all(updated_at: 6.minutes.ago)
        end

        it 'returns searches from the last 5 minutes' do
          expect(subject.count).to eq(50)
        end
      end
    end
  end

  describe 'methods' do
    context '#increment_times' do
    end

    context '#recent?' do
    end
  end
end
