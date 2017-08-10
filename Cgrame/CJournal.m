%
% Classe CJournal < CGUIJournal       (Sealed)
%
% CJournal gère la journalisation d'Analyse.
%
% Une classe SINGLETON,
%   donc une seule instance possible. Pour récupérer le handle
%   de l'objet existant (ou en créer un premier) :
%
%   foo = CJournal.getInstance()
%
%__________________________
% METHODS (Access =private)
%   tO =CJournal     % CONSTRUCTOR
%
% METHODS (Static)
%   sObj =getInstance
%
% METHODS
%      tO = CJournal
%    sObj = getInstance
%           delete(tO)     % DESTRUCTOR
%           initLesmots(tO)
%
classdef (Sealed) CJournal < CGUIJournal

  methods (Access =private)

    %--------------------
    % CONSTRUCTOR
    %--------------------
    function tO = CJournal
      tO.initGui();
    end

  end  % methods (Access =private)

  methods (Static)

    %-----------------------------------------------------------
    % Fonction accessible de partout et par tous.
    % Si aucun objet CJournal existe, il appelle le constructeur
    % autrement il retourne le handle sur l'objet existant.
    %-----------------------------------------------------------
    function sObj = getInstance
      persistent localObj;
      if isempty(localObj) || ~isa(localObj, 'CJournal')
        localObj =CJournal();
      end
      sObj =localObj;
    end

  end  % methods (Static)

  methods

    %------------------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
      end
    end

    function initLesmots(tO)
      OA =CAnalyse.getInstance();
      tO.lesmots ={['Analyse, version ' OA.Fic.vermot]};
      tO.lesmots{end+1} =' ';
      tO.lesmots{end+1} =['Début de la journalisation: ' datestr(now)];
      tO.lesmots{end+1} ='----------------------------------------------------------------------------';
    end

  end

end
