describe IdigbioClient do
  it "has a version number" do
    expect(IdigbioClient::VERSION).to match(/^[\d]+\.[\d]+\.[\d]+$/)
    expect(IdigbioClient.version).to match(/^[\d]+\.[\d]+\.[\d]+$/)
  end
end
