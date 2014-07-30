(function() {
  var parseFile, _;

  _ = require('underscore');

  _.str = require('underscore.string');

  module.exports = function(input) {
    var add, chunk, del, file, line, lines, ln_add, ln_del, noeol, normal, parse, schema, _i, _len;
    if (!input) {
      return [];
    }
    if (input.match(/^\s+$/)) {
      return [];
    }
    lines = input.split('\n');
    if (lines.length === 0) {
      return [];
    }
    ln_del = 0;
    ln_add = 0;
    file = {
      lines: [],
      deletions: 0,
      additions: 0
    };
    chunk = function(line, match) {
      ln_del = +match[1];
      ln_add = +match[3];
      return file.lines.push({
        type: 'chunk',
        chunk: true,
        content: line
      });
    };
    del = function(line) {
      file.lines.push({
        type: 'del',
        del: true,
        ln: ln_del++,
        content: line
      });
      return file.deletions++;
    };
    add = function(line) {
      file.lines.push({
        type: 'add',
        add: true,
        ln: ln_add++,
        content: line
      });
      return file.additions++;
    };
    noeol = '\\ No newline at end of file';
    normal = function(line) {
      if (!file) {
        return;
      }
      return file.lines.push({
        type: 'normal',
        normal: true,
        ln1: line !== noeol ? ln_del++ : void 0,
        ln2: line !== noeol ? ln_add++ : void 0,
        content: line
      });
    };
    schema = [[/^@@\s+\-(\d+),(\d+)\s+\+(\d+),(\d+)\s@@/, chunk], [/^-/, del], [/^\+/, add]];
    parse = function(line) {
      var m, p, _i, _len;
      for (_i = 0, _len = schema.length; _i < _len; _i++) {
        p = schema[_i];
        m = line.match(p[0]);
        if (m) {
          p[1](line, m);
          return true;
        }
      }
      return false;
    };
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      if (!parse(line)) {
        normal(line);
      }
    }
    return file;
  };

  parseFile = function(s) {
    var t;
    s = _.str.ltrim(s, '-');
    s = _.str.ltrim(s, '+');
    s = s.trim();
    t = /\d{4}-\d\d-\d\d\s\d\d:\d\d:\d\d(.\d+)?\s(\+|-)\d\d\d\d/.exec(s);
    if (t) {
      s = s.substring(0, t.index).trim();
    }
    if (s.match(/^(a|b)\//)) {
      return s.substr(2);
    } else {
      return s;
    }
  };

}).call(this);
