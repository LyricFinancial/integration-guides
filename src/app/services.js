var lyricVendorDemoServices;

lyricVendorDemoServices = angular.module("lyricvendordemo.services", ["ngResource"]);

lyricVendorDemoServices.factory("Client", [
  "$resource", function($resource) {
    return $resource("https://api.lyricfinancial.com/vendorAPI/v1/json/clients", {
      clientId: "@clientId"
    }, {
      save: {
        method: "POST",
        headers: {
          "vendorId": "ascap",
          "content-type": "application/json; charset=utf-8"
        },
        transformResponse: function(data, headers) {
          var response;
          response = {};
          response.data = data;
          response.headers = headers();
          return response;
        }
      }
    });
  }
]);
