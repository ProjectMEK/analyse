%
% Class CBatchEditExec
%
% Le d�veloppement de cet option a commenc� vers 2011,
% �tant constamment interrompu pour diff�rents ajouts/p�pins,
% �a n'a pas �volu� trop trop.
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