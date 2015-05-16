describe IdigbioClient do
  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^[\d]+\.[\d]+\.[\d]+$/)
      expect(subject.version).to match(/^[\d]+\.[\d]+\.[\d]+$/)
    end
  end

  describe ".search" do
    context "small query" do
      let(:params) { { "rq" => { "genus" => "acer" }, "limit" => 2 } }

      it "returns 2 items" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 2
      end
    end

    context "larger query" do
      let(:params) { { "rq" => { genus: "acer" }, :limit => 288 } }

      it "returns 288 items" do
        res = subject.search(params: params)
        expect(res[:items].size).to eq 288
      end
    end
  end
end
