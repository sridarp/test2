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
      'manage.products.list': {
        url: '', // No url, this state is the index of manage.products
        templateUrl: 'app/states/manage/products/list/list.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Manage Products List',
        resolve: {
          products: resolveProducts
        }
      }
    };
  }

  /** @ngInject */
  function resolveProducts(Product) {
    return Product.query().$promise;
  }

  /** @ngInject */
  function StateController($state, products, productTypes, ProductTypeModal) {
    var vm = this;

    vm.title = 'Manage Products List';
    vm.products = products;
    vm.productTypes = productTypes;

    vm.showModal = showModal;

    function showModal() {
      ProductTypeModal.showModal().then(handleResult);

      function handleResult(selections) {
        $state.go('manage.products.create', selections);
      }
    }
  }
})();
