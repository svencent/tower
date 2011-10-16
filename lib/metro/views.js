(function() {
  var Views, _;
  _ = require("underscore");
  Views = {
    Base: require('./views/base'),
    Template: require('./views/template'),
    bootstrap: function() {
      this.resolve_load_paths();
      return this.resolve_template_paths();
    },
    resolve_load_paths: function() {
      var file;
      file = Metro.Assets.File;
      return this.load_paths = _.map(this.load_paths, function(path) {
        return file.expand_path(path);
      });
    },
    resolve_template_paths: function() {
      var file, path, template_paths, _i, _len, _ref;
      file = require("file");
      template_paths = this.template_paths;
      _ref = this.load_paths;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        path = _ref[_i];
        file.walkSync(path, function(_path, _directories, _files) {
          var template, _file, _j, _len2, _results;
          _results = [];
          for (_j = 0, _len2 = _files.length; _j < _len2; _j++) {
            _file = _files[_j];
            template = [_path, _file].join("/");
            _results.push(template_paths.indexOf(template) === -1 ? template_paths.push(template) : void 0);
          }
          return _results;
        });
      }
      return this.template_paths;
    },
    load_paths: ["./spec/spec-app/app/views"],
    template_paths_by_name: {},
    template_paths: []
  };
  module.exports = Views;
}).call(this);