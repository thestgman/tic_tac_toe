var app = angular.module('ticTacToeApp', []);

app.config(function($httpProvider) {
    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;

    //Remove the header containing XMLHttpRequest used to identify ajax call
    //that would prevent CORS from working
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
});

app.controller('MainCtrl', function($scope, $http) {
    $scope.get = function() {
        $http.get("http://localhost:4567/something").success(function(result) {
            console.log("Success", result);
            $scope.resultGet = result;
        }).error(function() {
            console.log("error");
        });
    };

    $scope.post = function(value) {
        $http.post("http://localhost:4567/something", { 'something': value }).success(function(result) {
            console.log(result);
            $scope.resultPost = result;
        }).error(function() {
            console.log("error");
        });
    };

});