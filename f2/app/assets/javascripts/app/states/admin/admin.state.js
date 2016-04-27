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
      'admin': {
        parent: 'application',
        abstract: true,
        template: '<ui-view></ui-view>',
        url: '/admin',
        data: {
          authorizedRoles: ['admin']
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'admin': {
        type: 'dropdown',
        state: 'admin',
        label: 'Admin',
        style: 'admin',
        order: 1000,
        isVisible: isVisible
      }
    };
  }

  /** @ngInject */
  function isVisible(SessionService) {
    return SessionService.isAdmin();
  }
})();
