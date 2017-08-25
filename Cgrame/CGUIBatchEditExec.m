%
% classdef CGUIBatchEditExec < CBasePourFigureAnalyse & CParamBatchEditExec
%
% Classe de gestion du GUI GUIBatchEditExec
% prendra en charge tous les callback du GUI
%
% METHODS
%       initGui(tO)
%       changePosteRadio(tO, src, varargin)
%       dossierFichierSortie(tO, src, varargin)
%       afficheModifDossier(tO,S)
%       afficheModifFichier(tO,S)
%       ajouterAction(tO, varargin)
%
classdef CGUIBatchEditExec < CBasePourFigureAnalyse & CParamBatchEditExec

  methods

    %-------------------
    % Création du GUI
    %-------------------
    function initGui(tO)
      tO.fig =GUIBatchEditExec(tO);
    end

    %------------------------------------------------
    % CHANGE SÉLECTION DE RADIOBUTTON DANS LE UIGROUP
    % une petite flèche indiquera la sélection.
    % src  est le handle du uigroup
    %------------------------------------------------
    function changePosteRadio(tO, src, varargin)
      % on recherche les radiobutton qui appartiennent au groupe
      tmp =findobj('style','radiobutton', 'parent',src);
      % on flush le CDATA de tous les radiobutton
      set(tmp, 'cdata',[]);
      % on load l'image et on l'affiche
      ico =imread('ptiteflechdrte.bmp','BMP');
      set(get(src,'SelectedObject'), 'cdata',ico);
    end

    %------------------------------------------------
    % Sélection de l'emplacement du fichier d' entrée
    %------------------------------------------------
    function dossierFichierEntree(tO, src, varargin)
      tO.changePosteRadio(src);
      foo =get(src,'SelectedObject');
      % En fonction du type de sélection, on choisi quel fichier traiter
      switch get(foo,'tag')
      case 'fichiermanuel'
        % choix des fichiers manuellement
        tO.afficheFichierManuel();
      case 'undosstousfich'
        % tous les fichiers sont dans un dossier
        tO.afficheDossier();
      case 'dossousdoss'
        % ici on va descendre au travers des sous-dossiers aussi
        tO.afficheDossier();
      end
    end

    %----------------------------------------------------------
    % On fait la sélection des fichiers à traiter manuellement 
    % et on inscrit le path complet dans la listbox.
    %----------------------------------------------------------
    function afficheFichierManuel(tO)
      lesmots ='Choix des fichiers à traiter';
      [fnom,pnom] =uigetfile({'*.mat','Fichier Analyse (*.mat)'},lesmots,'multiselect','on');
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
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

    %--------------------------------------------------------------
    % On choisi le dossier qui contient tous les fichiers à traiter
    % et on inscrit le path du dossier dans la listbox.
    %--------------------------------------------------------------
    function afficheDossier(tO)
      lesmots ='Choix du dossier qui contient tous les fichiers à traiter';
      pnom =uigetdir(lesmots);
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
        return;
      end
      % on affiche dans la listbox
      set(findobj('tag','choixfichier'),'value',1,'string',pnom);
    end

    %------------------------------------------------
    % Sélection de l'emplacement du fichier de sortie
    %------------------------------------------------
    function dossierFichierSortie(tO, src, varargin)
      tO.changePosteRadio(src);
      % il faut afficher ou cacher certain uicontrol
      switch get(get(src,'SelectedObject'),'tag')
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
      set(get(findobj('tag','BGnomfichOUT'),'children'),'enable',S);
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

    %-----------------------------------
    % Effacer une action
    %-----------------------------------
    function effacerAction(tO, varargin)
      V =get(findobj('tag','batchafaire'),'value');
      tO.effaceAction(V);
      tO.afficheListAction(0);
    end

    %-------------------------------------------------
    % Monter une action
    % pour déplacer vers le haut la tache sélectionnée
    %-------------------------------------------------
    function monterAction(tO, varargin)
      V =get(findobj('tag','batchafaire'),'value');
      tO.remonte(V);
      tO.afficheListAction(-1);
    end

    %------------------------------------------------
    % Descendre une action
    % pour déplacer vers le bas la tache sélectionnée
    %------------------------------------------------
    function descendreAction(tO, varargin)
      V =get(findobj('tag','batchafaire'),'value');
      tO.redescend(V);
      tO.afficheListAction(1);
    end

    %-----------------------------------
    % Modifier une action
    %-----------------------------------
    function modifierAction(tO, varargin)
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
      hJ =CJournal.getInstance();
      hJ.ajouter(['Travail en lot, début: ' datestr(now)]);
    end

  end  % methods

end
