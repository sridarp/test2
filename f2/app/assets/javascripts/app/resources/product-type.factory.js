(function() {
  'use strict';

  angular.module('app.resources')
    .factory('ProductType', ProductTypeFactory);

  /** @ngInject */
  function ProductTypeFactory($resource, $http) {
    var ProductType = $resource('/api/v1/product_types/:id', {id: '@id'});

    return ProductType;
  }
})();
