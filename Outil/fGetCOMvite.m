function varargout = fGetCOMvite(varargin)
% GetCOM calculates the gravity line from horizontal force and COP data.
% The method of double integration of horizontal force is used here. 
% The values of GLINE coincide with the values of COP when the horizontal
% force is zero. The COP in these instants are used to find the 
% integration constants.
% Run GetCOM like GL = GetCOM(T,F,COP,MASS)
% Inputs:
%  T: time vector [s] or sampling frequency [Hz] (real number)
%  F: horizontal force vector [N] (the force you apply on the ground)
%  COP: center of pressure vector [mm]
%  MASS: body mass [kg]
% Outputs:
%  GL: gravity line vector [mm]
% In this program, the first and last points of COP is considered to be coincident
% with GL to avoid problems in the extremities (later, you must discard about the
% first and last second of the COP and GL trajectories).
% Inspired from Marcos Duarte
   if nargin == 4
      f = varargin{2};
      cop = varargin{3};
      mass = varargin{4};
      if length(varargin{1})== 1
         freq = varargin{1};  % sampling frequency
         t = (1:length(f))'/freq;
      else
         t = varargin{1};
         freq = abs(1/(t(2)-t(1)));
         if size(t,1) == 1
            t=t';
         end
      end
      if size(f,1)==1
         f=f'
         cop=cop';
         col=0;
      end
   else
      error('Incorrect number of inputs')
      return
   end   
   % zero mean:
   f = f-mean(f);
   meancop = mean(cop);
   cop = cop-meancop;
   % Find the instants where F is zero (in these instants GL and COP coincide):
   % **-** [ind,xzeros] = findzeros(t,f);
   xzeros = findzeros(t,f);     % ind n'est pas utilisé plus bas
   % **-** ind = ind';
   xzeros = xzeros';
   %consider the first and last points of COP coincident with GL to avoid problems
   % in the extremities (later, you must discard the first and last second of the GL):
   % **-** ind = [1; ind; length(t)];
   xzeros = [t(1); xzeros; t(end)];
   long =length(xzeros)-1;
   iep0=interp1(t,cop,xzeros,'linear');
   % GL:
   %append xzeros:
   tcopglc=[t; xzeros];
   [tcopglc,inds]=sort(tcopglc);
   % on converti tout de suite la force--> accélération et millimètre.
   fcopglc = [1000*f/mass; zeros(long+1,1)];
   fcopglc=fcopglc(inds);
   copglc=[cop;iep0];
   copglc=copglc(inds);
   % on repère les valeurs identiques qui se suivent
   ind0=find(diff(tcopglc==0));
   % et on les retranche
   tcopglc(ind0)=[];
   fcopglc(ind0)=[];
   copglc(ind0)=[];
   gl=[];tgl2=[];ffgl=[];
   for i=1:long
      ini=find(tcopglc==xzeros(i));
      fim=find(tcopglc==xzeros(i+1));
      if fim > length(tcopglc)
         fim=length(tcopglc);
      end
      if fim-ini > 1
         timegl=tcopglc(ini:fim);
         dtimegl =diff(timegl);     % ajouté pour accélérer les calculs
         ffgl=fcopglc(ini:fim);
         copgl=copglc(ini:fim);
         % double integration of the force data (ou plutôt acceleration data):
         % **-** v=1000*cumtrapz( timegl, ffgl )/mass;	% m to mm
         v = cumsum([0; dtimegl.*(ffgl(1:end-1)+(diff(ffgl)/2))]); % la division par la masse a été faite plus haut
         % **-** v0=( copgl(end) -  copgl(1) - trapz( timegl, v ) ) / ( timegl(end)-timegl(1) );
         v0 = (copgl(end) - copgl(1) - sum(dtimegl.*(v(1:end-1)+(diff(v)/2))) ) / ( timegl(end)-timegl(1) );
         v=v0+v;
         % **-** x=copgl(1)+cumtrapz(timegl,v);
         x = copgl(1) + cumsum([0; dtimegl.*(v(1:end-1)+(diff(v)/2))]);
         gl(ini:fim)=x;
         tgl2(ini:fim)=timegl;
      end
   end
   temp=find( diff(tgl2)==0 );
   tgl2(temp)=[];
   gl(temp)=[];
   temp=find( tgl2(2:end)==0 );
   tgl2(temp+1)=[];
   gl(temp+1)=[];
   % interp gl with t:
   gl=interp1(tgl2',gl',t,'spline');
   if exist('col')
      gl=gl';
   end
   gl=gl+meancop;
   varargout{1}=gl;
end

%
% Routine modifié par MEK
% voir plus bas, la routine originale
%
function yzeros = findzeros(x,y)
  % on veut des matrices lignes
  if size(y,2) == 1
     y = y';
  end
  if size(x,2) == 1
     x = x';
  end
  % find +- transitions (approximate values for zeros):
  % ind(i): the first number AFTER the zero value
  K =abs(diff(sign([y(1) y y(end)])));
  ind =find(K==2);
  % find better approximation of zeros values using linear interpolation:
  %
  % b  = Y1 - m X1
  % X0 = -b / m
  % on aura donc
  % X0 = X1 - Y1/m
  %
  yzeros = zeros(1,length(ind));
  dx =x(1)-x(2);
  for i = 1:length(ind)
    % p = l'inverse de la pente (1/m)
    p = dx/( y(ind(i)-1)-y(ind(i)));
    yzeros(i) = x(ind(i)-1) - (y(ind(i)-1)*p );
  end
  yzeros = sort([yzeros x(find(y==0))]);
end


function varargout = findzeros_ORIGINAL(varargin)
%FINDZEROS  Find zeros in a vector.
%  IND=FINDZEROS(Y) finds the indices (IND) which are close to local zeros in the vector Y.  
%  [IND,XZEROS]=FINDZEROS(X,Y), besides IND finds the values of local zeros (XZEROS) in the 
%  vector X by linear interpolation of the vector Y.
%  Inputs:
%   X: vector
%   Y: vector
%  Outputs:
%   IND: indices of the zeros values in the vector Y
%   XZEROS: values in the vector X of zeros in the vector Y
%  Marcos Duarte  mduarte@usp.br 11oct1998 
if nargin==1
   y=varargin{1};
   if size(y,2)==1
      y=y';
   end
elseif nargin ==2
   x=varargin{1}; 
   y=varargin{2}; 
   if ~isequal(size(x),size(y))
      error('Vectors must have the same lengths')
      return
   elseif size(x,2)==1
      x=x'; y=y';
   end
else
   error('Incorrect number of inputs')
   return
end
% find +- transitions (approximate values for zeros):
%ind(i): the first number AFTER the zero value
ind = sort( find( ( [y 0]<0 & [0 y]>0 ) | ( [y 0]>0 & [0 y]<0 ) ) );
% find who is near zero:
ind1=find( ( abs(y(ind)) - abs(y(ind-1)) )<= 0 );
ind2=find( ( abs(y(ind)) - abs(y(ind-1)) )> 0 );
indzero = sort([ind(ind1) ind(ind2)-1 find(y==0)]);
varargout{1}=indzero;
if exist('x')
   % find better approximation of zeros values using linear interpolation:
   yzeros=zeros(1,length(ind));
   for i=1:length(ind)
      p=polyfit( y(ind(i)-1:ind(i)),x(ind(i)-1:ind(i)),1 );
      yzeros(i)=polyval(p,0);
   end
   yzeros=sort([yzeros x(find(y==0))]);
   varargout{2}=yzeros;
end

end