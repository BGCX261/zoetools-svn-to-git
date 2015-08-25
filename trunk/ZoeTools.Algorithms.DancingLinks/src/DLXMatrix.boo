# Dancing Links (DLX) Implementation
# Tamara Roberson <tamara.roberson@gmail.com>
# Based on code from sfabriz.
# For detailed explanation, see:
#   http://www.osix.net/modules/article/?id=792

namespace ZoeTools.Algorithms.DancingLinks

import System
import System.Collections

import ZoeTools.Objects.LinkedMatrix

class DLXMatrix (Matrix):
	# Events
	event GotSolutionEvent as callable (object)

	# Fields 
	[Getter (Solutions)] _sol = Stack ()
	[Getter (Solution)] _solution as (int, 2)
	[Getter (GotSolution)] _got_solution = false 
	[Property (TotSolutions)] _tot_solutions = 0


	# Methods
	# Methods :: Public
	# Methods :: Public :: Solve
	def Solve ():
	"""<summary>The Knuth DLX algorithm</summary>"""
		if FirstHeader.Right == FirstHeader:
			_tot_solutions++
			GotSolutionEvent (self)
			return

		c as Header = FindMin ()
		return if c.Size == 0  # not a good solution
		
		CoverColumn (c)
		r = c.Down
		j as Node

		while r != c:
			_sol.Push (r)
			j = r.Right

			while j != r:
				CoverColumn (j.Head)
				j = j.Right

			Solve ()
			r = _sol.Pop ()
			c = r.Head
			j = r.Left

			while j != r:
				UncoverColumn (j.Head)
				j = j.Left

			r = r.Down

		UncoverColumn (c)


	# Methods :: Public :: FindMin
	def FindMin ():
	"""
	<summary>
	  Finds the minimum sized header in order to minimize the branches 
	  for the solution tree.
	</summary>
	<returns>The minimum sized header</returns>
	"""
		min = int.MaxValue
		head_min as Header
		head as Header = super.FirstHeader.Right

		while head != super.FirstHeader:
			if head.Size < min:
				min = head.Size
				head_min = head
		
			head = head.Right

		return head_min


	# Methods :: Public :: CoverColumn (int) 
	def CoverColumn (index as int):
	"""
	<summary>
	  Covers one column (with Knuth DLX cover method) given the index.
	</summary>
	<param name="index">
	  The index in columns[] for the column to cover
	</param>
	"""
		CoverColumn (super.Columns[index])


	# Methods :: Public :: CoverColumn (Header)
	def CoverColumn (c as Header):
	"""
	<summary>
	  Covers one column (with Knuth DLX cover method) given the Header.
	</summary>
	<param name="c">The column to cover</param>
	"""
		# header unplugging
		c.Left.Right = c.Right
		c.Right.Left = c.Left
	
		# nodes unplugging
		i = c.Down
		j as Node

		while i != c:
			j = i.Right

			while j != i:
				j.Up.Down = j.Down
				j.Down.Up = j.Up
				j.Head.Size--
				j = j.Right

			i = i.Down


	# Methods :: Public :: UncoverColumn (int)
	def UnCoverColumn (index as int):
	"""
	<summary>
	  Uncover one column (with Knuth DLX cover method) given the index.
	</summary>
	<param name="index">
	  The index in columns[] of the column to uncover
	</param>
	"""
		UncoverColumn (super._columns[index])


	# Methods :: Public :: UncoverColumn (Header)
	def UncoverColumn (c as Header):
	"""
	<summary>
	  Uncovers one column (with Knuth DLX cover method) given the Header.
	</summary>
	<param name="c">The column to uncover</param>
	"""
		# nodes plugging
		i = c.Up
		j as Node

		while i != c:
			j = i.Left

			while j != i:
				j.Up.Down = j
				j.Down.Up = j
				j.Head.Size++
				j = j.Left

			i = i.Up

		# header plugging
		c.Left.Right = c
		c.Right.Left = c


	# Methods :: Public :: SelectMultipleRows
	def SelectMultipleRows (index as (int)):
	"""
	<summary>Selects multiple rows.</summary>
	<param name="index">Indexes in rows[] of the rows to select.</param>
	"""
		for i in range (index.Length):
			SelectRow (index[i])


	# Methods :: Public :: SelectRow
	def SelectRow (index as int):
	"""
	<summary>Selects one row to force solution.</summary>
	<param name="index">The index in rows[] of the row to select.</param>
	"""
		row = Rows[index]
		_sol.Push (row)
		
		# TODO: turn this do-while upright
		while true:
			CoverColumn (row.Head)
			row = row.Right
			break unless (row != Rows[index])


	# Methods :: Public :: UnselectAllRows
	def UnselectAllRows ():
	"""<summary>Unselects all rows pushed in stack.</summary>"""
		while (_sol.Count > 0):
			UnselectRow ()


	# Methods :: Public :: UnselectRow
	def UnselectRow ():
	"""<summary>Unselects the last row pushed in the sol stack.</summary>"""
		n = (_sol.Pop () as Node).Left

		# TODO: turn this do-while upright.
		while true:
			UncoverColumn (n.Head)
			n = n.Left
			break unless (n != Rows[n.Row])

		UncoverColumn (n.Head)

