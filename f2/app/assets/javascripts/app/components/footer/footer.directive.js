(function() {
  'use strict';

  angular.module('app.components')
    .directive('footer', FooterDirective);

  /** @ngInject */
  function FooterDirective() {
    var directive = {
      restrict: 'AE',
      replace: true,
      link: link,
      templateUrl: 'app/components/footer/footer.html',
      controller: FooterController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function FooterController(Version) {
      var vm = this;
      vm.activate = activate;

      function activate() {
        updateVersion();
      }

      function updateVersion() {
        Version.get().$promise.then(handleResults);

        function handleResults(version) {
          vm.version = version.jellyfish_version;
        }
      }
    }
  }
})();
