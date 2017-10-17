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
    % handle de l'action qui l'a "callé"
    hAct =[];
  end  %properties

  methods

    %----------------------------------------------------------------------
    % CONSTRUCTOR
    % En Entrée
    %   queHacer  que faire à l'ouverture
    %----------------------------------------------------------------------
    function tO = CDifferBat(queHacer,H)
      if exist('queHacer')
        switch queHacer
          case 'configuration'
            % on conserve la trace de celui qui nous a appelé
            tO.hAct =H;
            % on appelle le GUI
            GUIDiffer(tO);
            set(tO.fig,'CloseRequestFcn',@tO.cFeni);
        end
      end
    end

    %
    % On ferme le GUI
    %
    function cFeni(tO)
      set(tO.fig, 'visible','off');
      pause(2)
      set(tO.fig, 'visible','off');
      pause(1)
      delete(tO.fig);
    end

  end  % methods

end
