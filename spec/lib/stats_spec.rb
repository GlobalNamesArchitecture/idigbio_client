describe IdigbioClient do
  describe ".count" do
    it "counts records by default" do
      all = subject.count
      expect(all).to be > 10
    end
  end
end
