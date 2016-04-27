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
      'manage.motd': {
        url: '/motd',
        redirectTo: 'manage.motd.edit',
        template: '<ui-view></ui-view>'
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'manage.alerts': {
        type: 'state',
        state: 'manage.motd',
        label: 'Message of the Day',
        order: 3
      }
    };
  }
})();
