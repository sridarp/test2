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
      'services': {
        parent: 'application',
        url: '/services',
        redirectTo: 'services.list',
        template: '<ui-view></ui-view>',
        data: {
          authorizedRoles: ['user', 'manager', 'admin']
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'services': {
        type: 'state',
        state: 'services',
        label: 'Services',
        style: 'services',
        order: 300
      }
    };
  }
})();
