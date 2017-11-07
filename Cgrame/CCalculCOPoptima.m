%
%  classdef CCalculCOPoptima < CCalculCOPGUI
%  Gestion du calcul du COP pour la plateforme Optima
%  La classe CCalculCOPGUI() g�re les callback du GUI
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
      tO.newplt =true;
    end

    %---------------------------------------------------------------------------
    % Comme on utilise les m�mes classes que CCalculCOP(), on va "overloader"
    % certaines fonctions plut�t que de recopier toutes les fonctions
    % en n'en changeant que quelques unes.
    %---------------------------------------------------------------------------

    % -------------------------------------
    % overload de la classe CGUICalculCOP()
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
      if ~tO.COPseul & ~R.COG
        tO.afficheStatus('Il faut s�lectionner un canal pour Fx et/ou Fy');
        return;
      end
      fpltOptima(tO, R);
      gaglobal('editnom');
      tO.terminus();
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
    % Lecture des param�tres dans un ficheir
    %---------------------
    function lireParam(tO)
      param =importCalculCOPoptima(tO);
      tO.importation(param);
    end

  end
end
