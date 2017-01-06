%
% classdef CStat4COP < CGuiStat4COP
%
% METHODS
%   tO =CStat4COP(conGUI)     % CONSTRUCTOR
%       auTravail(tO, varargin)
%
classdef CStat4COP < CGuiStat4COP

  methods

    %------------
    % CONSTRUCTOR
    %-----------------------------
    function tO =CStat4COP(conGUI)
      tO.initGui();
    end

    %-----------------------------
    % on a cliqu� sur "au travail"
    %-------------------------------
    function auTravail(tO, varargin)
      % lecture du GUI
      tO.syncObjetConGui();
      try
        tO.isValid();
        stat4COP(tO);
      catch e
        if strncmpi(e.identifier, 'matlab', 6)
          getReport(e)
          tO.afficheStatus('Voir "fen�tre noire" pour l''erreur');
        else
          tO.afficheStatus(e.message);
        end
        return;
      end
      tO.terminus();
    end

  end % methods
end % classdef
