%
% classdef CDifferBat < CDiffer
%
% Classe pour faire les travaux de differ en mode Batch
% Il sera appelé pour la configuration avec le GUIDiffer
% à la sortie du GUI il faudra récupérer les paramètres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CDifferBat()  % CONSTRUCTOR
%              aFaire(tO,queHacer,H1)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitGUI(tO,S)
%              sauveGUI(tO,varargin)
%
classdef CDifferBat < CDiffer

  properties
    % handle de l'action qui l'a "callé"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CDifferBat()
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
            tO.onDessine(ftmp.Vg.nad, ftmp.Hdchnl.Listadname);
          case 'auTravail'
          	% En entrée, H1  --> handle du fichier de travail
          	tO.cParti(H1,tO.hAct.pact);
        end
      end
    end

    %------------------------------------------
    % On présente le GUI
    % En entrée N  --> nombre de canaux A/D
    %           L  --> Liste des noms de canaux
    %------------------------------------------
    function onDessine(tO,N,L)
      % on appelle le GUI
      GUIDiffer(tO,N,L);
      % on modifie le "callback" de fermeture de la fenêtre
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI)
      % si on a déjà des param on les applique
      if ~isempty(tO.hAct.pact)
        tO.reInitGUI(tO.hAct.pact);
      end
    end

    %-------------------------------------------------------
    % Après avoir configuré, si on revient modifier le GUI
    % il faut vérifier si le nb de canaux a changé
    % En entrée  N  --> structure des nouvelles infos du GUI
    %-------------------------------------------------------
    function reagirSiModifMajeur(tO,N)
      % pour simplifier l'écriture
      A =tO.hAct;
      if ~isempty(A.pact)
        % si on a coché/décoché l'écriture sur le canal source ou
        % si on doit créer un nouveau canal et que le nb de canaux a changé
        if ~(A.pact.ovw == N.ovw) | (~N.ovw & ~(A.pact.nad == N.nad))
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
        can =get(findobj('tag','ListeCan'),'string');
        % on supprime ceux qui exèdent
        S.nad(S.nad>length(can)) =[];
        % sélection des canaux
        set(findobj('tag','ListeCan'),'value',S.nad);
        % on écrit ou non sur le canal source
        set(findobj('tag','memeCan'),'value',S.ovw);
        % largeur de fenêtre pour le filtrage
        set(findobj('Tag','LargeurFenLissage'),'string',S.lar);
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des paramètres du GUI afin de pouvoir y revenir
    % ou de démarrer le travail à faire.
    % De plus, on modifie le fichier virtuel correspondant
    %
    function sauveGUI(tO,varargin)
      % lecture des infos du GUI
      foo.nad =get(findobj('tag','ListeCan'),'value');
      foo.ovw =get(findobj('tag','memeCan'),'value');
      foo.lar =get(findobj('Tag','LargeurFenLissage'),'string');
      % est-ce que les params sont "acceptables"?
      if isempty(str2num(foo.lar)) | str2num(foo.lar) < 0
        hJ =CJournal.getInstance();
        hJ.ajouter('La valeur de la largeur de fenêtre n''est pas un nombre entier!', tO.S);
        return;
      end
      % Pour simplifier l'écriture
      H2 =CBatchEditExec.getInstance();
      ftmp =H2.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % si on ne ré-écrit pas dans les canaux sources, il faut en ajouter
      nombre =length(foo.nad);
      if ~foo.ovw
        hdchnl.duplic(foo.nad);
        Ncan =vg.nad+1:vg.nad+nombre;
        vg.nad =vg.nad+nombre;
      else
      	Ncan =foo.nad;
      end
      % puis on ré-assigne un nouveau nom tenant compte de l'opération à faire
      for U =1:nombre
        hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Ncan(U)})];
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
