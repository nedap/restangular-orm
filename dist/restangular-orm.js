var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

angular.module('RestangularORM', ['restangular']).provider('notificationStream', [
  function() {
    this.stream = new Bacon.Bus;
    this.$get = (function(_this) {
      return function() {
        return _this.stream;
      };
    })(this);
    this.setStream = (function(_this) {
      return function(newStream) {
        return _this.stream = newStream;
      };
    })(this);
    return null;
  }
]).factory('RestangularModel', [
  'Restangular', 'notificationStream', function(Restangular, stream) {
    var RestangularModel;
    return RestangularModel = (function(_super) {
      __extends(RestangularModel, _super);

      function RestangularModel(data) {
        RestangularModel.__super__.constructor.apply(this, arguments);
      }

      RestangularModel.initialize = function() {
        var name, options, _i;
        name = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), options = arguments[_i++];
        this.restangularURL = options.url;
        Restangular.addElementTransformer(options.url, false, (function(_this) {
          return function(data) {
            if (options.factory && _this.hasOwnProperty(options.factory) && typeof _this[options.factory] === 'function') {
              return _this[options.factory](data, _this, stream);
            } else {
              return new _this(data, _this, stream);
            }
          };
        })(this));
        return RestangularModel.__super__.constructor.initialize.call(this, name[0]);
      };

      RestangularModel.find = function(id) {
        return Restangular.one(this.restangularURL, id).get();
      };

      RestangularModel.all = function() {
        return Restangular.all(this.restangularURL).getList();
      };

      RestangularModel.hasMany = function() {
        return RestangularModel.__super__.constructor.hasMany.apply(this, arguments);
      };

      RestangularModel.hasOne = function() {
        return RestangularModel.__super__.constructor.hasOne.apply(this, arguments);
      };

      RestangularModel.getMethodName = function(property) {
        return "get" + (property.slice(0, 1).toUpperCase()) + (property.slice(1));
      };

      return RestangularModel;

    })(RelationalModel);
  }
]);
