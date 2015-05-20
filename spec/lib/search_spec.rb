describe IdigbioClient::Search do
  describe ".search" do
    let(:params) { { "rq" => { "genus" => "acer" }, "limit" => 2 } }

    context "small query" do
      it "returns 2 items" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 2
      end
    end

    context "larger query" do
      let(:params) { { "rq" => { genus: "acer" }, limit: 288 } }

      it "returns 288 items" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 288
      end

      it "returns 188 items with offset 100" do
        res = subject.search(params: params.merge(offset: 100))
        expect(res[:items].size).to eq 188
      end
    end

    context "no limit given" do
      let(:params) { { rq: { genus: "acer" } } }

      it "returns first 100 items" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 100
      end
    end

    context "no query given" do
      let(:params) { {} }

      it "returns first 100 records" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 100
      end
    end

    context "get method" do
      it "returns 2 results" do
        res = subject.search(method: :get, params: params)
        expect(res[:items].size).to eq 2
      end
    end

    context "different path" do
      let(:params) { { rq: { country: "USA" } } }

      it "returns 2 results" do
        res = subject.search(path: "search/", params: params)
        expect(res[:items].size).to eq 100
      end
    end
  end
end
