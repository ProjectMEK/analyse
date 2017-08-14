function varargout =choixfichier(varargin)
  if nargout
    for ii=1:nargout
      varargout{ii}=0;
    end
  end
  if nargin == 0
    return;
  else
    elmando = varargin{1};
  end
  switch elmando
  %--------------------
  case 'BGuiFichEntree'
    % INTERFACE CHOIX FICHIERS D'ENTRÉES
    intx =10; inty =15; bouty =25; boutx =75;
    lapos =varargin{4};
    posx =lapos(1); largeur =lapos(3);
    fig =varargin{2};
    ss =varargin{3};
    latache =get(fig,'UserData');
    mx =15;lbox1 =80;winx =largeur-posx-2*mx-boutx-intx;
    posx =posx+mx;large =winx;haut =bouty;posy =lapos(2)-2*haut;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], ...
              'HorizontalAlignment','Center', 'Style','text',...
              'String','Fichiers à Traiter');
    haut =lbox1; posy =posy-haut;
    if ss.tacfic
      lalist =choixliste('BTypeEntreeSi');
      choix =ss.ChoixEntree;
      lesnoms =ss.ListeFentree;
    elseif latache > 1
      lalist =choixliste('BTypeEntree');
      choix =ss.tach(latache).ChoixEntree;
      lesnoms =ss.tach(latache).ListeFentree;
      if choix == 4
        elno =latache+1;
        for ii=1:latache-1
          if ss.tach(latache).FichierLien == ss.tach(ii).elno
            elno =ii;
          end
        end
        if elno > latache
          lesnoms ='Refaites votre choix';
        end
      end
    else
      lalist =choixliste('BTypeEntreeSi');
      choix =ss.tach(latache).ChoixEntree;
      if choix == 4
        choix =1;
        lesnoms ='Refaites votre choix';
      else
        lesnoms =ss.tach(latache).ListeFentree;
      end
    end
    uicontrol('Parent',fig, 'Tag','FichierEntree',...
              'BackgroundColor',[1 1 1], 'Callback','choixfichier(''fichierentree'')',...
              'Position',[posx posy large haut], 'Style','listbox', ...
              'String',lalist, 'max',1, 'Value',choix);
    posx =posx+large+intx; haut =bouty;
    uicontrol('Parent',fig, 'Callback','choixfichier(''btfichierentree'')', ...
              'Position',[posx posy boutx haut], 'String','Choisir');
    posx =mx; posy =posy - haut;
    uicontrol('Parent',fig, 'Tag','VoirFichierEntree',...
              'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
              'Style','popupmenu', 'String',lesnoms, 'Value',1);
    varargout{1} =posy;
  %---------------------
  case 'BGuiFichSortie'
    % INTERFACE CHOIX FICHIERS DE SORTIES
    lapos =varargin{4};
    posx =lapos(1); largeur =lapos(3);
    mx =15;intx =10; inty =15; bouty =25; boutx =75;
    lbox3 =80; winx =largeur-posx-2*mx-boutx-intx;
    fig =varargin{2};
    ss =varargin{3};
    latache =get(fig,'UserData');
    posx =posx+mx; large =winx;haut =bouty;posy =lapos(2)-bouty-haut;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], ...
              'HorizontalAlignment','Center', 'Style','text',...
              'String','Sauvegarde des résultats');
    haut =lbox3;posy =posy-haut;
    lalist =choixliste('BTypeSortie');
    if ss.tacfic
      choix =ss.ChoixSortie;
      lesnoms =ss.ListeFsortie;
    else
      choix =ss.tach(latache).ChoixSortie;
      lesnoms =ss.tach(latache).ListeFsortie;
    end
    uicontrol('Parent',fig, 'Tag','FichierSortie',...
              'BackgroundColor',[1 1 1], 'Callback','choixfichier(''fichiersortie'')',...
              'Position',[posx posy large haut], 'Style','listbox', ...
              'String',lalist, 'Value',choix);
    posx =posx+large+intx; large =boutx;haut =bouty;
    uicontrol('Parent',fig, 'Callback','choixfichier(''btfichiersortie'')', ...
              'Position',[posx posy large haut], 'String','Paramètres');
    posx =mx; posy =posy - haut; large =winx;
    uicontrol('Parent',fig, 'Tag','VoirFichierSortie',...
              'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
              'Style','popupmenu', 'String',lesnoms, 'Value',1);
    varargout{1} =posy;  
  %-------------------
  case 'fichierentree'
    lafig =findobj('tag','IpProp');
    if strcmp(get(lafig,'SelectionType'), 'open')
      hh =guidata(lafig);
      if hh.tacfic
        hh.ChoixEntree =get(findobj('Tag','FichierEntree'),'value');
      else
        latache =get(lafig,'UserData');
        hh.tach(latache).ChoixEntree =get(findobj('Tag','FichierEntree'),'value');
      end
      hh =choixfichier('BEntree',hh);
      guidata(lafig,hh);
    end
  %---------------------
  case 'btfichierentree'
    lafig =findobj('tag','IpProp');
    hh =guidata(lafig);
    if hh.tacfic
      hh.ChoixEntree =get(findobj('Tag','FichierEntree'),'value');
    else
      latache =get(lafig,'UserData');
      hh.tach(latache).ChoixEntree =get(findobj('Tag','FichierEntree'),'value');
    end
    hh =choixfichier('BEntree',hh);
    guidata(lafig,hh);
  %-------------------
  case 'fichiersortie'
    lafig =findobj('tag','IpProp');
    if strcmp(get(lafig,'SelectionType'), 'open')
      hh =guidata(lafig);
      if hh.tacfic
        hh.ChoixSortie =get(findobj('Tag','FichierSortie'),'value');
      else
        latache =get(lafig,'UserData');
        hh.tach(latache).ChoixSortie =get(findobj('Tag','FichierSortie'),'value');
      end
      hh =choixfichier('BSortie',hh);
      guidata(lafig,hh);
    end
  %---------------------
  case 'btfichiersortie'
    lafig =findobj('tag','IpProp');
    hh =guidata(lafig);
    if hh.tacfic
      hh.ChoixSortie =get(findobj('Tag','FichierSortie'),'value');
    else
      latache =get(lafig,'UserData');
      hh.tach(latache).ChoixSortie =get(findobj('Tag','FichierSortie'),'value');
    end
    hh =choixfichier('BSortie',hh);
    guidata(lafig,hh);
  %-------------
  case 'BEntree'
    %
    % Pré-Traitement du choix des fichiers en entrée (BATCH)
    % 1-par fichiers, 2-contenu d'un dossier, 3-contenu d'un dossier+sous-dossiers
    %
    pp =varargin{2};
    if pp.tacfic
      cd(pp.PathEntree);
      if pp.ChoixEntree == 1
        [fname, pname] =uigetfile({'*.*', 'Tous les fichiers'}, 'Fichiers à Traiter','MultiSelect','on');
        if isequal(fname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.PathEntree =pname;
        if iscell(fname)
          pp.ListeFentree =sort(fname);
        else
          pp.ListeFentree ={fname};
        end
        pp.isFichierIn =1;
        set(findobj('Tag','VoirFichierEntree'),'string',pp.ListeFentree,'value',1);
      else
        pname =uigetdir(pp.PathEntree,'PATH des fichiers à Traiter');
        if isequal(pname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.PathEntree =pname;
        pp.ListeFentree ={pname};
        pp.isFichierIn =1;
        set(findobj('Tag','VoirFichierEntree'),'string',pp.PathEntree,'value',1);
      end
    else
      latache =get(findobj('tag','IpProp'),'UserData');
      cd(pp.tach(latache).PathEntree);
      switch pp.tach(latache).ChoixEntree
      %-----
      case 1
        [fname, pname] =uigetfile({'*.*', 'Tous les fichiers'}, 'Fichiers à Traiter','MultiSelect','on');
        if isequal(fname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.tach(latache).PathEntree =pname;
        if iscell(fname)
          pp.tach(latache).ListeFentree =sort(fname);
        else
          pp.tach(latache).ListeFentree ={fname};
        end
        pp.tach(latache).isFichierIn =1;
        set(findobj('Tag','VoirFichierEntree'),'string',pp.tach(latache).ListeFentree,'value',1);
      %----------
      case {2, 3}
        pname =uigetdir(pp.tach(latache).PathEntree,'PATH des fichiers à Traiter');
        if isequal(pname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.tach(latache).PathEntree =pname;
        pp.tach(latache).ListeFentree ={pname};
        pp.tach(latache).isFichierIn =1;
        set(findobj('Tag','VoirFichierEntree'),'string',pp.tach(latache).PathEntree,'value',1);
      %-----
      case 4
        if latache > 1
          elno =1;
          for ii =1:latache-1
            laliste{ii} =pp.tach(ii).descr;
            if pp.tach(ii).elno == pp.tach(latache).FichierLien
              elno =ii;
            end
          end
          posx =25;posy =50;largeur =450;hauteur =150;
          fig =figure('Name',pp.tach(latache).descr,'tag', 'IpLien',...
                      'Units','pixel','Position', [posx posy largeur hauteur], ...
                      'defaultuicontrolunits','pixel',...
                      'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                      'defaultUIControlFontSize',10);
          %********FICHIERS D'ENTRÉES
          posx =20; large =largeur-2*posx; posy =hauteur-25; haut =25; posy =posy-haut;
          uicontrol('Parent',fig,'style','text','Position',[posx posy large haut],...
                    'String','Le résultat de quelle tâche servira de fichier d''entrée pour celle-ci?');
          posy =posy-haut;
          tmp =uicontrol('Parent',fig,'BackgroundColor',[1 1 1],...
                         'Position',[posx posy large haut],'Style','popupmenu',...
                         'String',laliste, 'Value', elno);
          large =50; posx =round((largeur-large)/2); posy =haut;
          okgo =uicontrol('parent',fig, 'callback','set(gcbo,''String'','':-)'')',...
                          'Position',[posx posy large haut], 'String','OK');
          set(fig,'WindowStyle','modal');
          waitfor(okgo, 'String',':-)');
          if isempty(findobj('tag', 'IpLien'))
            % ya rien à dire!
          elseif strcmp(get(okgo,'String'),':-)')
            tmp =get(tmp,'value');
            delete(fig);
            pp.tach(latache).FichierLien =pp.tach(tmp).elno;
            pp.tach(latache).PathEntree =pp.tach(tmp).PathSortie;
            pp.tach(latache).ListeFentree ={pp.tach(tmp).descr};
            pp.tach(latache).isFichierIn =1;
            set(findobj('Tag','VoirFichierEntree'),'string',pp.tach(tmp).descr,'value',1);
          end
        end
      end
    end
    varargout{1} =pp;
  %-------------
  case 'BSortie'
    %
    % Pré-Traitement du choix des fichiers de sortie (BATCH)
    % 1-'Écraser les fichiers sources ' 2-'Même dossier, rebaptiser les fichiers'
    % 3-'Un nouveau dossier pour tous les fichiers' 4-'Nouveau dossier, même arborescence'
    %
    pp =varargin{2};
    if pp.tacfic
      cd(pp.PathSortie);
      switch pp.ChoixSortie
      %-----
      case 1
        pp.ListeFsortie =pp.ListeFentree;
        pp.PathSortie =pp.PathEntree;
        cd(pp.PathSortie);
        pp.isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',pp.ListeFsortie,'value',1);
      %-----
      case 2
        pp =kelnom(pp);
      %----------
      case {3 ,4}
        pname =uigetdir(pp.PathSortie,'Choisir ou Créer le dossier (pour sauvegarder)');
        if isequal(pname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.PathSortie =pname;
        pp.ListeFsortie ={pname};
        pp.isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',pp.PathSortie,'value',1);
      end
    else
      latache =get(findobj('tag','IpProp'),'UserData');
      cd(pp.tach(latache).PathSortie);
      switch pp.tach(latache).ChoixSortie
      %-----
      case 1
        if pp.tach(latache).ChoixEntree < 4
          pp.tach(latache).ListeFsortie =pp.tach(latache).ListeFentree;
        else
          pp.tach(latache).ListeFsortie ='Même fichiers qu''en entrée';
        end
        pp.tach(latache).PathSortie =pp.tach(latache).PathEntree;
        cd(pp.tach(latache).PathSortie);
        pp.tach(latache).isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',pp.tach(latache).ListeFsortie,'value',1);
      %-----
      case 2
        pp =kelnom(pp);
      %----------
      case {3 ,4}
        pname =uigetdir(pp.tach(latache).PathSortie,'Choisir ou Créer le dossier (pour sauvegarder)');
        if isequal(pname,0)
          varargout{1} =pp;
          return;
        end
        cd(pname);
        pp.tach(latache).PathSortie =pname;
        pp.tach(latache).ListeFsortie ={pname};
        pp.tach(latache).isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',pp.tach(latache).PathSortie,'value',1);
      end
    end
    varargout{1} =pp;
  end
return

function ss =kelnom(ss)
  latache =get(findobj('tag','IpProp'),'UserData');
  if ss.tacfic
    pref =ss.prefixe;
    prenom =ss.prenom;
  else
    pref =ss.tach(latache).prefixe;
    prenom =ss.tach(latache).prenom;
  end
  mx =10; my =10; largeur =250; hauteur =150;
  posx =100; posy =100; large =largeur; haut =hauteur;
  fig =figure('position',[posx posy large haut],'tag', 'IpPrenom');
  posx =mx; haut =40; posy =hauteur-haut-my; large =largeur-2*mx;
  uicontrol('parent',fig,'position',[posx posy large haut],'style','text',...
            'string','Chaîne de caractères à ajouter au nom du fichier',...
            'fontweight','bold','background',[0.8 0.8 0.8]);
  haut =20; posy =posy-2*haut; large =15;
  hdpref =uicontrol('parent',fig,'position',[posx posy large haut],'style','checkbox',...
                    'value',pref,'tooltipstring',...
                    'Si coché, l''ajout se fait comme préfixe. Autrement ce sera comme suffixe');
  posx =posx+large; large =largeur-posx-mx;
  hdnom =uicontrol('parent',fig,'position',[posx posy large haut],'style','edit','string',prenom);
  large =25; posx =round((largeur-large)/2); posy =posy-2*haut;
  okgo =uicontrol('parent',fig,'position',[posx posy large haut],'string','OK',...
                  'Callback','set(gcbo,''String'','':-)'')');
  set(fig,'WindowStyle','modal');
  waitfor(okgo, 'String',':-)');
  if isempty(findobj('tag', 'IpPrenom'))
    % ya rien à dire!
    return;
  elseif strcmp(get(okgo,'String'),':-)')
    pref =get(hdpref,'value');
    prenom =deblank(get(hdnom,'string'));
    if isempty(prenom)
      prenom ='S';
    end
    if ss.tacfic
      ss.prefixe =pref;
      ss.prenom =prenom;
      if ss.isFichierIn
        if ss.ChoixEntree == 1
          for ii =1:length(ss.ListeFentree)
            if pref == 0
              [P,N,E,V] = fileparts(ss.ListeFentree{ii});
              ss.ListeFsortie{ii} =[N prenom E];
            else
              ss.ListeFsortie{ii} =[ prenom ss.ListeFentree{ii} ];
            end
          end
        else
          ss.ListeFsortie =ss.ListeFentree;
        end
        ss.isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',ss.ListeFsortie,'value',1);
      end
    else
      ss.tach(latache).prefixe =pref;
      ss.tach(latache).prenom =prenom;
      if ss.tach(latache).isFichierIn
        if ss.tach(latache).ChoixEntree == 1
          for ii =1:length(ss.tach(latache).ListeFentree)
            if pref == 0
              [P,N,E,V] = fileparts(ss.tach(latache).ListeFentree{ii});
              ss.tach(latache).ListeFsortie{ii} =[ N prenom E ];
            else
              ss.tach(latache).ListeFsortie{ii} =[ prenom ss.tach(latache).ListeFentree{ii} ];
            end
          end
        elseif ss.tach(latache).ChoixEntree == 4
          if pref == 0
            ss.tach(latache).ListeFsortie =['Même fichiers qu''en entrée ''+'' ' prenom];
          else
            ss.tach(latache).ListeFsortie =[prenom ' ''+'' Même fichiers qu''en entrée'];
          end
        else
          if pref == 0
            ss.tach(latache).ListeFsortie =[ss.tach(latache).ListeFentree ' ''+'' ' prenom];
          else
            ss.tach(latache).ListeFsortie =[prenom ' ''+'' ' ss.tach(latache).ListeFentree];
          end
        end
        ss.tach(latache).isFichierOut =1;
        set(findobj('Tag','VoirFichierSortie'),'string',ss.tach(latache).ListeFsortie,'value',1);
      end
    end
    delete(gcf);
  end
return