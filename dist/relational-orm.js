var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

angular.module('RestangularORM', ['restangular']).value('relationalNotifications', new Bacon.Bus).factory('RestangularModel', [
  'Restangular', 'relationalNotifications', function(Restangular, stream) {
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
              return _this[options.factory](data, stream);
            } else {
              return new _this(data, stream);
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
