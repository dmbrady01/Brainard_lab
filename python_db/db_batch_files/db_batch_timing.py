#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_batch_timing.py: a series of functions used to get timing information of
songs or syllables from .cbin and .cbin.not.mat files.
"""

#importing modules
import fnmatch, datetime, time


def songtiming(filename, filetype = '.cbin', evtaf = 'Amp'):
	"""Converts the name of a recorded song in evtaf to
	a standard date (Year, Month (as a number), Day, Hour, Minutes, Seconds).
	By default, it converts files from EvTaf_Amp, so change it
	if you used EvTaf_4."""
	
	if evtaf = 'Amp':
		