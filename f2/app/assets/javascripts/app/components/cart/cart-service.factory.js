(function() {
  'use strict';

  angular.module('app.components')
    .factory('CartService', CartServiceFactory);

  /** @ngInject */
  function CartServiceFactory(Toasts, $modal, lodash, SelectedProjectHelper) {
    var service = {
      itemCountTotal: 0,
      getProjects: getProjects,
      add: add,
      remove: remove,
      removeProject: removeProject,
      clear: clear,
      isEmpty: isEmpty,
      showModal: showModal
    };

    var projects = {};

    return service;

    function getProjects() {
      return projects;
    }

    function add(project, product) {
      var projectId = project.id;

      if (lodash.isUndefined(projects[projectId])) {
        projects[projectId] = {
          projectDetails: project,
          products: []
        };
      }
      projects[projectId].products.push({
        product: lodash.cloneDeep(product),
        service: {
          name: null
        }
      });
      service.itemCountTotal += 1;
      calculateProjectCost();
      Toasts.toast(product.name + ' has been add to your cart under ' + project.name);
      checkBudget(project);
    }

    function remove(index) {
      var selectedProjectId = SelectedProjectHelper.selectedProject.id;
      if (projects[selectedProjectId].products[index]) {
        projects[selectedProjectId].products.splice(index, 1);
        service.itemCountTotal -= 1;
        if (0 === projects[selectedProjectId].products.length) {
          delete projects[selectedProjectId];
        } else {
          calculateProjectCost();
        }
      }
    }

    function removeProject(projectId) {
      if (projects[projectId]) {
        service.itemCountTotal -= projects[projectId].products.length;
        delete projects[projectId];
      }
    }

    function clear() {
      projects = {};
      service.itemCountTotal = 0;
    }

    function isEmpty() {
      return 0 === Object.keys(projects).length;
    }

    function showModal() {
      var modalOptions = {
        templateUrl: 'app/components/cart/cart-modal.html',
        controller: CartModalController,
        size: 'lg',
        controllerAs: 'vm',
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);
    }

    function calculateProjectCost() {
      var selectedProjectId = SelectedProjectHelper.selectedProject.id;
      if (angular.isUndefined(projects[selectedProjectId])) {
        return;
      }
      projects[selectedProjectId].total = lodash.reduce(projects[selectedProjectId].products, computeProductTotal, 0);

      function computeProductTotal(total, line) {
        return total + (parseFloat(line.product.monthly_price) + ((parseFloat(line.product.hourly_price)) * 750));
      }
    }

    function checkBudget(project) {
      if (project.budget < projects[project.id].total) {
        Toasts.error('You have exceeded the budget for ' + project.name);
      }
    }
  }

  /** @ngInject */
  function CartModalController(CartService, ProductHelper, $modalInstance,
                               Toasts, Order, lodash, SelectedProjectHelper) {
    var vm = this;

    vm.remove = remove;
    vm.removeProject = removeProject;
    vm.removeAllProjects = removeAllProjects;
    vm.clear = clear;
    vm.checkout = checkout;
    vm.configure = configure;
    vm.isEmpty = isEmpty;
    vm.resetDefaultProject = resetDefaultProject;
    vm.tabSelected = tabSelected;

    activate();

    function activate() {
      vm.projects = CartService.getProjects();
    }

    function remove(index) {
      CartService.remove(index);
    }

    function removeProject(projectId) {
      CartService.removeProject(projectId);
    }

    function removeAllProjects() {
      CartService.clear();
    }

    function clear() {
      CartService.clear();
    }

    function checkout() {
      var projectOrder = {
        products: []
      };
      var selectedProject = SelectedProjectHelper.selectedProject.id;
      var projectObject = vm.projects[selectedProject];

      if (lodash.every(projectObject.products, configuredProductCheck)) {
        if (projectObject.projectDetails.budget >= projectObject.total) {
          projectOrder.project_id = selectedProject;
          projectOrder.products = lodash.map(projectObject.products, buildOrderItem);

          Order.save(projectOrder, saveSuccess, saveError);
        } else {
          Toasts.error('Cart total exceeds project budget, cannot process order.');
        }
      } else {
        Toasts.error('Please confirm all products are configured prior to placing an order.');
      }

      function saveSuccess() {
        removeProject(selectedProject);
        $modalInstance.close();
        Toasts.toast('Order accepted.');
      }

      function saveError(data) {
        if (data.data.error) {
          Toasts.error(data.data.error);
        } else {
          Toasts.error('Could not place order at this time.');
        }
      }

      function buildOrderItem(item) {
        return {
          product_id: item.product.id,
          answers: item.product.answers,
          service: item.service
        };
      }
    }

    function configure(index, productRow) {
      ProductHelper.showModal(productRow).then(handleResult);

      function handleResult(configuration) {
        configureProduct(configuration, index);
      }
    }

    function resetDefaultProject() {
      SelectedProjectHelper.reset();
      $modalInstance.close();
      Toasts.toast('Default project for the cart has been reset.');
    }

    function isEmpty() {
      return CartService.isEmpty();
    }

    function tabSelected(project) {
      SelectedProjectHelper.selectProject(project, true);
    }

    // Private
    function configuredProductCheck(product) {
      return product.service.name !== null;
    }

    function configureProduct(configuration, index) {
      var selectedProjectId = SelectedProjectHelper.selectedProject.id;
      vm.projects[selectedProjectId].products[index].service.name = configuration.name;
    }
  }
})();
