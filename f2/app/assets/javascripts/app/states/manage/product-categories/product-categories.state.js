(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.navItems(navItems());
    navigationHelper.sidebarItems(sidebarItems());
  }

  function getStates() {
    return {
      'manage.product-categories': {
        url: '/product-categories',
        redirectTo: 'manage.product-categories.list',
        template: '<ui-view></ui-view>'
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'manage.product-categories': {
        type: 'state',
        state: 'manage.product-categories',
        label: 'Product Categories',
        order: 4
      }
    };
  }
})();
