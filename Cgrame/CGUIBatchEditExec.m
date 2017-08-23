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
    % Cr�ation du GUI
    %-------------------
    function initGui(tO)
      tO.fig =GUIBatchEditExec(tO);
    end

    %------------------------------------------------
    % CHANGE S�LECTION DE RADIOBUTTON DANS LE UIGROUP
    % une petite fl�che indiquera la s�lection.
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
    % S�lection de l'emplacement du fichier d' entr�e
    %------------------------------------------------
    function dossierFichierEntree(tO, src, varargin)
      tO.changePosteRadio(src);
      foo =get(src,'SelectedObject');
      % En fonction du type de s�lection, on choisi quel fichier traiter
      switch get(foo,'tag')
      case 'fichiermanuel'
        % choix des fichiers manuellement
        tO.afficheFichierManuel();
      case 'undosstousfich'
        tO.afficheDossier();
      case 'dossousdoss'
        tO.afficheDossier();
      end
    end

    %----------------------------------------------------------
    % On fait la s�lection des fichiers � traiter manuellement 
    % et on inscrit le path complet dans la listbox.
    %----------------------------------------------------------
    function afficheFichierManuel(tO)
      lesmots ='Choix des fichiers � traiter';
      [fnom,pnom] =uigetfile({'*.mat','Fichier Analyse (*.mat)'},lesmots,'multiselect','on');
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
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

    %--------------------------------------------------------------
    % On choisi le dossier qui contient tous les fichiers � traiter
    % et on inscrit le path du dossier dans la listbox.
    %--------------------------------------------------------------
    function afficheDossier(tO)
      lesmots ='Choix du dossier qui contient tous les fichiers � traiter';
      pnom =uigetdir(lesmots);
      % on est sortie en annulant la commande (aucun choix)
      if ~ischar(pnom)
        return;
      end
      % on affiche dans la listbox
      set(findobj('tag','choixfichier'),'value',1,'string',pnom);
    end

    %------------------------------------------------
    % S�lection de l'emplacement du fichier de sortie
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
      set(get(findobj('tag','BGnomfichOUT'),'children'),'enable',S);
    end

    %-----------------------------------
    % Ajouter une action
    %-----------------------------------
    function ajouterAction(tO, varargin)
    end

    %-----------------------------------
    % Effacer une action
    %-----------------------------------
    function effacerAction(tO, varargin)
    end

    %-------------------------------------------------
    % Monter une action
    % pour d�placer vers le haut la tache s�lectionn�e
    %-------------------------------------------------
    function monterAction(tO, varargin)
    end

    %------------------------------------------------
    % Descendre une action
    % pour d�placer vers le bas la tache s�lectionn�e
    %------------------------------------------------
    function descendreAction(tO, varargin)
    end

    %-----------------------------------
    % Modifier une action
    %-----------------------------------
    function modifierAction(tO, varargin)
    end

  end  % methods

end
