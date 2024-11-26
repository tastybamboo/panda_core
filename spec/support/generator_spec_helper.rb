module GeneratorSpecHelper
  def self.timestamped_path
    File.expand_path("../../tmp/#{Time.now.to_i}", __FILE__)
  end
end
