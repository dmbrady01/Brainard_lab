#!/usr/bin/env python
#note: make sure the script is executable from the shell by
#entering something like this at the command line: 
#chmod +x myfile.py
#to execute in shell, type ./myfile.py (if in cd)

"""
db_plot.py: contains functions for plotting data.
"""

__author__ = "DM Brady"
__datewritten__ = "07Aug2013"
__lastmodified__ = "07Aug2013"

#import modules
import numpy as np
import matplotlib.pyplot as plt

def generate_x_y(prob_map):
    s = prob_map.shape
    x, y = np.meshgrid(np.arange(s[0]), np.arange(s[1]))
    return x.ravel(), y.ravel()
    
def heatmap(prob_map):
    x, y = generate_x_y(prob_map)
    plt.figure()
    plt.hexbin(x, y, C=prob_map.ravel())