function [e, Aw, V] = ma_whitefil(y,p,range,gr)
% [e, Aw, V] = ma_whitefil(y,p,range,gr)
%
% adaptive moving average (MA) whitening filter of order p
%
%  y           input signal (column vector)
%  p           filter order
%  range (opt) reference interval [start end] for parameter estimation, [] -> complete sequence (default)
%  gr (opt)    1 -> display filter process, 0 -> no display (default)
%
%  e           whitened signal (innovations)
%  Aw          estimated coefficients of whitening filter (AR coefficients A(q) of process model)
%  V           estimated variance of process noise
%
%  method:     an autoregressive (AR) model is fitted to the measured signal y within the reference interval
%              by using a prediction error criterion (Least Squares Method).
%              The innovations sequence e is obtained by filtering y with the
%              whitening filter determined by the coefficients of the model
%
% version 3.2  by Gerhard.Staude@unibw-muenchen.de                                                May 2010
%__________________________________________________________________________________________________________
%
% some remarks:
%
%                AR process model              |     MA whitening filter
%                                              | 
%                 ---------------              |    ----------------
%       w[k]     |           1   |        y[k] |   |          Aw(q) |      e[k]
%            --->|  H(z) = ----  |-------------|-->| H_w(z) = ----- |----> 
%                |          A(q) |             |   |            1   |
%                 ---------------              |    ----------------
%                                              |
%                                              |
%                                  
% y[k]   observed signal
% e[k]   whitened signal (innovations)
% w[k]   process noise (Gaussian white noise term with variance V)
%
% H(z)   transfer function of AR model
% H_w(z) transfer function of whitening filter
%
% transfer function H(z) is characterized by polynomial
%                     -1         -2                 -p
% A(q) =  1   + A(2)*q   + A(3)*q   + ... + A(p+1)*q
%        -1                                -n 
% where q   denotes the shift operator   (q   * y[k] = y[t-n] )
%__________________________________________________________________________________________________________
%
% AR model equation:
%
% A(q)*y[k] = w[k]
%
% corresponding difference equation:
%
% y[k] = - A(2)*y[k-1] - A(3)*y[k-2] ... - A(p+1)*y[k-p] + w[k]
%__________________________________________________________________________________________________________
%
% The coefficients of the polynomial Aw(q) and the variance V of the process noise w[k] are estimated
% from y[k] by applying a prediction error criterion (Least Squares Method)
% to the reference interval (y(range(1):range(2))). Within the
% reference interval, the signal is assumed to have zero mean, thus the
% coefficients are estimated from the filtered noise only. 
% Parameters Aw are adjusted such that the sum of squares of the residual
% e[k] becomes minimum within the reference interval.
%
% If the model is successfully identified (Aw(q)=A(q)), the spectral color introduced by the AR process can
% be completely removed, i.e. e[k]= w[k] 
%__________________________________________________________________________________________________________


  %--------------------------------------------------------------------------
  %preparations
  
  if nargin<4
    gr=0;
  end   
  
  % preset reference interval wref
  if nargin<3
     wref=1:length(y);
  else
     if isempty(range)
        wref=1:length(y);
     else
        wref=range(1):range(2);
     end   
  end   
  
  y=y(:);            % make sure that y is a column vector
  
  y=y-mean(y(wref)); % make sure that y is zero mean inside the reference interval
  
  % estimate coefficients of p-th order AR model
  Aw=arls(y(wref),p); % function arls() see below
  
  % compute filtered signal (innovations)
  if ~isempty(Aw)
     e=filter(Aw,1,y);
  else
     e=y; % use original sequence if model identification failed 
  end
  
  e(1:p)=0; % remove transients
  
  % estimate variance V of lumped noise term
  V=mean(e(wref).^2);
  
  % display filter process
  if gr
     clf
     ax(1)=subplot(221);
     plot(y,'b-')
     axis tight
     title('input signal y[k]')
     
     ax(2)=subplot(222);
     plot(e,'g-')
     axis tight
     title('whitened signal e[k] (innovations)')
     zoom on
     linkaxes(ax,'x')
     
     subplot(223)
     m=acf([y e],20);
     plot(0:20,m(:,1),'b-',0:20,m(:,2),'g-')
     axis tight
     title('autocorrelation functions (total)')
     
     if ~isempty(range)
         subplot(224)
         m=acf([y(wref) e(wref)],20);
         plot(0:20,m(:,1),'b-',0:20,m(:,2),'g-')
         axis tight
         title('acf (reference interval)')
     end
  end

%--------------------------------------------------------------------------
% local functions

function Aw=arls(x,p)
  % compute least squares estimate of coefficients Aw of p-th order AR model from signal x
  % using covariance method
  
  x=x(:);           % be sure that x is a column vector
  N=length(x);      % signal length
  
  % compute autocorrelation vector rxx for lags 0, 1, ... p
  rxx=zeros(1,p+1);
  for m=0:p % loop across all lags
     rxx(m+1)=x(1+m:N)'*x(1:N-m)/(N-m);
  end
  
  % compute autocorrelation matrix Rxx
  Rxx=toeplitz(rxx(1:end-1));
  
  
  % check for persistent excitation
  if rank(Rxx)<p
      disp('WARNING: The signal x is not sufficiently exciting for the chosen model order in MA_WHITEFIL !')
      Aw=[];
      return
  end
  
  % solve Wiener-Hopf equations
  th=-Rxx\rxx(2:end)';
  
  % get coefficients of AR difference equation
  Aw=[1 th'];

%--------------------------------------------------------------------------


function y=acf(x,lag)
  %y=acf(x,lag)
  %computes autocorrelation function of input signal x
  %up to lag  LAG
  %if x is a matrix, ACFs are calculated separately for each column
  
  [nsmp,ntrc]=size(x);
  
  for i=1:ntrc
    h=xcorr(x(:,i),'coeff');
    y(:,i)=h(nsmp:nsmp+lag);
  end

   