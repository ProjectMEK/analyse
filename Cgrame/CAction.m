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
      % nom de la classe à appeler
      classe =[];
      % paramètre (structure) à passer à la classe
      pact =[];
      % les paramètres ont été sauvegardés, on est prêt à passer à l'action
      pret =false;
  end  %properties

  methods

    %----------------------------------------------------------------------
    % CONSTRUCTOR
    % En Entrée
    %   description  est le nom valide d'action
    %   laclasse     le nom de la classe pour créer l'objet
    %   lastruct     structure qui contient les param utiles à cette action
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
