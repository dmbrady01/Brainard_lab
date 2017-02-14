#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_sys_batch.py: allows you to create batch files from the command line. 
Takes up to four arguments: script (db_sys_batch.py), file type ('cbin', 
'notmat', 'cbinnotmat', and 'catch' have specific functions, but others 
can be supported like '*.rec' will list all .rec files or 'bk59bk42*' 
will list all files beginning with bk59bk42), file name, and path. If 
four are not specified, it asks for missing input or assumes path is 
current directory ('./')
"""

__author__ = "DM Brady"
__datewritten__ = "22May2013"
__lastmodified__ = "23May2013"

if __name__ == "__main__":
	#imports sys & db_batch_files.db_batch modules
	from sys import argv
	from db_batch_files import db_batch
	
	#checks the arguments given and prompts or sets default
	#for missing arguments
	filetype, filename, path = db_batch.checksysargs(argv)

	#print "%s %s %s" % (filetype, filename, path)

	#checks to see if filetype matches cbin, notmat, or catch
	#and does the appropriate batch writing
	if filetype == "cbin":
		db_batch.listcbin(filename, path)
	elif filetype == "notmat":
		db_batch.listnotmat(filename, path)
	elif filetype == "catch":
		db_batch.listcatch(filename, path)
	elif filetype == "cbinnotmat":
		db_batch.listcbinnotmat(filename, path)
	else:
		#if filetype is not cbin, notmat, or catch, tries to
		#list all files specified in a batch file
		listofstuff = db_batch.findfiles(filetype, path)
		db_batch.writefile(listofstuff,path + filename)
else:
	print "Cannot be imported. Script meant to be used at the",
	print "command line. Hope you are just using help or pydoc."