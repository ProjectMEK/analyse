function EMGRms(varargin)
%
% RMS (Root Mean Square)
%
% Laboratoire GRAME
% Avril 2000, octobre 2010
%
% Fonction qui retourne les valeurs RMS d'une courbe en fonction du temps.
%
% Le programme utilise un algorithme de "fenêtres glissantes" (fait le
% calcul du RMS sur chaque fenêtre qui se décalle en fonction de l'overlap
% choisi, l'overlap étant le chevauchement de 2 fenêtres consécutives).
% Les paramètres à choisir sont donc: le choix des canaux, le point de départ, 
% la largeur de la fenêtre et la largeur de l'overlap.
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
    if vg.nad > 2, letop =vg.nad; else, letop =vg.nad+1; end
    dep ={'Numéro d''échantillon: '; 'Point marque: '};
    largeur =300; hauteur=450;
    lapos =positionfen('G','C',largeur, hauteur);
    fig =figure('Name', 'RMS (Root Mean Square)', 'Position',lapos, ...
                'CloseRequestFcn','EMGRms(''fermer'')',...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','pixels',...
                'DefaultUIControlFontSize',11, 'Resize', 'off');
    mx =50; hbout =25;
    posx =mx; large =largeur-2*mx; my =15; haut =hbout; posy =hauteur-haut-my; mmy =10;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'String','Choix des canaux:', ...
              'HorizontalAlignment','center', 'Style','text');
    haut =200; posy =posy-haut;
    uicontrol('Parent',fig, 'tag','NomCanaux', 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut], ...
              'String',hdchnl.Listadname, 'Callback','EMGRms(''chcanal'')', ...
              'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    px1 =35; px2 =220; posx =px1; haut =hbout; posy =posy-haut-my; larged =40; large =largeur-larged-2*px1;
    uicontrol('Parent',fig, 'tag','TxtPtDepart', 'HorizontalAlignment','Center', 'Style','text', ...
              'Position',[posx posy large+larged haut], 'String','Échantillon/Point de depart');
    posy =posy-haut; corrx =20;
    uicontrol('Parent',fig, 'tag','ChoixPtDepart', 'Position',[posx posy large-corrx haut], 'String',dep, ...
              'Callback','EMGRms(''Pointdepart'')', 'Style','popupmenu', 'Value',1);
    uicontrol('Parent',fig, 'tag','Edit01', 'Style', 'edit', 'Position', [posx+large posy larged haut], 'String', '1');
    liste = '...';
    uicontrol('Parent',fig, 'tag','ChoixDuPoint', 'BackgroundColor',[1 1 1], 'String',liste, ...
              'Position',[posx+large-corrx posy larged+corrx haut], 'Visible','Off', 'Min',1, 'Style','popupmenu', 'Value',1);
    posy =posy-haut-mmy;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'String','Largeur de la fenetre: ', ...
              'HorizontalAlignment','Right', 'Style','text');
    uicontrol('Parent',fig, 'tag','Edit02', 'Style', 'edit', 'Position', [posx+large posy larged haut], 'String', '100');
    posy =posy-haut-mmy;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'String','Largeur de l´overlap: ', ...
              'HorizontalAlignment','Right', 'Style','text');
    uicontrol('Parent',fig, 'tag','Edit03', 'Style', 'edit', 'Position', [posx+large posy larged haut], 'String', '50');
    large =90; posx =round((largeur-large)/2);
    uicontrol('Parent',fig, 'Callback','EMGRms(''travail'')', 'Position',[posx haut large haut], 'String','Au travail');
    set(fig,'WindowStyle','modal');
  %-------------
  case 'chcanal'
    ptdepa =get(findobj('tag','ChoixPtDepart'),'Value');
      if ptdepa == 2
        laval =get(findobj('tag','ChoixDuPoint'),'value');
        canaux =get(findobj('tag','NomCanaux'), 'Value')';  %'
        liste ={'...'};
        nptm =min([hdchnl(canaux,:).npoints]);
        for l =1:nptm
          liste{end+1} =['n° ' num2str(l)];
        end
        if laval > nptm+1
          laval =1;
        end
        set(findobj('tag','ChoixDuPoint'), 'String',liste, 'value',laval);
      end
      %
  %-----------------
  case 'Pointdepart'
    ptdepa = get(findobj('tag','ChoixPtDepart'), 'Value');
    %-------------
    switch(ptdepa)
    %-----
    case 1                                                      	
      set(findobj('tag','ChoixDuPoint'), 'Visible','Off');
      set(findobj('tag','Edit01'), 'Visible', 'On');
    %-----
    case 2
      set(findobj('tag','Edit01'),'Visible','Off');
      canaux =get(findobj('tag','NomCanaux'), 'Value')';  %'
      liste ={'...'};																%
      nptm =min(hdchnl.npoints(canaux,:));
      for l =1:nptm																%
      liste{end+1} =['n° ' num2str(l)];					%
      end  																			%	
      set(findobj('tag','ChoixDuPoint'), 'String',liste, 'Visible','On');
    end
    %
    vg.valeur = ptdepa;
  %-------------
  case 'travail'
    Wb =waitbar(0, 'Travail en cours...');
    canaux =get(findobj('tag','NomCanaux'), 'Value')';  %'
    nombre =length(canaux);
    window =str2double(get(findobj('tag','Edit02'),'String'));
    overlap =str2double(get(findobj('tag','Edit03'),'String'));
    if isempty(overlap)
      overlap =0;
    end
    if window <= overlap
      uicontrol(findobj('tag','Edit02'));
      return;
    end
    %---------------------------------
    % On ajoute les canaux nécessaires
    hdchnl.duplic(canaux);
    Dti =CDtchnl();
    Dtf =CDtchnl();
    ptdepa =get(findobj('tag','ChoixPtDepart'), 'Value');
    %-------------
    switch(ptdepa)
    %-----
    case 1    % pt de départ choisi par l'utilisateur
      ptdep =str2double(get(findobj('tag','Edit01'),'String'));
      for ncan =1:nombre
      	vg.nad =vg.nad+1;
      	Ofich.getcanal(Dti, canaux(ncan));
      	Dtf.cloneThat(Dti);                             % Idem à:  Dti.cloneThis(Dtf)
      	Dti.Dato.(Dti.Nom)(:) =Dtf.Dato.(Dtf.Nom)(:).^2;
      	if min(hdchnl.nsmpls(vg.nad,:)) == max(hdchnl.nsmpls(vg.nad,:))
      	  % si on a tous le m^ nb d'échantillon
          nbdon =hdchnl.nsmpls(vg.nad,1);
          if overlap
            nbfen =floor((nbdon-ptdep+1-window)/(window-overlap))+1;
          else
            nbfen =floor((nbdon-ptdep+1)/window);
          end
          total =nombre*nbfen;
          tmp =(ncan-1)*nbfen;
          a =ptdep;
          for n =1:nbfen
            b =a+window-1;
            Dtf.Dato.(Dtf.Nom)(n, :) =sqrt(mean(Dti.Dato.(Dti.Nom)(a:b, :),1) );
            a =a+window-overlap;
            tmp =tmp+1;
            waitbar(tmp/total, Wb);
          end
          ind =hdchnl.rate(canaux(ncan),1);
          hdchnl.sweeptime(vg.nad,:) =(nbdon-ptdep)/ind;
          hdchnl.nsmpls(vg.nad,:) =nbfen;
          hdchnl.rate(vg.nad,:) = ((nbfen)*ind)/(nbdon-ptdep);
          hdchnl.frontcut(vg.nad, :) =hdchnl.frontcut(vg.nad, :)+(ptdep/ind);
          hdchnl.max(vg.nad, :) =max(Dtf.Dato.(Dtf.Nom)(1:nbfen, :));
          hdchnl.min(vg.nad, :) =min(Dtf.Dato.(Dtf.Nom)(1:nbfen, :));
          for j =1:vg.ess
            hdchnl.comment{vg.nad, j} =['RMS.' num2str(window) '-' num2str(overlap) '//' hdchnl.comment{vg.nad, j}];
          end
      	else
          for j = 1:vg.ess
            nbdon =hdchnl.nsmpls(vg.nad, j);
            if overlap
              nbfen =floor((nbdon-ptdep+1-window)/(window-overlap))+1;
            else
              nbfen =floor((nbdon-ptdep+1)/window);
            end
            total =nombre*vg.ess*nbfen;
            tmp =(ncan-1)*vg.ess*nbfen+j-1;
            a =ptdep;
            for n =1:nbfen
              b =a+window-1;
              Dtf.Dato.(Dtf.Nom)(n, j) =sqrt(mean(Dti.Dato.(Dti.Nom)(a:b, j),1) );
              a =a+window-overlap;
              tmp =tmp+1;
              waitbar(tmp/total, Wb);
            end
            ind =hdchnl.rate(canaux(ncan),j);
            hdchnl.sweeptime(vg.nad, j)=(nbdon-ptdep)/ind;
            hdchnl.nsmpls(vg.nad, j) =nbfen;
            hdchnl.rate(vg.nad, j) =((nbfen)*ind)/(nbdon-ptdep);
            hdchnl.frontcut(vg.nad, j) =hdchnl.frontcut(vg.nad, j)+(ptdep/ind);
            hdchnl.max(vg.nad, j) =max(Dtf.Dato.(Dtf.Nom)(1:nbfen, j));
            hdchnl.min(vg.nad, j) =min(Dtf.Dato.(Dtf.Nom)(1:nbfen, j));
            hdchnl.comment{vg.nad, j} =['RMS-' num2str(window) '-' num2str(overlap) '//' hdchnl.comment{vg.nad, j}];
          end
        end
        Ofich.setcanal(Dtf, vg.nad);
        hdchnl.adname{vg.nad} =['RMS(' hdchnl.adname{vg.nad} ')'];
      end
    %-----
    case 2   %pt deja marque
      ptchnl =Ofich.Ptchnl;
      pdp =get(findobj('tag','ChoixDuPoint'), 'Value')-1;
      if pdp == 0
        disp('Il faut choisir un point');
        return;
      else
        ttest =Ofich.assezpt(canaux,pdp);
        if ttest
          return;
        end
      end
      for ncan =1:nombre
        vg.nad =vg.nad+1;
      	Ofich.getcanal(Dti, canaux(ncan));
      	Dtf.cloneThat(Dti);
      	Dti.Dato.(Dti.Nom)(:) =Dtf.Dato.(Dtf.Nom)(:).^2;
        for j =1:vg.ess
          ptdep =ptchnl.Dato(pdp,hdchnl.point(canaux(ncan),j),1);
          nbdon =hdchnl.nsmpls(vg.nad,j);
          if overlap
            nbfen =floor((nbdon-ptdep+1-window)/(window-overlap))+1;
          else
            nbfen =floor((nbdon-ptdep+1)/window);
          end
          total =nombre*vg.ess*nbfen;
          tmp =(ncan-1)*vg.ess*nbfen+j-1;
          a =ptdep;
          for n =1:nbfen
            b =a+window-1;
            Dtf.Dato.(Dtf.Nom)(n, j) =sqrt(mean(Dti.Dato.(Dti.Nom)(a:b, j),1) );
            a =a+window-overlap;
            tmp =tmp+1;
            waitbar(tmp/total, Wb);
          end
          ind =hdchnl.rate(vg.nad,j);
          hdchnl.sweeptime(vg.nad,j) =(nbdon-ptdep)/ind;
          hdchnl.comment{vg.nad, j} =['RMS-' num2str(window) '-' num2str(overlap) '//' hdchnl.comment{vg.nad, j}];
          hdchnl.frontcut(vg.nad,j) =hdchnl.frontcut(vg.nad,j)+(ptdep/ind);
          hdchnl.nsmpls(vg.nad,j) =nbfen;
          hdchnl.rate(vg.nad,j) =((nbfen)*ind)/(nbdon-ptdep);
          hdchnl.max(vg.nad, j) =max(Dtf.Dato.(Dtf.Nom)(1:nbfen, j));
          hdchnl.min(vg.nad, j) =min(Dtf.Dato.(Dtf.Nom)(1:nbfen, j));
        end
        Ofich.setcanal(Dtf, vg.nad);
        hdchnl.adname{vg.nad} =['RMS(' deblank(hdchnl.adname{vg.nad}) ')'];
      end  %for ncan =1:nombre
    end  %switch(ptdepa)
    delete(Dti);
    delete(Dtf);
    delete(Wb);
    delete(gcf);
    vg.sauve = 1;																%etat de sauvegar du doc.
    gaglobal('editnom');
  %--------------
  case 'fermer'															   	%Si on choisit l'abandon
    delete(gcf);												   		%   efface le menu
  end
end
