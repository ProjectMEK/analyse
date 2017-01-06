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
        tO.auTravail();
      else
        tO.initGui();
      end
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
        tO.afficheStatus('Il faut s�lectionner 3 ou 6 canaux!!!');
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
    % Lecture des param�tres dans un ficheir
    %---------------------
    function lireParam(tO)
      param =importCalculCOPoptima(tO);
      tO.importation(param);
    end

  end
end
