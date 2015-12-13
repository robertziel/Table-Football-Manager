(function() {
  var app = angular.module('App', []);

  app.controller('AppController', ['$http','$scope',function($http, $scope){


    var updateData = function() {
        $http.get(document.URL + '/games.json').then(function(response) {
          $scope.Games = JSON.parse(response.data.games);
          $scope.UserData = response.data.user;

      });
    };

    $scope.CreateGame = function() {
        $http.post(document.URL + '/games.json').then(function(response) {
          updateData();

      });
    };

    $scope.LeaveGame = function() {
        $http.delete(document.URL + '/games/' + $scope.Games.id + '.json').then(function(response) {
          updateData();

      });
    };

    //LOOP
    var loopFunction = function() {
      updateData("");
      var timer = setInterval(function() {
        updateData("");
      }, 5000);
    }

    loopFunction();
    //LOOP

    $scope.show = function() {
      return ($scope.UserData === null ) ? true : false ;
    }

  }]);

})();
