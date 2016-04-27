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
      'projects': {
        parent: 'application',
        url: '/projects',
        redirectTo: 'projects.list',
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
      'projects': {
        type: 'state',
        state: 'projects',
        label: 'Projects',
        style: 'projects',
        order: 100
      }
    };
  }
})();
