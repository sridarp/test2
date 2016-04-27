(function() {
  'use strict';

  angular.module('app.resources')
    .factory('StaffPermissions', StaffPermissionsFactory);

  /** @ngInject */
  function StaffPermissionsFactory($resource) {
    var StaffPermissions = $resource('/api/v1/staff/:id/permissions/:projectId', {
      id: '@id',
      projectId: '@projectId'
    });

    return StaffPermissions;
  }
})();
