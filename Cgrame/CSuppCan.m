%
% Class CSuppCan
%
%
%
%
% METHODS
%       CSuppCan()                    CONSTRUCTOR
%
%
%
classdef CSuppCan < handle

  properties
    fig =[];
  end

  methods

    %------------------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %------------------------------------------------------
    % Affiche le GUI pour d�finir les param�tres de travail
    %------------------------------------------------------
    function guiSuppCan(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      GUISuppCan(tO, hdchnl.Listadname);
    end

    %---------------------------------------------------------------------------
    % On toggle entre le mode "supprimer" et "Conserver" les canaux s�lectionn�s
    %---------------------------------------------------------------------------
    function modifCheckbox(tO,src,evt)
      if get(src,'value')
        leTexte ='Choix des canaux � conserver';
      else
        leTexte ='Choix des canaux � supprimer';
      end
      set(findobj('tag','TitSuppCOns'),'string',leTexte);
    end

    %--------------------------------------------------------------------
    % On proc�de au calcul � partir des valeurs de l'interface graphique.
    %--------------------------------------------------------------------
    function travail(tO,varargin)
      hA =CAnalyse.getInstance();
      hF =hA.findcurfich();
      % lecture des param�tres du GUI
      foo.nad =get(findobj('tag','ListeCan'),'Value')';           % canaux � supprimer/con...
      foo.soc =get(findobj('tag','OnConserveCan'),'Value');       % Supprime Ou Conserve
      % on appel la fonction qui va faire le travail
      tO.cParti(hF,foo);
      % on supprime le GUI
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %---------------------------------------------------
    % Ici on effectue le travail pour la fonction Differ
    % m�me chose en mode batch
    % En entr�e  Ofich  --> handle du fichier � traiter
    %                S  --> structure des param du GUI
    %            batch  --> true si on est en mode batch
    %---------------------------------------------------
    function cParti(tO, Ofich, S, Bat)
      if ~exist('Bat','var')
        Bat =false;
      end
      OA =CAnalyse.getInstance();
      % gestion du waitbar
      leTit ='Suppression en cours...';
      tt =false;
      hwb =findobj('type','figure','name',OA.wbnom);
      if isempty(hwb)
        hwb =waitbar(0.01, leTit, 'name',OA.wbnom);
        tt =true;
      end
      % param�tres du GUI
      Vcan =S.nad;
      conserv =S.soc;
      % infos utiles du fichier
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      aSupp =1:vg.nad;
      if conserv
        % comme on conserve les canaux s�lectionn�s, on va les supp de "aSupp"
        aSupp(Vcan) =[];
      else
        % ici on supprime les canaux s�lectionn�s
        aSupp =Vcan;
      end
      waitbar(0.05,hwb,leTit);
      Ofich.suppcan(aSupp,Bat);
      if tt
        delete(hwb);
      end
    end
  end
end  