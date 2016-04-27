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
      'orders.details': {
        url: '/details/:orderId',
        templateUrl: 'app/states/orders/details/details.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Order Details',
        resolve: {
          order: resolveOrder
        }
      }
    };
  }

  /** @ngInject */
  function resolveOrder($stateParams, Order) {
    return Order.get({
      id: $stateParams.orderId,
      'includes[]': ['products', 'project', 'services', 'staff']
    }).$promise;
  }

  /** @ngInject */
  function StateController(order, lodash) {
    var vm = this;

    vm.order = order;
    vm.staff = order.staff;
    vm.products = order.products;
    vm.project = order.project;

    vm.activate = activate;

    activate();

    function activate() {
      lodash.forEach(vm.order.services, mapProduct);

      function mapProduct(service) {
        service.product = lodash.find(order.products, {'id': service.product_id});
      }
    }
  }
})();
