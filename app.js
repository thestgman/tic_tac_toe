var app = angular.module('ticTacToeApp', []);


app.config(function($httpProvider) {
    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;

    //Remove the header containing XMLHttpRequest used to identify ajax call
    //that would prevent CORS from working
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
});


app.controller('MainCtrl', function($scope, $http) {
    var server_address = 'http://localhost:4567';
    var field = null;

    // TODO: this must be defined in some standard library. Do not reinvent the wheel.
    $scope.isUndefinedOrNull = function(val) {
        return angular.isUndefined(val) || val === null
    };

    $scope.newGame = function() {
        $scope.winner = null;
        $scope.draw = null;

        $http.get(server_address + "/new_game").success(function(result) {
            console.log("Success", result);
            $scope.field = result.field;
        }).error(function() {
            console.log("error getting field");
        });
    };

    $scope.tickPosition = function(position) {
        if ($scope.isUndefinedOrNull($scope.field[position]) &&
            $scope.isUndefinedOrNull($scope.winner) &&
            $scope.isUndefinedOrNull($scope.draw)) {
            $http.post(server_address + "/do_move", {'position': position}).success(function (result) {
                console.log("Success", result);
                $scope.field = result.field;
                $scope.winner = result.winner;
                $scope.draw = result.draw;
            }).error(function () {
                console.log("error placing move field");
            });
        }
    };
});