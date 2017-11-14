%
%  classdef CCalculCOPoptima < CCalculCOPGUI
%  Gestion du calcul du COP pour la plateforme Optima
%  La classe CCalculCOPGUI() gère les callback du GUI
%
% METHODS disponibles
% tO = CCalculCOPoptima(conGUI)
%      auTravail(tO, varargin)
%      syncObjetConGui(tO)           overload de la classe CCalculCOPGUI()
%      lireParam(tO)                 overload de la classe CCalculCOPGUI()
%
classdef CCalculCOPoptima < CCalculCOPGUI

  methods

    %------------------------------
    % CONSTRUCTOR
    %------------------------------
    function tO =CCalculCOPoptima()
      % par défaut, newplt = false: pour la AMTI
      tO.newplt =true;
    end

    %----------------------------------------------------------------------------
    % Comme on utilise les mêmes classes que CCalculCOPamti(), on va "overloader"
    % certaines fonctions plutôt que de recopier toutes les fonctions
    % en n'en changeant que quelques unes.
    %----------------------------------------------------------------------------

    % -------------------------------------
    % overload de la classe CGUICalculCOP()
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
      if ~tO.COPseul & ~R.COG
        tO.afficheStatus('Il faut sélectionner un canal pour Fx et/ou Fy');
        return;
      end
      OA =CAnalyse.getInstance();
      Fhnd =OA.findcurfich();
      tO.cParti(Fhnd, R);
      gaglobal('editnom');
      tO.terminus();
    end

    %-------------------------------------------------------
    % Ici on effectue le travail pour la fonction fpltOptima
    % même chose en mode batch
    % En entrée  Ofich  --> handle du fichier à traiter
    %                S  --> structure des param du GUI
    %              Bat  --> true si on est en mode batch
    %-------------------------------------------------------
    function cParti(tO,Ofich,S,Bat)
      if ~exist('Bat','var')
      	Bat =false;
      end
      fpltOptima(tO, Ofich, S);
    end

    %--------------------------------------
    % overload de la classe CCalculCOPGUI()
    % on synchronise les valeurs de FC (faceur de conversion)
    % avec celle du GUI
    %---------------------------
    function syncObjetConGui(tO)
      tO.optimaFC =convCellArray2Mat(get(findobj('tag','LaTableMC'), 'Data'));
    end

    % -------------------------------------
    % overload de la classe CGUICalculCOP()
    % Lecture des paramètres dans un ficheir
    %---------------------
    function lireParam(tO)
      param =importCalculCOPoptima(tO);
      tO.importation(param);
    end

  end
end
