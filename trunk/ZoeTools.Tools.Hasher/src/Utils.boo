# ZoeTools.Tools.Hasher
# Copyright (C) 2007 Tamara Roberson <tamara.roberson@gmail.com>
# Released under the terms of the GNU GPL v2 or later. 

namespace ZoeTools.Tools.Hasher

import System

class Utils:
	# Methods
	# Methods :: Public
	# Methods :: Public :: BytesToHex
	static def BytesToHex (data as (byte)):
		upper_tmp = BitConverter.ToString (data)
		upper     = upper_tmp.Replace ("-", "")
		hex       = upper.ToLower ()

		return hex


	# Methods :: Public :: BytesToMB
	static def BytesToMB (val as int):
		return BytesToMB (val, false)


	static def BytesToMB (val as int, use_si as bool):
	"""
	use_si - use base 10 (MB = 10^6), 
	  otherwise use base 2 (MB = 2^20)
	"""
		# Calculate bytes per megabyte (either binary or decimal)
		bytes_per_mb_dbl as double
		if (use_si):
			bytes_per_mb_dbl = Math.Pow (10, 6)
		else:
			bytes_per_mb_dbl = Math.Pow (2, 20)

		bytes_per_mb = cast (single, bytes_per_mb_dbl)

		# Return value in megabytes
		return cast (single, val) / bytes_per_mb
