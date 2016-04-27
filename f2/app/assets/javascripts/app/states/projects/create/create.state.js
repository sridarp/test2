(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'projects.create': {
        url: '/create',
        templateUrl: 'app/states/projects/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Project Create',
        resolve: {
          projectQuestions: resolveProjectQuestions
        }
      }
    };
  }

  /** @ngInject */
  function resolveProjectQuestions(ProjectQuestion, lodash) {
    return ProjectQuestion.query({ordered: true}).$promise.then(mapAsFieldQuestions);

    function mapAsFieldQuestions(questions) {
      return lodash.map(questions, mapQuestion);

      function mapQuestion(question) {
        return question.asField();
      }
    }
  }

  /** @ngInject */
  function StateController(Project, projectQuestions) {
    var vm = this;

    vm.activate = activate;

    activate();

    function activate() {
      initProject();
    }

    // Private

    function initProject() {
      vm.project = Project.new({answers: projectQuestions});
    }
  }
})();
