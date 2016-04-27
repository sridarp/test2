(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'products.details': {
        url: 'product/:productId',
        templateUrl: 'app/states/products/details/details.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Product Details',
        resolve: {
          product: resolveProduct
        }
      }
    };
  }

  /** @ngInject */
  function resolveProduct(Product, $stateParams) {
    return Product.get({
      id: $stateParams.productId,
      'includes[]': ['product_type', 'answers', 'provider']
    }).$promise;
  }

  /** @ngInject */
  function StateController(product) {
    var vm = this;

    vm.title = 'Product Details';

    vm.product = product;

    vm.activate = activate;

    activate();

    function activate() {
    }
  }
})();
