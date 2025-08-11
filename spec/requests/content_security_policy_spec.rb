RSpec.describe "Content Security Policy", type: :request, aggregate_failures: true do
  it "sets all the necessary csp fields" do
    get "/"

    csp = last_response.headers["Content-Security-Policy"]

    expect(csp).to include("base-uri 'self'")
    expect(csp).to include("child-src 'self'")
    expect(csp).to include("connect-src 'self'")
    expect(csp).to include("default-src 'none'")
    expect(csp).to include("font-src 'self' https://cdnjs.cloudflare.com https://fonts.gstatic.com data:")
    expect(csp).to include("form-action https://account.withings.com/ 'self'")
    expect(csp).to include("frame-ancestors 'self'")
    expect(csp).to include("frame-src 'self'")
    expect(csp).to include("img-src 'self' https: data:")
    expect(csp).to include("media-src 'self'")
    expect(csp).to include("object-src 'none'")
    expect(csp).to include("script-src 'self' 'unsafe-inline'")
    expect(csp).to include("style-src 'self' 'unsafe-inline' https:")
  end
end
