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
% Pour maintenir une "compatibilit�" lors de l'�volution de cette fonction
% version 1.01       premi�re essai de traitement en batch
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