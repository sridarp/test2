(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Alert', AlertFactory);

  /** @ngInject */
  function AlertFactory($resource) {
    var Alert = $resource('/api/v1/alerts/:id', {id: '@id'}, {
      // Get single
      'update': {
        method: 'PUT',
        isArray: false
      }
    });

    Alert.statusToType = statusToType;

    return Alert;

    function statusToType(status) {
      switch (status) {
        case 'critical':
          return 'danger';
        case 'ok':
          return 'success';
        case 'warning':
          return 'warning';
        default:
          return 'info';
      }
    }
  }
})();
