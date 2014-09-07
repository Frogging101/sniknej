class Jenkins
  class HTTP
    include HTTParty

    base_uri(ENV['SNIKNEJ_JENKINS_URI'])
    basic_auth(ENV['SNIKNEJ_JENKINS_USER_ID'], ENV['SNIKNEJ_JENKINS_API_TOKEN'])

#    format :json
#    debug_output $stdout
  end

  class << self
    def console(name, id, params={})
      HTTP.get("/job/#{URI.escape(name)}/#{URI.escape(id)}/consoleText").body.to_s
    end

    def jobs(params={})
      response do
        HTTP.get('/api/json', :query => params)
      end
    end

    def job(name, params={})
      response do
        HTTP.get("/job/#{URI.escape(name)}/api/json", :query => params)
      end
    end

    protected

    def response
      Hashie::Mash.new(yield.parsed_response)
    end
  end
end
