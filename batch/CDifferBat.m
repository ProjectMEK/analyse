%
% classdef CDifferBat < CDiffer
%
% Classe pour faire les travaux de differ en mode Batch
% Il sera appel� pour la configuration avec le GUIDiffer
% � la sortie du GUI il faudra r�cup�rer les param�tres
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
    % En Entr�e
    %   queHacer  que faire � l'ouverture
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
