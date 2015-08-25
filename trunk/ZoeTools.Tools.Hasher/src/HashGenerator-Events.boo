# ZoeTools.Tools.Hasher
# Incremental hash generator with proress reports.
# Copyright (C) 2007 Tamara Roberson <tamara.roberson@gmail.com>
# Released under the terms of the GNU GPL v2 or later. 

namespace ZoeTools.Tools.Hasher

import System


# Args
# Args :: HashBeginEventArgs
class HashBeginEventArgs (EventArgs):
	[Getter (TotalBytes)] _total_bytes as int

	def constructor (total_bytes as int):
		_total_bytes = total_bytes


# Args :: HashEndEventArgs
class HashEndEventArgs (EventArgs):
	[Getter (Status)] _status as StatusType

	def constructor ():
		_status = StatusType.Ok

	def constructor (status as StatusType):
		_status = status


# Args :: ProgressUpdateEventArgs
class ProgressUpdateEventArgs (EventArgs):
	[Getter (Message)] _msg as string
	[Getter (Value  )] _val as int

	def constructor (msg as string, val as int):
		_msg = msg
		_val = val


### HashGenerator (partial) ###
partial class HashGenerator:
	# Events
	event HashBeginEvent      as callable (object, HashBeginEventArgs     )
	event HashEndEvent        as callable (object, HashEndEventArgs       )
	event ProgressUpdateEvent as callable (object, ProgressUpdateEventArgs)

	
	# Emitters
	# Emitters :: EmitHashBeginEvent
	protected def EmitHashBeginEvent (total_bytes as int):
		args = HashBeginEventArgs (total_bytes)
		HashBeginEvent (self, args)

	
	# Emitters :: EmitHashEndEvent
	protected def EmitHashEndEvent (status as StatusType):
		args = HashEndEventArgs (status)
		HashEndEvent (self, args)


	# Emitters :: EmitProgressUpdateEvent
	protected def EmitProgressUpdateEvent (msg as string, val as int):
		args = ProgressUpdateEventArgs (msg, val)
		ProgressUpdateEvent (self, args)

