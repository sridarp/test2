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
      'orders': {
        parent: 'application',
        url: '/orders',
        redirectTo: 'orders.list',
        template: '<ui-view></ui-view>',
        data: {
          authorizedRoles: ['user', 'manager', 'admin']
        }
      }
    };
  }

  function sidebarItems() {
    return {
      'order-history': {
        type: 'state',
        state: 'orders',
        label: 'Orders',
        style: 'orders',
        order: 250
      }
    };
  }
})();
