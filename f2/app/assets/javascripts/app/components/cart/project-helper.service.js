(function() {
  'use strict';

  angular.module('app.components')
    .service('ProjectHelper', ProjectHelperService);

  /** @ngInject */
  function ProjectHelperService($modal, Project) {
    var service = {
      showModal: showModal
    };

    return service;

    function showModal(product) {
      var modalOptions = {
        templateUrl: 'app/components/cart/project-helper.html',
        controller: ProjectHelperController,
        controllerAs: 'vm',
        resolve: {
          projects: resolveProjects,
          product: resolveProduct
        },
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);

      return modal.result;

      function resolveProjects(Project) {
        return Project.query({approved: true, archived: false}).$promise;
      }

      function resolveProduct() {
        return product;
      }
    }
  }

  /** @ngInject */
  function ProjectHelperController(projects, product, $modalInstance, CartService, SelectedProjectHelper, lodash) {
    var vm = this;

    vm.selections = {
      projectId: null,
      projectDefault: false
    };
    vm.addToCart = addToCart;

    activate();

    function activate() {
      initFields();
    }

    function addToCart() {
      $modalInstance.close();
      var selectedProject = lodash.find(projects, {'id': vm.selections.projectId});
      SelectedProjectHelper.selectProject(selectedProject, vm.selections.projectDefault);
      CartService.add(selectedProject, product);
    }

    // Private
    function initFields() {
      vm.fields = [
        {
          key: 'projectId',
          type: 'select',
          templateOptions: {
            label: 'Projects',
            options: projects,
            valueProp: 'id',
            labelProp: 'name'
          }
        },
        {
          key: 'projectDefault',
          type: 'checkbox',
          templateOptions: {
            label: '  ',
            checkboxLabel: 'Default Project'
          }
        }
      ];
    }
  }
})();
