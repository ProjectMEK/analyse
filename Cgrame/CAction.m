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
  end  %properties

  methods

    %------------------------------------------
    % CONSTRUCTOR
    % En Entrée: on veut un nom valide d'action
    %------------------------------------------
    function tO = CAction(varargin)
      if nargin > 0
        tO.description =varargin{1};
      end
    end

  end  % methods

end
