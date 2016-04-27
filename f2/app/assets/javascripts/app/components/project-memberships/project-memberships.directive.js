(function() {
  'use strict';

  angular.module('app.components')
    .directive('projectMemberships', ProjectMembershipsDirective);

  /** @ngInject */
  function ProjectMembershipsDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        project: '=',
        memberships: '='
      },
      link: link,
      templateUrl: 'app/components/project-memberships/project-memberships.html',
      controller: ProjectMembershipsController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function ProjectMembershipsController(lodash, Toasts, Membership, MembershipModal) {
      var vm = this;

      vm.activate = activate;
      vm.showModal = showModal;
      vm.remove = remove;
      vm.readOnly = readOnlyCheck;

      function activate() {
      }

      function showModal(membership) {
        var clonedMembership = null;

        if (angular.isUndefined(membership)) {
          membership = Membership.new({project_id: vm.projectId});
        }
        clonedMembership = angular.copy(membership);
        MembershipModal.showModal(clonedMembership).then(handleResult);

        function handleResult() {
          membership = angular.merge(membership, clonedMembership);
          if (membership.id) {
            membership.$update(updateSuccess, saveFailure);
          } else {
            membership.$save(saveSuccess, saveFailure);
          }
        }

        function saveSuccess() {
          Toasts.toast('Membership saved.');
          membership = angular.merge(membership, clonedMembership);
          vm.memberships.push(membership);
        }

        function updateSuccess() {
          membership = angular.merge(membership, clonedMembership);
          Toasts.toast('Membership updated.');
        }

        function saveFailure(error) {
          Toasts.error('Error while saving membership.');
        }
      }

      function remove(membership) {
        membership.$delete(deleteSuccess, deleteFailure);

        function deleteSuccess() {
          lodash.remove(vm.memberships, {id: membership.id});
          Toasts.toast('Membership successfully removed.');
        }

        function deleteFailure() {
          Toasts.error('Could not remove membership. Try again later.');
        }
      }

      function readOnlyCheck() {
        return null === vm.project.archived;
      }
    }
  }
})();
