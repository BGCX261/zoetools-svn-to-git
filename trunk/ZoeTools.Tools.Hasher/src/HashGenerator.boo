# ZoeTools.Tools.Hasher
# Incremental hash generator with progress reports.
# Copyright (C) 2007 Tamara Roberson <tamara.roberson@gmail.com>
# Released under the terms of the GNU GPL v2 or later. 

namespace ZoeTools.Tools.Hasher

import System
import System.IO
import System.Text
import System.Security.Cryptography

### StatusType ###
public enum StatusType:
	Ok
	Abort
	Error


### HashGenerator (partial) ###
partial class HashGenerator:
	# Constants
	protected static final BLOCK_SIZE as int = (512 * 1024) # in bytes


	# Objects
	_reader as BinaryReader
	_algorithm as HashAlgorithm 
	

	# Variables
	_file as string
	_total_bytes = 0
	_bytes_read = 0
	_hash as (byte)
	[Getter (Status)] _status = StatusType.Ok


	# Constructor
	public def constructor (file as string, algorithm as HashAlgorithm):
		_file = file
		_algorithm = algorithm 

	
	# Methods
	# Methods :: Public
	# Methods :: Public :: GenerateHashHex	
	def GenerateHashHex ():
		hash = GenerateHash ()
		return Utils.BytesToHex (hash)

	
	# Methods :: Public :: GenerateHash
	def GenerateHash ():
		Initialize ()
		
		try:
			HashAllBlocks()
		except e as AbortedException:
			_status = StatusType.Abort
			raise 
		except:
			_status = StatusType.Error
			raise 
		ensure:
			Finish ()
		
		return _hash
	
	
	# Methods :: Protected
	# Methods :: Protected :: Inititalize
	protected def Initialize ():
		fs = FileStream (_file, FileMode.Open)
		_reader = BinaryReader (fs)
		_total_bytes = cast (int, _reader.BaseStream.Length)
		EmitHashBeginEvent (_total_bytes)


	# Methods :: Protected :: Finish
	protected def Finish ():
		_reader.Close ()
		EmitHashEndEvent (_status)
		return if (_status != StatusType.Ok)
		_hash = _algorithm.Hash

	
	# Methods :: Protected :: HashBlock
	protected def HashBlock ():
		buffer = _reader.ReadBytes (BLOCK_SIZE)
		last_block = (_total_bytes - BLOCK_SIZE)
		is_final = (_bytes_read >= last_block)
		TransformBlock (is_final, buffer)
		_bytes_read += buffer.Length
		UpdateProgress ()

	
	# Methods :: Protected :: HashAllBlocks
	protected def HashAllBlocks ():
		while (_bytes_read < _total_bytes):
			HashBlock ()

	
	# Methods :: Protected :: TransformBlock
	protected def TransformBlock (is_final as bool, ref buffer as (byte)):
		if is_final: TransformBlockFinal  (buffer)
		else:        TransformBlockNormal (buffer)

	
	# Methods :: Protected :: TransformBlockNormal
	protected def TransformBlockNormal (ref buffer as (byte)):
		_algorithm.TransformBlock (buffer, 0, buffer.Length, buffer, 0)

	
	# Methods :: Protected :: TransformBlockFinal
	protected def TransformBlockFinal (ref buffer as (byte)):
		_algorithm.TransformFinalBlock(buffer, 0, buffer.Length)

	
	# Methods :: Protected :: UpdateProgress
	protected def UpdateProgress ():
		# Show bytes in MB
		read  = Utils.BytesToMB (_bytes_read)
		total = Utils.BytesToMB (_total_bytes)
		
		# Format Progress Text
		fmt = '{0:F} of {1:F} MB hashed'
		str = String.Format (fmt, read, total)
		
		# Emit
		EmitProgressUpdateEvent (str, _bytes_read)

