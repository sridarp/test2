(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Membership', MembershipFactory);

  /** @ngInject */
  function MembershipFactory($resource) {
    var Membership = $resource('/api/v1/memberships/:id',
      {id: '@id', project_id: '@project_id'}, {
        query: {
          url: '/api/v1/projects/:project_id/memberships',
          method: 'GET',
          isArray: true
        },
        save: {
          url: '/api/v1/projects/:project_id/memberships',
          method: 'POST',
          isArray: false
        },
        update: {
          method: 'PUT',
          isArray: false
        }
      });

    Membership.defaults = {
      project_id: null,
      group_id: null,
      role_id: null
    };

    Membership.new = newMembership;

    return Membership;

    function newMembership(data) {
      return new Membership(angular.extend({}, Membership.defaults, data || {}));
    }
  }
})();
