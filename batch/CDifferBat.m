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
    % handle de l'action qui l'a "call�"
    hAct =[];
  end  %properties

  methods

    %----------------------------------------------------------------------
    % CONSTRUCTOR
    % En Entr�e
    %   queHacer  que faire � l'ouverture
    %          H  le handle d'un objet CAction()
    %----------------------------------------------------------------------
    function tO = CDifferBat(queHacer,H,)
      if exist('queHacer')
        switch queHacer
          case 'configuration'
            % on conserve la trace de celui qui nous a appel�
            tO.hAct =H;
            % on appelle le GUI
            tO.onDessine();
        end
      end
    end

    %-------------------
    % On pr�sente le GUI
    %-------------------
    function onDessine(tO)
      % on appelle le GUI
      GUIDiffer(tO);
      set(tO.fig,'CloseRequestFcn','delete(gcf)');
      
    end

  end  % methods

end
