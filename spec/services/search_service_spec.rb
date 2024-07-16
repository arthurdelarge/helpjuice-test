require 'rails_helper'

RSpec.describe SearchService, type: :service do
  let(:local_ip_address) { '::1' }
  let(:query)            { 'QUERY' }

  describe '#set_query' do
    subject { SearchService.set_query(local_ip_address, query) }

    context 'when ip_address and query are present' do
      context 'when the search already exists' do
        let!(:search) { Search.create(query: query, ip_address: local_ip_address) }

        before { Search.create(query: query, ip_address: local_ip_address) }

        it 'increments the times' do
          expect { subject }.to change { search.reload.times }.by(1)
        end

        it 'updates the updated_at' do
          expect { subject }.to change { search.reload.updated_at }
        end
      end

      context 'when the search does not exist but the query starts with the previous query' do
        let(:previous_query) { 'Q' }
        let!(:search) { Search.create(query: previous_query, ip_address: local_ip_address) }

        it 'updates the previous search' do
          expect { subject }.to change { search.reload.query }.from(previous_query.downcase).to(query.downcase)
        end

        it 'sets the times to the previous search' do
          expect { subject }.not_to change { search.reload.times }
        end
      end

      context 'when the search does not exist' do
        it 'creates a new search' do
          expect { subject }.to change(Search, :count).by(1)
        end
      end
    end

    context 'when ip_address and query are not present' do
      it 'does not create a new search' do
        expect { SearchService.set_query(nil, nil) }.not_to change(Search, :count)
      end

      it 'does not update the previous search' do
        expect { SearchService.set_query(nil, nil) }.not_to change(Search, :count)
      end

      it 'returns nil' do
        expect(SearchService.set_query(nil, nil)).to be_nil
      end
    end
  end
end
