describe IdigbioClient do
  describe ".show" do
    it "returns record given only uuid" do
      res = subject.show("1c29be70-24e7-480b-aab1-61224ded0f34")
      expect(res[:data].keys).to include(:publisher_type)
    end

    it "returns record of a given type" do
      res = subject.show("1c29be70-24e7-480b-aab1-61224ded0f34", :publisher)
      expect(res[:data].keys).to include(:publisher_type)
    end

    it "returns record of a type given as a string" do
      res = subject.show("1c29be70-24e7-480b-aab1-61224ded0f34", "publisher")
      expect(res[:data].keys).to include(:publisher_type)
    end

    it "fails if type is not known" do
      expect do
        subject.show("1c29be70-24e7-480b-aab1-61224ded0f34", :buzzinga)
      end.to raise_error
    end
  end
end
