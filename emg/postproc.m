function [t,c,Qc,plog,var,cvar]=postproc(y,t0,dcrit,gr)
% [t,c,Qc,plog,var,cvar]=postproc(y,t0,dcrit,gr)
%
% post processor for event classification in independent random process with piece-wise constant variance and constant mean.
% Classification is based on multiple comparison of variances using the F-test
%
% Changes in variance between subsequent segments in y (transition times defined by the vector of change time candidates t0) are
% tested for significance and segments are classified according to their variance. Change time candidates separating subsequent
% segments assigned to the same variance class are eliminated.
%
% Prerequisite: Samples in y are independent and have an approximate Gaussian distribution with constant mean 
%
% y        input signal (column vector)
% t0       vector with indices of possible level changes in variance (change time candidates)
% dcrit    decision criterion for class definition
%          if dcrit is a real number 0<dcrit<1, a fixed significance level alpha=dcrit will be used for the two-sided F-test
%          if dcrit is an integer number > 1, the significance level alpha is automatically adjusted such that a minimum number of dcrit classes will be established
%          defaults to dcrit=2
% gr (opt) 1-> display results, 0 -> no graphics (default)
%
% t        vector with indices of significant level changes between segments (including "transition" at sample 1)
% c        vector with variance class (1, 2, ...) for each segment (classes are numbered according to increasing variance) 
% Qc       vector with estimated variance of each class
% plog     structure with detailed test results for all segment candidates and change time candidates (for details see below)
% var      estimated variance profile
% cvar     95% confidence interval of variance profile
%
% -----------------------------------------------------------------------------------------------------------
% Example
%
% v=[0.1*ones(300,1); ones(200,1); 0.3*ones(100,1)]; % generate variance profile
% t0=[201 301 501];                                  % vector with change time candidates
% y=sqrt(v).*randn(size(v));                         % generate noise signal
% t=postproc(y,t0,0.001,1)                           % apply post processor with threshold 0.001 and graphics enabled   
%
% ------------------------------------------------------------------------------------------------------------
% Method:
%
% An unsupervised learning rule is applied to determine the number of statistically different variance classes contained in y
% and to assign the segment candidates (epochs between successive change time candidates) to the variance classes found. To this, segment candidates are sorted according to
% alternate extremes in variance (i.e., [smallest, largest, next smallest, next largest, ...] in order to determine a learning sequence
% and subsequently subjected to a repeated comparison of variances using the F-test.
%
% Initially, the estimated variance of the first segment candidate in the learning sequence is assigned to a variance class c1 and the estimated variance of the second segment
% in the learning sequence is compared to the variance of the first segment by a F-test. The F-test computes the probability (p-value) that the true variance in both segments.
% is the same and the observed difference in variance estimates just occured by chance. If this probability falls below a critical threshold alpha, the two variances are considered
% to be different and a new variance class c2 is established with the variance estimate of the second segment serving as a prototype for the new class c2. Otherwise, the second segment
% is assigned to the already existing variance class c1 and the variance estimates are merged thus forming a new (improved) variance estimate for c1. Next, the samples of the third segment
% in the learning sequence are compared to the already found prototypes c1 and c2. If the largest outcome of the tests is below threshold, a new variance class c3 is created.
% Otherwise, the segment is assigned to the variance class with the largest p-value,and so on. This procedure is repeated segment by segment until the end of the learning sequence is reached. 
%
% If dcrit is an integer number, a log-linear search is performed to find the smallest level alpha of significance for which a total number of dcrit classes will be obtained.
% To this, the threshold is initialized with the outcome of the F-test for the smallest and largest variance in the sequence and subsequently increased until classification
% yields a total number of dcrit classes. Note that the number of classes found may exceed dcrit, if the threshold required to associate the smallest and the largest variance
% to separate classes already yields more than a total number of dcrit classes. 
% 
% After class prototypes were defined, each segment candidate is compared to all variance prototypes and the segment is assigned to the best fitting class.
% Finally, change time candidates indicating transitions between subsequent segments belonging to the same variance class are eliminated.
%
% Results are summarized in the structure plog
%
%          plog.class         vector with variance class assigned to each segment candidate
%          plog.ischange      logical vector indicating change time candidates with class changes 
%          plog.pclass        matrix with F-test p-values for each segment candidate and variance class
%          plog.order         vector with numbers indicating at which position in the learning sequence each segment candidate was presented                       
%          plog.plearn        vector with p-values assigned to each segment candidate during class prototyping                       
%                             (p-value of most similar variance class already available when the segment was presented during learning
%                             p-values<=alpha indicate creation of new classes)
%          plog.clearn        class number each segment candidate is assigned to during learning
%          plog.alpha         significance level used during prototyping
%
%  References: 
%
%   [1]   Staude G., Kafka V., Wolf W., "Determination of premotor silent periods from myoelectric signals", Biomed. Tech. Suppl. 2, 45:228-232, 2000
%
% version 1.6 by Gerhard.Staude@unibw.de                                                        December 2009

  % set defaults
  if nargin<4
     gr=0;
  end
  
  if nargin<3
      dcrit=2;
  end
  
  
  y=y(:);                   % make sure that y is a column vector
  t0=t0(:)';                % make sure that t0 is a row vector
  
  y=y-mean(y);              % subtract mean
  
  t0=[1 t0 length(y)];      % expand change index vector to include beginning and end of the sequence
  
  % group data according to segments and determine size and variance of each segment
  N=length(t0)-1;           % total number of segments
  
  S=[0; cumsum(y.^2)]';     % cumulative sum of squared samples 
  
  ns=diff(t0);              % vector with number of samples in each segment
  Qs=diff(S(t0))./(ns-1);   % vector with estimated variance of each segment
  
  % determine sequence for presentation of segments during class prototyping
  [dummy sq]=sort(Qs);      % sort segments according to increasing variance
  hsq=zeros(size(sq));      % then alternate small and large variances
  if rem(length(sq),2)
     hsq(1:2:length(sq))=sq(1:ceil(end/2));hsq(2:2:length(sq))=sq(end:-1:ceil(end/2)+1);
  else
     hsq(1:2:length(sq)-1)=sq(1:end/2);hsq(2:2:length(sq))=sq(end:-1:end/2+1);
  end
  sq=hsq;
  
  if dcrit>1 
     alpha=adjustthreshold(Qs(sq),ns(sq),dcrit); % adjust significance level to obtain a minimum number dcrit of classes
  else
     alpha=dcrit; % use fixed significance level alpha=dcrit
  end
  
  % apply unsupervised learning rule to find class prototypes
  [Qc,nc,result,plog]=classify(Qs(sq),ns(sq),alpha);
  plog.order=sq; % order of segments in learning sequence
  plog.alpha=alpha; % threshold used during learning
  
  % assign segments to the variance classes found
  plog.pclass=zeros(N,length(Qc));                       
  for i=1:N
     % perform F-test to compare the variance of the i-th segment with all variance classes
     F=Qc/Qs(i);        % compute F-statistic (ratio between variances to be compared)
     ps=ftest(F,nc-1,repmat(ns(i)-1,size(nc))); % compute p-values from cumulative F distribution function
  
     % determine most similar class (largest probability p to observe F when true variances are equal) 
     [m, indexm]=max(ps);
     plog.class(i)=indexm; % assign class membership
     plog.pclass(i,:)=ps;  % save corresponding outcome of F-test (p-values) for all classes
  end
  
  % mark change candidates indicating transitions between different classes by 1
  plog.ischange=(diff(plog.class)~=0);
  
  % remove change time candidates separating subsequent segments with the same class membership from list
  hh=[1 find(plog.ischange)+1];
  t=t0(hh);
  
  % determine class membership for each merged segment
  c=plog.class(hh);
  
  % resort class numbers according to increasing variance
  [Qc iv]=sort(Qc);
  ih(iv)=1:length(iv);
  c=ih(c);
  plog.clearn=ih(plog.clearn);
  plog.class=ih(plog.class);
  plog.pclass=plog.pclass(:,iv);
  
  % compute final variance estimates and confidence intervals
  ht=t;
  ht(end+1)=length(y);
  n=diff(ht);             % vector with number of samples in each final segment
  Q=diff(S(ht))./(n-1);   % vector with estimated variance of each final segment
  Qconf=confvar(Q,n,0.05);% matrix with corresponding confidence intervals
  
  % compute corresponding time profiles
  var=zeros(length(y),1);    % variance profile
  cvar=zeros(length(y),2);   % confidence intervals
  for k=1:length(ht)-1
     var(ht(k):ht(k+1))=Q(k);
     cvar(ht(k):ht(k+1),1)=Qconf(k,1);
     cvar(ht(k):ht(k+1),2)=Qconf(k,2);
  end
  
  
  % graphics
  if gr
     clf
     hzoom=zoom;
     set(hzoom,'Enable','on'); % enable zoom
     ax(1)=subplot(311);
     plot(1:length(y),y)
     line(repmat(t0,[2 1]),repmat([min(y); max(y)],size(t0)),'LineStyle',':','Color','k');
     line(repmat(t,[2 1]),repmat([min(y); max(y)],size(t)),'LineStyle','-','Color','k');
     axis tight
     p=max(y)-.1*(max(y)-min(y));
     ht=[t length(y)];
     for i=2:length(ht)
        if length(Qc)>1
            patch([ht(i-1) ht(i) ht(i) ht(i-1)],[min(y) min(y) max(y) max(y)],'k','edgealpha',0,'facealpha',.5*(c(i-1)-1)/(max(c)-1));
        end
        text(.5*(ht(i-1)+ht(i)),p,char(64+c(i-1)),'HorizontalAlignment','center','Clipping','on') % label classes by a, b, c, ...
     end
     p=max(y)-.9*(max(y)-min(y));
     for i=2:length(t0)
        text(.5*(t0(i-1)+t0(i)),p,num2str(i-1),'HorizontalAlignment','center','Clipping','on') % label segment candidates by 1, 2, 3, ...
     end
     title('analyzed signal and identified segments of similar variance (dotted lines indicate eliminated change time candidates)')
     ylabel('amplitude')
     
     ax(2)=subplot(312);
     plot(1:length(y),log10(cvar),'r--',1:length(y),log10(var),'b-')
     axis tight
     title('estimated variance profile  red: 95% confidence interval')
     ylabel('log variance')
  
     setAxesZoomMotion(hzoom,ax,'horizontal')
     linkaxes(ax,'x'); % link axes 1 and 2 during zoom
  
     ax=subplot(325);
     p=0.45;
     if length(Qc)>1
         for i=1:length(Qc)
            patch([i-p i+p i+p i-p],[log10(min(Qc)) log10(min(Qc)) log10(Qc(i)) log10(Qc(i))],'k','edgealpha',1,'facealpha',.5*(i-1)/(max(c)-1));
         end
     end
     axis tight
     set(gca,'Xtick',1:length(Qc),'XtickLabel',char(64+(1:length(Qc)))')
     title('identified class prototypes')
     xlabel('variance class')
     ylabel('log variance')
     
     ax(2)=subplot(326);
     p=0.45;
     hold on
     for i=1:N
        if plog.plearn(i)<=alpha 
           stem(i,log10(plog.plearn(i)),'r','filled');
        else
           stem(i,log10(plog.plearn(i)),'b','filled');
        end
        text(i,log10(plog.plearn(i))-25,char(64+plog.clearn(i)),'Clipping','on') % associated class 
     end
     plot(1:N,zeros(1,N)+log10(alpha),'g--')
     hold off
     axis tight
     set(gca,'ylim',[min(log10(plog.plearn))-50 0])
     set(gca,'Xtick',1:N)
     set(gca,'XtickLabel',plog.order)
     if dcrit>1
        title(['prototyping procedure, grn: decision level adjusted to log(alpha)=' num2str(fix(log10(alpha))) ' aiming for ' num2str(dcrit) ' classes'])
     else
        title(['prototyping procedure    grn: decision level fixed at log(alpha)=' num2str(fix(log10(alpha)))])
     end
        xlabel('segments presented, red dots indicate creation of a new class prototype')
     ylabel('log max p-value')
     setAxesZoomMotion(hzoom,ax,'horizontal')
  end


% Auxiliary functions

function p = ftest(x,n1,n2)
  %   p = ftest(x,n1,n2)
  %   computes the probability that a F-distributed random variable 
  %   with n1 and n2 degrees of freedom exceeds a critical value x(two-sided)
  %   Algorithm is based on the incomplete beta function
  %
  %   x    scalar or vector with critical value(s)
  %   n1   scalar or vector with degrees of freedom of sample 1 
  %   n2   scalar or vector with degrees of freedom of sample 2
  %
  %   p    scalar or vector with resulting p-value(s)
  
  p = zeros(size(x));
  h = (n2 <= x.*n1);
  if any(h)
      xx = n2(h)./(n2(h)+x(h).*n1(h));
      p(h) = betainc(xx, n2(h)/2, n1(h)/2,'upper');
  end
  if any(~h)
      hh = n1(~h).*x(~h);
      xx = hh./(hh+n2(~h));
      p(~h) = betainc(xx, n1(~h)/2, n2(~h)/2,'lower');
  end
  p=2*min([p; 1-p]); % adjust p-values for two-sided test (two-tailed distribution)
  p(p==0)=realmin; % be sure that p>0


function c=confvar(Q,n,p)
  % c=confvar(Qs,ns,p)
  %
  % compute confidence interval at significance level p
  % of variance estimate Q computed from a data sample of size n
  % according to  Q = sum((y-mean(y)).^2)/(n-1)
  %
  % Q       scalar or vector with estimated variance(s)
  % n       scalar or vector with number of samples used for the estimate(s)
  % p       scalar or vector with significance level(s)
  
  % be sure that parameters are either scalars or column vectors
  Q=Q(:);
  n=n(:);
  p=p(:);
  
  % compute confidence limits based on percentage points of chi2 distribution
  % with n-1 degrees of freedom (two-sided test)
  cl=((n-1)./chi2crit(1-p/2,n-1)).*Q; % lower bound
  cu=((n-1)./chi2crit(p/2,n-1)).*Q; % upper bound
  
  c=[cl cu];



function X = chi2crit(p,n)
  % X = chi2crit(p,n)
  % computes percentage point X for significance level p
  % from chi square distribution with n degrees of freedom
  %
  % Algorithm:
  % approximation via standard normal distribution
  % valid for n>30
  % 
  %
  % p           significance level
  % n           degrees of freedom
  %      see SACHS p 136   
  
  % compute critical value z from one-sided standard normal distribution
  pp=1-p;
  l=pp<=0.5;
  z(l)=sqrt(2)*erfinv(1-2*pp(l));
  z(~l)=-sqrt(2)*erfinv(2*pp(~l)-1);
  
  % compute percentage point X
  X = n.*(1-2./(9*n) + z.*sqrt(2./(9*n))).^3;



function alpha=adjustthreshold(Qs,ns,nclasses)
  % adjust significance level alpha of F-test to yield a particular number nclasses of
  % classes during class prototyping of variances Qs
  % performs a log-linear and a binary search within the interval 0<alpha<=1
  
  Nit=2000; % maximum depth of binary search
  
  % return alpha=1 if sequence consists of a single segment only
  if length(Qs)==1
      alpha=1;
      return
  end
  
  % initialize search interval
  ubnd=1; % initialize upper bound
  F=Qs(1)/Qs(2); % compute F-statistic for segments with largest and smallest variance
  lbnd=ftest(F,ns(1)-1,ns(2)-1); % initialize lower bound 
  
  [Qc,nc,reslbnd]=classify(Qs,ns,lbnd,nclasses); % try lower bound of search interval
  if reslbnd>=0 % return lower bound if number of classes found is nclasses or larger 
     alpha=lbnd;
     return
  end
  
  [Qc,nc,resubnd]=classify(Qs,ns,ubnd,nclasses); % try upper bound of search interval
  if resubnd<=0 % return upper bound if number of classes found is nclasses or smaller
     alpha=ubnd;
     return
  end
  
  % perform a log-linear search between lbnd and ubnd 
  talpha=[10.^(fix(log10(lbnd)):abs(log10(lbnd))/50:0) ubnd];
  res=zeros(size(talpha))+NaN;
  for i=1:length(talpha)
      [Qc,nc,res(i)]=classify(Qs,ns,talpha(i),nclasses);
      if res(i)==0 % return if correct number of classes is found
         alpha=talpha(i); 
         return
      end
  end
  
  % refine search interval for binary search 
  h=find(res==1,1,'first');
  ubnd=talpha(h);
  if h>1
     lbnd=talpha(h-1);
  end
  
  % perform binary search
  alpha=1;
  for i=1:Nit
     oalpha=alpha; % save previous value
     alpha=(lbnd+ubnd)/2; % set alpha to center of current search interval
     if abs(alpha-oalpha)<=realmin % stop search if resolution limit is reached
         return
     end
     [Qc,nc,res]=classify(Qs,ns,alpha,nclasses); % try alpha
     if res==0 % stop search if nclasses classes were found
         return
     end
     if res<0 
         lbnd=alpha; % continue search in upper half of current interval
     else
         ubnd=alpha; % continue search in lower half of current interval
     end
  end



function [Qc,nc,result,plog]=classify(Qs,ns,alpha,nclasses)
  % find class prototypes for variance estimates Qs by sequentially performing F-tests at significance level alpha
  % if the optional input argument nclasses is present,the total number of classes obtained
  % is monitored and testing is stopped as soon as the number of classes found exceeds nclasses
  %
  % Qs             vector with variance estimates to be classified
  % ns             vector with corresponding number of samples each estimate is based on
  % alpha          decision level for two-sided F-test
  % nclasses (opt) desired number of classes
  %
  % Qc             vector with variance prototypes identified
  % nc             vector with corresponding number of samples the prototype is based on
  % result         result of check
  %                1  if the number of classes found already exceeds nclasses
  %                0  if the number of classes found equals the desired number of nclasses
  %                -1 if the number of classes found is smaller than the desired number nclasses
  % plog           structure with detailed learning history
  %          plog.plearn        vector with p-values assigned to each segment candidate during class prototyping                       
  %                             (p-value of most similar variance class already available when the segment was presented during learning
  %                             p-values<=alpha indicate creation of new classes)
  %          plog.clearn        class number each segment candidate is assigned to during learning
  
  % initialize classification vectors
  Qc=Qs(1);             % first element of vector with variance estimates for each class
  nc=ns(1);             % first element of vector with number of samples of each variance class  
  
  if nargout==4
      plog=[];                                % structure with test results for all segment candidates        
      plog.plearn=[alpha zeros(1,length(Qs)-1)];       % initialize the p-value of the first segment presented in the learning sequence with alpha
      plog.clearn=[1 zeros(1,length(Qs)-1)];           % first segment in sequence is assigned to class 1
  end
  
  % apply unsupervised learning rule to find variance classes
  for i=2:length(Qs)  
  
     % perform F-test to compare the variance of the i-th segment with the previously found variance classes
     F=Qc/Qs(i); % compute F-statistic (ratio between variances to be compared)
     ps=ftest(F,nc-1,repmat(ns(i)-1,size(nc))); % compute p-values from cumulative F distribution function 
     
     % determine most similar class (largest probability p to observe F when true variances are equal) 
     [m, indexm]=max(ps);
  
     % test for significant differences
     if m<=alpha % case of significant deviation even from best fitting class
        Qc(end+1)=Qs(i); % create new class with variance of current segment as prototype
        nc(end+1)=ns(i);
        if nargout==4
            plog.clearn(i)=length(Qc); % save new class to which the segment is assigned to
        end
     else
        Qc(indexm)=((nc(indexm)-1)*Qc(indexm)+(ns(i)-1)*Qs(i))/(nc(indexm)+ns(i)-1);  % add current segment to the already existing most similar class
        nc(indexm)=nc(indexm)+ns(i); 
        if nargout==4
            plog.clearn(i)=indexm;     % save existing class the segment is assigned to
        end
     end
     if nargout==4
         plog.plearn(i)=m;    % save p-value of the most similar class
     end
     
     % end loop and return 1 if number of classes already exceeds target number of classes
     if nargin==4
         if length(nc)>nclasses
             result=1;
             return
         end
     end
  end
  
  % check if number of classes found equals nclasses
  if nargin==4
     result=(length(nc)==nclasses)-1;
  else
     result=[];
  end
