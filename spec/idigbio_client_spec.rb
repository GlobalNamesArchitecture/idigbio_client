describe IdigbioClient do
  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^[\d]+\.[\d]+\.[\d]+$/)
      expect(subject.version).to match(/^[\d]+\.[\d]+\.[\d]+$/)
    end
  end

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

  describe ".fields" do
    it "returns fields of a default 'records' type" do
      res = subject.fields
      expect(res).to be_kind_of Hash
      expect(res[:uuid]).to eq(type: "string", fieldName: "uuid")
    end

    it "returns fields on allowed type" do
      res = subject.fields("mediarecords")
      expect(res).to be_kind_of Hash
      expect(res[:uuid]).to eq(type: "string", fieldName: "uuid")
    end

    it "fails if type is unknown" do
      expect { subject.fields("whateva") }.to raise_error
    end
  end
end
