%
%  classdef CCalculCOPoptima < CGuiCalculCOP
%  Gestion du calcul du COP pour la plateforme Optima
%
% METHODS disponibles
% tO = CCalculCOPoptima(conGUI)
%      auTravail(tO, varargin)
%
classdef CCalculCOPoptima < CGuiCalculCOP

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTR�E on a conGUI une variable logique qui d�terminera si:
    %   false -->  on initialise les param�tres � partir d'un fichier
    %   true  -->  se sera les valeurs par d�fauts.
    %-------------------------------
    function tO =CCalculCOPoptima(conGUI)
      tO.newplt =true;
      if ~conGUI
        tO.lireParam();
      end
      tO.initGui();
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

    %---------------------------------------------------------
    % La fonction "cogline" a besoin en entr�e de
    % - un vecteur temps (sec)
    % - un vecteur de force (Fx ou Fy)
    % - un vecteur du CPx ou CPy qui fit avec la force ci-haut
    % - la masse du sujet
    %---------------------------------------------------------
    function prepareCalculCOG(tO,REP)
    end

    %--------------------------------------
    % overload de la classe CGUICalculCOP()
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
