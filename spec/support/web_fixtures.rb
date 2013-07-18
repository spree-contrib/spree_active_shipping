module WebFixtures
  def fixture(name)
    files = Dir[Pathname.new(File.expand_path(File.dirname(__FILE__)) + "/../fixtures/#{name}*")]
    File.read(files.first)
  end
end