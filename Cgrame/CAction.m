%
% classdef CAction < handle
%
% METHODS
%         tO = CAction(varargin)  % CONSTRUCTOR
%
classdef CAction < handle

  properties
      % nom/description de l'action
      description =[];
      % nom de la classe � appeler
      classe =[];
      % param�tre (structure) � passer � l'action
      pact =[];
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

  end  % methods

end
