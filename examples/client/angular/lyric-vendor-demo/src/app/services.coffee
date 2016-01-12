lyricVendorDemoServices = angular.module("lyricvendordemo.services", ["ngResource"])

lyricVendorDemoServices.factory "Client", [
  "$resource"
  ($resource) ->
    # return $resource("#{window.__env.API_BASE}/clients")
    return $resource("https://api.lyricfinancial.com/vendorAPI/v1/json/clients"
      clientId: "@clientId"
    ,
      save:
        method: "POST",
        headers:
          "vendorId":"ascap",
          "content-type":"application/json; charset=utf-8"
        transformResponse: (data, headers) ->
          response = {}
          response.data = data
          response.headers = headers()
          response
    )
]