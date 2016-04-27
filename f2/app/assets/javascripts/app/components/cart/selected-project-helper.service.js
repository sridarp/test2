(function() {
  'use strict';

  angular.module('app.components')
    .service('SelectedProjectHelper', SelectedProjectHelperService);

  /** @ngInject */
  function SelectedProjectHelperService(lodash, Project) {
    var service = {
      selectedProject: {},
      defaultProject: false,
      selectProject: selectProject,
      reset: reset
    };

    return service;

    function selectProject(selected, setDefault) {
      service.selectedProject = selected;
      if (setDefault) {
        service.defaultProject = true;
      }
    }

    function reset() {
      service.selectedProject = {};
      service.defaultProject = false;
    }
  }
})();
