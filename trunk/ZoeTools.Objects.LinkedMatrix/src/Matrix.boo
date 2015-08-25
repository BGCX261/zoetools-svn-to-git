# Sudoku Solver
# Tamara Roberson <tamara.roberson@gmail.com>
# Based on code from sfabriz.
# For detailed explanation, see:
#   http://www.osix.net/modules/article/?id=792

namespace ZoeTools.Objects.LinkedMatrix

import System
import System.IO

class Matrix:
"""<summary>A linked matrix of Nodes.</summary>"""
	# Objects
	[Getter (FirstHeader)] _first_header as Header
	[Getter (Columns)]_columns as (Header)
	[Getter (Rows)] _rows as (Node)

	# Constructor
	def constructor ():
		_first_header = Header (0)


	# Methods
	# Methods :: Public
	# Methods :: Public :: BuildSkeleton
	def BuildSkeleton (
	  [required (r > 0)] r as int,
	  [required (c > 0)] c as int):
	"""
	<summary>Builds the rows and columns arrays.</summary>
	<remarks>
	  This method mustn't be called if LoadInputFile is called
	</remarks>
	<param name="r">Number of rows</param>
	<param name="c">Number of columns</param>
	"""
		_columns = array (Header, c)
		_rows    = array (Node  , r)

		# columns
		for i in range (c):
			_columns[i] = Header (i)
			LinkNodesLeftRight (_columns[i], _first_header)	

		# rows
		for i in range (r):
			_rows[i] = Node ()


	# Methods :: Public :: AppendRow
	def AppendRow (
	  [required (r.Length <= _columns.Length)]
	  [required (r.Length > 0)]
	  r as string,
	  [required (row < _rows.Length)]
	  [required (row >= 0)]
	  row as int):
	"""
	<summary>Appends one row to the matrix</summary>
	<param name="r">
	  The string representation of the row (e.g. 01010100011)
	</param>
	<param name="row">The number of the row</param>
	"""
		first as Node
		t     as Node

		for i in range (r.Length):
			continue if (r[i] == char ('1'))

			if first is null:
				first = Node (row)
				LinkNodesUpDown (first, _columns[i])
				_rows[row] = first
			else:
				t = Node (row)
				LinkNodesLeftRight (t, first)
				LinkNodesUpDown (t, _columns[i])


	# Methods :: Public :: AppendRow
	def AppendRow (
	  [required (pos[pos.Length-1] < _columns.Length)]
	  [required (pos.Length > 0)]
	  pos as (int), 
	  [required (row < _rows.Length)]
	  row as int):
	"""
	<summary>Appends one row to the matrix</summary>
	<param name="pos">
	  Array filled with the positions of the columns where to append the
	  nodes
	</param>
	<param name="row">The number of the row</param>
	"""
		first = Node (row)
		LinkNodesUpDown (first, _columns[pos[0]])
		_rows[row] = first

		for i in range (1, pos.Length):
			t = Node (row)
			LinkNodesLeftRight (t, first)
			LinkNodesUpDown (t, _columns[pos[i]])


	# Methods :: Private
	# Methods :: Private :: LinkNodesLeftRight
	private def LinkNodesLeftRight (
	  [required] a as Node,
	  [required] b as Node):
		a.Left  = b.Left
		a.Right = b
		b.Left.Right = a
		b.Left       = a


	# Methods :: Private :: LinkNodesUpDown
	private def LinkNodesUpDown (
	  [required] a as Node,
	  [required] b as Node):
		a.Head = b
		a.Down = b
		a.Up   = b.Up
		b.Up.Down = a
		b.Up      = a	
		a.Head.Size++

