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
      'projects.details': {
        url: '/:projectId',
        templateUrl: 'app/states/projects/details/details.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Project Details',
        resolve: {
          project: resolveProject,
          services: resolveServices,
          memberships: resolveMemberships,
          projectQuestions: resolveProjectQuestions
        }
      }
    };
  }

  /** @ngInject */
  function resolveProject($stateParams, Project) {
    return Project.get({
      id: $stateParams.projectId,
      'includes[]': ['latest_alerts', 'approvals', 'approvers', 'memberships', 'groups', 'answers']
    }).$promise;
  }

  /** @ngInject */
  function resolveServices($stateParams, ProjectService) {
    return ProjectService.query({
      projectId: $stateParams.projectId,
      'includes[]': ['product']
    }).$promise;
  }

  /** @ngInject */
  function resolveMemberships($stateParams, Membership) {
    return Membership.query({
      project_id: $stateParams.projectId,
      'includes[]': ['group', 'role']
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
  function StateController($state, lodash, Toasts, project, services, memberships, projectQuestions) {
    var vm = this;

    vm.title = 'Project Details';
    vm.project = project;
    vm.services = services;
    vm.memberships = memberships;
    vm.activeServices = activeServices;
    vm.archiveProject = archiveProject;

    vm.activate = activate;
    vm.approve = approve;
    vm.reject = reject;

    activate();

    function activate() {
      initAnswers();
    }

    function approve() {
      $state.reload();
    }

    function reject() {
      $state.transitionTo('projects.list');
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

    function activeServices() {
      var status = lodash.pluck(vm.services, 'status');
      if (0 === status.length) {
        return false;
      }
    }

    function archiveProject() {
      vm.project.$delete(saveSuccess, saveFailure);

      function saveSuccess() {
        Toasts.toast('Project Archived');
        $state.go('projects');
      }

      function saveFailure(error) {
        var data = error.data;
        var message = 'Project Not Archived';

        if (angular.isObject(data) && angular.isDefined(data.error)) {
          message = data.error;
        }

        Toasts.error(message);
      }
    }
  }
})
();
