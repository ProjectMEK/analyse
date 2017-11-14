%
% classdef CCalculCOPamti < CCalculCOPGUI
%  Gestion du calcul du COP pour la plateforme Amti
%
% METHODS disponibles
% tO = CCalculCOPamti(conGUI)
%      auTravail(tO, varargin)
%
classdef CCalculCOPamti < CCalculCOPGUI

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTRÉE on a conGUI une variable logique qui déterminera si:
    %   false -->  on initialise les paramètres à partir d'un fichier
    %   true  -->  se sera les valeurs par défauts.
    %-------------------------------
    function tO = CCalculCOPamti()
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
      OA =CAnalyse.getInstance();
      Fhnd =OA.findcurfich();
      tO.cParti(Fhnd, R);
      gaglobal('editnom');
      tO.terminus();
    end

    %-------------------------------------------------------
    % Ici on effectue le travail pour la fonction fpltAmti
    % même chose en mode batch
    % En entrée  Ofich  --> handle du fichier à traiter
    %                S  --> structure des param du GUI
    %              Bat  --> true si on est en mode batch
    %-------------------------------------------------------
    function cParti(tO,Ofich,S,Bat)
      if ~exist('Bat','var')
      	Bat =false;
      end
      fpltAmti(tO, Ofich, S);
    end



  end
end
