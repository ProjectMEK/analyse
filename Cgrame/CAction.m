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
      % si les param�tres ont �t� sauvegard�s, on est pr�t � passer � l'action
      pret =false;
      % handle du fichier (peut-�tre virtuel) � traiter
      hfi =[];
      % handle de l'objet d�fini par tO.classe
      hO =[];
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

    % DESTRUCTOR
    %
    function delete(tO)
      if ~isempty(tO.hO)
        delete(tO.hO);
        tO.hO =[];
      end
    end

    %--------------------------------------------------------
    % Affichage du GUI pour la configuration de cette action.
    %--------------------------------------------------------
    function afficheGUI(tO)
      % si c'est la 1�re fois que l'on appelle le constructeur
      if isempty(tO.hO)
        foo =str2func(tO.classe);
        tO.hO =foo();
      end
      tO.hO.aFaire('configuration',tO);
    end

    %----------------------------------------------------------
    % On d�marre le travail � faire de cette action
    % En entr�e on re�oit hF un objet CLireAnalyse() qui est le
    % fichier courant (de travail).
    %----------------------------------------------------------
    function enRoute(tO,hF)
      % si c'est la 1�re fois que l'on appelle le constructeur
      if isempty(tO.hO)
        foo =str2func(tO.classe);
        tO.hO =foo();
      end
      tO.hO.aFaire('auTravail',hF);
    end

    %----------------------------------------------
    % On sauvegarde suite au passage par le GUI
    % En entr�e   S  --> structure des infos du GUI
    %----------------------------------------------
    function sauveConfig(tO,S)
      % on conserve les params du GUI
      tO.pact =S;
      tO.pret =true;
      % on conserve le fichier virtuel
      H2 =CBatchEditExec.getInstance();
      ftmp =H2.tmpFichVirt;
      ftmp.reClone(tO.hfi);
    end

  end  % methods

end
