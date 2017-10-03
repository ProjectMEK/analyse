%
% classdef CDifferBat < CDiffer
%
% Classe pour faire les travaux de differ en mode Batch
% Il sera appelé pour la configuration avec le GUIDiffer
% à la sortie du GUI il faudra récupérer les paramètres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CDifferBat(queHacer)  % CONSTRUCTOR
%
classdef CDifferBat < CDiffer

  properties
      % 
  end  %properties

  methods

    %----------------------------------------------------------------------
    % CONSTRUCTOR
    % En Entrée
    %   queHacer  que faire à l'ouverture
    %----------------------------------------------------------------------
    function tO = CDifferBat(queHacer)
      if exist('queHacer')
        switch queHacer
          case 'ouverture'
          
        end
      end
    end

  end  % methods

end
