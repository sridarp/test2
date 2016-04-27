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
      'manage': {
        parent: 'application',
        abstract: true,
        template: '<ui-view></ui-view>',
        url: '/manage',
        data: {
          authorizedRoles: ['admin', 'manager']
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'manage': {
        type: 'dropdown',
        state: 'manage',
        label: 'Manage',
        style: 'manage',
        order: 900,
        isVisible: isVisible
      }
    };
  }

  /** @ngInject */
  function isVisible(SessionService) {
    return SessionService.isManager();
  }
})();
