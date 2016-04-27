(function() {
  'use strict';

  angular.module('app.components')
    .factory('AuthorizationService', AuthorizationServiceFactory);

  /** @ngInject */
  function AuthorizationServiceFactory(SessionService, userRoles, AuthenticationService) {
    var service = {
      isAuthorized: isAuthorized
    };

    return service;

    function isAuthorized(authorizedRoles) {
      if (!angular.isArray(authorizedRoles)) {
        authorizedRoles = [authorizedRoles];
      }
      if (0 === authorizedRoles.length) {
        authorizedRoles = [userRoles.all];
      }
      // If authorizedRoles contains 'all', then we allow it through.
      if (-1 !== authorizedRoles.indexOf(userRoles.all)) {
        return true;
      } else {
        return (AuthenticationService.isAuthenticated() && -1 !== authorizedRoles.indexOf(SessionService.role));
      }
    }
  }
})();
