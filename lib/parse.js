    var add, chunk, del, file, line, lines, ln_add, ln_del, noeol, normal, parse, schema, _i, _len;
    file = {
      lines: [],
      deletions: 0,
      additions: 0
    schema = [[/^@@\s+\-(\d+),(\d+)\s+\+(\d+),(\d+)\s@@/, chunk], [/^-/, del], [/^\+/, add]];
    return file;