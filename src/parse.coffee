_ = require 'underscore'
_.str = require 'underscore.string'

# parses unified diff
# http://www.gnu.org/software/diffutils/manual/diffutils.html#Unified-Format
module.exports = (input) ->
	return [] if not input
	return [] if input.match /^\s+$/

	lines = input.split '\n'
	return [] if lines.length == 0

	ln_del = 1
	ln_add = 1

	file = []

	chunk = (line, match) ->
		ln_del = +match[1]
		ln_add = +match[3]
		file.push {type:'chunk', chunk:true, content:line}

	del = (line) ->
		file.push {type:'del', del:true, base:ln_del++, content:line}

	add = (line) ->
		file.push {type:'add', add:true, head:ln_add++, content:line}

	noeol = '\\ No newline at end of file'
	normal = (line) ->
		return if not file or line is noeol
		file.push {
			type: 'normal'
			normal: true
			base: ln_del++
			head: ln_add++
			content: line
		}

	schema = [
		[/^@@\s+\-(\d+),(\d+)\s+\+(\d+),(\d+)\s@@/, chunk],
		[/^-/, del],
		[/^\+/, add]
	]

	parse = (line) ->
		for p in schema
			m = line.match p[0]
			if m
				p[1](line, m)
				return true
		return false

	for line in lines
		normal(line) unless parse line

	return file

parseFile = (s) ->
	s = _.str.ltrim s, '-'
	s = _.str.ltrim s, '+'
	s = s.trim()
	# ignore possible time stamp
	t = (/\d{4}-\d\d-\d\d\s\d\d:\d\d:\d\d(.\d+)?\s(\+|-)\d\d\d\d/).exec(s)
	s = s.substring(0, t.index).trim() if t
	# ignore git prefixes a/ or b/
	if s.match (/^(a|b)\//) then s.substr(2) else s
