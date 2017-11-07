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
    % EN ENTRÉE on a conGUI une variable logique qui déterminera si:
    %   false -->  on initialise les paramètres à partir d'un fichier
    %   true  -->  se sera les valeurs par défauts.
    %-------------------------------
    function tO = CCalculCOP(conGUI)
      % plus rien à faire pour l'instant
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
        tO.afficheStatus('Il faut sélectionner 3 ou 6 canaux!!!');
        return;
      end
      if ~tO.COPseul & length(R.lesCan) < 6
        tO.afficheStatus('Pour le calcul du COG, il faut sélectionner les six canaux.');
        return;
      end
      fpltAmti(tO, R);
      gaglobal('editnom');
      tO.terminus();
    end
  end
end
