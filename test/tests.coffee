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
diff --git a/file b/file
index 123..456 789
--- a/file
+++ b/file
@@ -1,2 +1,2 @@
- line1
+ line2
"""
		files = parse diff
		expect(files.length).to.be(1)
		file = files[0]
		expect(file.from).to.be('file')
		expect(file.to).to.be('file')
		expect(file.lines.length).to.be(3)
		expect(file.lines[0].content).to.be('@@ -1,2 +1,2 @@')
		expect(file.lines[1].content).to.be('- line1')
		expect(file.lines[2].content).to.be('+ line2')

	it 'should parse diff with new file mode line', ->
		diff = """
diff --git a/test b/test
new file mode 100644
index 0000000..db81be4
--- /dev/null
+++ b/test
@@ -0,0 +1,2 @@
+line1
+line2
"""
		files = parse diff
		expect(files.length).to.be(1)
		file = files[0]
		expect(file.new).to.be.true
		expect(file.from).to.be('/dev/null')
		expect(file.to).to.be('test')
		expect(file.lines.length).to.be(3)
		expect(file.lines[0].content).to.be('@@ -0,0 +1,2 @@')
		expect(file.lines[1].content).to.be('+line1')
		expect(file.lines[2].content).to.be('+line2')

	it 'should parse multiple files in diff', ->
		diff = """
diff --git a/file1 b/file1
index 123..456 789
--- a/file1
+++ b/file1
@@ -1,2 +1,2 @@
- line1
+ line2
diff --git a/file2 b/file2
index 123..456 789
--- a/file2
+++ b/file2
@@ -1,3 +1,3 @@
- line1
+ line2
"""
		files = parse diff
		expect(files.length).to.be(2)
		file = files[0]
		expect(file.from).to.be('file1')
		expect(file.to).to.be('file1')
		expect(file.lines.length).to.be(3)
		expect(file.lines[0].content).to.be('@@ -1,2 +1,2 @@')
		expect(file.lines[1].content).to.be('- line1')
		expect(file.lines[2].content).to.be('+ line2')
		file = files[1]
		expect(file.from).to.be('file2')
		expect(file.to).to.be('file2')
		expect(file.lines.length).to.be(3)
		expect(file.lines[0].content).to.be('@@ -1,3 +1,3 @@')
		expect(file.lines[1].content).to.be('- line1')
		expect(file.lines[2].content).to.be('+ line2')

	it 'should parse gnu sample diff', ->
		diff = """
--- lao	2002-02-21 23:30:39.942229878 -0800
+++ tzu	2002-02-21 23:30:50.442260588 -0800
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
		files = parse diff
		expect(files.length).to.be(1)
		file = files[0]
		expect(file.from).to.be('lao')
		expect(file.to).to.be('tzu')
