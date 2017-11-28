%
% classdef CBatchEditExecGUI < CBasePourFigureAnalyse & CBatchEditExecParam
%
% Classe de gestion du GUI GUIBatchEditExec
% prendra en charge tous les callback du GUI
%
% METHODS
%          initGui(tO)
%          ouvrirParamBatch(tO, src, varargin)
%          sauveParamBatch(tO, src, varargin)
%      V = prepareInfoBatchGUI(tO)
%          ecraseInfoBatchGUI(tO, V)
%          afficheSelectionFichIN(tO)
%          changePosteRadio(tO, src, varargin)
%          resetPosteRadio(tO, src, varargin)
%          dossierFichierEntree(tO, src, varargin)
%    cok = afficheFichierManuel(tO)
%    cok = afficheDossier(tO)
%   pnom = selectionDir(tO, T)
%          dossierFichierSortie(tO, src, varargin)
%          afficheModifDossier(tO,S)
%          afficheModifFichier(tO,S)
%          ajouterAction(tO, varargin)
%          ajoutAction(tO, meschoix)
%          effacerAction(tO, varargin)
%          monterAction(tO, varargin)
%          descendreAction(tO, varargin)
%          modifierAction(tO, varargin)
%          resetApres(tO)
%          afficheListAction(tO,ordre)
%          auTravail(tO, varargin)
%     OK = verifGUI(tO, J)
%      V = getSelectedObject(tO)
%          fabricListFichierIn(tO,FIN)
%          choixDossierSortie(tO,varargin)
%    rep = verifFsortie(tO,hF,hL)
%          fabricListFichierOut(tO,hFo,hFi)
%          setDossierTop(tO, liss)
%    rep = listFichRecursif(tO,lepath,rep)
%
classdef CBatchEditExecGUI < CBasePourFigureAnalyse & CBatchEditExecParam

  methods

    %-------------------
    % Création du GUI
    %-------------------
    function initGui(tO)
      if isempty(tO.fig)
        tO.fig =GUIBatchEditExec(tO);
        tO.onVide();
      else
        figure(tO.fig);
      end
    end

    %-----------------------------------------------
    % RÉCUPÈRE LA SAUVEGARDE POUR UNE RÉ-UTILISATION
    % src  est le handle du menu
    %-----------------------------------------------
    function ouvrirParamBatch(tO, src, varargin)
      % quel est le fichier contenant les paramètres du travail à faire?
      [Fnom, Fpath] =uigetfile('*.mat','Choisissez un fichier contenant les paramètres');
      if isequal(Fnom,0) || isequal(Fpath,0)
        return;
      end
      % lecture du fichier contenant la structure
      foo =load([Fpath Fnom], 'Info');
      % application de la partie "properties" de l'objet
      tO.ecraseInfoBatch(foo.Info.Bprop);
      % application de la partie "GUI"
      tO.ecraseInfoBatchGUI(foo.Info.Bgui);
    end

    %-----------------------------------------------
    % SAUVEGARDE TOUS POUR UNE PROCHAINE UTILISATION
    % src  est le handle du menu
    %-----------------------------------------------
    function sauveParamBatch(tO, src, varargin)
      % dans quel fichier on place tout cela?
      [Fnom, Fpath] =uiputfile('batch.mat','Entrez un nom de fichier pour sauvegarder les paramètres');
      if isequal(Fnom,0) || isequal(Fpath,0)
        return;
      end
      % Préparation des informations du GUI à sauvegarder
      Info.Bgui =tO.prepareInfoBatchGUI();
      % préparation des propriétés de la classe CBatchEditExecParam()
      Info.Bprop =tO.prepareInfoBatch();
      save([Fpath Fnom], 'Info');
    end

    %---------------------------------------------------------
    % On retourne les valeurs et string du GUI afin de pouvoir
    % revenir au même point dans une séance subséquente
    %---------------------------------------------------------
    function V = prepareInfoBatchGUI(tO)
      % nom du tag des propriétés où on sauvegarde une valeur
      propval ={'fichiermanuel','undosstousfich','dossousdoss','ecrase','changfich',...
                'changdoss','changtout','prefix','suffix'};
      % lecture de chacune de ces propriétés et sauvegarde dans une structure
      for U =1:length(propval)
        V.(propval{U}) =get(findobj('tag',propval{U}),'value');
      end
      % nom du tag des propriétés où on sauvegarde une string
      propstr ={'choixfichier','editdossierfinal','editfichierpresuf','batchafaire'};
      % lecture de chacune de ces propriétés et sauvegarde dans une structure
      for U =1:length(propstr)
        V.(propstr{U}) =get(findobj('tag',propstr{U}),'string');
      end
    end

    %---------------------------------------------------------
    % On ré-écrit par dessus les valeurs et string du GUI avec
    % les infos recueillis dans une séance précédante
    %---------------------------------------------------------
    function ecraseInfoBatchGUI(tO, V)
      % nom du tag des propriétés où on sauvegarde une valeur
      propval ={'fichiermanuel','undosstousfich','dossousdoss','ecrase','changfich',...
                'changdoss','changtout','prefix','suffix'};
      % lecture de chacune de ces propriétés et sauvegarde dans une structure
      for U =1:length(propval)
        if isfield(V, propval{U})
          set(findobj('tag',propval{U}),'value',V.(propval{U}));
        end
      end
      % nom du tag des propriétés où on sauvegarde une string
      propstr ={'choixfichier','editdossierfinal','editfichierpresuf','batchafaire'};
      % lecture de chacune de ces propriétés et sauvegarde dans une structure
      for U =1:length(propstr)
        if isfield(V, propstr{U})
          set(findobj('tag',propstr{U}),'string',V.(propstr{U}));
        end
      end
      % On fait afficher les sélections avec "flèche" pour les dossiers --> IN
      tO.afficheSelectionFichIN();
      % On fait afficher les sélections avec "flèche" pour les dossiers --> OUT
      tO.dossierFichierSortie(findobj('tag','BGfichOUT'));
      % On fait afficher les sélections avec "flèche" pour Préfixe/Sufixe du nouveau nom
      tO.changePosteRadio(findobj('tag','BGnomfichOUT'));
    end

    %----------------------------------------------------------
    % AFFICHE LA FLÈCHE SUR LA SÉLECTION DANS LE PSEUDO-UIGROUP
    % une petite flèche indiquera la sélection.
    %----------------------------------------------------------
    function afficheSelectionFichIN(tO)
      % on recherche les radiobutton qui appartiennent au groupe
      hBG =findobj('tag','BGfichIN');
      tmp =findobj('style','radiobutton', 'parent',hBG);
      % on flush le CDATA de tous les radiobutton
      set(tmp, 'cdata',[]);
      % on load l'image et on l'affiche pour le radiobutton sélectionné
      try
        ico =imread(which('ptiteflechdrte.bmp'),'BMP');
        set(tO.getSelectedObject(), 'cdata',ico);
      catch sss;
        % rien à faire pour Octave
      end
      % sous le uiButtonGroup, on affiche le nombre de fichier à traiter
      set(hBG,'title',[num2str(tO.Nfich) ' fichiers à traiter'])
    end

    %------------------------------------------------
    % CHANGE SÉLECTION DE RADIOBUTTON DANS LE UIGROUP
    % une petite flèche indiquera la sélection.
    % src  est le handle du uigroup
    %------------------------------------------------
    function changePosteRadio(tO, src, varargin)
      % on recherche les radiobutton qui appartiennent au groupe
      tmp =findobj('style','radiobutton', 'parent',src);
      try
        % on flush le CDATA de tous les radiobutton
        set(tmp, 'cdata',[]);
        % on load l'image et on l'affiche
        ico =imread('ptiteflechdrte.bmp','BMP');
        set(get(src,'SelectedObject'), 'cdata',ico);
      catch sss;
        % rien à faire car Octave ne supporte pas encore le "cdata"
      end
    end

    %----------------------------------------------
    % DÉ-SÉLECTION DES RADIOBUTTONS DANS LE UIGROUP
    % On efface les icones et SelectedObject = []
    % src  est le handle du uigroup
    %----------------------------------------------
    function resetPosteRadio(tO, src, varargin)
      % on recherche les radiobutton qui appartiennent au groupe
      tmp =findobj('style','radiobutton', 'parent',src);
      % on flush le CDATA de tous les radiobutton
      set(tmp, 'cdata',[]);
      % on remet la sélection vide
      set(src,'SelectedObject',[]);
    end

    %-----------------------------------------------
    % Sélection de l'emplacement du fichier d'entrée
    % src est le handle du radiobutton
    %-----------------------------------------------
    function dossierFichierEntree(tO, src, varargin)
      % recherche du uipanel qui contient les radiobuttons
      ppa =get(src,'parent');
      % on recherche les radiobutton qui appartiennent au groupe
      tmp =findobj('style','radiobutton', 'parent',ppa);
      try
        % pour Matlab
        % on flush le CDATA de tous les radiobutton
        set(tmp,'value',0,'cdata',[]);
        % on load l'image et on l'affiche
        ico =imread(which('ptiteflechdrte.bmp'),'BMP');
        set(src,'value',1,'cdata',ico);
      catch sss;
        % pour Octave
        set(src,'value',1);
      end
      % on vide la listbox de son contenu
      set(findobj('tag','choixfichier'),'value',1,'string','');
      tO.Nfich =0;
      rep =true;
      % En fonction du type de sélection, on choisi quel fichier traiter
      switch get(src,'tag')
      case 'fichiermanuel'
        % choix des fichiers manuellement
        rep =tO.afficheFichierManuel();
      case 'undosstousfich'
        % tous les fichiers sont dans un dossier
        rep =tO.afficheDossier();
      case 'dossousdoss'
        % ici on va descendre au travers des sous-dossiers aussi
        rep =tO.afficheDossier();
      end
      if ~ rep
        set(tmp,'value',0,'cdata',[]);
      else
        tO.fabricListFichierIn(src);
      end
      set(ppa,'title',[num2str(tO.Nfich) ' fichiers à traiter']);
    end

    %----------------------------------------------------------
    % On fait la sélection des fichiers à traiter manuellement 
    % et on inscrit le path complet dans la listbox.
    %----------------------------------------------------------
    function cok = afficheFichierManuel(tO)
      cok =true;
      lesmots ='Choix des fichiers à traiter';
      [fnom,pnom] =uigetfile({'*.mat','Fichier Analyse (*.mat)'},lesmots,'multiselect','on');
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
        cok =false;
        return;
      end
      % si on a choisi un seul fichier, il ne sera pas placé dans une cellule
      if ~iscell(fnom)
        fnom ={fnom};
      end
      % on ajoute le path au nom de fichier
      for U=1:length(fnom)
        fnom{U} =fullfile(pnom,fnom{U});
      end
      % on affiche dans la listbox
      set(findobj('tag','choixfichier'),'value',1,'string',fnom);
    end

    %-------------------------------------------------------------------
    % On choisi le dossier qui contient tous les fichiers à traiter (IN)
    % et on inscrit le path du dossier dans la listbox.
    %-------------------------------------------------------------------
    function cok = afficheDossier(tO)
      cok =false;
      lesmots ='Choix du dossier qui contient tous les fichiers à traiter';
      P = tO.selectionDir(lesmots);
      if ~isempty(P)
        % on affiche dans la listbox
        set(findobj('tag','choixfichier'),'value',1,'string',P);
        cok =true;
      end
    end

    %--------------------------------------------------------------------
    % Sélection d'un dossier
    % En entrée     T  -->  titre de la fenêtre
    % En sortie  pnom  -->  [] si on annule, autrement le path du dossier
    %--------------------------------------------------------------------
    function pnom = selectionDir(tO, T)
      pnom =uigetdir(pwd,T);
      if ~ischar(pnom)
        % on est sortie en annulant la commande (aucun choix)
        pnom =[];
      end
    end

    %------------------------------------------------
    % Sélection de l'emplacement du fichier de sortie
    %------------------------------------------------
    function dossierFichierSortie(tO, src, varargin)
      tO.changePosteRadio(src);
      % il faut afficher ou cacher certain uicontrol
      fiou =get(get(src,'SelectedObject'),'tag');
      switch fiou
      case 'ecrase'
        tO.afficheModifDossier('off');
        tO.afficheModifFichier('off');
      case 'changfich'
        tO.afficheModifDossier('off');
        tO.afficheModifFichier('on');
      case 'changdoss'
        tO.afficheModifDossier('on');
        tO.afficheModifFichier('off');
      case 'changtout'
        tO.afficheModifDossier('on');
        tO.afficheModifFichier('on');
      end
    end

    %--------------------------------------------------
    % Afficher/cacher la modification du nom de dossier
    % EN Entrée:  S  --> 'on' ou 'off'
    %--------------------------------------------------
    function afficheModifDossier(tO,S)
      set(findobj('tag','editdossierfinal'),'enable',S);
      set(findobj('tag','boutondossierfinal'),'enable',S);
    end

    %--------------------------------------------------
    % Afficher/cacher la modification du nom de fichier
    % EN Entrée:  S  --> 'on' ou 'off'
    %--------------------------------------------------
    function afficheModifFichier(tO,S)
      set(findobj('tag','editfichierpresuf'),'enable',S);
      % on cherche les "enfants" à modifier
      fafo =get(findobj('tag','BGnomfichOUT'),'children');
      try
        % Matlab veut une cellule
        set(fafo,'enable',S);
      catch sss;
        % Octave veut une matrice
        set(cell2mat(fafo),'enable',S);
      end
    end

    %------------------------------------------
    % Ajouter une action à partir de la listbox
    %------------------------------------------
    function ajouterAction(tO, varargin)
      % lire la sélection dans la listbox
      valchoix =get(findobj('tag','listbatchafaire'),'value');
      % sortir les noms d'action
      leschoix =tO.listChoixActions(valchoix);
      tO.ajoutAction(leschoix);
      % afficher la liste dans la listbox des actions sélectionnées
      tO.afficheListAction(0);
    end

    %---------------------------------------
    % Ajouter une action à partir d'une cell
    %---------------------------------------
    function ajoutAction(tO, meschoix)
      % on vérifie que meschoix n'est pas vide
      if ~isempty(meschoix)
        % on va boucler tous les éléments de meschoix
        for U = 1:length(meschoix)
          % création d'un objet CAction
          tO.creerNouvelAction(meschoix{U});
        end
      end
    end

    %------------------------------
    % Effacer l'action sélectionnée
    %------------------------------
    function effacerAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on l'efface
      tO.effaceAction(V);
      % on remet à zéro la propriété "pret"
      tO.mazPret(V);
      % on ré-affiche laliste
      tO.afficheListAction(0);
    end

    %-------------------------------------------------
    % Monter une action
    % pour déplacer vers le haut la tache sélectionnée
    %-------------------------------------------------
    function monterAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on la déplace
      tO.remonte(V);
      % on remet à zéro la propriété "pret"
      tO.mazPret(V-1);
      tO.afficheListAction(-1);
    end

    %------------------------------------------------
    % Descendre une action
    % pour déplacer vers le bas la tache sélectionnée
    %------------------------------------------------
    function descendreAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on la déplace
      tO.redescend(V);
      % on remet à zéro la propriété "pret"
      tO.mazPret(V);
      tO.afficheListAction(1);
    end

    %-----------------------------------------------
    % Modifier/Configurer une action
    % Lorsque l'on configure une action, il faut que
    % les actions précédentes aient été configurées.
    %-----------------------------------------------
    function modifierAction(tO, varargin)
      % on s'assure qu'il y a des actions
      if tO.Naction > 0
        % alors, de quel action il s'agit
        v =get(findobj('tag','batchafaire'),'value');
      	% handle de l'action à configurer
        foo =tO.listAction{v};
        % on passe le bon handle du fichier virtuel à l'action
        foo.hfi =tO.listFichVirt{v};
        % il faut que les actions précédentes aient été configurées
        if tO.isActionAvantPret(v)
          qui =tO.setTmpFichVirt(v);
        else
      	  hJ =CJournal.getInstance();
          hJ.ajouter('Il faut configurer les actions précédentes avant de configurer celle-ci!', tO.S);
      		return;
      	end
        if qui
          foo.afficheGUI();
        end
      end
    end

    %-------------------------------------------------------------
    % Comme il y a eu une modification majeure dans les paramètres
    % de l'action en cours de modification, on doit changer la
    % propriété "pret" des actions suivantes.
    %-------------------------------------------------------------
    function resetApres(tO)
      % il faut savoir quelle est l'action "courante"
      v =get(findobj('tag','batchafaire'),'value');
      tO.mazPret(v+1);
    end

    %-----------------------------------------------
    % Afficher la liste des actions sélectionnées
    % ordre nous permet de faire monter ou descendre
    % la sélection dans la listbox
    %-----------------------------------------------
    function afficheListAction(tO,ordre)
      % on génère la liste selon l'ordre entrée dans tO.listAction
      foo =tO.genereListAction();
      % on affiche dans le listbox: ATTENTION 'value'
      N =get(findobj('tag','batchafaire'),'value')+ordre;
      N =max(1,min(tO.Naction,N));
      set(findobj('tag','batchafaire'),'value',1,'string',foo,'value',N);
    end

    %-------------------------------
    % Au travail
    %-------------------------------
    function auTravail(tO, varargin)
      % On appelle le journal pour l'écriture des événements
      tO.S =0;
      hJ =CJournal.getInstance();
      hJ.ajouter(['Travail en lot, début: ' datestr(now)]);
      % vérification des param d'entrée avant de commencer
      if tO.verifGUI(hJ);
        % on commence à travailler en mode batch
        tO.tournezLaManivelle(hJ);
      else
        hJ.ajouter('Le traitement en batch n''a pas été effectué.');
      end
    end

    %-----------------------------------
    % Vérification des paramètres du GUI, il y a 3 panels à vérifier
    % FICHIER ENTRÉE
    % FICHIER SORTIE
    % ACTION À FAIRE
    %-----------------------------------
    function OK = verifGUI(tO, J)
      OK =true;
      J.ajouter('Vérification des paramètres d''entrées',tO.S);
      tO.S =tO.S+2;
      %---------------------
      % PARAM FICHIER ENTRÉE
      %---------------------
      % recherche du radiobutton sélection dans le uipanel des fichiers à traiter
      hfIN =tO.getSelectedObject();
      if isempty(hfIN)
        OK =false;
        J.ajouter('*** Il faut faire un choix de fichier à traiter', tO.S);
      end
      %---------------------
      % PARAM FICHIER SORTIE
      %---------------------
      hfOUT =get(findobj('tag','BGfichOUT'),'SelectedObject');
      OK =(OK & tO.verifFsortie(hfOUT,J));
      %---------------------
      % PARAM ACTION À FAIRE
      %---------------------
      if isempty(get(findobj('tag','batchafaire'),'string'))
        OK =false;
        J.ajouter('*** Il faut choisir au moins une action pour pouvoir traiter!!!', tO.S);
      end
      % Si il n'y a pas d'erreur, on fabrique les listes de fichier entrée/sorties
      if OK
        % On fabrique la liste des fichiers à traiter
        tO.fabricListFichierIn(hfIN);
        % Puis on fabrique la liste des fichiers de sortie
        if tO.Nfich < 1
          % il n'y a pas de fichier dans notre sélection
          OK =false;
          J.ajouter('*** Le dossier sélectionné ne contient pas de fichier à traiter', tO.S);
        else
          % fabrication de la liste des fichiers de sortie
          tO.fabricListFichierOut(hfOUT,hfIN);
          % ON EST RENDU À VÉRIFIER LES ACTIONS
          if tO.isActionsPretes()
            % rien pour l'instant
          else
            OK =false;
            J.ajouter('*** Il faut configurer toutes les actions à exécuter', tO.S);
          end
        end
      end
      tO.S =max(0,tO.S-2);
    end

    %-------------------------------------------------------------------------
    % Trouver le radiobutton qui est sélectionné dans notre Pseudo-ButtonGroup
    % On retourne le handle du radiobutton ou []
    %-------------------------------------------------------------------------
    function V = getSelectedObject(tO)
      Ppa =findobj('tag','BGfichIN');
      V =findobj('parent',Ppa, 'style','radiobutton','value',1);
    end

    %--------------------------------------------
    % On fabrique la liste des fichiers à traiter
    % En entrée, FIN --> handle du radiobutton
    %--------------------------------------------
    function fabricListFichierIn(tO,FIN)
      if ~exist('FIN')
        FIN =tO.getSelectedObject();
        if isempty(FIN)
          tO.Nfich =0;
          return;
        end
      end
      pnom =get(findobj('tag','choixfichier'),'string');
      switch get(FIN, 'tag')
      case 'fichiermanuel'
        % le cas ou on a choisi les fichier manuellement
        foo =pnom;
        if ~iscell(foo)
          % lorsqu'il n'y a qu'un choix on a une string plutôt qu'une cellule
          foo ={foo};
        end
      case 'undosstousfich'
        % le cas ou on a choisi un dossier
        fnom =dir([pnom '\*.mat']);
        foo ={};
        for U =1:length(fnom)
          foo{end+1,1} =fullfile(pnom,fnom(U).name);
        end
      case 'dossousdoss'
        % le cas ou on a choisi un dossier et tous ses sous-dossiers
        foo ={};
        foo =tO.listFichRecursif(pnom,foo);
      end
      tO.listFichIN =foo;
      tO.Nfich =length(foo);
    end

    % Sélection du dossier de sortie
    %
    function choixDossierSortie(tO,varargin)
      lesmots ='Choix du dossier pour la sauvegarde des fichiers à traiter';
      P = tO.selectionDir(lesmots);
      if ~isempty(P)
        % on affiche dans la listbox
        set(findobj('tag','editdossierfinal'),'value',1,'string',P);
      end
    end

    %--------------------------------------------------------
    % Vérification des infos du uipanel de fichier de sortie
    % En Entrée, hF  est le handle du radiobutton sélectionné
    %            hL  est le handle du "logbook"
    %--------------------------------------------------------
    function rep = verifFsortie(tO,hF,hL)
      rep =true;
      letag =get(hF, 'tag');
      if strncmpi(letag,'changfich',9) | strncmpi(letag,'changtout',9)
        % Changement du nom de fichier
        txt =deblank(get(findobj('Tag','editfichierpresuf'),'string'));
        if isempty(txt)
          rep =false;
          hL.ajouter('*** Il faut donner un préfixe/suffixe pour le nouveau nom de fichier de sortie',tO.S)
        end
      end
      if strncmpi(letag,'changdoss',9) | strncmpi(letag,'changtout',9)
        % Changement du nom de dossier
        dd =deblank(get(findobj('tag','editdossierfinal'),'string'));
        if isempty(dd)
          rep =false;
          hL.ajouter('*** Il faut donner un nom pour le nouveau nom de dossier de sortie',tO.S)
        end
      end
    end

    %-----------------------------------------------------------------------------------
    % En fonction du choix, on fabrique la liste des fichiers pour la sauvegarde
    % En entrée: hFo  est le handle du radiobutton sélectionné pour le dossier de sortie
    %            hFi  est le handle du radiobutton sélectionné pour le nom de fichier
    %-----------------------------------------------------------------------------------
    function fabricListFichierOut(tO,hFo,hFi)
      % quel est le choix de dossier de sortie sélectionné
      letag =get(hFo, 'tag');
      % on va travailler sur une liste temporaire
      Ltmp =tO.listFichIN;
      % MODIFICATION du nom de fichier
      if strncmpi(letag,'changfich',9) | strncmpi(letag,'changtout',9)
        % mot à ajouter en pré/suf(fixe) au nom de fichier
        txt =deblank(get(findobj('Tag','editfichierpresuf'),'string'));
        % préfixe ou suffixe
        pfixtag =get(get(findobj('tag','BGnomfichOUT'),'SelectedObject'),'tag');
        pfix =false;
        if strncmpi(pfixtag,'prefix',6)
          pfix =true;
        end
        % modification de la partie "nom de fichier"
        for U =1:tO.Nfich
          % on sépare le path/nom fichier/extension
          [a,b,c] =fileparts(Ltmp{U});
          if pfix
            % la modif s'ajoute comme un préfixe
            Ltmp{U} =fullfile(a,[txt b c]);
          else
            % la modif s'ajoute comme un suffixe
            Ltmp{U} =fullfile(a,[b txt c]);
          end
        end
      end
      % MODIFICATION de la partie nom du dossier
      if strncmpi(letag,'changdoss',9) | strncmpi(letag,'changtout',9)
        % nouveau nom pour le dossier de sortie
        nouvd =deblank(get(findobj('tag','editdossierfinal'),'string'));
        % on va discréminer en fonction du type de sélection faite pour les fichiers d'entrée
        switch get(hFi, 'tag')
          case {'fichiermanuel','undosstousfich'}
            % ici on a juste à changer le nom de dossier complet
            for U =1:tO.Nfich
              % on sépare le path/nom fichier/extension
              [a,b,c] =fileparts(Ltmp{U});
              Ltmp{U} =fullfile(nouvd,[b c]);
            end
          case 'dossousdoss'
            % ancien nom pour le dossier, c'est la partie à modifier
            ancd =get(findobj('tag','choixfichier'),'string');
            % longueur de la string
            Lancd =length(ancd);
            for U =1:tO.Nfich
              % on sépare le path/nom fichier/extension
              [a,b,c] =fileparts(Ltmp{U});
              Ltmp{U} =fullfile(nouvd,a(Lancd+1:end), [b c]);
            end
        end
      end
      tO.listFichOUT =Ltmp;
      tO.setDossierTop(Ltmp);
    end

    % Détermination du dossier de sortie "top niveau"
    % En entrée  liss  -->  liste des dossier\fichier de sortie
    function setDossierTop(tO, liss)
      if ~exist('liss')
        liss =tO.listFichOUT;
      end
      [tO.pathOUT,fnom] =fileparts(liss{1});
      for U =1:tO.Nfich
        [pnom,fff] =fileparts(liss{U});
        lemin =min(length(pnom),length(tO.pathOUT));
        for V =1:lemin
          if ~(pnom(V) == tO.pathOUT(V))
            break;
          end
        end
        tO.pathOUT =tO.pathOUT(1:V);
      end
      % au cas ou on aurait C:\dossier1\s001 etC:\dossier1\s002 etc.
      while ~isdir(tO.pathOUT)
        tO.pathOUT(end) =[];
      end
    end

    %--------------------------------------------------------------------
    % Fonction récursive pour démanteler tous les fichiers ".mat"
    % au travers des dossiers/sous-dossiers
    % En entrée:  lepath  est le dossier à inspecter
    %             rep     est la liste des fichiers "dossier\fichier.mat"
    % En sortie   rep      "   "
    %--------------------------------------------------------------------
    function rep = listFichRecursif(tO,lepath,rep)
      % on conserve le dossier de départ
      pIN =pwd();
      % on se place dans le dossier à inspecter
      cd(lepath);
      % lecture du dossier courant
      lfich =dir();
      % on commence à 3 car les 2 premières sont: "." et ".."
      for U =3:length(lfich)
        [a,b,ext] =fileparts(lfich(U).name);
        if lfich(U).isdir
          % il s'agit d'un dossier
          rep =tO.listFichRecursif(lfich(U).name,rep);
        elseif strncmpi(ext, '.mat', 4)
          rep{end+1,1} =fullfile(pwd(), lfich(U).name);
        end
      end
      % on retourne au dossier de départ avant de quitter
      cd (pIN);
    end

  end  % methods

end
