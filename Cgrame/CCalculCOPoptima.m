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
    % EN ENTRÉE on a conGUI une variable logique qui déterminera si:
    %   false -->  on initialise les paramètres à partir d'un fichier
    %   true  -->  se sera les valeurs par défauts.
    %-------------------------------
    function tO =CCalculCOPoptima(conGUI)
      tO.newplt =true;
      if ~conGUI
        tO.lireParam();
        tO.auTravail();
      else
        tO.initGui();
      end
    end

    %---------------------------------------------------------------------------
    % Comme on utilise les mêmes classes que CCalculCOP(), on va "overloader"
    % certaines fonctions plutôt que de recopier toutes les fonctions
    % en n'en changeant que quelques unes.
    %---------------------------------------------------------------------------

    % -------------------------------------
    % overload de la classe CGUICalculCOP()
    %-------------------------------
    function auTravail(tO, varargin)
      if ~isempty(tO.fig)
        tO.syncObjetConGui();
      end
      con6Can =tO.canFx*tO.canFy*tO.canFz*tO.canMx*tO.canMy*tO.canMz;
      con3Can =tO.canFz*tO.canMx*tO.canMy;
      if con6Can > 0
        lesCan =[tO.canFx tO.canFy tO.canFz tO.canMx tO.canMy tO.canMz];
      elseif con3Can > 0
        lesCan =[tO.canFz tO.canMx tO.canMy];
      else
        if isempty(tO.fig)
          tO.initGui();
        end
        tO.afficheStatus('Il faut sélectionner 3 ou 6 canaux!!!');
        return;
      end
      fpltOptima(tO, lesCan);
      gaglobal('editnom');
      tO.terminus();
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
    % Lecture des paramètres dans un ficheir
    %---------------------
    function lireParam(tO)
      param =importCalculCOPoptima(tO);
      tO.importation(param);
    end

  end
end
