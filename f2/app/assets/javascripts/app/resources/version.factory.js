(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Version', VersionFactory);

  /** @ngInject */
  function VersionFactory($resource) {
    var Version = $resource('/api/v1/version/', {});

    return Version;
  }
})();
