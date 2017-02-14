#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_batch.py: contains functions to make text files listing cbin,
cbin.not.mat, and cbin.catch files when using evtaf. Also contains
the more general functions findfiles, writefiles, and appendfiles 
which search a specified directory for files with a specific name,
write lists to a file, or appends lists to a file.
"""

__author__ = "DM Brady"
__datewritten__ = "21May2013"
__lastmodified__ = "23May2013"

#imports os & fnmatch modules
import os, fnmatch, sys

def checksysargs(args):
	"""checks to see the number of input arguments for
	a batch function called at the command line.
	arg[0] = script, arg[1] = list type (catch, cbin, etc.),
	arg[2] = filename, arg[3] = path. Returns or prompts and
	returns list type, filename, and path"""
	if len(args) == 1:
		return raw_input('Type? '), raw_input('Name? '), './'
	elif len(args) == 2:
		return args[1], raw_input('Name? '), './'
	elif len(args) == 3:
		return args[1], args[2], './'
	else:
		return args[1], args[2], args[3]

def checkbatchargs(*args):
	"""checks to see the number of input arguments. if
	none are specified, path = './' and it prompts for
	a batchname. else, arg[0] = batchname, arg[1] = path"""
	if len(args) == 0:
		return raw_input('Name of batch file? '), './'
	elif len(args) == 1:
		return args[0], './'
	else:
		return args

		
def checkstringconvert(data):
	"""checks to see if input is a string, if not, it 
	converts it to one. Else, does nothing."""
	if isinstance(data, str) == False:
		data = str(data)
	return data

		
def findfiles(phrase, path):
	"""searches for a particular 'phrase' in a specified 
	'path' and writes it to list."""
	filelist = []
	#loops through the directory path
	for filename in os.listdir(path):
		#looks for a match between phrase and filename,
		#if it matches, it appends it to filelist
		if fnmatch.fnmatch(filename, phrase):
			filelist.append(filename)
	#if no matches are found, exits function
	if not filelist:
		print "There are no files with phrase: %s" % phrase
		sys.exit()
	return filelist
				
	
def writefile(listofstuff, name, escape = "\n"):
	"""Takes a list and writes out each element into a text 
	file called 'name.' Entries are separated by 'escape.'
	Default is newline."""
	#opens a file named 'name.'
	filelist = open(name, 'w')
	#goes through list, converts to string if necessary,
	#prints item, and writes it to file
	for filename in listofstuff:
		filename = checkstringconvert(filename)
		print filename
		filelist.write(filename)
		filelist.write(escape)
	
	filelist.close()

	
def appendfile(listofstuff, name, escape = "\n"):
	"""Takes a list and appends each element at the end
	of text file called 'name.' Entries are separated by
	'escape.' Default is newline."""
	#opens a file called 'name.'
	filelist = open(name, 'a')
	#similar to writefile, but appends to end of file
	for filename in listofstuff:
		filename = checkstringconvert(filename)
		print "%s appended" % filename
		filelist.write(filename)
		filelist.write(escape)
		
	filelist.close()


def listnotmat(*args):
	"""takes up to two inputs (batchname, path) and 
	creates a file called batchname listing all the 
	cbin.not.mat files in path. Default path is './'"""
	#checks to see what arguments are provided
	batchname, path = checkbatchargs(*args)
	
	#finds .not.mat files
	listofstuff = findfiles('*.cbin.not.mat', path)
	
	#writes results to file
	writefile(listofstuff, path + batchname)

	
def listcbin(*args):
	"""takes up to two inputs (batchname, path) and 
	creates a file called batchname listing all the cbin 
	files in path. Default path is './'"""
	#checks arguments given
	batchname, path = checkbatchargs(*args)
	
	#finds .cbin files
	listofstuff = findfiles('*.cbin', path)
	
	#writes results to file
	writefile(listofstuff, path + batchname)
	
	
def listcatch(*args):
	"""takes up to two inputs (batchname, path) and creates
	a file called batchname listing all the catch cbin 
	files in path. Default path is './'"""
	#checks input arguments
	batchname, path = checkbatchargs(*args)
	
	#lists the .rec files
	listofstuff = findfiles('*.rec', path)
	
	catchlist = []
	#goes through the list of rec files
	for filename in listofstuff:	
		#opens each rec file	
		recfilecontents = open(path + filename, 'r')
		
		#searches for a catch trial (1) vs. not catch (0)
		for line in recfilecontents:
			if 'Catch Song = 1' in line:
				catchlist.append(filename.replace('.rec','.cbin'))

		recfilecontents.close()
	
	#writes results to file
	writefile(catchlist, path + batchname)
	
def listcbinnotmat(*args):
	"""takes up to two input (batchname, path) and creates a file
	called batchname listing all the cbin files that already have
	a cbin.not.mat file. Used primarily after labeling all songs in
	a folder to have a convenient list of cbin files that you are 
	interested in."""
	
	#checks input arguments
	batchname, path = checkbatchargs(*args)
	
	#lists the .notmat files
	listofstuff = findfiles('*.not.mat', path)
	
	#Uses list comprehension to get rid of the .not.mat extension
	listofstuff = [element[:-8] for element in listofstuff]
	#listofstuff = [element.replace('.cbin.not.mat','.cbin')
	# for element in listofstuff] #an alternative option
	
	writefile(listofstuff, path + batchname)
	