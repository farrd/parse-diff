expect = require 'expect.js'
parse = require '../src/parse'

describe 'diff parser', ->
	it 'should parse null', ->
		expect(parse(null).length).to.be(0)

	it 'should parse empty string', ->
		expect(parse('').length).to.be(0)

	it 'should parse whitespace', ->
		expect(parse(' ').length).to.be(0)

	it 'should parse simple git-like diff', ->
		diff = """
@@ -1,2 +1,2 @@
- line1
+ line2
"""
		file = parse diff
		expect(file.length).to.be(3)
		expect(file[0].content).to.be('@@ -1,2 +1,2 @@')
		expect(file[1].content).to.be('- line1')
		expect(file[2].content).to.be('+ line2')

	it 'should parse diff with new file mode line', ->
		diff = """
@@ -0,0 +1,2 @@
+line1
+line2
"""
		file = parse diff
		expect(file.length).to.be(3)
		expect(file[0].content).to.be('@@ -0,0 +1,2 @@')
		expect(file[1].content).to.be('+line1')
		expect(file[2].content).to.be('+line2')

	it 'should parse diff with correct positions', ->
		diff = """
@@ -0,0 +1,2 @@
+line1
+line2
@@ -5,0 +7,2 @@
+line3
+line4
"""
		file = parse diff
		expect(file.length).to.be(6)
		expect(file[0].position).to.be(0)
		expect(file[1].position).to.be(1)
		expect(file[2].position).to.be(2)
		expect(file[3].position).to.be(3)
		expect(file[4].position).to.be(4)
		expect(file[5].position).to.be(5)

	it 'should parse gnu sample diff', ->
		diff = """
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
+The named is the mother of all things.
+
Therefore let there always be non-being,
	so we may see their subtlety,
And let there always be being,
@@ -9,3 +8,6 @@
The two are the same,
But after they are produced,
	they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
+The door of all subtleties!
"""
		file = parse diff
		expect(file.length).to.be(17)
