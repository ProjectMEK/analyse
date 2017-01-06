function EMGZero(varargin)
%
% CHANGEMENT DE POLARITE
%
% Laboratoire GRAME
% Mai 2000, juillet 2002, novembre 2010
%
% Fonction qui comptabilise le nombre de fois où la courbe traverse l'axe des "0"
% sur un intervalle déterminé; calculs qui peuvent se répéter sur des intervalles
% successifs; les résultats sont sauvegardés dans un fichier texte.
% L'algorithme utilise comme condition, le changement de signe de la pente entre 2 
% échantillons.
% Les paramètres demandés sont: le choix des canaux, l'intervalle de calcul,
% le nombre de fois où on fait répéter le calcul sur des intervalles 
% successifs (maximum de 10), et le séparateur (espace, virgule,...) pour la 
% sauvegarde dans le fichier texte.
%
% Mars 2009
% Modification dans l'algorythme pour détecter les changement de polarité
% maintenant on "annule les zéros" avec la valeur précédente...
%
% ***Avis à ceux qui veulent suivre la démarche ou faire des corrections***
%
% Afin d'optimiser en vitesse la routine, les mêmes variables seront ré-utilisées
% plutôt que de créer de nouvelles et abandonner les vieilles.
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
    vg.valeur = 1;
    if vg.nad > 2; letop =vg.nad; else letop =vg.nad+1; end
    dep ={'temps en seconde'; 'Point marqué'};
    largeur =320; hauteur =465;
    lapos =positionfen('gauche','centre',largeur,hauteur);
    separa ={'virgule';'point virgule';'Tab'};
    fig =figure('Name', 'CHANGEMENT DE POLARITÉ', 'Position',lapos, 'Resize', 'off', ...
                'CloseRequestFcn','EMGZero(''fermer'')',...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','pixels', 'DefaultUIControlFontSize',11);		
    margx =20; posx =margx; haut =25; margy=20; posy =hauteur-margy-haut; large =largeur-(2*posx);
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'String','Choix des canaux:', 'Style','text');
    large =250; posx =round((largeur-large)/2); haut =100; posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixCanaux', 'Style','listbox', 'BackgroundColor',[1 1 1], ...
              'Position',[posx posy large haut], 'Callback', 'EMGZero(''chcanal'')',...
              'String',hdchnl.Listadname, 'Min',1,  'Max',letop, 'Value',1);
    haut =25; posy =posy-2*haut; large =round(largeur/2); posx =round((largeur-large)/2);
    uicontrol('Parent',fig, 'Position',[posx posy large haut-5], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix de Début/Fin');
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixDebutFin', 'Position',[posx posy large haut], ...
              'Style','popupmenu', 'String',dep, 'Callback','EMGZero(''Ptsextremites'')', 'Value',1);
    posy =round(posy-1.75*haut); large =round(largeur/6); posx =round(largeur/4);
    uicontrol('Parent',fig, 'tag','TempsDebut', 'style', 'edit', ...
              'position', [posx posy large haut], 'string', '0.01');
    uicontrol('Parent',fig, 'tag','PointDebut', 'BackgroundColor',[1 1 1], 'visible','off', ...
              'Position',[posx posy large haut], 'Style','popupmenu', 'String','...', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Début', 'FontSize',10);
    posx =round(largeur*0.75)-large;
    uicontrol('Parent',fig, 'tag','TempsFin', 'style', 'edit', 'position', [posx posy large haut], 'string', '5');
    uicontrol('Parent',fig, 'tag','PointFin', 'BackgroundColor',[1 1 1], 'Style','popupmenu', ...
              'Position',[posx posy large haut], 'String','...', 'visible','off', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'String','Fin', 'FontSize',10);
    posy =posy-3*haut; posx =margx; Edx =40; large =largeur-2*margx-Edx;
    uicontrol('Parent',fig, 'Style','text', 'Position',[posx posy large haut], ...
              'HorizontalAlignment','right', 'String','Nombre de périodes desirees:');
    uicontrol('Parent',fig, 'Tag','NbPeriodes', 'style', 'edit', 'position', [posx+large posy Edx haut], 'string', '1');
    posy =round(posy-1.4*haut); Edx =100; large =large-Edx;
    uicontrol('Parent',fig, 'Style','text', 'Position',[posx posy large haut], ...
              'HorizontalAlignment','right', 'String','Separateur:');
    uicontrol('Parent',fig, 'Tag','Separateur', 'Style','popupmenu', 'String',separa, ...
              'Position',[posx+large posy Edx haut], 'Value',1);
    large =100; posx =round((largeur-large)/2); posy =posy-2*haut;
    uicontrol('Parent',fig, 'Callback','EMGZero(''travail'')', 'Position',[posx posy large haut], 'String','au travail');
    set(fig,'WindowStyle','modal');
  %-------------
  case 'chcanal'
    ptdepa =get(findobj('tag','ChoixDebutFin'),'Value');
      %
      if ptdepa == 2
        canaux =get(findobj('tag','ChoixCanaux'),'Value')';  %'
        liste ={'...'};
        nptm =min(min(hdchnl.npoints(canaux,:)));
        d =get(findobj('tag','PointDebut'),'Value');
        f =get(findobj('tag','PointFin'),'Value');
        if nptm
          for l =1:nptm
            liste(end+1) ={['n°',num2str(l)]};
          end
          if d-1 > nptm; d =1; end;
          if f-1 > nptm; f =1; end;
        else
          d =1;
          f =1;
        end
        set(findobj('tag','PointDebut'),'String', liste, 'value', d);
        set(findobj('tag','PointFin'),'String', liste, 'value', f);
      end
      %
  %-------------------
  case 'Ptsextremites'                                   		   %pts dep et fin
    pts =get(findobj('tag','ChoixDebutFin'),'Value');      	   %pts=1 : ech qcq
    %----------
    switch(pts)
    %-----
    case 1
      set(findobj('tag','PointDebut'), 'Visible', 'off');
      set(findobj('tag','TempsDebut'), 'Visible', 'on');
      set(findobj('tag','PointFin'), 'Visible', 'off');
      set(findobj('tag','TempsFin'), 'Visible', 'on');
    %-----
    case 2
      canaux =get(findobj('tag','ChoixCanaux'),'Value')';  %'
      liste ={'...'};
      nptm =min(min(hdchnl.npoints(canaux,:)));
      for l =1:nptm
        liste(end+1) ={['n°',num2str(l)]};
      end
      set(findobj('tag','TempsDebut'), 'Visible', 'off');
      set(findobj('tag','PointDebut'), 'Visible', 'on', 'String', liste);
      set(findobj('tag','TempsFin'), 'Visible', 'off');
      set(findobj('tag','PointFin'), 'Visible', 'on', 'String', liste);
    end
    vg.valeur =pts;
  %-------------
  case 'travail'
    [nomfich,lieu] =uiputfile('*.*','Polarité');
    if length(nomfich) == 1 && nomfich == 0
      return;
    end
    canaux =get(findobj('tag','ChoixCanaux'),'Value')'; %'
    nombre =length(canaux);
    pts =get(findobj('tag','ChoixDebutFin'),'Value');   % 1=choix du temps,  2=choix des points marqués
    succ =str2double(get(findobj('Tag','NbPeriodes'),'String'));
    pcourant =pwd;
    stimu ='Catégorie';
    saut =[char(13), char(10)];
    sep =get(findobj('Tag','Separateur'),'Value');
    Arsep =[',;' char(9)];
    tab =Arsep(sep);
    nom_ess =vg.lesess;
    % Création des entêtes
    for i =1:nombre
      if i == 1
        nbzr =['Canal-1',tab,'Delta t',tab,'nbzros1'];
      else
        nbzr =[nbzr,tab,'Canal-',num2str(i),tab,'Delta t',tab,'nbzros1'];
      end
      for n =2:succ
        nbzr =[nbzr,tab,'nbzros',num2str(n)];
      end
    end
    %----------
    switch(pts)                                               	   
    %----------
    case 1         %pts de debut et fin en seconde     			
      deltat = zeros(nombre,vg.ess,'single');
      deb = str2double(get(findobj('tag','TempsDebut'),'String'));	%val du pt de dep
      fin = str2double(get(findobj('tag','TempsFin'),'String'));   	%val du pt final
      if deb > fin
        pp =deb; deb =fin; fin =pp;
      elseif deb == fin
        disp('Revoyez le choix de vos points???');
        return;
      end
      Dt =CDtchnl();
      for ncan =1:nombre
        Ofich.getcanal(Dt, canaux(ncan));
        nsmpls =max(hdchnl.nsmpls(canaux(ncan),:));
        letmp(1:nsmpls, 1:vg.ess, ncan) =sign(Dt.Dato.(Dt.Nom)(1:nsmpls,1:vg.ess));
        for V =1:vg.ess
          fs =hdchnl.rate(canaux(ncan), V);
          fcut =hdchnl.frontcut(canaux(ncan), V);
          fdeb =max(1/fs, deb-fcut);
          tdeb =floor(fdeb * fs);
          tfin =min(floor((fin-fcut) * fs), hdchnl.nsmpls(canaux(ncan),V));
          window =floor((tfin-tdeb+1)/succ);
          tfin =tdeb+(window*succ);
          a =tdeb;
          b =a+window-1;
          deltat(ncan,V) =round(100 *(tfin-tdeb)/fs)/100;   %en sec.
          for n =1:succ
          	if letmp(a, V, ncan) == 0
          		tt =find(letmp(a:b, V, ncan) ~= 0);
          		if isempty(tt)
          			letmp(a:b, V, ncan) =1;                    % il n'y avait que des zéros
          		else
          			letmp(a, V, ncan) =letmp(tt(1)+a-1, V, ncan);
          		end
          	end
          	tt =find(letmp(a:b, V, ncan) == 0);
            for H =1:length(tt)
              letmp(tt(H)+a-1, V, ncan) =letmp(tt(H)+a-2, V, ncan);
            end
            letmp(n, V, ncan) =length( find(letmp(a:b-1, V, ncan).*letmp(a+1:b, V, ncan) == -1) );
            a =a+window;
            b =b+window;
          end
        end
      end
    %------
    case 2				% pts dep et fin de PTCHNL					
      pd =get(findobj('tag','PointDebut'),'Value');   	%num pt dep
      pf =get(findobj('tag','PointFin'),'Value');   	%num pt fin
      if pd == 1 || pf == 1 || pd == pf
        disp('Revoyez le choix de vos points???');
        return;
      elseif pd > pf
        pp =pd; pd =pf; pf =pp;
      end
      ttest =Ofich.assezpt(canaux,[pd-1 pf-1]);
      if ttest
        return;
      end
      deltat =zeros(nombre,vg.ess, 'single');
      ptchnl =Ofich.Ptchnl;
      Dt =CDtchnl();
      for ncan =1:nombre
        Ofich.getcanal(Dt, canaux(ncan));
        nsmpls =max(hdchnl.nsmpls(canaux(ncan),:));
        letmp(1:nsmpls, 1:vg.ess, ncan) =sign(Dt.Dato.(Dt.Nom)(1:nsmpls,1:vg.ess));
        for V =1:vg.ess
          fs =hdchnl.rate(canaux(ncan),V);
          tdeb =floor(ptchnl.Dato((pd-1),hdchnl.point(canaux(ncan),V),1));
          tfin =floor(ptchnl.Dato((pf-1),hdchnl.point(canaux(ncan),V),1));
          window =floor((tfin-tdeb+1)/succ);
          tfin =tdeb+(window*succ);
          a =tdeb;
          b =a+window-1;
          deltat(ncan,V) =round(100*(tfin-tdeb)/fs)/100;
          for n =1:succ
          	if letmp(a, V, ncan) == 0
          		tt =find(letmp(a:b, V, ncan) ~= 0);
          		if isempty(tt)
          			letmp(a:b, V, ncan) =1;                    % il n'y avait que des zéros
          		else
          			letmp(a, V, ncan) =letmp(tt(1)+a-1, V, ncan);
          		end
          	end
          	tt =find(letmp(a:b, V, ncan) == 0);
            for H =1:length(tt)
              letmp(tt(H)+a-1, V, ncan) =letmp(tt(H)+a-2, V, ncan);
            end
            letmp(n, V, ncan) =length( find(letmp(a:b-1, V, ncan).*letmp(a+1:b, V, ncan) == -1) );
            a =a+window;
            b =b+window;
          end
        end
      end
    end			% end du switch sur les pts de dep et fin	
    delete(Dt);
    cd(lieu);
    fileident =fopen(nomfich,'w');
    entete =strcat(['Essai',tab,stimu,tab,nbzr]);
    contenu =[entete saut];
    fprintf(fileident,'%s',contenu);
    for j =1:vg.ess
      mot =nom_ess{j};
    	if isempty(vg.nomstim) && length(vg.nomstim) >= hdchnl.numstim(j)
        stimu =vg.nomstim(hdchnl.numstim(j));
      else
        stimu =[];
      end
      contenu =[num2str(j),tab,stimu];
      for ncan =1:nombre
        cana =hdchnl.adname{canaux(ncan)};
        contenu =strcat(contenu,tab,cana,tab,num2str(deltat(ncan,j)));
        for k =1:succ
          contenu =strcat(contenu,tab,num2str(letmp(k, j, ncan)));
        end
      end
      fprintf(fileident,'%s',[contenu saut]);
    end
    fclose(fileident);
    delete(gcf);
    cd(pcourant);
  %------------
  case 'fermer'
    delete(gcf);
  %--
  end
end
