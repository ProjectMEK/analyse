%
% classdef CSuppCanBat < CSuppCan
%
% Classe pour supprimer/conserver les canaux en mode Batch
% Il sera appel� pour la configuration avec le GUISuppCan
% � la sortie du GUI il faudra r�cup�rer les param�tres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CSuppCanBat()  % CONSTRUCTOR
%              aFaire(tO,queHacer,H1)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitGUI(tO,S)
%              sauveGUI(tO,varargin)
%
classdef CSuppCanBat < CSuppCan

  properties
    % handle de l'action qui l'a "call�"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CSuppCanBat()
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
      GUISuppCan(tO,L);
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
    % Apr�s avoir configur�, si on revient MODIFIER le GUI
    % il faut v�rifier car le nb de canaux a chang�
    % En entr�e  N  --> structure des nouvelles infos du GUI
    %-------------------------------------------------------
    function reagirSiModifMajeur(tO,N)
      % pour simplifier l'�criture
      A =tO.hAct;
      if ~isempty(A.pact)
        % comme on a chang� le nombre de canaux
        hB =CBatchEditExec.getInstance();
        hB.resetApres();
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
        % on modifie le texte "supprimer/conserver"
        hnd =findobj('tag','OnConserveCan');
        set(hnd,'value',S.soc);
        tO.modifCheckbox(hnd);
      end
    end

    %-----------------------------------------------------------
    % Sauvegarde des param�tres du GUI afin de pouvoir y revenir
    % ou de d�marrer le travail � faire.
    % De plus, on modifie le fichier virtuel correspondant
    %-----------------------------------------------------------
    function sauveGUI(tO,varargin)
      % lecture des infos du GUI
      tous =get(findobj('tag','ListeCan'),'string');
      foo.nad =get(findobj('tag','ListeCan'),'value');
      foo.soc =get(findobj('tag','OnConserveCan'),'value');
      nombre =length(foo.nad);
      % est-ce que les params sont "acceptables"?
      if (nombre == length(tous) & ~foo.soc) | ...
         (nombre == 0 & foo.soc)
        hJ =CJournal.getInstance();
        hJ.ajouter('Vous ne pouvez pas supprimer tous les canaux', tO.S);
        return;
      end
      % Pour simplifier l'�criture
      H2 =CBatchEditExec.getInstance();
      ftmp =H2.tmpFichVirt;
      hdchnl =ftmp.Hdchnl;
      vg =ftmp.Vg;
      % il faut diff�rencier si on conserve ou supprime les canaux s�lectionn�s
      aSupp =1:vg.nad;
      if foo.soc
        % on conserve les canaux s�lectionn�s
        aSupp(foo.nad) =[];
      else
        % ici on supprime les canaux s�lectionn�s
      	aSupp =foo.nad;
      end
      %
      % On supprime les infos dans hdchnl et vg
      hdchnl.SuppCan(aSupp);
      vg.nad =vg.nad-length(aSupp);
      % Il faut avertir les fichiers virtuels suivant car on a supprim� des canaux
      tO.reagirSiModifMajeur(foo);
      % on sauvegarde les infos dans l'objet CAction associ�
      tO.hAct.sauveConfig(foo);
      % avant de quitter, on efface le GUI
      delete(tO.fig);
      tO.fig =[];
    end

  end  % methods

end
