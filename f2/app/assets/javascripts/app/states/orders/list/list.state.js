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
      'orders.list': {
        url: '', // No url, this state is the index of orders
        templateUrl: 'app/states/orders/list/list.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Order History',
        resolve: {
          orders: resolveOrders
        }
      }
    };
  }

  /** @ngInject */
  function resolveOrders(Order) {
    return Order.query({'includes[]': ['staff', 'project', 'services', 'products']}).$promise;
  }

  /** @ngInject */
  function StateController(lodash, orders, Staff) {
    var vm = this;

    vm.title = 'Order History';

    activate();

    function activate() {
      initOrders();
    }

    // Private

    function initOrders() {
      vm.projects = lodash.groupBy(lodash.map(orders, mapOrder), 'project_id');

      function mapOrder(order) {
        var project = order.project;
        var staff = order.staff;

        delete order.project;
        delete order.staff;

        order.project = project.name;
        order.project_id = project.id;
        order.total = order.total();
        order.staff = new Staff(staff).fullName();
        order.status = lodash.capitalize(order.status);

        return order;
      }
    }
  }
})();
