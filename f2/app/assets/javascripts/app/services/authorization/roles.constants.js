(function() {
  'use strict';

  angular.module('app.components')
    .constant('userRoles', {
      all: 'all',
      user: 'user',
      manager: 'manager',
      admin: 'admin'
    });
})();
