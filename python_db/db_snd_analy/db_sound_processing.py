#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_sound_processing.py: contains functions to do sound analysis. Requires
.cbin.not.mat files to extract syllables and db_batch.timing module
to extract timing information.
"""

__author__ = "DM Brady"
__datewritten__ = "07Aug2013"
__lastmodified__ = "07Aug2013"

#import modules
import numpy.fft as fft

def calculate_fft(signal):
    """Input a chunk of your signal and will return the fft for that chunk"""
    #runs rfft on signal chunk
    complex_fft = fft.rfft(signal)
    #takes the abs of complex_fft
    return abs(complex_fft)