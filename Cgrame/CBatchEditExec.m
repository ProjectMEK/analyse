%
% Class (Sealed) CBatchEditExec
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
classdef (Sealed) CBatchEditExec < CBatchEditExecGUI

  methods (Access =private)

    %-----------------------------
    % CONSTRUCTOR
    %-----------------------------
    function tO = CBatchEditExec()
      tO.listChoixActions =infoActions();
    end

  end

  methods (Static)

    %-----------------------------------------------------------------
    % Fonction accessible de partout et par tous.
    % Si aucun objet CBatchEditExec existe, il appelle le constructeur
    % autrement il retourne le handle sur l'objet existant.
    %-----------------------------------------------------------------
    function sObj =getInstance
      persistent localObj;
      if isempty(localObj) || ~isa(localObj, 'CBatchEditExec')
        localObj =CBatchEditExec();
      end
      sObj =localObj;
    end

  end  % methods (Static)

  methods

    function delete(tO)
      if ~isempty(tO.listAction)
        tO.effaceTouteAction()
      end
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %----------------------------------
    % On ferme la figure
    % On overload la m�thode "terminus"
    %----------------------------------
    function terminus(tO, src, event)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

  end

end