%
% Class CBatchEditExec
%
% Le développement de cet option a commencé vers 2011,
% étant constamment interrompu pour différents ajouts/pépins,
% ça n'a pas évolué trop trop.
%
% METHODS
%       CBatchEditExec()                    CONSTRUCTOR
%
% Pour maintenir une "compatibilité" lors de l'évolution de cette fonction
% version 1.01       première essai de traitement en batch
%
%-------------------------------------------------------------------------
classdef CBatchEditExec < CGUIBatchEditExec

  methods

    %-----------------------------
    % CONSTRUCTOR
    %-----------------------------
    function tO = CBatchEditExec()
      tO.initGui();
    end

    function delete(tO)
      if ~isempty(tO.listAction)
        tO.effaceTouteAction()
      end
      if ~isempty(tO.fig)
        delete(tO.fig);
      end
    end

  end

end