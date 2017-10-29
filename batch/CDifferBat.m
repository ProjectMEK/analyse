%
% classdef CDifferBat < CDiffer
%
% Classe pour faire les travaux de differ en mode Batch
% Il sera appel� pour la configuration avec le GUIDiffer
% � la sortie du GUI il faudra r�cup�rer les param�tres
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
    % handle de l'action qui l'a "call�"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CDifferBat()
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
            tO.onDessine(ftmp.Vg.nad, ftmp.Hdchnl.Listadname);
          case 'auTravail'
          	% En entr�e, H1  --> handle du fichier de travail
          	tO.cParti(H1,tO.hAct.pact);
        end
      end
    end

    %------------------------------------------
    % On pr�sente le GUI
    % En entr�e N  --> nombre de canaux A/D
    %           L  --> Liste des noms de canaux
    %------------------------------------------
    function onDessine(tO,N,L)
      % on appelle le GUI
      GUIDiffer(tO,N,L);
      % on modifie le "callback" de fermeture de la fen�tre
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI)
      % si on a d�j� des param on les applique
      if ~isempty(tO.hAct.pact)
        tO.reInitGUI(tO.hAct.pact);
      end
    end

    %-------------------------------------------------------
    % Apr�s avoir configur�, si on revient modifier le GUI
    % il faut v�rifier si le nb de canaux a chang�
    % En entr�e  N  --> structure des nouvelles infos du GUI
    %-------------------------------------------------------
    function reagirSiModifMajeur(tO,N)
      % pour simplifier l'�criture
      A =tO.hAct;
      if ~isempty(A.pact)
        % si on a coch�/d�coch� l'�criture sur le canal source ou
        % si on doit cr�er un nouveau canal et que le nb de canaux a chang�
        if ~(A.pact.ovw == N.ovw) | (~N.ovw & ~(A.pact.nad == N.nad))
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
        can =get(findobj('tag','ListeCan'),'string');
        % on supprime ceux qui ex�dent
        S.nad(S.nad>length(can)) =[];
        % s�lection des canaux
        set(findobj('tag','ListeCan'),'value',S.nad);
        % on �crit ou non sur le canal source
        set(findobj('tag','memeCan'),'value',S.ovw);
        % largeur de fen�tre pour le filtrage
        set(findobj('Tag','LargeurFenLissage'),'string',S.lar);
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des param�tres du GUI afin de pouvoir y revenir
    % ou de d�marrer le travail � faire.
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
        hJ.ajouter('La valeur de la largeur de fen�tre n''est pas un nombre entier!', tO.S);
        return;
      end
      % Pour simplifier l'�criture
      H2 =CBatchEditExec.getInstance();
      ftmp =H2.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % si on ne r�-�crit pas dans les canaux sources, il faut en ajouter
      nombre =length(foo.nad);
      if ~foo.ovw
        hdchnl.duplic(foo.nad);
        Ncan =vg.nad+1:vg.nad+nombre;
        vg.nad =vg.nad+nombre;
      else
      	Ncan =foo.nad;
      end
      % puis on r�-assigne un nouveau nom tenant compte de l'op�ration � faire
      for U =1:nombre
        hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Ncan(U)})];
      end
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
