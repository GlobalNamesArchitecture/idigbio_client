describe IdigbioClient do
  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^[\d]+\.[\d]+\.[\d]+$/)
      expect(subject.version).to match(/^[\d]+\.[\d]+\.[\d]+$/)
    end
  end

  describe ".logger" do
    it "returns logger" do
      expect(subject.logger).to be_kind_of Logger
    end
  end
end
