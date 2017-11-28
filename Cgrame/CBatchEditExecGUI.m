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
    % Cr�ation du GUI
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
    % R�CUP�RE LA SAUVEGARDE POUR UNE R�-UTILISATION
    % src  est le handle du menu
    %-----------------------------------------------
    function ouvrirParamBatch(tO, src, varargin)
      % quel est le fichier contenant les param�tres du travail � faire?
      [Fnom, Fpath] =uigetfile('*.mat','Choisissez un fichier contenant les param�tres');
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
      [Fnom, Fpath] =uiputfile('batch.mat','Entrez un nom de fichier pour sauvegarder les param�tres');
      if isequal(Fnom,0) || isequal(Fpath,0)
        return;
      end
      % Pr�paration des informations du GUI � sauvegarder
      Info.Bgui =tO.prepareInfoBatchGUI();
      % pr�paration des propri�t�s de la classe CBatchEditExecParam()
      Info.Bprop =tO.prepareInfoBatch();
      save([Fpath Fnom], 'Info');
    end

    %---------------------------------------------------------
    % On retourne les valeurs et string du GUI afin de pouvoir
    % revenir au m�me point dans une s�ance subs�quente
    %---------------------------------------------------------
    function V = prepareInfoBatchGUI(tO)
      % nom du tag des propri�t�s o� on sauvegarde une valeur
      propval ={'fichiermanuel','undosstousfich','dossousdoss','ecrase','changfich',...
                'changdoss','changtout','prefix','suffix'};
      % lecture de chacune de ces propri�t�s et sauvegarde dans une structure
      for U =1:length(propval)
        V.(propval{U}) =get(findobj('tag',propval{U}),'value');
      end
      % nom du tag des propri�t�s o� on sauvegarde une string
      propstr ={'choixfichier','editdossierfinal','editfichierpresuf','batchafaire'};
      % lecture de chacune de ces propri�t�s et sauvegarde dans une structure
      for U =1:length(propstr)
        V.(propstr{U}) =get(findobj('tag',propstr{U}),'string');
      end
    end

    %---------------------------------------------------------
    % On r�-�crit par dessus les valeurs et string du GUI avec
    % les infos recueillis dans une s�ance pr�c�dante
    %---------------------------------------------------------
    function ecraseInfoBatchGUI(tO, V)
      % nom du tag des propri�t�s o� on sauvegarde une valeur
      propval ={'fichiermanuel','undosstousfich','dossousdoss','ecrase','changfich',...
                'changdoss','changtout','prefix','suffix'};
      % lecture de chacune de ces propri�t�s et sauvegarde dans une structure
      for U =1:length(propval)
        if isfield(V, propval{U})
          set(findobj('tag',propval{U}),'value',V.(propval{U}));
        end
      end
      % nom du tag des propri�t�s o� on sauvegarde une string
      propstr ={'choixfichier','editdossierfinal','editfichierpresuf','batchafaire'};
      % lecture de chacune de ces propri�t�s et sauvegarde dans une structure
      for U =1:length(propstr)
        if isfield(V, propstr{U})
          set(findobj('tag',propstr{U}),'string',V.(propstr{U}));
        end
      end
      % On fait afficher les s�lections avec "fl�che" pour les dossiers --> IN
      tO.afficheSelectionFichIN();
      % On fait afficher les s�lections avec "fl�che" pour les dossiers --> OUT
      tO.dossierFichierSortie(findobj('tag','BGfichOUT'));
      % On fait afficher les s�lections avec "fl�che" pour Pr�fixe/Sufixe du nouveau nom
      tO.changePosteRadio(findobj('tag','BGnomfichOUT'));
    end

    %----------------------------------------------------------
    % AFFICHE LA FL�CHE SUR LA S�LECTION DANS LE PSEUDO-UIGROUP
    % une petite fl�che indiquera la s�lection.
    %----------------------------------------------------------
    function afficheSelectionFichIN(tO)
      % on recherche les radiobutton qui appartiennent au groupe
      hBG =findobj('tag','BGfichIN');
      tmp =findobj('style','radiobutton', 'parent',hBG);
      % on flush le CDATA de tous les radiobutton
      set(tmp, 'cdata',[]);
      % on load l'image et on l'affiche pour le radiobutton s�lectionn�
      try
        ico =imread(which('ptiteflechdrte.bmp'),'BMP');
        set(tO.getSelectedObject(), 'cdata',ico);
      catch sss;
        % rien � faire pour Octave
      end
      % sous le uiButtonGroup, on affiche le nombre de fichier � traiter
      set(hBG,'title',[num2str(tO.Nfich) ' fichiers � traiter'])
    end

    %------------------------------------------------
    % CHANGE S�LECTION DE RADIOBUTTON DANS LE UIGROUP
    % une petite fl�che indiquera la s�lection.
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
        % rien � faire car Octave ne supporte pas encore le "cdata"
      end
    end

    %----------------------------------------------
    % D�-S�LECTION DES RADIOBUTTONS DANS LE UIGROUP
    % On efface les icones et SelectedObject = []
    % src  est le handle du uigroup
    %----------------------------------------------
    function resetPosteRadio(tO, src, varargin)
      % on recherche les radiobutton qui appartiennent au groupe
      tmp =findobj('style','radiobutton', 'parent',src);
      % on flush le CDATA de tous les radiobutton
      set(tmp, 'cdata',[]);
      % on remet la s�lection vide
      set(src,'SelectedObject',[]);
    end

    %-----------------------------------------------
    % S�lection de l'emplacement du fichier d'entr�e
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
      % En fonction du type de s�lection, on choisi quel fichier traiter
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
      set(ppa,'title',[num2str(tO.Nfich) ' fichiers � traiter']);
    end

    %----------------------------------------------------------
    % On fait la s�lection des fichiers � traiter manuellement 
    % et on inscrit le path complet dans la listbox.
    %----------------------------------------------------------
    function cok = afficheFichierManuel(tO)
      cok =true;
      lesmots ='Choix des fichiers � traiter';
      [fnom,pnom] =uigetfile({'*.mat','Fichier Analyse (*.mat)'},lesmots,'multiselect','on');
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
        cok =false;
        return;
      end
      % si on a choisi un seul fichier, il ne sera pas plac� dans une cellule
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
    % On choisi le dossier qui contient tous les fichiers � traiter (IN)
    % et on inscrit le path du dossier dans la listbox.
    %-------------------------------------------------------------------
    function cok = afficheDossier(tO)
      cok =false;
      lesmots ='Choix du dossier qui contient tous les fichiers � traiter';
      P = tO.selectionDir(lesmots);
      if ~isempty(P)
        % on affiche dans la listbox
        set(findobj('tag','choixfichier'),'value',1,'string',P);
        cok =true;
      end
    end

    %--------------------------------------------------------------------
    % S�lection d'un dossier
    % En entr�e     T  -->  titre de la fen�tre
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
    % S�lection de l'emplacement du fichier de sortie
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
    % EN Entr�e:  S  --> 'on' ou 'off'
    %--------------------------------------------------
    function afficheModifDossier(tO,S)
      set(findobj('tag','editdossierfinal'),'enable',S);
      set(findobj('tag','boutondossierfinal'),'enable',S);
    end

    %--------------------------------------------------
    % Afficher/cacher la modification du nom de fichier
    % EN Entr�e:  S  --> 'on' ou 'off'
    %--------------------------------------------------
    function afficheModifFichier(tO,S)
      set(findobj('tag','editfichierpresuf'),'enable',S);
      % on cherche les "enfants" � modifier
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
    % Ajouter une action � partir de la listbox
    %------------------------------------------
    function ajouterAction(tO, varargin)
      % lire la s�lection dans la listbox
      valchoix =get(findobj('tag','listbatchafaire'),'value');
      % sortir les noms d'action
      leschoix =tO.listChoixActions(valchoix);
      tO.ajoutAction(leschoix);
      % afficher la liste dans la listbox des actions s�lectionn�es
      tO.afficheListAction(0);
    end

    %---------------------------------------
    % Ajouter une action � partir d'une cell
    %---------------------------------------
    function ajoutAction(tO, meschoix)
      % on v�rifie que meschoix n'est pas vide
      if ~isempty(meschoix)
        % on va boucler tous les �l�ments de meschoix
        for U = 1:length(meschoix)
          % cr�ation d'un objet CAction
          tO.creerNouvelAction(meschoix{U});
        end
      end
    end

    %------------------------------
    % Effacer l'action s�lectionn�e
    %------------------------------
    function effacerAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on l'efface
      tO.effaceAction(V);
      % on remet � z�ro la propri�t� "pret"
      tO.mazPret(V);
      % on r�-affiche laliste
      tO.afficheListAction(0);
    end

    %-------------------------------------------------
    % Monter une action
    % pour d�placer vers le haut la tache s�lectionn�e
    %-------------------------------------------------
    function monterAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on la d�place
      tO.remonte(V);
      % on remet � z�ro la propri�t� "pret"
      tO.mazPret(V-1);
      tO.afficheListAction(-1);
    end

    %------------------------------------------------
    % Descendre une action
    % pour d�placer vers le bas la tache s�lectionn�e
    %------------------------------------------------
    function descendreAction(tO, varargin)
      % De quelle action s'agit-il
      V =get(findobj('tag','batchafaire'),'value');
      % on la d�place
      tO.redescend(V);
      % on remet � z�ro la propri�t� "pret"
      tO.mazPret(V);
      tO.afficheListAction(1);
    end

    %-----------------------------------------------
    % Modifier/Configurer une action
    % Lorsque l'on configure une action, il faut que
    % les actions pr�c�dentes aient �t� configur�es.
    %-----------------------------------------------
    function modifierAction(tO, varargin)
      % on s'assure qu'il y a des actions
      if tO.Naction > 0
        % alors, de quel action il s'agit
        v =get(findobj('tag','batchafaire'),'value');
      	% handle de l'action � configurer
        foo =tO.listAction{v};
        % on passe le bon handle du fichier virtuel � l'action
        foo.hfi =tO.listFichVirt{v};
        % il faut que les actions pr�c�dentes aient �t� configur�es
        if tO.isActionAvantPret(v)
          qui =tO.setTmpFichVirt(v);
        else
      	  hJ =CJournal.getInstance();
          hJ.ajouter('Il faut configurer les actions pr�c�dentes avant de configurer celle-ci!', tO.S);
      		return;
      	end
        if qui
          foo.afficheGUI();
        end
      end
    end

    %-------------------------------------------------------------
    % Comme il y a eu une modification majeure dans les param�tres
    % de l'action en cours de modification, on doit changer la
    % propri�t� "pret" des actions suivantes.
    %-------------------------------------------------------------
    function resetApres(tO)
      % il faut savoir quelle est l'action "courante"
      v =get(findobj('tag','batchafaire'),'value');
      tO.mazPret(v+1);
    end

    %-----------------------------------------------
    % Afficher la liste des actions s�lectionn�es
    % ordre nous permet de faire monter ou descendre
    % la s�lection dans la listbox
    %-----------------------------------------------
    function afficheListAction(tO,ordre)
      % on g�n�re la liste selon l'ordre entr�e dans tO.listAction
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
      % On appelle le journal pour l'�criture des �v�nements
      tO.S =0;
      hJ =CJournal.getInstance();
      hJ.ajouter(['Travail en lot, d�but: ' datestr(now)]);
      % v�rification des param d'entr�e avant de commencer
      if tO.verifGUI(hJ);
        % on commence � travailler en mode batch
        tO.tournezLaManivelle(hJ);
      else
        hJ.ajouter('Le traitement en batch n''a pas �t� effectu�.');
      end
    end

    %-----------------------------------
    % V�rification des param�tres du GUI, il y a 3 panels � v�rifier
    % FICHIER ENTR�E
    % FICHIER SORTIE
    % ACTION � FAIRE
    %-----------------------------------
    function OK = verifGUI(tO, J)
      OK =true;
      J.ajouter('V�rification des param�tres d''entr�es',tO.S);
      tO.S =tO.S+2;
      %---------------------
      % PARAM FICHIER ENTR�E
      %---------------------
      % recherche du radiobutton s�lection dans le uipanel des fichiers � traiter
      hfIN =tO.getSelectedObject();
      if isempty(hfIN)
        OK =false;
        J.ajouter('*** Il faut faire un choix de fichier � traiter', tO.S);
      end
      %---------------------
      % PARAM FICHIER SORTIE
      %---------------------
      hfOUT =get(findobj('tag','BGfichOUT'),'SelectedObject');
      OK =(OK & tO.verifFsortie(hfOUT,J));
      %---------------------
      % PARAM ACTION � FAIRE
      %---------------------
      if isempty(get(findobj('tag','batchafaire'),'string'))
        OK =false;
        J.ajouter('*** Il faut choisir au moins une action pour pouvoir traiter!!!', tO.S);
      end
      % Si il n'y a pas d'erreur, on fabrique les listes de fichier entr�e/sorties
      if OK
        % On fabrique la liste des fichiers � traiter
        tO.fabricListFichierIn(hfIN);
        % Puis on fabrique la liste des fichiers de sortie
        if tO.Nfich < 1
          % il n'y a pas de fichier dans notre s�lection
          OK =false;
          J.ajouter('*** Le dossier s�lectionn� ne contient pas de fichier � traiter', tO.S);
        else
          % fabrication de la liste des fichiers de sortie
          tO.fabricListFichierOut(hfOUT,hfIN);
          % ON EST RENDU � V�RIFIER LES ACTIONS
          if tO.isActionsPretes()
            % rien pour l'instant
          else
            OK =false;
            J.ajouter('*** Il faut configurer toutes les actions � ex�cuter', tO.S);
          end
        end
      end
      tO.S =max(0,tO.S-2);
    end

    %-------------------------------------------------------------------------
    % Trouver le radiobutton qui est s�lectionn� dans notre Pseudo-ButtonGroup
    % On retourne le handle du radiobutton ou []
    %-------------------------------------------------------------------------
    function V = getSelectedObject(tO)
      Ppa =findobj('tag','BGfichIN');
      V =findobj('parent',Ppa, 'style','radiobutton','value',1);
    end

    %--------------------------------------------
    % On fabrique la liste des fichiers � traiter
    % En entr�e, FIN --> handle du radiobutton
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
          % lorsqu'il n'y a qu'un choix on a une string plut�t qu'une cellule
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

    % S�lection du dossier de sortie
    %
    function choixDossierSortie(tO,varargin)
      lesmots ='Choix du dossier pour la sauvegarde des fichiers � traiter';
      P = tO.selectionDir(lesmots);
      if ~isempty(P)
        % on affiche dans la listbox
        set(findobj('tag','editdossierfinal'),'value',1,'string',P);
      end
    end

    %--------------------------------------------------------
    % V�rification des infos du uipanel de fichier de sortie
    % En Entr�e, hF  est le handle du radiobutton s�lectionn�
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
          hL.ajouter('*** Il faut donner un pr�fixe/suffixe pour le nouveau nom de fichier de sortie',tO.S)
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
    % En entr�e: hFo  est le handle du radiobutton s�lectionn� pour le dossier de sortie
    %            hFi  est le handle du radiobutton s�lectionn� pour le nom de fichier
    %-----------------------------------------------------------------------------------
    function fabricListFichierOut(tO,hFo,hFi)
      % quel est le choix de dossier de sortie s�lectionn�
      letag =get(hFo, 'tag');
      % on va travailler sur une liste temporaire
      Ltmp =tO.listFichIN;
      % MODIFICATION du nom de fichier
      if strncmpi(letag,'changfich',9) | strncmpi(letag,'changtout',9)
        % mot � ajouter en pr�/suf(fixe) au nom de fichier
        txt =deblank(get(findobj('Tag','editfichierpresuf'),'string'));
        % pr�fixe ou suffixe
        pfixtag =get(get(findobj('tag','BGnomfichOUT'),'SelectedObject'),'tag');
        pfix =false;
        if strncmpi(pfixtag,'prefix',6)
          pfix =true;
        end
        % modification de la partie "nom de fichier"
        for U =1:tO.Nfich
          % on s�pare le path/nom fichier/extension
          [a,b,c] =fileparts(Ltmp{U});
          if pfix
            % la modif s'ajoute comme un pr�fixe
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
        % on va discr�miner en fonction du type de s�lection faite pour les fichiers d'entr�e
        switch get(hFi, 'tag')
          case {'fichiermanuel','undosstousfich'}
            % ici on a juste � changer le nom de dossier complet
            for U =1:tO.Nfich
              % on s�pare le path/nom fichier/extension
              [a,b,c] =fileparts(Ltmp{U});
              Ltmp{U} =fullfile(nouvd,[b c]);
            end
          case 'dossousdoss'
            % ancien nom pour le dossier, c'est la partie � modifier
            ancd =get(findobj('tag','choixfichier'),'string');
            % longueur de la string
            Lancd =length(ancd);
            for U =1:tO.Nfich
              % on s�pare le path/nom fichier/extension
              [a,b,c] =fileparts(Ltmp{U});
              Ltmp{U} =fullfile(nouvd,a(Lancd+1:end), [b c]);
            end
        end
      end
      tO.listFichOUT =Ltmp;
      tO.setDossierTop(Ltmp);
    end

    % D�termination du dossier de sortie "top niveau"
    % En entr�e  liss  -->  liste des dossier\fichier de sortie
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
    % Fonction r�cursive pour d�manteler tous les fichiers ".mat"
    % au travers des dossiers/sous-dossiers
    % En entr�e:  lepath  est le dossier � inspecter
    %             rep     est la liste des fichiers "dossier\fichier.mat"
    % En sortie   rep      "   "
    %--------------------------------------------------------------------
    function rep = listFichRecursif(tO,lepath,rep)
      % on conserve le dossier de d�part
      pIN =pwd();
      % on se place dans le dossier � inspecter
      cd(lepath);
      % lecture du dossier courant
      lfich =dir();
      % on commence � 3 car les 2 premi�res sont: "." et ".."
      for U =3:length(lfich)
        [a,b,ext] =fileparts(lfich(U).name);
        if lfich(U).isdir
          % il s'agit d'un dossier
          rep =tO.listFichRecursif(lfich(U).name,rep);
        elseif strncmpi(ext, '.mat', 4)
          rep{end+1,1} =fullfile(pwd(), lfich(U).name);
        end
      end
      % on retourne au dossier de d�part avant de quitter
      cd (pIN);
    end

  end  % methods

end
