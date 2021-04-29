local helpers = require "spec.helpers"
local kong_client = require "kong_client.spec.test_helpers"

describe("Body Inspector", function()
  local kong_sdk, send_request

  setup(function()
    helpers.start_kong({ plugins = "body-inspector" })

    kong_sdk = kong_client.create_kong_client()
    send_request = kong_client.create_request_sender(helpers.proxy_client())
  end)

  teardown(function()
    helpers.stop_kong(nil)
  end)

  before_each(function()
    helpers.db:truncate()
  end)

  context("when plugin enabled with default vaules", function()

    local service

    before_each(function()
      service = kong_sdk.services:create({
        name = "test-service",
        id = "0a7f3795-bc92-43b5-aada-258113b7c4ed",
        url = "http://mockbin:8080/status/502/something_went_wrong"
      })

      kong_sdk.routes:create_for_service(service.id, "/test")
    end)

    it("should not touch the response", function()
      kong_sdk.plugins:create({
        service = {
          id = service.id
        },
        name = "body-inspector"
      })

      local response = send_request({
        method = "GET",
        path = "/test"
      })

      assert.are.equal(502, response.status)
      assert.is_equal("something_went_wrong", response.body.message)
    end)
  end)

end)
