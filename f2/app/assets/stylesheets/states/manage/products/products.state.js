(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.sidebarItems(sidebarItems());
  }

  function getStates() {
    return {
      'manage.products': {
        url: '/products',
        redirectTo: 'manage.products.list',
        template: '<ui-view></ui-view>',
        resolve: {
          productTypes: resolveProductTypes
        }
      }
    };
  }

  function sidebarItems() {
    return {
      'manage.products': {
        type: 'state',
        state: 'manage.products',
        label: 'Products',
        order: 5
      }
    };
  }

  /** @ngInject */
  function resolveProductTypes(ProductType) {
    return ProductType.query().$promise;
  }
})();
