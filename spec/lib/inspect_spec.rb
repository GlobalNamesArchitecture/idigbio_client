describe IdigbioClient do
  describe ".fields" do
    it "returns fields of types" do
      res = subject.fields
      expect(res).to be_kind_of Hash
      expect(res.keys).to eq subject.types.map(&:to_sym)
      expect(res[:records][:uuid]).to eq(type: "string", fieldName: "uuid")
    end

    it "returns fields on allowed type" do
      res = subject.fields(:mediarecords)
      expect(res).to be_kind_of Hash
      expect(res[:mediarecords][:uuid]).to eq(type: "string", fieldName: "uuid")
    end

    it "returns fields of type sent as a string" do
      res = subject.fields("mediarecords")
      expect(res).to be_kind_of Hash
      expect(res[:mediarecords][:uuid]).to eq(type: "string", fieldName: "uuid")
    end

    it "fails if type is unknown" do
      expect { subject.fields("whateva") }.to raise_error
    end
  end
end
