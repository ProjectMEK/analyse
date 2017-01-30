%
% Classe CFic
%
% Gestion des fichiers ouverts
%
classdef CFic < handle

  properties
    nf =0;
    hfich =[];              % handle des objets CFichier
    curfich =[];            % fichier actif
    lastfich =[];           % ancien fichier actif
    basedir =[];            % dossier ou se trouve analyse.m
    ddir =pwd;              % dernier répertoire de travail ouvert
    recent ={};             % nom des derniers fichiers ouverts
    como =0;                % nombre de fichier dans tO.recent
    pref =[];               % handle d'un CPref()
    laver =[];              % version en chiffre
    vermot ='';             % version en texte
  end

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CFic()
      % ici on a seulement le path du fichier de démarrage à initialiser
      % il servira de path de base.
      [tO.basedir, s,s] =fileparts( which('analyse.m'));
    end

    %-------------------------------------------
    % Suite à l'ouverture d'un fichier, On met à
    % jour laliste des derniers fichiers ouverts
    %-------
    function majFichRecent(tO)
      %--------------------------------------------------
      % Si on a un menu de fichier récent, on le supprime
      yen_ati =findobj('tag','FRecent');
      if ~ isempty(yen_ati)
		    delete(yen_ati);
	    end
	    if tO.pref.conserver
	      if ~isempty(tO.hfich)
          %--------------------------
          % Handle du fichier courant
          OFi =tO.hfich{tO.curfich};
          if ~ isempty(OFi.Info.foname)
            if isempty(tO.recent)
              tO.recent ={OFi.Info.foname};
            else
      		    etalors =strcmpi(OFi.Info.foname, tO.recent);
              lebon =find(etalors);
      		    etalors =1:length(etalors);
              if isempty(lebon)
                tO.recent(2:end+1) =tO.recent;
                tO.recent{1} =OFi.Info.foname;
              else
                ttt{1} =tO.recent{lebon};
                etalors(lebon) =[];
                if ~isempty(etalors)
                  ttt(2:length(etalors)+1) =tO.recent(etalors);
                end
                tO.recent =ttt;
              end
      	    end
          end
        end
        tO.como =min(tO.pref.maxfr, length(tO.recent));
        tO.recent =tO.recent(1:tO.como);
        for U =1:tO.como
          Elfich =num2str(U);
          uimenu('Parent',findobj('tag','FRmnu'), 'Callback',['mnouvre(CFichEnum.analyse,' Elfich ')'],...
          'tag','FRecent', 'Label',tO.recent{U});
        end
      end
    end

    %-----------------------------------------
    % initialise la liste des fichiers récents
    % avec le contenu "val"
    %-------------------------------
    function initFichRecent(tO, val)
      if ~isempty(val) && iscell(val)
        tO.recent ={};
        cuanto =min(length(val), tO.pref.maxfr);
      	for U =1:cuanto
      		if ~isempty(deblank(val{U}))
      		  tO.recent{end+1} =val{U};
      		end
      	end
      end
    	tO.como =length(tO.recent);
    end

  end % methods
end