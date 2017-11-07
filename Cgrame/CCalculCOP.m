%
% classdef CCalculCOP < CCalculCOPGUI
%  Gestion du calcul du COP pour la plateforme Amti
%
% METHODS disponibles
% tO = CCalculCOP(conGUI)
%      auTravail(tO, varargin)
%
classdef CCalculCOP < CCalculCOPGUI

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTR�E on a conGUI une variable logique qui d�terminera si:
    %   false -->  on initialise les param�tres � partir d'un fichier
    %   true  -->  se sera les valeurs par d�fauts.
    %-------------------------------
    function tO = CCalculCOP(conGUI)
      % plus rien � faire pour l'instant
    end

    %------------------------------------------------------------
    % overload la fonction autravail de la classe CGUICalculCOP()
    %-------------------------------
    function auTravail(tO, varargin)
      if ~isempty(tO.fig)
        tO.syncObjetConGui();
      end
      R =tO.verifNbCan();
      if isempty(R.lesCan)
        tO.afficheStatus('Il faut s�lectionner 3 ou 6 canaux!!!');
        return;
      end
      if ~tO.COPseul & length(R.lesCan) < 6
        tO.afficheStatus('Pour le calcul du COG, il faut s�lectionner les six canaux.');
        return;
      end
      fpltAmti(tO, R);
      gaglobal('editnom');
      tO.terminus();
    end
  end
end
