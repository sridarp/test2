(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Project', ProjectFactory);

  /** @ngInject */
  function ProjectFactory($resource, lodash, moment) {
    var Project = $resource('/api/v1/projects/:id', {id: '@id'}, {
      'update': {
        method: 'PUT',
        isArray: false
      },
      'approve': {
        url: '/api/v1/projects/:id/approve',
        method: 'POST',
        params: {'includes[]': ['approvals', 'approvers']}
      },
      'reject': {
        url: '/api/v1/projects/:id/reject',
        method: 'DELETE',
        params: {'includes[]': ['approvals', 'approvers']}
      },
      'approvals': {
        url: '/api/v1/projects/:id/approvals',
        method: 'GET',
        isArray: true
      }
    });

    Project.defaults = {
      name: '',
      description: '',
      img: '',
      start_date: null,
      end_date: null
    };

    Project.new = newProject;

    Project.prototype.finalApproval = finalApproval;
    Project.prototype.scheduleRemaining = scheduleRemaining;
    Project.prototype.monthsRemaining = monthsRemaining;
    Project.prototype.budgetRemaining = budgetRemaining;
    Project.prototype.budgetUtilization = budgetUtilization;
    Project.prototype.budgetUtilizationStatus = budgetUtilizationStatus;
    Project.prototype.budgetRemainder = budgetRemainder;
    Project.prototype.budgetRemainderStatus = budgetRemainderStatus;

    return Project;

    function newProject(data) {
      return new Project(angular.extend({}, angular.copy(Project.defaults), data || {}));
    }

    function finalApproval() {
      /* jshint validthis:true */
      var self = this;

      if (!angular.isDefined(self.approvals) || (0 === self.approvals.length)) {
        return null;
      }

      return findFinalApproval(self.approvals, self.approvers);

      function findFinalApproval(approvals, approvers) {
        var approval = approvals[approvals.length - 1];

        if (approvers) {
          lodash.each(approvers, function(approver) {
            if (approver.id === approval.staff_id) {
              approval.staff_name = [approver.first_name, approver.last_name].join(' ');
            }
          });
        }

        return approval;
      }
    }

    function scheduleRemaining() {
      /* jshint validthis:true */
      var self = this;

      var now = moment();
      var endDate = moment(self.end_date);

      if (!self.end_date) {
        return 0;
      }

      if (now.isAfter(endDate)) {
        return 0;
      }

      return parseFloat(endDate.diff(now, 'months', true).toFixed(1));
    }

    function monthsRemaining() {
      /* jshint validthis:true */
      var self = this;

      return self.monthly_spend ? parseFloat((self.budgetRemaining() / self.monthly_spend).toFixed(1)) : '99+';
    }

    function budgetRemaining() {
      /* jshint validthis:true */
      var self = this;

      return Math.max(0, self.budget - self.spent);
    }

    function budgetUtilization() {
      /* jshint validthis:true */
      var self = this;

      return Math.round(self.spent / self.budget * 100);
    }

    function budgetUtilizationStatus() {
      /* jshint validthis:true */
      var self = this;

      var util = self.budgetUtilization();

      if (util <= 60) {
        return 'success';
      } else if (util <= 80) {
        return 'warning';
      }

      return 'danger';
    }

    function budgetRemainder() {
      /* jshint validthis:true */
      var self = this;

      return Math.round((self.budget - self.spent) / self.budget * 100);
    }

    function budgetRemainderStatus() {
      /* jshint validthis:true */
      var self = this;

      var rem = self.budgetRemainder();

      if (rem >= 40) {
        return 'success';
      } else if (rem >= 20) {
        return 'warning';
      }

      return 'danger';
    }
  }
})();
