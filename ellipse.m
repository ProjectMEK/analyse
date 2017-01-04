function ellipse(varargin)
%
% function to draw confidence ellipse (95% level)
% voir la convertion dans le fichier CEllipse.m
%
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
    xn=guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  catego =Ofich.Catego;
  %
  switch(commande)
  %---------------
  case 'ouverture'
% enlevé le 29 oct 2009  	Ofich.lesess();
%  	Ofich.lescats();
    if vg.nad  >2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','H',400,490);
    xn.fig(1) =figure('Name','MENU ELLIPSE', 'Position',lapos, ...
          'CloseRequestFcn','ellipse(''fermer'')',...
          'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
          'defaultUIControlunits','pixels',...
          'defaultUIControlFontSize',10, 'Resize','off');
    uicontrol('Parent',xn.fig(1), ...
          'FontSize',12,...
          'FontWeight','bold',...
          'Position',[25 440 175 25], ...
          'String','Choix du canal X ', ...
          'Style','text');
    xn.control(1) = uicontrol('Parent',xn.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[25 295 175 135], ...
          'String',hdchnl.Listadname, ...
          'Min',1,...
          'Style','listbox', ...
          'Value',1);
    uicontrol('Parent',xn.fig(1), ...
          'FontSize',12,...
          'FontWeight','bold',...
          'Position',[200 440 175 25], ...
          'String','Choix du canal Y ', ...
          'Style','text');
    xn.control(2) =uicontrol('Parent',xn.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[200 295 175 135], ...
          'String',hdchnl.Listadname, ...
          'Min',1,...
          'Style','listbox', ...
          'Value',1);
    uicontrol('Parent',xn.fig(1), ...
          'FontWeight','bold',...
          'Position',[25 245 175 25], ...
          'String','Canal du Point Marqué', ...
          'Style','text');
    xn.control(3) =uicontrol('Parent',xn.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[25 180 175 70], ...
          'String',['...|' hdchnl.Listadname], ... 
          'Callback','ellipse(''choixPM'')',...
          'Min',1,...
          'Style','listbox', ...
          'Value',1);  %['...|canal X |canal Y'], ...
    uicontrol('Parent',xn.fig(1), ...
          'FontWeight','bold',...
          'Position',[200 245 175 25], ...
          'String','Catégorie', ...
          'Style','text');
    if vg.niveau
      les_niv =catego.Dato(1,1,1).nom;
      for i =2:vg.niveau
        les_niv =strcat(les_niv, '|',catego.Dato(1,i,1).nom);
      end
    else
     les_niv =['aucune'];
    end
    xn.control(6) =uicontrol('Parent',xn.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[200 180 175 70], ...
          'String',les_niv, ...
          'Max',1,...
          'Style','listbox', ...
          'Value',1);  % Les Catégories
    points ='...';
    uicontrol('Parent',xn.fig(1), ...
          'FontWeight','bold',...
          'Position',[25 155 165 20], ...
          'String','Points disponibles', ...
          'Style','text');
    xn.control(4) =uicontrol('Parent',xn.fig(1), ...
          'BackgroundColor',[1 1 1], ...
          'Position',[40  115 100 40], ...
          'String',points, ...
          'Min',1,...
          'Style','listbox', ...
          'Value',1);
    xn.control(5) =uicontrol('Parent',xn.fig(1), ...
          'Position',[200 100 100 25], ...
          'String','Au travail!', ...
          'Callback','ellipse(''travail'')');   
    uicontrol('Parent',xn.fig(1), ...
            'Position',[1 1 398 65],...
            'Style','frame');
    uicontrol('Parent',xn.fig(1), ...
          'FontSize',9,...
          'Position',[25 10 350 45], ...
          'String','Les ellipses de confiances (p<.05) de points marqués - la longueur des axes principaux(Axe1) et secondaires(Axe2) et son orientation(angle) sont calculées', ...
          'Style','text');
  set(xn.fig(1),'WindowStyle','modal');
  guidata(gcf,xn);
  %-------------
  case 'travail'
    ptchnl =Ofich.Ptchnl;
    canalx =get(xn.control(1),'Value') ;  % X
    canaly =get(xn.control(2),'Value');   % Y
    canPM =get(xn.control(3),'Value')-1;  % canal des pts ref
    ptmk =get(xn.control(4),'Value') -1;  % pts
    leniv =get(xn.control(6),'Value');    % leniv? hé ben bonyenne, c'est le niveau!
    if ptmk == 0
      disp('Vous avez sélectionnez "..." !!!');
    elseif canalx == canaly 
      disp('Il faut choisir des canaux differents pour x et y !!!');
    elseif canPM == 0
      disp('Vous avez sélectionnez "..." !!!');
    else
      ttest =Ofich.assezpt(canPM,ptmk);
      if ttest
        return;
      end
      h1 =waitbar(0,'Lecture des points en cours');
      dtxc1 =CDtchnl();
      Ofich.getcanal(dtxc1, canalx);
      dtyc2 =CDtchnl();
      Ofich.getcanal(dtyc2, canaly);
      dtc3 =dtxc1.clone();
      for j =1:vg.ess
        waitbar(j/vg.ess);
        xpt =ptchnl.Dato(ptmk,hdchnl.point(canPM,j),1);
        xval(j) =dtxc1.Dato.(dtxc1.Nom)(xpt,j);
        yval(j) =dtyc2.Dato.(dtyc2.Nom)(xpt,j);
      end
      hdchnl.duplic([canalx canaly canalx]);
      waitbar(0,h1,['Compilation des résultats, Catégorie= ' catego.Dato(1,leniv,1).nom]);
      for stim =1:catego.Dato(1,leniv,1).ncat				%loop over all conditions
        if catego.Dato(2,leniv,stim).ncat
          cond = find(catego.Dato(2,leniv,stim).ess'); %'
          lacondit =deblank(catego.Dato(2,leniv,stim).nom);
          xx = [xval(cond)]; %now incorporate this and yy into ellipse
          yy = [yval(cond)];
          mx = mean(xx);
          my = mean(yy);
          x = xx-mx;				%centre the data at (0 0)
          y = yy - my;
          pf = polyfit(xx,yy,1); %fit to st line
          %yf = polyval(pf,xx);  
          thetabase = atan(pf(1)); % find slope
          if thetabase > pi
            thetabase = thetabase - pi
          end
          [th, d] = cart2pol(x,y); 	%convert data to polar
          th_new = th - thetabase;	%rotate by slope value
          [xnew, ynew] = pol2cart(th_new, d);	%recreate cartesian values of rotated data
          pf2 = polyfit(xnew,ynew,1)	;	%do another fit to check if line is horizontal
          extratheta = 0;
          if abs(pf2(1)) > 0.05			%rotate by extra angle if slope not horizontal
            extratheta = atan(pf2(1));
            th_new = th_new - extratheta;
            [xnew, ynew] = pol2cart(th_new, d);
          end
          mxx = mean(xnew);				%find new means (should be zero)
          myy = mean(ynew);
          stdxx = std(xnew);			%find std of data in x and y
          stdyy = std(ynew);
          theta = (0:0.5:20)/10*pi;			%create angle vector to create ellipse points
          elpx = mxx + sqrt(6.17)*stdxx*cos(theta);	% IS 40 points enough ??????????????
          elpy = myy + sqrt(6.17)*stdyy*sin(theta);
          %now rotate back
          [elpth, elpd] = cart2pol(elpx, elpy); %determine polar coordinates of ellipse points
          elpth = elpth + thetabase + extratheta; %rotate back, this is the ellipse inclination
          primaryD = 2*sqrt(6.17)*stdxx;				%determine the axes' lengths
          secondaryD = 2*sqrt(6.17)*stdyy;
          theta = (thetabase + extratheta)*360/(2*pi);			%orientation of ellipse in degrees
          ell_data = [0; primaryD; secondaryD; theta; 0]; %zeros added to make 3 central points more visible
          [elp_xnew, elp_ynew] = pol2cart(elpth, elpd); %regenerate the cartesian values 
          elp_xnew = elp_xnew + mx;
          elp_ynew = elp_ynew + my;
          num_el_points = length(elp_xnew);
          %figure   %put this back in/remove  if need/no need  to check ellipses
          %plot(xx,yy,'r*')
          %hold on
          %plot(elp_xnew,elp_ynew,'b-');
          %title(['primary = ' num2str(primaryD) ' secondary = ' num2str(secondaryD) 'angle' num2str(theta)]);
          %now stock values for all trials in condition
          for stp = 1:size(cond,1)
            dtxc1.Dato.(dtxc1.Nom)(1:num_el_points,cond(stp)) =elp_xnew'; %'
            dtyc2.Dato.(dtyc2.Nom)(1:num_el_points,cond(stp)) =elp_ynew';  %'
            dtc3.Dato.(dtc3.Nom)(1:5,cond(stp)) =[ ell_data];
            tmp =strcat('Ellipse-xpts /', lacondit);
            hdchnl.comment{vg.nad+1, cond(stp)} =tmp;
            tmp =strcat('Ellipse-ypts /', lacondit);
            hdchnl.comment{vg.nad+2, cond(stp)} =tmp;
            tmp =strcat('Ellipse-sum /', lacondit);
            hdchnl.comment{vg.nad+3, cond(stp)} =tmp;
            hdchnl.nsmpls((vg.nad)+ 1 ,cond(stp)) =num_el_points;    %record the number of data points for new chanels
            hdchnl.nsmpls((vg.nad)+ 2 ,cond(stp)) =num_el_points;
            hdchnl.nsmpls((vg.nad)+ 3 ,cond(stp)) =5;
          end
          if stim == 1
            coms = [hdchnl.adname{canalx} '-'  hdchnl.adname{canaly}];
            hdchnl.adname{vg.nad+1} =['Elx.' coms];
            hdchnl.adname{vg.nad+2} =['Ely.' coms];
            hdchnl.adname{vg.nad+3} ='El.Axe1.Axe2.angle';
          end
        end  % if catego.Dato(2,leniv,stim).ncat il doit y avoir des essaies
        waitbar(stim/catego.Dato(1,leniv,1).ncat);
      end
      Ofich.setcanal(dtxc1, vg.nad+1);
      Ofich.setcanal(dtyc2, vg.nad+2);
      Ofich.setcanal(dtc3, vg.nad+3);
      %automatically define the three values in the third channel as PM's
      for j =1: vg.ess
        Ofich.marqettyp(vg.nad+3, j, 1, 2, 0);
        Ofich.marqettyp(vg.nad+3, j, 2, 3, 0);
        Ofich.marqettyp(vg.nad+3, j, 3, 4, 0);
        elnumero =hdchnl.nsmpls(vg.nad+1 ,j);
        hdchnl.max(vg.nad+1, j) =max(dtxc1.Dato.(dtxc1.Nom)(1:elnumero,j));
        hdchnl.min(vg.nad+1, j) =min(dtxc1.Dato.(dtxc1.Nom)(1:elnumero,j));
        elnumero =hdchnl.nsmpls(vg.nad+2 ,j);
        hdchnl.max(vg.nad+2, j) =max(dtyc2.Dato.(dtyc2.Nom)(1:elnumero,j));
        hdchnl.min(vg.nad+2, j) =min(dtyc2.Dato.(dtyc2.Nom)(1:elnumero,j));
        elnumero =hdchnl.nsmpls(vg.nad+3 ,j);
        hdchnl.max(vg.nad+3, j) =max(dtc3.Dato.(dtc3.Nom)(1:elnumero,j));
        hdchnl.min(vg.nad+3, j) =min(dtc3.Dato.(dtc3.Nom)(1:elnumero,j));
      end  
      close(h1);  
      vg.nad =vg.nad +3;
      delete(xn.fig(1));
      vg.sauve =1;
      gaglobal('editnom');
    end
  %-------------
  case 'choixPM'
    canalpm = get(xn.control(3),'Value') -1;  %ref canal
    if canalpm ==0
      points = '...';
      set(xn.control(4),'value',1);
      set(xn.control(4),'string',points);
    else   
      points = '...';
      nptpm = hdchnl.npoints(canalpm,1);
      for np = 1:nptpm
        points = strcat(points,'|','n°',num2str(np));
      end	
      set(xn.control(4),'string',points);
    end
  %------------
  case 'fermer'
    delete(xn.fig(1));
  end
end
