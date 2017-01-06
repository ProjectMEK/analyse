%
% Le développement de cet option a commencé vers 2011,
% étant constamment interrompu pour différents ajouts/pépins,
% ça n'a pas évolué trop trop.
%
function varargout = batchEditExec(varargin)
  if nargin == 0
    mando ='peinture';
    hh =hhdefaut;
  else
    mando =varargin{1};
    hh =guidata(findobj('tag', 'IpBatch'));
  end
  for ii =1:nargout
    varargout{ii} =0;
  end
  %-----------
  switch mando
  %--------------
  case 'peinture'
    % ***INTERFACE POUR L'EXÉCUTION EN BATCH***
    moniteur =get(0,'ScreenSize');
    moniteur =[moniteur(3) moniteur(4) moniteur(3) moniteur(4)];
    lafig =gcf;
    lapos =[get(lafig,'position')] .* moniteur;
    posx =lapos(1); haut =300; posy =lapos(2)+lapos(4)-haut; large =600;
    fig  =figure('Name','TRAITEMENT EN LOT','tag', 'IpBatch',...
                 'Resize','on', 'Position', [posx posy large haut], ...
                 'CloseRequestFcn','batchEditExec(''desintegration'')','MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                 'defaultUIControlFontSize',10);
    set(lafig,'Visible','Off');
    lemnu =uimenu('Parent',fig, 'Label','&Fichier','enable','on');
    uimenu('Parent',lemnu, 'Label','&Ouvrir fichier batch','callback','batchEditExec(''BOuvrir'')');
    uimenu('Parent',lemnu, 'Label','&Sauvegarder fichier batch','callback','batchEditExec(''BSauve'')');
    intx =0.03; inty =0.025; bouty =0.08; boutx =0.15; winx =0.7;
    hbox =1-5*bouty; margex =.075;
  % ********FICHIER/TÂCHES OU TÂCHE/FICHIERS  CHECKBOX
    posx =margex;large =1-2*margex;haut =bouty; posy =1-1.5*haut;
    uicontrol('Parent',fig, 'Tag','tacfictac',...
              'Position',[posx posy large haut], 'Style','checkbox',...
              'callback','batchEditExec(''tacfic'')','value', hh.tacfic, ...
              'tooltipstring','L''inverse serait: Exécuter première tâche sur tous les fichiers, passer à la tâche suivante',...
              'String', 'Ouvrir premier fichier, exécuter toutes les tâches, passer au fichier suivant');
  % ********BATCH À EXÉCUTER
    large =winx; posy =posy-1.5*haut; debuty =posy;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], ...
              'HorizontalAlignment','Center', 'Style','text',...
              'String','Tâches à effectuer');
    haut =hbox;posy =posy-haut; finy =posy;
    conmnu = uicontextmenu;
    uicontrol('Parent',fig, 'Tag','batchafaire',...
              'BackgroundColor',[1 1 1], 'Callback','batchEditExec(''batchafaire'')',...
              'Style','listbox', 'Position',[posx posy large haut], ...
              'String',hh.tach(1).Descr,'UIContextMenu', conmnu, 'Value',1);
    % Définition des ContextMenus
    uimenu(conmnu,'Label', 'Ajouter', 'Callback','batchEditExec(''ajouterbatch'')');
    uimenu(conmnu,'Label', 'Supprimer', 'Callback', 'batchEditExec(''efface'')');
    uimenu(conmnu,'Label', 'Monter', 'Callback', 'batchEditExec(''monter'')');
    uimenu(conmnu,'Label', 'Descendre', 'Callback', 'batchEditExec(''descendre'')');
    posx =posx+large+intx;large =boutx;haut=bouty;posy =debuty-((debuty-finy-5*haut)/2)-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''ajouterbatch'')', ...
  	      'Position',[posx posy large haut], 'String','Ajouter');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''efface'')', ...
  	      'Position',[posx posy large haut], 'String','Supprimer');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''monter'')', ...
  	      'Position',[posx posy large haut], 'String','Monter');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''descendre'')', ...
              'Position',[posx posy large haut], 'String','Descendre');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''batchpropriete'')', ...
              'Position',[posx posy large haut], 'String','Propriété');
  % ********AU TRAFFAILLE, voyons, qui a encowe pis mes dents... :-B
    posx =(1-large)/2; posy =bouty/2;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''allez_du_nerf'')', ...
              'Position',[posx posy large haut], 'String','Au travail');
    guidata(fig,hh);
  %-------------
  case 'BOuvrir'
    uiload;
    set(findobj('Tag','tacfictac'),'value',hh.tacfic);
    guidata(findobj('tag', 'IpBatch'),hh);
    batchEditExec('disptach');
  %------------
  case 'BSauve'
    [Fnom, Fpath] =uiputfile('batch.mat','Entrez un nom de fichier pour sauvegarder les paramètres');
    if isequal(Fnom,0) || isequal(Fpath,0)
      return;
    else
      save([Fpath Fnom], 'hh');
    end

  %---------------------------------------
  % Choix Fichier/tâches ou Tâche/fichiers
  %------------
  case 'tacfic'
    hh.tacfic =get(findobj('Tag','tacfictac'),'value');
    guidata(findobj('tag', 'IpBatch'),hh);

  %----------------------------
  % Édition/Création des tâches
  %-----------------
  case 'batchafaire'
    if strcmp(get(findobj('tag','IpBatch'),'SelectionType'), 'open')
      latache =get(findobj('Tag','batchafaire'),'value');
      if latache > hh.tot      % Création d'une tâche
        modibatch(hh);
      else
        editache(hh,latache);
      end
    end

  %------------------
  % Ajout d'une tâche
  %------------------
  case 'ajouterbatch'
    modibatch(hh);
    guidata(findobj('tag','IpBatch'),hh);

  %-------------------
  % Édition des tâches
  %--------------------
  case 'batchpropriete'
    latache=get(findobj('Tag','batchafaire'),'value');
    if latache > hh.tot
      return;
    else
      editache(hh,latache);
    end

  %---------------------------
  % Ajouter une nouvelle Batch
  %---------------
  case 'ajoubatch'
    hh = CreerUnNouveau(hh);
    guidata(findobj('tag','IpBatch'),hh);
    batchEditExec('disptach');

  %------------------------------------------------
  % Ajouter une nouvelle Batch et fermer la fenêtre
  %-------------------
  case 'ajoubatchferm'
    hh = CreerUnNouveau(hh);
    guidata(findobj('tag','IpBatch'),hh);
    batchEditExec('disptach');
    delete(gcf);

  %--------------
  case 'disptach'
    for ii=1:hh.tot
      taches{ii}=hh.tach(ii).descr;
    end
    taches{hh.tot+1} ='****Nouvelle tâche****';
    set(findobj('Tag','batchafaire'),'string', taches);

  %-------------------------------------------
  % Fait monter la tâche sélectionné d'un rang
  %------------
  case 'monter'
    latache=get(findobj('Tag','batchafaire'),'value');
    if (latache < hh.tot+1) && (hh.tot > 1)
      tache=hh.tach;
      if latache == 1
        hh.tach(hh.tot) = tache(1);
        for i=1:hh.tot-1
          hh.tach(i)=tache(i+1);
        end
        latache=hh.tot;
      else
        hh.tach(latache-1)=tache(latache);
        hh.tach(latache)=tache(latache-1);
        latache=latache-1;
      end
      guidata(findobj('tag','IpBatch'),hh);
      batchEditExec('disptach');
      set(findobj('Tag','batchafaire'),'value',latache);
    end

  %----------------------------------------------
  % Fait descendre la tâche sélectionné d'un rang
  %---------------
  case 'descendre'
    latache=get(findobj('Tag','batchafaire'),'value');
    if (latache < hh.tot+1) && (hh.tot > 1)
      tache=hh.tach;
      if latache == hh.tot
        hh.tach(1)=tache(hh.tot);
        for ii=2:hh.tot
          hh.tach(ii)=tache(ii-1);
        end
        latache=1;
      else
        hh.tach(latache+1)=tache(latache);
        hh.tach(latache)=tache(latache+1);
        latache=latache+1;
      end
      guidata(findobj('tag','IpBatch'),hh);
      batchEditExec('disptach');
      set(findobj('Tag','batchafaire'),'value',latache);
    end

  %-----------------
  % Enlève une tâche
  %------------
  case 'efface'
    latache=get(findobj('Tag','batchafaire'),'value');
    if latache < hh.tot+1
      hh.tot=hh.tot-1;
      hh.tach(latache)=[];
      guidata(findobj('tag','IpBatch'),hh);
      batchEditExec('disptach');
    end

  %-------------------
  case 'allez_du_nerf'
    if hh.tacfic
      fictaches;
    else
      tacfichiers;
    end

  %--------------
  case 'terminus'
    delete(gcf);

  %--------------------
  case 'desintegration'
    cd(hh.Path);
    fig =gcf;
    set(findobj('tag','IpTraitement'),'Visible','On');
    delete(fig);
  end
end

%
% initialisation des valeurs par défaut
%
function prmt = hhdefaut
    prmt.status =0;
    prmt.erreur =0;
    prmt.Path =pwd;
    prmt.ChoixEntree =1;
    prmt.ChoixSortie =4;
    prmt.isFichierIn =0;
    prmt.isFichierOut =0;
    prmt.PathEntree =pwd;
    prmt.PathSortie =pwd;
    prmt.ListeFentree ={'aucun fichier à traiter'};
    prmt.ListeFsortie ={'Fichier de sortie à déterminer'};
    prmt.prefixe =1;
    prmt.prenom =[];
    prmt.NbFTraiter =0;
    prmt.exten ='.mat';
    prmt.tot =0;
    prmt.elno =0;
    prmt.tacfic =1;
    prmt.tach(1).Descr ={'****Nouvelle tâche****'};
end

%
% Édition/Modification des paramètres de cette tâche
%
function editache(hh,tache)
  hh.status=tache;
  guidata(findobj('Tag','IpBatch'),hh);
  lafonc = str2func(hh.tach(tache).laclasse);
  lafonc('edition');
end 

%
% affichage de la FENÊTRE pour créer les Batchs
%
function modibatch(hh)
  lapos =get(0,'pointerlocation');
  hh.status =0;
  leboss =get(0,'ScreenSize');
  %-----DIMENSION DE LA FENÊTRE
  largeur =400; hauteur =150;
  posx =lapos(1);posy =lapos(2)-(hauteur);
  if posy+hauteur > leboss(4)
    posy=50;
  end
  if posx+largeur > leboss(3)
    posx=50;
  end
  fig =figure('Name','Ajout de Tâches','tag', 'IpAjoutTach',...
              'Resize','on', 'Position', [posx posy largeur hauteur], ...
              'CloseRequestFcn','batchEditExec(''terminus'')',...
              'defaultuicontrolunits','Normalized',...
              'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'defaultUIControlFontSize',10);
  margex =0.05;posx =margex;large =(1-3*margex)*0.65;haut =0.75;posy =(1-haut)/2;
  laliste =choixliste('BChoixTache','nom');
  uicontrol('Parent',fig, 'tag','typBatch',...
            'Position',[posx posy large haut], ...
            'BackgroundColor',[0.9 0.9 0.9],...
            'max',length(laliste), 'value',1,...
            'Style','listbox', 'String', laliste);
  posx=posx+large+margex;large=1-margex-posx;haut=0.2;posy=1-2*haut;
  uicontrol('parent',fig, 'Position',[posx posy large haut], ...
            'style','pushbutton', 'string','Ajouter',...
            'callback','batchEditExec(''ajoubatch'')');
  posy=posy-2*haut;
  uicontrol('parent',fig, 'Position',[posx posy large haut], ...
            'style','pushbutton', 'string','Ajouter et Fermer',...
            'callback','batchEditExec(''ajoubatchferm'')');
  guidata(findobj('tag','IpBatch'),hh);
  set(fig,'WindowStyle','modal');
end

%
% Ici, le travail à faire est de prendre
% un fichier à la fois et exécuter toutes
% les tâches. On va au fichier suivant et on recommence...
%
function fictaches
  lafig =findobj('tag','IpBatch');
  pp =guidata(lafig);
  commentaire('creacion',['Liste des étapes effectuées <' date '>']);
  commentaire('escribir',' ');
  pp.exten =pp.tach(1).exten;
  pp =verifentrer(pp,1);
  if pp.erreur
    return;
  end
  
end

function tacfichiers

end

%
% ON PEUT PASSER UN OU DEUX PARAMÈTRES
% verifentrer(structure, NodeTache)
% verifentrer(structure)
% la structure pourra être: ss ou ss.tach
%
function vv =verifentrer(varargin)
  commentaire('escribir','-Vérification des fichiers sources');
  vv =varargin{1};
  elno =1;
  if nargin > 1
    elno =varargin{2};
  end
  if vv(elno).isFichierIn == 0
    commentaire('escribir',['-Tâche ' num2str(elno) ', fichiers sources manquant!'],2);
    vv(elno).erreur =1;
    return;
  end
  cd(vv(elno).PathEntree);
  %--------------------------
  switch vv(elno).ChoixEntree
  %-----     Par fichier
  case 1
    %  Rien à faire de plus
  %-----     Contenu d'un dossier
  case 2
    fchr =dir(['*' vv(elno).exten]);
    if sum([fchr.isdir])
      for ii =length(fchr):-1:1
        if fchr(ii).isdir
          fchr(ii) =[];
        end
      end
    end
    if not(length(fchr))
      commentaire('escribir',['-Tâche ' num2str(elno) ', fichiers sources manquant!'],2);
      vv(elno).erreur =1;
      return;
    end
    for ii =1:length(fchr)
      vv(elno).ListeFentree{ii} =fchr(ii).name;
    end
  %-----     Contenu d'un dossier et ses sous-dossiers
  case 3
    fchr =dir(['*' vv(elno).exten]);
    tmp.Archivo =[];
    tmp.nb =0;
    for ii =1:length(fchr)
      tmp.path ='';
      if fchr(ii).isdir
       %*****Ici on Call LA Fonction récursive*****
      else
        tmp.nb =tmp.nb+1;
        tmp.Archivo{tmp.nb} =fchr(ii).name;
      end
    end
  %-----     Fichiers d'une tâche précédente
  case 4
    
  end
  vv(elno).NbFTraiter =length(vv(elno).ListeFentree);
  commentaire('adicion','...OK');
end

%
% Initialisation des valeurs par défaut des
% différents périfériques
%
function  Spp = CreerUnNouveau(Spp)
  letyp=get(findobj('tag','typBatch'),'value');
  fuu = choixliste('BChoixTache','classe');
  for U=1:length(letyp)
    lafonc = str2func(fuu{letyp(U)});
    Spp = lafonc('untoutnouveau', Spp);
  end
end

% dans suppess.m il y avait
%
%  %-------------------
%  case 'untoutnouveau'
%    ss =varargin{2};
%    ccc =ss.tot + 1;
%    ss.tot =ccc;
%    ss.tach(ccc).listess =[];
%    ss.tach(ccc).laclasse ='suppess';
%    ss.tach(ccc).descr =['Supprimer Essais: '];
%    varargout{1} =ss;
%  end
