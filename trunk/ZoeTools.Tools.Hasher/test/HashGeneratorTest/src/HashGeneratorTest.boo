namespace ZoeTools.Tools.Hasher.Tests

import System
import System.Security.Cryptography
import ZoeTools.Tools.Hasher

class HashGeneratorTest:
	[Getter (Hash)] _hash as string

	def constructor (fname as string):
		#algorithm = SHA1CryptoServiceProvider ()
		#algorithm = MD5CryptoServiceProvider ()
		#algorithm = SHA256Managed ()
		algorithm = SHA512Managed ()
		gen = HashGenerator (fname, algorithm)
		gen.HashBeginEvent += OnHashBeginEvent
		gen.HashEndEvent   += OnHashEndEvent
		gen.ProgressUpdateEvent += OnProgressUpdateEvent
		_hash = gen.GenerateHashHex ()

	private def OnHashBeginEvent (obj as object, args as HashBeginEventArgs):
		print "Hash Begin (Total bytes: ${args.TotalBytes})"

	private def OnHashEndEvent (obj as object, args as HashEndEventArgs):
		print "Hash End (Status: ${args.Status})"

	private def OnProgressUpdateEvent (obj as object, args as ProgressUpdateEventArgs):
		print "Progress Update (Message: ${args.Message}, Value: ${args.Value})"

static def Main (args as (string)):
	fname = args [0]
	test = HashGeneratorTest (fname)
	print "Hash: ${test.Hash}"
