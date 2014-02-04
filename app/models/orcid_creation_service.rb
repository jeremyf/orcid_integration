# Responsible for minting a new ORCID for the given payload.
class OrcidCreationService
  attr_reader :host, :access_token
  def initialize(config)
    @host = config.fetch(:host)
    @access_token = config.fetch(:access_token)
  end

  def call(payload)
    response = deliver(payload)
    parse(response)
  end

  protected
  def deliver(payload)
    RestClient.post(uri, payload, headers)
  end

  def parse(response)
    response.headers.fetch(:location).sub(host, '').split("/")[1]
  end

  def uri
    File.join(host, "v1.1/orcid-profile")
  end

  def headers
    {
      :accept => :xml,
      'Authorization' => "Bearer #{access_token}",
     'Content-Type'=>'application/vdn.orcid+xml'
    }
  end
end