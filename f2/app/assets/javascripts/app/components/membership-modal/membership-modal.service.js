(function() {
  'use strict';

  angular.module('app.components')
    .factory('MembershipModal', MembershipModalFactory);

  /** @ngInject */
  function MembershipModalFactory($modal) {
    var service = {
      showModal: showModal
    };

    return service;

    function showModal(membership) {
      var modalOptions = {
        templateUrl: 'app/components/membership-modal/membership-modal.html',
        controller: MembershipModalController,
        controllerAs: 'vm',
        resolve: {
          roles: resolveRoles,
          groups: resolveGroups,
          membership: resolveMembership
        },
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);

      return modal.result;

      /** @ngInject */
      function resolveRoles(Role) {
        return Role.query().$promise;
      }

      /** @ngInject */
      function resolveGroups(Group) {
        return Group.query().$promise;
      }

      function resolveMembership() {
        return membership;
      }
    }
  }

  /** @ngInject */
  function MembershipModalController(lodash, membership, roles, groups) {
    var vm = this;

    vm.membership = membership;

    activate();

    function activate() {
      initFields();
    }

    // Private

    function initFields() {
      vm.fields = [
        {
          key: 'group_id',
          type: 'select',
          templateOptions: {
            label: 'Group',
            options: groups,
            valueProp: 'id',
            labelProp: 'name',
            onChange: setRelations
          }
        },
        {
          key: 'role_id',
          type: 'select',
          templateOptions: {
            label: 'Role',
            options: roles,
            valueProp: 'id',
            labelProp: 'name',
            onChange: setRelations
          }
        }
      ];
    }

    function setRelations() {
      if (vm.membership.group_id) {
        vm.membership.group = lodash.find(groups, 'id', vm.membership.group_id);
      }
      if (vm.membership.role_id) {
        vm.membership.role = lodash.find(roles, 'id', vm.membership.role_id);
      }
    }
  }
})();
