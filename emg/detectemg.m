function [changetimes, levels]=detectemg(data, kid)
% [changetimes, levels]=detectemg(filename,gr)
%
% detection and classification of muscle activation intervals in SEMG signals
% SEMG data are segmented into muscle activation intervals according to their variance    
%
% Method:          1) preprocessing using MA-Whitening-Filter
%                  2) AGLR decision rule for detection of abrupt step-like changes in the variance of an independent Gaussian random process [1]
%                  3) post processor based on multiple comparison of variances for classification of muscle activation levels
%
% PARAMETERS
%
% filename          string with name of data file
% gr (opt)          1 -> enable graphics, 0 -> disable graphics
%                   if gr is a 3x1 logical vector, graphics for
%                   preprocessor (gr(1)), AGLR decision rule (gr(2)), and postprocessor (gr(3))
%                   can be separately enabled or disabled
%
% changetimes       cell array with detected change times (in samples)
% levels            cell array with corresponding activation levels (numbered according to increasing variance)
%--------------------------------------------------------------------------
%
% FORMAT OF DATA FILE
%
% The data file "filename" must be a Matlab binary file (*.mat) containing the
% following variable:
%
% data       MxN matrix with N measured signals
%            each column of the matrix represents a single EMG recording comprising M data points
%
%--------------------------------------------------------------------------
%
% EXAMPLE:
%
%           [t,l]=detectemg('sampledata1.mat');    % analyzes the sample file sampledata1.mat included in the ZIP-File and returns the detected
%                                                  % change times and activation levels in variables t and l, respectively 
%           [t,l]=detectemg('sampledata1.mat',1);  % same as above but with graphics enabled
%           [t,l]=detectemg('sampledata1.mat',[0 0 1]);  % same as above but with graphics enabled for postprocessor only
%
%           Each of the files sampledata1.mat and sampledata2.mat comprises 10 segments of surface EMG recorded from the first dorsal interosseus (FDI) muscle
%           in a reaction time experiment. Subjects performed rapid lateral abductions of the index finger in response to a visual stimulus.
%
%           sampledata1.mat    10 voluntary rapid contractions initiated from different levels of precontraction
%           sampledata2.mat    10 voluntary rapid contractions superimposed to small voluntary cyclic movements (mimicked tremor)
%
%           sampling rate 1 kHz, visual stimulus at ts=2048
%
%--------------------------------------------------------------------------
%
% References:
%
%
%   [1]   Staude G., Kafka V., Wolf W., "Determination of premotor silent periods from myoelectric signals",
%         Biomed. Tech. Suppl. 2, 45:228-232, 2000
%
%   [2]   G. Staude and W. Wolf, "Objective motor response onset detection in surface myoelectric signals",
%         Med Eng Physics 21, 449-467, 1999
%
%   [3]   Staude G., Flachenecker C., Daumer M., and Wolf W. "Onset detection in surface electromyographic
%         signals: a systematic comparison of methods", Applied Sig. Process., 2001(2):67-81, 2001.
%
% Version 3.2  by gerhard.staude@unibw-muenchen.de                                        May 2010 
%_______________________________________________________________________________________________________

  % apply 8th order MA-whitening filter
  fy=ma_whitefil(data,8,[], 0); 
  
  % apply AGLR decision rule (data, L, h, d, mode, gr)
  t0=saglrstepvar(fy, kid.varl, kid.varh, kid.vard,'multiple', 0);
  
  % apply post processor 
  expected_levels =3;
  [changetimes, levels]=postproc(fy,t0,expected_levels, 0);
     
end
