%
% classdef CCalculCOP < CGuiCalculCOP
%  Gestion du calcul du COP pour la plateforme Amti
%
% METHODS disponibles
% tO = CCalculCOP(conGUI)
%      auTravail(tO, varargin)
%
classdef CCalculCOP < CGuiCalculCOP

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTR�E on a conGUI une variable logique qui d�terminera si:
    %   false -->  on initialise les param�tres � partir d'un fichier
    %   true  -->  se sera les valeurs par d�fauts.
    %-------------------------------
    function tO = CCalculCOP(conGUI)
      if ~conGUI
        tO.lireParam();
      end
      tO.initGui();
    end

    %------------------------------------------------------------
    % overload la fonction autravail de la classe CGUICalculCOP()
    %-------------------------------
    function auTravail(tO, varargin)
      if ~isempty(tO.fig)
        tO.syncObjetConGui();
      end
      con6Can =tO.canFx*tO.canFy*tO.canFz*tO.canMx*tO.canMy*tO.canMz;
      con3Can =tO.canFz*tO.canMx*tO.canMy;
      if con6Can > 0
        lesCan =[tO.canFx tO.canFy tO.canFz tO.canMx tO.canMy tO.canMz];
        fpltAmti(tO, lesCan);
      elseif con3Can > 0
        lesCan =[tO.canFz tO.canMx tO.canMy];
        fpltAmti(tO, lesCan);
      elseif ~isempty(tO.fig)
        tO.afficheStatus('Il faut s�lectionner 3 ou 6 canaux!!!');
        return;
      end
      gaglobal('editnom');
      tO.terminus();
    end
  end
end
