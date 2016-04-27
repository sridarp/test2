(function() {
  'use strict';

  angular.module('app.resources')
    .factory('ProjectService', ProjectServiceFactory);

  /** @ngInject */
  function ProjectServiceFactory($resource) {
    var ProjectService = $resource('/api/v1/projects/:projectId/services', {
      projectId: '@project_id'
    });

    return ProjectService;
  }
})();
