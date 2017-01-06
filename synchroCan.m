%
% DialogBox pour demander les infos relatives à la synchro
% Tous les canaux de tous les essais doivent être marqués
% si on synchronise par points...
%
% Mars 2007, MEK, GRAME
%
function synchroCan(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    syn =guidata(gcf);
  end
  %
  switch(commande)
  %---------------
  case 'ouverture'
  	lapos =positionfen('gauche','centre',300,350);
    lafig =figure('Name','MENUSYNCHRO', ...
            'tag','FigureSynchro',...
            'Position',lapos, ...
            'CloseRequestFcn','synchroCan(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',12,...
            'Resize','off');
    uicontrol('Parent',lafig, ...
            'Position',[50 120 200 25], ...
            'String','Temps (sec) à conserver', ...
            'Style','text');
    uicontrol('Parent',lafig, ...
            'Position',[25 90 50 20], ...
            'Style','text',...
            'String','Avant:');
    syn.ed(1) =uicontrol('Parent',lafig, ...
            'Position',[75 90 50 20], ...
            'Style','edit');
    uicontrol('Parent',lafig, ...
            'Position',[140 90 50 20], ...
            'Style','text',...
            'String','Après:');
    syn.ed(2) =uicontrol('Parent',lafig, ...
            'Position',[190 90 50 20], ...
            'Style','edit');
    uicontrol('Parent',lafig, ...
            'Callback','synchroCan(''travail'')', ...
            'Position',[100 40 100 20], ...
            'String','Au travail');
    uicontrol('Parent',lafig, ...
            'Position',[30 315 240 20], ...
            'FontSize',10,...
            'FontWeight','bold',...
            'Style','text',...
            'String','Choix du type de synchronisation');
    syn.control(2) =uicontrol('Parent',lafig, ...
            'Callback','synchroCan(''choix'')', ...
            'Position',[50 290 200 20], ...
            'String','Point marqué des canaux|Minimum des canaux|Maximum des canaux', ...
            'Style','popupmenu', ...
            'Value',1);
     uicontrol('Parent',lafig, ...
            'Position',[25 185 100 20], ...
            'tag','LeTexte','Style','text',...
            'String','point marqué:');
    syn.ed(3) =uicontrol('Parent',lafig, ...
            'Position',[125 185 50 20], ...
            'tag','Ledit','Style','edit');
    set(lafig,'WindowStyle','modal');
    guidata(gcf,syn);
  %-----------
  case 'choix'
    test=get(syn.control(2),'Value');
    if test > 1
      set(findobj('tag','LeTexte'),'visible','off');
      set(findobj('tag','Ledit'),'visible','off');
    else
      set(findobj('tag','LeTexte'),'visible','on');
      set(findobj('tag','Ledit'),'visible','on');
    end
  %-------------
  case 'travail'
    OA =CAnalyse.getInstance();
    Ofich =OA.findcurfich();
    hdchnl =Ofich.Hdchnl;
    vg =Ofich.Vg;
    ptchnl =Ofich.Ptchnl;
    dtchnl =CDtchnl();
    avant =str2num(get(syn.ed(1),'String'));  % Lecture des paramètres dans l'interface
    apres =str2num(get(syn.ed(2),'String'));
    afaire =get(syn.control(2),'Value');
    lepoint =str2num(get(syn.ed(3),'String'));
    matpts =zeros(1,vg.ess);
    Matpt =zeros(vg.nad,vg.ess);
    switch(afaire)
    %-----
    case 1  % Point marqué d'un canal
      ttest =Ofich.assezpt([1:vg.nad], lepoint);
      if ttest
        uicontrol(syn.ed(3));
        return;
      end
      for ii =vg.ess:-1:1
        for jj =vg.nad:-1:1
          if ptchnl.Dato(lepoint,hdchnl.point(jj,ii),2) < 0
            Matpt(jj,ii) = 1;  % point bidon
          else
            Matpt(jj,ii) = double(ptchnl.Dato(lepoint,hdchnl.point(jj,ii),1));
          end
        end
      end
    %-----
    case 2
    	elfonction =@min;
    %-----
    case 3
    	elfonction =@max;
    end
    tavant = round(avant * hdchnl.rate);
    tapres = round(apres * hdchnl.rate);
    temps = tavant + tapres;    % est donc en nb d'échantillons
    ttest = max(temps(:));
    aa = zeros(size(matpts));
    for U =1:vg.nad
    	Ofich.getcanal(dtchnl, U);
    	N =dtchnl.Nom;
    	aa(:) =0;
    	if afaire > 1
    		for V =1:vg.ess
    		  [a,matpts(1,V)] =elfonction(dtchnl.Dato.(N)(1:hdchnl.nsmpls(U,V),V));
    		end
    	else
    		matpts =Matpt(U,:);
    	end
      ss =find(matpts(1,:) < tavant(U,:));
      if length(ss)
        aa(ss) =1;
      end
      ss =find(hdchnl.nsmpls(U,:) < (matpts(1,:)+tapres(U,:)));
      if length(ss)
        aa(ss) =aa(ss)+2;
      end
      coupe = matpts(1,:)-tavant(U,:);
      for V =1:vg.ess
        switch(aa(V))
        case 0
          loffset =1;      % offset dans la matrice de sortie
          debut =matpts(1,V)-tavant(U,V)+1;
          lafin =matpts(1,V)+tapres(U,V);
        case 1  % il manque des smpl à gauche
          loffset =tavant(U,V)-matpts(1,V)+1;
          debut =1;
          lafin =matpts(1,V)+tapres(U,V);
        case 2  % il manque des smpl à droite
          loffset =1;
          debut =matpts(1,V)-tavant(U,V)+1;
          lafin =hdchnl.nsmpls(U,V);
        case 3  % il manque des smpl à gauche et à droite
          loffset =tavant(U,V)-matpts(1,V)+1;
          debut =1;
          lafin =hdchnl.nsmpls(U,V);
        end
        tsync =lafin-debut+loffset;
        treel =temps(U,V);
        dtchnl.Dato.(N)(loffset:tsync,V) =dtchnl.Dato.(N)(debut:lafin,V);
        dtchnl.Dato.(N)(1:loffset,V) =dtchnl.Dato.(N)(loffset,V);
        dtchnl.Dato.(N)(tsync:treel,V) =dtchnl.Dato.(N)(tsync,V);
        hdchnl.max(U,V) =max(dtchnl.Dato.(N)(:,V));
        hdchnl.min(U,V) =min(dtchnl.Dato.(N)(:,V));
        for k =1:hdchnl.npoints(U,V)
          ptchnl.Dato(k,hdchnl.point(U,V),1) =ptchnl.Dato(k,hdchnl.point(U,V),1)-coupe(V);
          if ptchnl.Dato(k,hdchnl.point(U,V),1) <= 0 | ptchnl.Dato(k,hdchnl.point(U,V),1) > temps(U,V)
            ptchnl.Dato(k,hdchnl.point(U,V),2) =-1;
          end
        end
      end
      if size(dtchnl.Dato.(N),1) > ttest
        dtchnl.Dato.(N)(ttest+1:end,:) =[];
      end
      Ofich.setcanal(dtchnl);
      hdchnl.nsmpls(U,:) =temps(U,:);
      hdchnl.sweeptime(U,:) =(temps(U,:) ./ hdchnl.rate(U,:));
    end
    hdchnl.frontcut(1:vg.nad,1:vg.ess) =0;
    ppp =findobj('tag','FigureSynchro');
    delete(ppp);
    delete(dtchnl);
    vg.sauve =1;
    OA.OFig.affiche();
  %--------------
  case 'fermer'
    ppp =findobj('tag','FigureSynchro');
    delete(ppp);
  end
end
