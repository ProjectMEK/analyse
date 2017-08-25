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
%
%
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
    end

  end

end