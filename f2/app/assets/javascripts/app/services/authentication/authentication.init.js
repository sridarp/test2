(function() {
  'use strict';

  angular.module('app.components')
    .run(startup);

  /** @ngInject */
  function startup(userSession, SessionService) {
    if (angular.isDefined(userSession.id)) {
      SessionService.create(userSession);
    }
  }
})();
