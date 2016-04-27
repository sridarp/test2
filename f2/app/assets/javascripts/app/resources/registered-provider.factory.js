(function() {
  'use strict';

  angular.module('app.resources')
    .factory('RegisteredProvider', RegisteredProviderFactory);

  /** @ngInject */
  function RegisteredProviderFactory($resource) {
    var RegisteredProvider = $resource('/api/v1/registered_providers/:id');

    return RegisteredProvider;
  }
})();
