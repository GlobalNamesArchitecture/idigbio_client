describe IdigbioClient do
  describe ".show" do
    it "returns record given only uuid" do
      res = subject.show("1c29be70-24e7-480b-aab1-61224ded0f34")
      expect(res[:data].keys).to include(:publisher_type)
    end
  end
end
