%
% classdef CAction < handle
%
% METHODS
%         tO = CAction(description,laclasse,lastruct)  % CONSTRUCTOR
%              afficheGUI(tO)
%
classdef CAction < handle

  properties
      % nom/description de l'action
      description =[];
      % nom de la classe � appeler
      classe =[];
      % param�tre (structure) � passer � la classe
      pact =[];
      % les param�tres ont �t� sauvegard�s, on est pr�t � passer � l'action
      pret =false;
  end  %properties

  methods

    %----------------------------------------------------------------------
    % CONSTRUCTOR
    % En Entr�e
    %   description  est le nom valide d'action
    %   laclasse     le nom de la classe pour cr�er l'objet
    %   lastruct     structure qui contient les param utiles � cette action
    %----------------------------------------------------------------------
    function tO = CAction(description,laclasse,lastruct)
      if exist('lastruct')
        tO.description =description;
        tO.classe =laclasse;
        tO.pact =lastruct;
      elseif exist('laclasse')
        tO.description =description;
        tO.classe =laclasse;
      elseif exist('description')
        tO.description =description;
      end
    end

    %-------------------------------------------------------
    % Affichage du GUI pour la configuration de cette action
    %-------------------------------------------------------
    function afficheGUI(tO)
      foo =str2func(tO.classe);
      foo('configuration',tO);
    end

  end  % methods

end
