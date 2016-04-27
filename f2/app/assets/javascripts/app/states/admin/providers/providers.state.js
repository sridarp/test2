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
      'admin.providers': {
        url: '/providers',
        redirectTo: 'admin.providers.list',
        template: '<ui-view></ui-view>',
        resolve: {
          registeredProviders: resolveRegisteredProviders
        }
      }
    };
  }

  /** @ngInject */
  function resolveRegisteredProviders(RegisteredProvider) {
    return RegisteredProvider.query().$promise;
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'admin.providers': {
        type: 'state',
        state: 'admin.providers',
        label: 'Providers',
        order: 9
      }
    };
  }
})();
