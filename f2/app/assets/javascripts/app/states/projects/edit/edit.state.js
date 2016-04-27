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
      'projects.edit': {
        url: '/edit/:projectId',
        templateUrl: 'app/states/projects/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Project Edit Role',
        resolve: {
          project: resolveProject,
          projectQuestions: resolveProjectQuestions
        }
      }
    };
  }

  /** @ngInject */
  function resolveProject(Project, $stateParams) {
    return Project.get({
      id: $stateParams.projectId,
      'includes[]': ['answers']
    }).$promise;
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
  function StateController(lodash, project, projectQuestions) {
    var vm = this;

    vm.title = 'Project Role';
    vm.project = project;

    vm.activate = activate;

    activate();

    function activate() {
      initAnswers();
    }

    // Private

    function initAnswers() {
      angular.forEach(projectQuestions, addAnswer);
      vm.project.answers = projectQuestions;

      function addAnswer(question) {
        var answer = lodash.find(vm.project.answers, 'name', question.name);

        angular.extend(question, answer || {});
      }
    }
  }
})();
