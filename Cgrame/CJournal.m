%
% Classe CJournal < CJournalGUI       (Sealed)
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
%     tO =CJournal     % CONSTRUCTOR
%
% METHODS (Static)
%   sObj =getInstance
%
% METHODS
%         delete(tO)     % DESTRUCTOR
%         initLesmots(tO)
%
classdef (Sealed) CJournal < CJournalGUI

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
    function sObj = getInstance(MAJ)
      persistent localObj;
      if ~exist('MAJ','var')
        MAJ =false;
      elseif MAJ
        localObj.delete();
        localObj =[];
      end
      try
        if isempty(localObj) | ~isvalid(localObj) | ~isa(localObj, 'CJournal')
          localObj =CJournal();
        end
      catch sss;
        if isempty(localObj) | isempty(localObj.fig) | ~isa(localObj, 'CJournal')
          localObj =CJournal();
        end
      end
      sObj =localObj;
    end

    %-------------------------------------------------------------------------
    % "On tue" l'instance active si elle existe, puis on en crée une nouvelle.
    % Ceci nous empêche d'avoir à faire un "clear classes" avant de recréer
    % une instance d'une classe sealed.
    %-------------------------------------------------------------------------
    function sObj = resetInstance
      sObj =CJournal.getInstance(true);
    end

  end  % methods (Static)

  methods

    %------------------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    function initLesmots(tO)
      try
        OA =CAnalyse.getInstance();
        laver =OA.Fic.vermot;
        tO.lesmots ={['Analyse, version ' laver]};
        tO.lesmots{end+1} =' ';
        tO.lesmots{end+1} =['Début de la journalisation: ' datestr(now)];
        tO.lesmots{end+1} ='----------------------------------------------------------------------------';
      catch sss;
        disp(sss.message);
        disp(sss.stack(end))
      end
    end

  end

end
