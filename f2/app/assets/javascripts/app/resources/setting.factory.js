(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Setting', SettingsFactory);

  /** @ngInject */
  function SettingsFactory($resource) {
    var Setting = $resource('/api/v1/settings/:name', {name: '@name'}, {
      update: {
        method: 'PUT',
        isArray: false
      }
    });

    return Setting;
  }
})();
