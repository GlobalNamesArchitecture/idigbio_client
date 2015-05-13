require 'minitest/autorun'
require '../idigbio/client'


class TestClient < Minitest::Test
    def setup
        @client = Idigbio::Client.new
    end

    def test_that_client_can_run_basic_search
        assert @client.search(params: {rq: {genus: 'acer'}, limit: 100}).key?('itemCount')
    end

    def test_record_search
        assert @client.search_records(rq: {genus: 'puma'}).key?('items')
    end

    def test_media_search
        assert @client.search_media(rq: {genus: 'puma'})['items'].length >= 1
    end
end