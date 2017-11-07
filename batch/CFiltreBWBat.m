%
% classdef CFiltreBWBat < CFiltreBW
%
% Classe pour filtrer les canaux (avec un ButterWorth) en mode Batch
% Il sera appelé pour la configuration avec le GUIFiltreBW
% à la sortie du GUI il faudra récupérer les paramètres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CFiltreBWBat()  % CONSTRUCTOR
%              aFaire(tO,queHacer,H1)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitGUI(tO,S)
%              sauveGUI(tO,varargin)
%
classdef CFiltreBWBat < CFiltreBW

  properties
    % handle de l'action qui l'a "callé"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CFiltreBWBat()
      % pour l'instant, rien à faire
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
          	tO.cParti(H1,tO.hAct.pact,true);
        end
      end
    end

    %------------------------------------------
    % On présente le GUI
    % En entrée L  --> Liste des noms de canaux
    %------------------------------------------
    function onDessine(tO,L)
      % on appelle le GUI
      GUIFiltreBW(tO,L);
      % on modifie le "callback" de fermeture de la fenêtre
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI)
      % si on a déjà des param on les applique
      if ~isempty(tO.hAct.pact)
        tO.reInitGUI(tO.hAct.pact);
        tO.quelChoix(findobj('tag','QuelFiltre'));
      end
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
        % si on a coché/décoché l'écriture sur le canal source ou
        % si on doit créer un nouveau canal et que le nb de canaux a changé
        if ~(A.pact.nouveau == N.nouveau) | (~N.nouveau & (~(length(A.pact.lescan) == length(N.lescan)) | ~(A.pact.lescan == N.lescan)) )
          hB =CBatchEditExec.getInstance();
          hB.resetApres();
        end
      end
    end

    %---------------------------------------------------------
    % On initialise les valeurs du GUI avec celles sauvegardés
    % En entrée  S  --> structure contenant les params du GUI
    %---------------------------------------------------------
    function reInitGUI(tO,S)
      if isstruct(S)
        % on s'assure que les canaux choisis existent
        can =get(findobj('tag','ChoixCanFiltre'),'string');
        % on supprime ceux qui exèdent
        S.lescan(S.lescan>length(can)) =[];
        % choix du type de filtre
        set(findobj('tag','QuelFiltre'),'Value',S.afaire);
        % sélection des canaux
        set(findobj('tag','ChoixCanFiltre'),'value',S.lescan);
        % on écrit ou non sur le canal source
        set(findobj('tag','memeCan'),'value',S.nouveau);
        % ordre du filtre
        set(findobj('tag','EditOrdreFiltre'),'String',S.ord);
        % fréquence de coupure en fonction du type de filtrage à faire
        set(findobj('tag','EditFreqCoupe1'),'String',S.frc1);
        set(findobj('tag','EditFreqCoupe2'),'String',S.frc2);
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des paramètres du GUI afin de pouvoir y revenir
    % ou de démarrer le travail à faire.
    % De plus, on modifie le fichier virtuel correspondant
    %-----------------------------------------------------------
    function sauveGUI(tO,varargin)
      % lecture des infos du GUI
      foo.afaire =get(findobj('tag','QuelFiltre'),'Value');
      foo.lescan =get(findobj('tag','ChoixCanFiltre'),'Value');
      foo.nouveau =get(findobj('tag','EcraseCanal') ,'Value');     % on écrase le canal source
      foo.ord =get(findobj('tag','EditOrdreFiltre'),'String');
      foo.frc1 =get(findobj('tag','EditFreqCoupe1'),'String');
      foo.frc2 =get(findobj('tag','EditFreqCoupe2'),'String');
      nombre =length(foo.lescan);
      % Pour simplifier l'écriture
      H2 =CBatchEditExec.getInstance();
      ftmp =H2.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % est-ce que les params sont "acceptables"?
      try
        for U=1:nombre
          tO.verifFreq(hdchnl,foo.afaire,foo.lescan(U),1,foo.frc1,foo.frc2)
        end
      catch LEbien
        hJ =CJournal.getInstance();
        hB =CBatchEditExec.getInstance();
        hJ.ajouter('Les fréquences ne peuvent dépasser la moitié des fréquences d''échantillonnages.', hB.S);
        return;
      end
      % si on ne ré-écrit pas dans les canaux sources, il faut en ajouter
      if ~foo.nouveau
        hdchnl.duplic(foo.lescan);
        Ncan =vg.nad+1:vg.nad+nombre;
        vg.nad =vg.nad+nombre;
      else
      	Ncan =foo.lescan;
      end
      % puis on ré-assigne un nouveau nom tenant compte de l'opération à faire
      for U =1:nombre
        hdchnl.adname{Ncan(U)} =tO.nouveauNom(hdchnl.adname{Ncan(U)}, foo.afaire);
      end
      % on met à jour la liste des noms de canaux
      hdchnl.ResetListAdname();
      % Vérification si c'est une modification au lieu d'une configuration
      tO.reagirSiModifMajeur(foo);
      % on sauvegarde les infos dans l'objet CAction associé
      tO.hAct.sauveConfig(foo);
      % avant de quitter, on efface le GUI
      delete(tO.fig);
      tO.fig =[];
    end

  end  % methods

end
