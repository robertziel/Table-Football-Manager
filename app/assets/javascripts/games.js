(function() {
  var app = angular.module('App', []);

  app.controller('AppController', ['$http','$scope',function($http, $scope){


    var updateData = function() {
        $http.get(document.URL + '/games.json').then(function(response) {
          $scope.Games = JSON.parse(response.data.games);
          $scope.UserData = response.data.user;
          $scope.AdminID = ($scope.UserData !== null) ? FindAdminId($scope.Games.users) : 0 ;
          $scope.Team1 = response.data.team1;
          $scope.Team2 = response.data.team2;

      });
    };

    var FindAdminId = function(users) {
      for (var i = 0; i <= users.length; i++) {
        if (users[i].admin === true) { return users[i].id; }
      }
    };

    $scope.FindAdminName = function(users) {
      for (var i = 0; i <= users.length; i++) {
        if (users[i].admin === true) { return users[i].email; }
      }
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

    $scope.JoinGame = function(url) {
        $http.put(document.URL + url).then(function(response) {
          updateData();

      });
    };

    $scope.Lottery = function(gameID) {
        $http.put(document.URL + '/lottery/?game=' + gameID).then(function(response) {
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
    };

    $scope.yourID = gon.yourID;
    $scope.youAdmin = function() {
      return ($scope.AdminID === $scope.yourID) ? true : false ;
    };

  }]);

})();
