(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Product', ProductFactory);

  /** @ngInject */
  function ProductFactory($resource) {
    var Product = $resource('/api/v1/products/:id', {id: '@id'}, {
      update: {
        method: 'PUT',
        isArray: false
      }
    });

    Product.defaults = {
      name: '',
      description: '',
      active: true,
      setup_price: '0.0',
      monthly_price: '0.0',
      hourly_price: '0.0',
      tags: []
    };

    Product.new = newProduct;

    function newProduct(data) {
      return new Product(angular.extend({}, Product.defaults, data || {}));
    }

    return Product;
  }
})();
