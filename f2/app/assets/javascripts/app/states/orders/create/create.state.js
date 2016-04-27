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
      'orders.create': {
        url: '/:productId',
        templateUrl: 'app/states/orders/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Order Create',
        resolve: {
          product: resolveProduct,
          projects: resolveProjects
        }
      }
    };
  }

  /** @ngInject */
  function resolveProduct($stateParams, Product) {
    return Product.get({id: $stateParams.productId, 'includes[]': ['product_type', 'provider']}).$promise;
  }

  /** @ngInject */
  function resolveProjects(Project) {
    return Project.query({approved: true, archived: false}).$promise;
  }

  /** @ngInject */
  function StateController(product, projects, Order) {
    var vm = this;

    vm.title = 'Order Create';

    vm.activate = activate;

    activate();

    function activate() {
      vm.subHeading = [product.product_type.name, product.name].join(' :: ');
      initOrder();
      initForm();
    }

    // Private

    function initOrder() {
      vm.order = Order.new({product_id: product.id});
      vm.order.product_id = product.id;
      vm.order.answers = product.order_questions;
    }

    function initForm() {
      vm.options = {
        formState: {
          product: product,
          provider: product.provider,
          projects: projects
        }
      };
    }
  }
})();
