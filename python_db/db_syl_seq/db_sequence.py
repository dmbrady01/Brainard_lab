#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_sequence.py: contains functions to do sequence analysis. Requires
.cbin.not.mat files to extract syllables and db_batch.timing module
to extract timing information.
"""

__author__ = "DM Brady"
__datewritten__ = "31May2013"
__lastmodified__ = "21Jun2013"

#import modules (re: regexp)
import re, numpy

def findmotif(string, motif):
	"""Returns an array of pairs (start position, motif). Can use
	regex for more general motif searches (ex: 'ab' vs 'a[a-z]').
	Ex: string = 'ab---cb-c-ca-ca', want all motifs that start with 'c'
	positions = findmotif(string, 'c[a-z]')
	positions = [(5, 'cb'), (10, 'ca'), (13, 'ca')]"""
	#makes a regular expression object from the search pattern
	p = re.compile(motif)
	#iterates through 'string' and gives the start, end, and motif
	matches = numpy.array([[m.start(), m.group()] for m in p.finditer(string)])
	#output of function
	return matches
	
def motifs_in_list(list_of_songs, motif):
	"""Uses findmotif to get a list of arrays (start position, motif),
	but searches a list of strings. Designed for a days worth of 
	labeled song being put in a list."""
	#loops through list_of_songs and performs findmotif on each element
	list_of_motifs = [findmotif(element, motif) for element in list_of_songs]
	#returns output
	return list_of_motifs
	
def convert_list_to_array(list_of_motifs):
	"""Converts a list of 2d arrays from findmotif or motifs_in_list
	into one giant array."""
	return numpy.vstack(list_of_motifs)
	
def unique_motifs_song(song_array, array=1 ):
	"""After using findmotif, you can put it into this function to see
	the number of unique motifs sung. Ex: 'ab---ab---ac---ad' will give
	the set('ab','ac','ad')."""
	if array == 1:
		return set(song_array)
	else:
		long_array = convert_list_to_array(song_array)
		return set(long_array)
	 	
	
# to get a list of motifs in each song (only unique to each song)	
#var = [set(u[1] for u in element) for element in c]