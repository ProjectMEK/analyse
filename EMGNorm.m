function EMGNorm(varargin)
%
% NORMALISATION
%
% Laboratoire GRAME
% Avril 2000...
%
% Fonction qui normalise tous les essais d'un canal par rapport au calcul
% de la valeur RMS d'un essai de référence.
%
% Les paramètres à choisir sont: le choix des canaux, l'essai de référence 
% pour le calcul du RMS, et l'intervalle de calcul.
%
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)																
  %---------------
  case 'ouverture'
    vg.valeur =1;
    if vg.nad > 2; letop =vg.nad; else letop =vg.nad+1; end
    dep ={'temps en seconde'; 'Point marqué'};
    largeur =350; hauteur =475; mgreg =25; mgfr =5; epais =25;
    lapos =positionfen('G','C',largeur, hauteur);
    fig =figure('Name','NORMALISATION', 'Position',lapos, 'CloseRequestFcn','EMGNorm(''fermer'')', ...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','pixels',...
                'DefaultUIControlFontSize',11, 'Resize', 'off');
    posx =mgreg; posy =hauteur-epais-5; large =largeur-(2*posx); haut =epais;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
              'Style','text', 'String','Choix du canal (RMS)');
    haut =150; posy =posy-haut-5;
    uicontrol('Parent',fig, 'tag','ChoixCanaux', 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut], ...
              'Style','listbox', 'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Value',1);
    lgfr =largeur-(2*mgfr); mbfr =5; htfr =round(posy-mbfr-(0.5*epais));
    uicontrol('Parent',fig, 'Position',[mgfr mbfr lgfr htfr], 'style','frame');
    posy =mbfr+htfr-epais-5; haut =epais;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
              'Style','text', 'String','Signal de référence (EMG)');
    large =round((largeur-epais-2*posx)/2); posy =round(posy-1.25*haut);
    uicontrol('Parent',fig, 'tag','ChoixCanauxRef', 'BackgroundColor',[1 1 1], ...
              'callback','EMGNorm(''initpts'')', 'Position',[posx posy large haut], ...
              'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-epais large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Canal', 'FontSize',10);
    posx =posx+large+epais;
    uicontrol('Parent',fig, 'tag','ChoixEssaiRef', 'BackgroundColor',[1 1 1], 'Style','popupmenu', ...
              'callback','EMGNorm(''initpts'')', 'Position',[posx posy large haut], ...
              'String',vg.lesess, 'Value',1);														%
    uicontrol('Parent',fig, 'Position',[posx posy-epais large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Essai', 'FontSize',10);
    posy =posy-2*haut; large =round(largeur/2); posx =round((largeur-large)/2);
    uicontrol('Parent',fig, 'Position',[posx posy large haut-5], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix de Début/Fin');
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixDebutFin', 'Position',[posx posy large haut], ...
              'Style','popupmenu', 'String',dep, 'Callback','EMGNorm(''Points'')', 'Value',1);
    posy =round(posy-1.75*haut); large =round(largeur/6); posx =round(largeur/4);
    uicontrol('Parent',fig, 'tag','TempsDebut', 'style', 'edit', ...
              'position', [posx posy large haut], 'string', '0');
    uicontrol('Parent',fig, 'tag','PointDebut', 'BackgroundColor',[1 1 1], 'visible','off', ...
              'Position',[posx posy large haut], 'Style','popupmenu', 'String','...', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Début', 'FontSize',10);
    posx =round(largeur*0.75)-large;
    uicontrol('Parent',fig, 'tag','TempsFin', 'style', 'edit', 'position', [posx posy large haut], 'string', '10');
    uicontrol('Parent',fig, 'tag','PointFin', 'BackgroundColor',[1 1 1], 'Style','popupmenu', ...
              'Position',[posx posy large haut], 'String','...', 'visible','off', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'String','Fin', 'FontSize',10);
    large =100; posx =round((largeur-large)/2); haut =epais; posy =posy-3*haut;
    uicontrol('Parent',fig, 'Callback','EMGNorm(''travail'')', ...
              'Position',[posx posy large haut], 'String','au travail');
    set(fig, 'WindowStyle','modal');
  %------------------------------------------------------------------------------------------
  case 'Points'
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    switch(pts)
    %-----
    case 1                                                  %cas valeur temporelle
      set(findobj('tag','PointDebut'),'visible','off');
      set(findobj('tag','PointFin'),'visible','off');
      set(findobj('tag','TempsDebut'),'visible','on');
      set(findobj('tag','TempsFin'),'visible','on');
    %-----
    case 2                                                  %cas pts déjà marqués	
      set(findobj('tag','TempsDebut'),'visible','off');
      set(findobj('tag','TempsFin'),'visible','off');
      set(findobj('tag','PointDebut'),'visible','on');
      set(findobj('tag','PointFin'),'visible','on');
      EMGNorm('initpts');
    end
    %
  %-------------
  case 'initpts'
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    if pts == 2
      canal =get(findobj('tag','ChoixCanauxRef'),'Value')';
      lessai=get(findobj('tag','ChoixEssaiRef'),'Value')';
      liste ='...';															%ait le meme nbr pr chaque
      nptm =hdchnl.npoints(canal,lessai); 									%essai
      for l =1:nptm
        liste =strcat(liste,'|','n°',num2str(l));
      end
      laval =get(findobj('tag','PointDebut'),'value');
      if laval > nptm+1
        laval =1;
      end
      set(findobj('tag','PointDebut'),'String',liste,'value',laval);
      laval =get(findobj('tag','PointFin'),'value');
      if laval > nptm+1
        laval =1;
      end
      set(findobj('tag','PointFin'),'String',liste,'value',laval);
    end
  %-------------
  case 'travail'
    canaux =get(findobj('tag','ChoixCanaux'), 'Value')'; %'
    nombre =length(canaux);
    essref =get(findobj('tag','ChoixEssaiRef'),'Value');
    canref =get(findobj('tag','ChoixCanauxRef'),'Value');
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    switch(pts)																	
    %-----
    case 1
      deb =str2double(get(findobj('tag','TempsDebut'),'String'));
      fin =str2double(get(findobj('tag','TempsFin'),'String'));
      fs =hdchnl.rate(canref,essref);
      tdeb =floor(deb*fs);
      if tdeb > hdchnl.nsmpls(canref,essref)-1
        disp('valeur de début incohérente');
        return;
      elseif tdeb == 0
        disp(['La valeur du début sera: ' num2str(1/fs) ' sec']);
        tdeb =1;
      end
      tfin =floor(fin*fs);
      if tfin <= tdeb
        disp('valeur de début/fin incohérente');
        return;
      elseif tfin > hdchnl.nsmpls(canref,essref)
        tfin =hdchnl.nsmpls(canref,essref);
        disp(['La valeur de fin sera: ' num2str(tfin/fs) ' sec']);
      end
    %-----
    case 2
      ptchnl =Ofich.Ptchnl;
      pd =get(findobj('tag','PointDebut'),'Value');
      pf =get(findobj('tag','PointFin'),'Value');
      if pd == 1 || pf == 1 || pd == pf
        disp('Revoyez vos choix de points???');
        return;
      end
      ttest =Ofich.assezpt(canref,[pd-1 pf-1],essref);
      if ttest
        return;
      else
        tdeb =ptchnl.Dato((pd-1),hdchnl.point(canref,essref),1);
        tfin =ptchnl.Dato((pf-1),hdchnl.point(canref,essref),1);
        if tfin < tdeb
          a =tdeb;
          tdeb =tfin;
          tfin =a;
        end
      end
    end
    Wb =waitbar(0, 'Travail en cours...');
    %------------------------
    % Ajout des canaux utiles
    hdchnl.duplic(canaux);
    Dt =CDtchnl();
    Ofich.getcaness(Dt, essref, canref);
    Xref =Dt.Databrut();
    rms =sqrt(mean(Xref(tdeb:tfin).^2));
    Vrms =100/rms;
    total =nombre*vg.ess;
    tmp =0;
    for ncan =1:nombre
    	vg.nad =vg.nad+1;
    	Ofich.getcanal(Dt, canaux(ncan));
      Dt.Dato.(Dt.Nom)(:) =Vrms*Dt.Dato.(Dt.Nom)(:);
      for j =1:vg.ess
        hdchnl.comment{vg.nad, j} =['NORM,rms=' num2str(rms) 'E' num2str(essref) 'C' num2str(canref) '//' hdchnl.comment{vg.nad, j}];
        n =hdchnl.nsmpls(vg.nad,j);
        hdchnl.max(vg.nad, j) =max(Dt.Dato.(Dt.Nom)(1:n, j));
        hdchnl.min(vg.nad, j) =min(Dt.Dato.(Dt.Nom)(1:n, j));
        tmp =tmp+1;
        waitbar(tmp/total, Wb);
      end
      Ofich.setcanal(Dt, vg.nad);
      hdchnl.adname{vg.nad} =['Norm(' deblank(hdchnl.adname{canaux(ncan)}) ')'];
    end
    delete(Dt);
    delete(Wb);
    delete(gcf);
    vg.sauve = 1;
    gaglobal('editnom');
  %------------
  case 'fermer'																%qd on abandonne
    delete(gcf);														%arrete et efface
  %--
  end
end
