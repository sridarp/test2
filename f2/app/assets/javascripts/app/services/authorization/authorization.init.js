(function() {
  'use strict';

  angular.module('app.components')
    .run(appRun);

  /** @ngInject */
  function appRun($rootScope, $state, AuthenticationService, AuthorizationService, jQuery) {
    $rootScope.$on('$stateChangeStart', changeStart);
    $rootScope.$on('$stateChangeError', changeError);
    $rootScope.$on('$stateChangeSuccess', changeSuccess);

    function changeStart(event, toState, toParams, fromState, fromParams) {
      var authorizedRoles = ['all'];

      if (toState.data && toState.data.authorizedRoles) {
        authorizedRoles = toState.data.authorizedRoles;
      }

      if (!AuthorizationService.isAuthorized(authorizedRoles)) {
        event.preventDefault();
        if (AuthenticationService.isAuthenticated()) {
          $state.transitionTo('errors.unauthorized');
        } else {
          $state.transitionTo('login');
        }
      }
    }

    function changeError(event, toState, toParams, fromState, fromParams, error) {
      // If a 401 is encountered during a state change, then kick the user back to the login
      if (401 === error.status) {
        event.preventDefault();
        if (AuthenticationService.isAuthenticated()) {
          $state.transitionTo('logout');
        } else if ('login' !== toState.name) {
          $state.transitionTo('login');
        }
      }
    }

    function changeSuccess() {
      jQuery('html, body').animate({scrollTop: 0}, 200);
    }
  }
})();
