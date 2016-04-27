(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.navItems(navItems());
    navigationHelper.sidebarItems(sidebarItems());
  }

  function getStates() {
    return {
      'admin.settings': {
        url: '/settings',
        templateUrl: 'app/states/admin/settings/settings.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Settings',
        resolve: {
          settings: resolveSettings
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'admin.settings': {
        type: 'state',
        state: 'admin.settings',
        label: 'Settings',
        order: 3
      }
    };
  }

  /** @ngInject */
  function resolveSettings(Setting) {
    return Setting.query().$promise;
  }

  /** @ngInject */
  function StateController(settings, lodash, EditSettingModal) {
    var vm = this;

    vm.title = 'Settings';

    vm.activate = activate;
    vm.edit = edit;

    activate();

    function activate() {
      createSettingGroups();
    }

    function edit(setting) {
      EditSettingModal.showModal(setting).then(updateSetting);

      function updateSetting(result) {
        setting.value = result.value;
      }
    }

    // Private

    function createSettingGroups() {
      vm.groups = lodash.groupBy(settings, groupByGroup);

      function groupByGroup(setting) {
        return setting.group;
      }
    }
  }
})();
