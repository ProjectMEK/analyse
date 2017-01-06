% 
% DialogBox pour demander les infos relatives à la synchro puis on passe à l'action.
%
% Ici on va synchroniser les essais en fonction d'un canal.
% Soit que l'on choisi le point maximum du canal C (Ti secondes), alors tous les autres
% canaux de cet essai seront synchronisé en gardant un certains nombre de sec avant Ti et après.
%
function synchroEss(varargin)
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  switch(commande)
  %---------------
  case 'ouverture'
    ledernier =vg.nad+1;
    Flarge =300; Fhaut =350;
    lapos =positionfen('gauche','centre',Flarge,Fhaut);
    laFig =figure('Name','MENUSYNCHRO', 'tag','FigureSynchro',...
            'Position',lapos, 'CloseRequestFcn','synchroEss(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',12, 'Resize','off');
    uicontrol('Parent',laFig, ...
            'Position',[50 120 200 25], ...
            'String','Temps (sec) à conserver', ...
            'Style','text');
    uicontrol('Parent',laFig, ...
            'Position',[25 90 50 20], ...
            'Style','text',...
            'String','Avant:');
    uicontrol('Parent',laFig, 'tag','tempsAvant',...
            'Position',[75 90 50 20], ...
            'Style','edit');
    uicontrol('Parent',laFig, ...
            'Position',[140 90 50 20], ...
            'Style','text',...
            'String','Après:');
    uicontrol('Parent',laFig, 'tag','tempsApres',...
            'Position',[190 90 50 20], ...
            'Style','edit');
    uicontrol('Parent',laFig, ...
            'Callback','synchroEss(''travail'')', ...
            'Position',[100 40 100 20], ...
            'String','Au travail');
    uicontrol('Parent',laFig, ...
            'Position',[30 315 240 20], ...
            'FontSize',10,...
            'FontWeight','bold',...
            'Style','text',...
            'String','Choix du type de synchronisation');
    uicontrol('Parent',laFig, 'tag','WSyncChoix',...
            'Callback','synchroEss(''choix'')', ...
            'Position',[50 290 200 20], ...
            'String',{'Point marqué d''un canal','Minimum du canal','Maximum du canal'}, ...
            'Style','popupmenu', ...
            'Value',1);
    uicontrol('Parent',laFig, ...
            'Position',[50 257 200 20], ...
            'FontSize',10,...
            'FontWeight','bold',...
            'Style','text',...
            'String','Choix du canal');
    lesnom =hdchnl.adname;
    lesnom(end+1) ={'canal actif'};
    uicontrol('Parent',laFig, 'tag','LeCanal',...
            'Position',[50 235 200 20], ...
            'String',lesnom, ...
            'Style','popupmenu', ...
            'Value',ledernier);
    uicontrol('Parent',laFig, 'tag','szPointMarque',...
            'Position',[25 185 100 20], ...
            'Style','text',...
            'String','point marqué:');
    uicontrol('Parent',laFig, 'tag','iPointMarque',...
            'Position',[125 185 50 20], ...
            'Style','edit');
    set(laFig,'WindowStyle','modal');
  %-----------
  case 'choix'
    test =get(findobj('tag','WSyncChoix'),'Value');
    if test == 1
      set(findobj('tag','szPointMarque'),'visible','on');
      set(findobj('tag','iPointMarque'),'visible','on');
    else
      set(findobj('tag','szPointMarque'),'visible','off');
      set(findobj('tag','iPointMarque'),'visible','off');
    end
  %-------------
  case 'travail'
  	lemot ='CPU au travail :-) ';
  	hWb =waitbar(0.001, lemot);
    dtchnl =CDtchnl();
  	ptchnl =Ofich.Ptchnl;
    avant =str2num(get(findobj('tag','tempsAvant'),'String'));  % Lecture des paramètres dans l'interface
    apres =str2num(get(findobj('tag','tempsApres'),'String'));
    afaire =get(findobj('tag','WSyncChoix'),'Value');
    lecanal =get(findobj('tag','LeCanal'),'Value');
    lepoint =get(findobj('tag','iPointMarque'),'String');
    if lecanal == vg.nad+1
      lecanal =vg.can(1);    % on a choisi canal actif
    end
    switch(afaire)
    %-----
    case 1  % Point marqué d'un canal
      lepoint =testPoint(lepoint);
      if isnan(lepoint)
        uicontrol(findobj('tag','iPointMarque'));
        return;
      end
      ttest =Ofich.assezpt(lecanal, lepoint);
      if ttest
        uicontrol(findobj('tag','iPointMarque'));
        return;
      end
      MM =double(ptchnl.Dato(lepoint,hdchnl.point(lecanal,:),1));
    %-----
    case 2  % Minimum du canal
    	Ofich.getcanal(dtchnl, lecanal);
    	N =dtchnl.Nom;
    	for U =1:vg.ess
    		[a,MM(U)] =min(dtchnl.Dato.(N)(1:hdchnl.nsmpls(lecanal,U),U)); % on cherche l'index du min
    	end
    %-----
    case 3  % Maximum du canal
    	Ofich.getcanal(dtchnl, lecanal);
    	N =dtchnl.Nom;
    	for U =1:vg.ess
    		[a,MM(U)] =max(dtchnl.Dato.(N)(1:hdchnl.nsmpls(lecanal,U),U)); % on cherche l'index du max
    	end
    end
    if size(MM,1) > size(MM,2)
    	MM =MM';  %'
    end
    tavant =round(avant * hdchnl.rate);
    tapres =round(apres * hdchnl.rate);
    temps =tavant + tapres;
    ttest = max(temps(:));
    aa = zeros(1, vg.ess);
    waitbar(0.1, hWb);
    Wtot =vg.nad*vg.ess;
    fcut =round(hdchnl.frontcut .* hdchnl.rate);
    MM =(MM+fcut(lecanal, :))./hdchnl.rate(lecanal,:); % temps en secondes des pts de synchro
    for U =1:vg.nad
    	Ofich.getcanal(dtchnl, U);
    	N =dtchnl.Nom;
    	aa(:) =0;
    	matpts =round((MM.*hdchnl.rate(U,:))-fcut(U, :));
      ss =find(matpts(1,:) < tavant(U,:));
      if length(ss)
        aa(ss) =1;
      end
      ss =find(hdchnl.nsmpls(U,:) < (matpts(1,:)+tapres(U,:)));
      if length(ss)
        aa(ss) =aa(ss)+2;
      end
      ss =find((hdchnl.nsmpls(U,:) < matpts(1,:)));
      if length(ss)
        aa(ss) =4;
      end
      ss =find(fcut(U,:) > matpts(1,:));
      if length(ss)
        aa(ss) =5;
      end
      ss =find((hdchnl.nsmpls(U,:) <= matpts(1,:)-tavant(U,:)) | (fcut(U,:) >= matpts(1,:)+tapres(U,:)));
      if length(ss)
        aa(ss) =6;
      end
      coupe =int32(matpts(1,:)-tavant(U,:));
    	for V =1:vg.ess
    		tropcourt =false;
    		loffset =1;      % offset dans la matrice de sortie
        switch(aa(V))
        case 0
          debut =matpts(1,V)-tavant(U,V)+1;
          lafin =matpts(1,V)+tapres(U,V);
        case 1  % il manque des smpl à gauche
          loffset =tavant(U,V)-matpts(1,V)+1;
          debut =1;
          lafin =matpts(1,V)+tapres(U,V);
        case 2  % il manque des smpl à droite
          debut =matpts(1,V)-tavant(U,V)+1;
          lafin =hdchnl.nsmpls(U,V);
        case 3  % il manque des smpl à gauche et à droite
          loffset =tavant(U,V)-matpts(1,V)+1;
          debut =1;
          lafin =hdchnl.nsmpls(U,V);
        case 4  % (hdchnl.nsmpls(U,:) < matpts(1,:))
          if fcut(U,V) > matpts(1,V)-tavant(U,V)
            loffset =fcut(U, V)-(matpts(1,V)-tavant(U,V))+1;
            debut =1;
          else
            debut =matpts(1,V)-tavant(U,V)+1;
          end
          lafin =hdchnl.nsmpls(U,V);
        case 5  % (fcut(U,:) > matpts(1,:))
          if hdchnl.nsmpls(U,V) > matpts(1,V)+tapres(U,V)
            lafin =matpts(1,V)-tapres(U,V);
          else
            lafin =hdchnl.nsmpls(U,V);
          end
          loffset =temps(U, V)-(matpts(1,V)+tapres(U,V)-fcut(U,V))+1;
          debut =1;
        case 6  % On a pas d'échantillon dans la zone recherchée
        	tropcourt =true;
        end
        if tropcourt
          dtchnl.Dato.(N)(1:temps(U,V),V) =0;
          hdchnl.max(U,V) =0;
          hdchnl.min(U,V) =0;
          for k =1:hdchnl.npoints(U,V)
            ptchnl.PointBidon(V, U, k);
          end
        else
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
              ptchnl.PointBidon(V, U, k);
            end
          end
        end
        waitbar((((U-1)*vg.ess)+V)/Wtot*.85+.1, hWb);
    	end
      if size(dtchnl.Dato.(N),1) > ttest
        dtchnl.Dato.(N)(ttest+1:end,:) =[];
      end
      Ofich.setcanal(dtchnl);
      hdchnl.nsmpls(U,:) =temps(U,:);
      hdchnl.sweeptime(U,:) =(temps(U,:) ./ hdchnl.rate(U,:));
    end
    waitbar(0.99, hWb);
    hdchnl.frontcut(1:vg.nad,1:vg.ess) =0;
    ppp =findobj('tag','FigureSynchro');
    delete(ppp);
    delete(dtchnl);
    delete(hWb);
    vg.sauve =1;
    OA.OFig.affiche();
  %--------------
  case 'fermer'
    ppp =findobj('tag','FigureSynchro');
    delete(ppp);
  end
end

function V =testPoint(P)
  V =str2double(P);
  if isnan(V) & strncmpi(P, 'p', 1)
    V =str2double(P(2:end));
  end
end