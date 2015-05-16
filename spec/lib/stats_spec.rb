describe IdigbioClient do
  describe ".count_records" do
    it "returns count" do
      all = subject.count_records
      expect(all).to be > 10
    end
  end
end
