describe IdigbioClient do
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
