# ZoeTools.Tools.Hasher
# Copyright (C) 2007 Tamara Roberson <tamara.roberson@gmail.com>
# Released under the terms of the GNU GPL v2 or later. 

namespace ZoeTools.Tools.Hasher

import System

class AbortedException (ApplicationException):
	def constructor ():
		super ("Abort")

