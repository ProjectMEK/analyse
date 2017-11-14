%
% classdef CCalculCOPcommunBat < handle
%
% Classe pour le calcul du COP pour la plateforme amti
% Il sera appelé pour la configuration avec le CalculCOPGUI
% à la sortie du GUI il faudra récupérer les paramètres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CCalculCOPcommunBat()  % CONSTRUCTOR
%              cPartiCommun(tO,hF,S,Bat)
%              syncObjetConGuiCommun(tO)
%          V = verifNbCanCommun(tO)
%              avantDeQuitterCommun(tO)
%          V = lectureTotalPropCommun(tO)
%              aFaire(tO,queHacer,H1)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitProp(tO,S)
%              sauveGUI(tO,varargin)
%
classdef CCalculCOPcommunBat < handle

  properties
    % handle de l'action qui l'a "callé"
    hAct =[];
  end  %properties

  methods

    %----------------------------------
    % METHOD à overloader par le parent
    %----------------------------------
    function cPartiCommun(tO,hF,S,Bat)
      %
    end
    function syncObjetConGuiCommun(tO)
      %
    end
    function V = verifNbCanCommun(tO)
      %
    end
    function V = lectureTotalPropCommun(tO)
      %
    end
    function avantDeQuitterCommun(tO)
      %
    end
    function V = getCOPseulCommun(tO)
      %
    end

    %---------------------------------------------------
    % Fonction qui reçoit les requête de travail à faire
    % En Entrée
    %   queHacer  --> que faire à l'ouverture
    %---------------------------------------------------
    function aFaire(tO,queHacer,H1)
      if exist('queHacer')
        switch queHacer
          case 'configuration'
            % En entrée, H1  --> handle d'un objet CAction(), celui qui nous a appelé
            tO.hAct =H1;
            % on appelle le GUI
            H2 =CBatchEditExec.getInstance();
            ftmp =H2.tmpFichVirt;
            tO.onDessine(ftmp.Hdchnl.Listadname);
          case 'auTravail'
          	% En entrée, H1  --> handle du fichier de travail
          	tO.cPartiCommun(H1,tO.hAct.pact,true);
        end
      end
    end

    %------------------------------------------
    % On présente le GUI
    % En entrée L  --> Liste des noms de canaux
    %------------------------------------------
    function onDessine(tO,L)
      % on appelle le GUI
      GuiCalculCOP(tO,L);
      % on modifie le "callback" de fermeture de la fenêtre
      set(findobj('Name','Calcul  COP-COG'),'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI);
      % si on a déjà des param il n'y a rien à faire
    end

    %-------------------------------------------------------
    % Après avoir configuré, si on revient MODIFIER le GUI
    % il faut vérifier car le nb de canaux a changé
    % En entrée  N  --> structure des nouvelles infos du GUI
    %-------------------------------------------------------
    function reagirSiModifMajeur(tO,N)
      % pour simplifier l'écriture
      A =tO.hAct;
      if ~isempty(A.pact)
        % si on a changé les canaux d'entrés
        if length(A.pact.lesCan) == length(N.lesCan)
          % on a le même nombre de canaux, mais ils peuvent avoir été changés
          if ~(A.pact.lesCan == N.lesCan)
            hB =CBatchEditExec.getInstance();
            hB.resetApres();
          end
        else
          hB =CBatchEditExec.getInstance();
          hB.resetApres();
        end
      end
    end

    %------------------------------------------------------------------
    % On initialise les propriétés avec celles sauvegardés
    % En entrée  S  --> structure contenant les propriétés de la classe
    %------------------------------------------------------------------
    function reInitProp(tO,S)
      if isstruct(S)
      	P =fieldnames(tO);
      	for U =1:length(P)
      	  if isfield(S,P{U})
      	  	tO.(P{U}) =S.(P{U});
      	  end
      	end
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des paramètres du GUI afin de pouvoir y revenir
    % ou de démarrer le travail à faire.
    % De plus, on modifie le fichier virtuel correspondant
    %-----------------------------------------------------------
    function sauveGUI(tO,varargin)
      hJ =CJournal.getInstance();
      hB =CBatchEditExec.getInstance();
      % synchronisation des infos du GUI
      tO.syncObjetConGuiCommun();
      % "analyse" des canaux, est-ce qu'ils sont "acceptables"?
      foo =tO.verifNbCanCommun();
      canal =foo.lesCan;
      % Attention au nombre de canux
      if isempty(canal)
        hJ.ajouter('Il faut sélectionner 3 ou 6 canaux!!!', hB.S);
        return;
      end
      % Si on choisit le calcul du COG, Fx et/ou Fy sont nécessaires
      if ~tO.getCOPseulCommun() & ~foo.COG
        hJ.ajouter('Il faut sélectionner un canal pour Fx et/ou Fy', hB.S);
        return;
      end
      % Pour simplifier l'écriture
      ftmp =hB.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % création des canaux
      hdchnl.duplic([canal canal(3) canal(3)]);
      hdchnl.adname{end-1} ='CPx';
      hdchnl.adname{end} ='CPy';
      nbcan =length(canal)+2;
      nCanal =nbcan-1;             % en fait c'est: length(canal)+2-1
      suivant =vg.nad+1;
      % Nouveau canaux
      if length(canal) == 6
        hdchnl.adname{end-nCanal} ='New_Fx'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_Fy'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_Fz'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_Mx'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_My'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_Mz'; suivant =suivant+1;
      elseif length(canal) == 3
        hdchnl.adname{end-nCanal} ='New_Fz'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_Mx'; nCanal =nCanal-1; suivant =suivant+1;
        hdchnl.adname{end-nCanal} ='New_My'; suivant =suivant+1;
      end
      % pour Cpx et Cpy
      cpx =suivant;
      suivant =suivant+1;
      % Calcul du centre de gravité...
      if foo.COG
        % création des canaux COG
        if foo.canFx > 0
          hdchnl.duplic(cpx);
          hdchnl.adname{end} ='CGx';
          suivant =suivant+1;
        end
        if foo.canFy > 0
          hdchnl.duplic(cpx+1);
          hdchnl.adname{end} ='CGy';
          suivant =suivant+1;
        end
      end
      vg.nad =suivant;
      % on met à jour la liste des noms de canaux
      hdchnl.ResetListAdname();
      % Vérification si c'est une modification au lieu d'une configuration
      tO.reagirSiModifMajeur(foo);
      % Relecture du GUI et on sauvegarde les infos dans l'objet CAction associé
      foo.par =tO.lectureTotalPropCommun();
      tO.hAct.sauveConfig(foo);
      % avant de quitter, on efface le GUI
      tO.avantDeQuitterCommun();
    end

  end  % methods

end
