# frozen_string_literal: true

module AdhDiary
  module Actions
    module Debug
      class Index < AdhDiary::Action
        def handle(request, response)
          output = <<~TEXT
            request.env['HTTPS'] == #{request.env["HTTPS"]}
            request.env['HTTP_X_FORWARDED_SSL'] == #{request.env["HTTP_X_FORWARDED_SSL"]}
            request.env['HTTP_X_FORWARDED_SCHEME'] == #{request.env["HTTP_X_FORWARDED_SCHEME"]}
            request.env['HTTP_X_FORWARDED_PROTO'] == #{request.env["HTTP_X_FORWARDED_PROTO"]}
            request.env['rack.url_scheme'] == #{request.env["rack.url_scheme"]}
            -----
            #{request.env.awesome_inspect}
          TEXT
          response.body = output
          response.content_type = "text/plain"
        end
      end
    end
  end
end
