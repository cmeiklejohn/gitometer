Bundler.require

Spec::Runner.configure do |config|
  config.include(Rack::Test::Methods)

  def app
    Gitometer::Application.app
  end
end

