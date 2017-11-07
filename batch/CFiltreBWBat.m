%
% classdef CFiltreBWBat < CFiltreBW
%
% Classe pour filtrer les canaux (avec un ButterWorth) en mode Batch
% Il sera appel� pour la configuration avec le GUIFiltreBW
% � la sortie du GUI il faudra r�cup�rer les param�tres
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
    % handle de l'action qui l'a "call�"
    hAct =[];
  end  %properties

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CFiltreBWBat()
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
      GUIFiltreBW(tO,L);
      % on modifie le "callback" de fermeture de la fen�tre
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      % on modifie le "callback" et le titre du bouton "Au travail"
      set(findobj('tag','boutonTravail'),'string','Sauvegarder','callback',@tO.sauveGUI)
      % si on a d�j� des param on les applique
      if ~isempty(tO.hAct.pact)
        tO.reInitGUI(tO.hAct.pact);
        tO.quelChoix(findobj('tag','QuelFiltre'));
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
        % si on a coch�/d�coch� l'�criture sur le canal source ou
        % si on doit cr�er un nouveau canal et que le nb de canaux a chang�
        if ~(A.pact.nouveau == N.nouveau) | (~N.nouveau & (~(length(A.pact.lescan) == length(N.lescan)) | ~(A.pact.lescan == N.lescan)) )
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
      % lecture des infos du GUI
      foo.afaire =get(findobj('tag','QuelFiltre'),'Value');
      foo.lescan =get(findobj('tag','ChoixCanFiltre'),'Value');
      foo.nouveau =get(findobj('tag','EcraseCanal') ,'Value');     % on �crase le canal source
      foo.ord =get(findobj('tag','EditOrdreFiltre'),'String');
      foo.frc1 =get(findobj('tag','EditFreqCoupe1'),'String');
      foo.frc2 =get(findobj('tag','EditFreqCoupe2'),'String');
      nombre =length(foo.lescan);
      % Pour simplifier l'�criture
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
        hJ.ajouter('Les fr�quences ne peuvent d�passer la moiti� des fr�quences d''�chantillonnages.', hB.S);
        return;
      end
      % si on ne r�-�crit pas dans les canaux sources, il faut en ajouter
      if ~foo.nouveau
        hdchnl.duplic(foo.lescan);
        Ncan =vg.nad+1:vg.nad+nombre;
        vg.nad =vg.nad+nombre;
      else
      	Ncan =foo.lescan;
      end
      % puis on r�-assigne un nouveau nom tenant compte de l'op�ration � faire
      for U =1:nombre
        hdchnl.adname{Ncan(U)} =tO.nouveauNom(hdchnl.adname{Ncan(U)}, foo.afaire);
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
