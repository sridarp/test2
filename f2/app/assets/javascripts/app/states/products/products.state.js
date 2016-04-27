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
      'products': {
        parent: 'application',
        url: '/',
        redirectTo: 'marketplace',
        template: '<ui-view></ui-view>',
        data: {
          authorizedRoles: ['user', 'manager', 'admin']
        }
      }
    };
  }
})();
