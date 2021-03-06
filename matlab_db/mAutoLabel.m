function [] = mAutoLabel(batch,the_template,syll,thresh,FFTthresh,minCount)
%
% script to autolabel syllables matching spectral template in batch of files.
%
% mAutoLabel(batch,the_template,syll,thresh,FFTthresh.minCount)
%
% batch = batchfile of cbin files.
%
% the_template = 128x1 vector generated by tafsimtw() used as spectral
% template
%
% syll = what you want to label the detected syllables.
%
% thresh = amplitude threshold for segmentation.
%
% FFTthresh = threshold for template match. Estimate using uievtafsim()
%
% minCount = number of consequetive FFTthresh crossings for syll
% detection. Also estimated from uievtafsim()
%

mk_tempf(batch,the_template,2,'obs0');

%min threshold
cntrng(1).MIN=minCount;
cntrng(1).MAX=10;
%true/false logic, true->note=0
cntrng(1).NOT=0;
%evtafmode=1; birdtafmode=0;
cntrng(1).MODE=1;
%threshold
cntrng(1).TH=FFTthresh;
%and/or logic with other templates.
cntrng(1).AND=0;
cntrng(1).BTMIN=0;

get_trigt2(batch,cntrng,0.05,128,1,1);
label_trigs(batch,syll,'obs0',thresh,1,1,10,20);