%
% classdef CCalculCOPoptimaBat < CCalculCOPoptima
%
% Classe pour le calcul du COP pour la plateforme Optima
% Il sera appel� pour la configuration avec le GUICalculCOPoptima
% � la sortie du GUI il faudra r�cup�rer les param�tres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CCalculCOPoptimaBat()  % CONSTRUCTOR
%              aFaire(tO,queHacer,H1)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitGUI(tO,S)
%              sauveGUI(tO,varargin)
%
classdef CCalculCOPoptimaBat < CCalculCOPoptima

  properties
    % handle de l'action qui l'a "call�"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CCalculCOPoptimaBat()
      % pour l'instant, rien � faire
    end

    %---------------------------------------------------
    % Fonction qui re�oit les requ�te de travail � faire
    % En Entr�e
    %   queHacer  --> que faire � l'ouverture
    %---------------------------------------------------
    function aFaire(tO,queHacer,H1)
      if exist('queHacer')
        switch queHacer
          case 'configuration'
            % En entr�e, H1  --> handle d'un objet CAction(), celui qui nous a appel�
            tO.hAct =H1;
            % on appelle le GUI
            H2 =CBatchEditExec.getInstance();
            ftmp =H2.tmpFichVirt;
            tO.onDessine(ftmp.Hdchnl.Listadname);
          case 'auTravail'
          	% En entr�e, H1  --> handle du fichier de travail
          	tO.cParti(H1,tO.hAct.pact,true);
        end
      end
    end

    %------------------------------------------
    % On pr�sente le GUI
    % En entr�e L  --> Liste des noms de canaux
    %------------------------------------------
    function onDessine(tO,L)
      % on appelle le GUI
      GuiCalculCOP(tO,L);
      % on modifie le "callback" de fermeture de la fen�tre
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI);
      % si on a d�j� des param il n'y a rien � faire
    end

    %-------------------------------------------------------
    % Apr�s avoir configur�, si on revient MODIFIER le GUI
    % il faut v�rifier car le nb de canaux a chang�
    % En entr�e  N  --> structure des nouvelles infos du GUI
    %-------------------------------------------------------
    function reagirSiModifMajeur(tO,N)
      % pour simplifier l'�criture
      A =tO.hAct;
      if ~isempty(A.pact)
        % si on a chang� les canaux d'entr�s
        if length(A.pact.lesCan) == length(N.lesCan)
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

    %---------------------------------------------------------
    % On initialise les valeurs du GUI avec celles sauvegard�s
    % En entr�e  S  --> structure contenant les params du GUI
    %---------------------------------------------------------
    function reInitGUI(tO,S)
      if isstruct(S)
        % on s'assure que les canaux choisis existent
        can =get(findobj('tag','ChoixCanFiltre'),'string');
        % on supprime ceux qui ex�dent
        S.lescan(S.lescan>length(can)) =[];
        % choix du type de filtre
        set(findobj('tag','QuelFiltre'),'Value',S.afaire);
        % s�lection des canaux
        set(findobj('tag','ChoixCanFiltre'),'value',S.lescan);
        % on �crit ou non sur le canal source
        set(findobj('tag','memeCan'),'value',S.nouveau);
        % ordre du filtre
        set(findobj('tag','EditOrdreFiltre'),'String',S.ord);
        % fr�quence de coupure en fonction du type de filtrage � faire
        set(findobj('tag','EditFreqCoupe1'),'String',S.frc1);
        set(findobj('tag','EditFreqCoupe2'),'String',S.frc2);
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des param�tres du GUI afin de pouvoir y revenir
    % ou de d�marrer le travail � faire.
    % De plus, on modifie le fichier virtuel correspondant
    %-----------------------------------------------------------
    function sauveGUI(tO,varargin)
      hJ =CJournal.getInstance();
      hB =CBatchEditExec.getInstance();
      % synchronisation des infos du GUI
      tO.syncObjetConGui();
      % "analyse" des canaux, est-ce qu'ils sont "acceptables"?
      foo =tO.verifNbCan();
      canal =foo.lesCan;
      % Attention au nombre de canux
      if isempty(canal)
        hJ.ajouter('Il faut s�lectionner 3 ou 6 canaux!!!', hB.S);
        return;
      end
      % Si on choisit le calcul du COG, Fx et/ou Fy sont n�cessaires
      if ~tO.COPseul & ~foo.COG
        hJ.ajouter('Il faut s�lectionner un canal pour Fx et/ou Fy', hB.S);
        return;
      end
      % Pour simplifier l'�criture
      ftmp =hB.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % cr�ation des canaux
      hdchnl.duplic([canal canal(3) canal(3)]);
      hdchnl.adname{end-1} ='CPx';
      hdchnl.adname{end} ='CPy';
      nbcan =length(canal)+2;
      nCanal =nbcan-1;             % en fait c'est: length(canal)+2-1
      suivant =vg.nad+1;
      %---         Do.. pour Data Output
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
      % Calcul du centre de gravit�...
      if foo.COG
        % cr�ation des canaux COG
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
      % on met � jour la liste des noms de canaux
      hdchnl.ResetListAdname();
      % V�rification si c'est une modification au lieu d'une configuration
      tO.reagirSiModifMajeur(foo);
      % on sauvegarde les infos dans l'objet CAction associ�
      tO.hAct.sauveConfig(foo);
      % avant de quitter, on efface le GUI
      delete(tO.fig);
      tO.fig =[];
    end

  end  % methods

end
