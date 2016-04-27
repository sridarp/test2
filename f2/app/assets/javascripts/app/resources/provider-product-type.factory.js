(function() {
  'use strict';

  angular.module('app.resources')
    .factory('ProviderProductType', ProviderProductTypeFactory);

  /** @ngInject */
  function ProviderProductTypeFactory($resource) {
    var ProviderProductType = $resource('/api/v1/providers/:providerId/product_types', {
      providerId: '@provider_id'
    });

    return ProviderProductType;
  }
})();
