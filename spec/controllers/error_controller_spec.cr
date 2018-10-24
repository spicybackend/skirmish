require "./spec_helper"

# Controller Unit Test
describe ErrorController do
  request = HTTP::Request.new("get", "/")
  response = HTTP::Server::Response.new(IO::Memory.new)
  context = HTTP::Server::Context.new(request, response)
  exception = Amber::Exceptions::Base.new
  subject = ErrorController.new(context, exception)

  describe "#not_found" do
    it "renders a 404 error page" do
      subject.not_found.should contain "404"
    end
  end

  describe "#forbidden" do
    it "renders a 403 error page" do
      subject.forbidden.should contain "403"
    end
  end

  describe "#internal_server_error" do
    it "renders a 500 error page" do
      subject.internal_server_error.should contain "500"
    end
  end

end

# Controller Integration Test
class ErrorControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
    end
    @handler.build :static do
      plug Amber::Pipe::Error.new
    end
    @handler.prepare_pipelines
  end
end

describe ErrorControllerTest do
  subject = ErrorControllerTest.new

  it "renders a 404 error page" do
    response = subject.get "/non-existent-route" # If this route exists, the test must be changed

    response.status_code.should eq 404
    response.body.should contain "404"
  end

end
