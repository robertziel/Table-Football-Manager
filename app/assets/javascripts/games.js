(function() {
  var app = angular.module('App', []);

  app.controller('AppController', ['$http','$scope',function($http, $scope){

    $scope.hide = true;

    $scope.domain = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[2]

    var updateData = function() {
        $http.patch($scope.domain + '/games.json').then(function(response) {
          $scope.Games = JSON.parse(response.data.games);
          $scope.UserData = response.data.user;
          $scope.UserWill = response.data.will;
          $scope.AdminID = ($scope.UserData !== null) ? FindAdminId($scope.Games.users) : 0 ;
          $scope.Team1 = response.data.team1;
          $scope.Team2 = response.data.team2;
          if ($scope.hide === true) {$scope.hide = false;}

      });
    };

    var FindAdminId = function(users) {
      for (var i = 0; i <= users.length; i++) {
        if (users[i].admin === true) { return users[i].id; }
      }
    };

    $scope.FindAdminName = function(users) {
      for (var i = 0; i <= users.length; i++) {
        if (users[i].admin === true) { return users[i].name; }
      }
    };

    $scope.CreateGame = function() {
        $http.post($scope.domain + '/games.json').then(function(response) {
          updateData();
          $scope.hide = true;

      });
    };

    $scope.LeaveGame = function() {
        $http.delete($scope.domain + '/games/' + $scope.Games.id + '.json').then(function(response) {
          updateData();
          $scope.hide = true;

      });
    };

    $scope.JoinGame = function(url) {
        $http.put($scope.domain + url).then(function(response) {
          updateData();
          $scope.hide = true;

      });
    };

    $scope.Lottery = function(gameID) {
        $http.put($scope.domain + '/lottery.json?game=' + gameID).then(function(response) {
          updateData();

      });
    };

    $scope.ChangeWill = function() {
        $http.put($scope.domain + '/will.json').then(function() {
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
