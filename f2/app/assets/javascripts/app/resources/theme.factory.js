(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Theme', ThemeFactory);

  /** @ngInject */
  function ThemeFactory($resource) {
    var theme = $resource('/api/v1/theme', {}, {
      get: {
        method: 'GET',
        isArray: false
      },
      update: {
        method: 'PUT',
        isArray: false
      },
      query: {
        isArray: false
      }
    });

    return theme;
  }
})();
