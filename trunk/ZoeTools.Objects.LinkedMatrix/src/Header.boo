# Sudoku Solver
# Tamara Roberson <tamara.roberson@gmail.com>
# Based on code from sfabriz.
# For detailed explanation, see:
#   http://www.osix.net/modules/article/?id=792

namespace ZoeTools.Objects.LinkedMatrix

class Header (Node):
	# Variables
	[Property (Name)] _name as int
	[Property (Size)] _size as int


	# Constructor
	def constructor ():
		self (0)

	def constructor (name as int):
		_name = name
		_size = 0

		self.Head = self
