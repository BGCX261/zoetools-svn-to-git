# Sudoku Solver
# Tamara Roberson <tamara.roberson@gmail.com>
# Based on code from sfabriz.
# For detailed explanation, see:
#   http://www.osix.net/modules/article/?id=792

namespace ZoeTools.Objects.LinkedMatrix

import System
import System.Collections.Generic
import System.Text

class Node:

	# Objects
	# Objects :: Neighbours
	[Property (Left )] _left  as Node
	[Property (Right)] _right as Node
	[Property (Up   )] _up    as Node
	[Property (Down )] _down  as Node

	# Objects :: Column Header
	[Property (Head)] _head as Header

	# Variables
	[Property (Row)] _row as int


	# Constructor
	def constructor ():
		self (-1, null)

	def constructor (row as int):
		self (row, null)

	def constructor (row as int, head as Header):
		_left  = self
		_right = self
		_down  = self
		_up    = self 

		_row  = row
		_head = head
