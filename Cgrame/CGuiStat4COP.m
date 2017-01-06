%
% classdef CGuiStat4COP < CBasePourFigureAnalyse & COngletUtil & CParamStat4COP
%
% Classe pour répondre au function callback du GUI GuiStat4COP
%
% METHODS
%       afficheStatus(tO, leStatus)
%       auTravail(tO, src, event)
%       changeCanCpx(tO, src, event)
%       changeCanCpy(tO, src, event)
%       changeFichierSortie(tO, src, event)
%       changeFiltre(tO, src, event)
%       changeRecup(tO, src, event)
%       initGui(tO)
%       syncObjetConGui(tO)
%
classdef CGuiStat4COP < CBasePourFigureAnalyse & COngletUtil & CParamStat4COP

  methods

    %------------------------
    % Création de l'interface
    %--------------------
    function initGui(tO)
      tO.fig =GuiStat4COP(tO);
    end

    %----------------------------------
    function auTravail(tO, src, event)
      % On fait rien, ça va se faire dans CStat4COP
    end

    %----------------------------------------
    % on vérifie la validité des infos du GUI
    %-------------------
    function isValid(tO)
      try
        isValid@CParamStat4COP(tO);
      catch e
        rethrow(e);
      end
    end

    %-------------------------------------------------
    % affichage de commentaire dans la barre de status
    %-----------------------------------
    function afficheStatus(tO, leStatus)
      if nargin == 1
       leStatus ='Remplissez les informations selon les résultats voulus';
      end
      set(findobj('Tag','TextStatus'), 'String',leStatus);
    end

    %-------------------------------------------
    % synchronise les propriétés de l'objet "tO"
    % avec les valeurs du GUI
    %---------------------------
    function syncObjetConGui(tO)
      tO.bornesText =strtrim(get(findobj('Tag','BorneDeTravail'), 'String'));
      tO.numeroSujet =strtrim(get(findobj('Tag','NumeroSujet'), 'String'));
      if tO.recup
        pat ='\s+';
        tO.recupDebutText =regexprep(get(findobj('Tag','RecupDebut'), 'String'), pat, '');
        tO.recupFinText =regexprep(get(findobj('Tag','RecupFin'), 'String'), pat, '');
      end
      if tO.onFiltre
        tO.freqCoupure =str2num(get(findobj('Tag','FrequenceDeCoupure'), 'String'));
        tO.ordreFiltre =str2num(get(findobj('Tag','OrdreDuFiltre'), 'String'));
      end
      tO.fenetreDiffer =str2num(get(findobj('tag','FenetreDiffer'), 'String'));
      tO.fichierSortie =get(findobj('tag','FichierSortie'), 'String');
    end

    %--------------------------------
    % changement de canal pour le Cpx
    %------------------------------------
    function changeCanCpx(tO, src, event)
      tO.canCpx =get(src, 'Value')-1;
    end

    %--------------------------------
    % changement de canal pour le Cpy
    %------------------------------------
    function changeCanCpy(tO, src, event)
      tO.canCpy =get(src, 'Value')-1;
    end

    %---------------------------------
    % "toggle" l'utilisation du filtre
    %------------------------------------
    function changeFiltre(tO, src, event)
      tO.onFiltre =get(src, 'Value');
      if tO.onFiltre
        set(findobj('Tag','FrequenceDeCoupure'), 'Enable','on');
        set(findobj('Tag','OrdreDuFiltre'), 'Enable','on');
      else
        set(findobj('Tag','FrequenceDeCoupure'), 'Enable','off');
        set(findobj('Tag','OrdreDuFiltre'), 'Enable','off');
      end
    end

    %---------------------------------
    % "toggle" l'utilisation de Recup.
    %-----------------------------------
    function changeRecup(tO, src, event)
      tO.recup =get(src, 'Value');
      if tO.recup
        set(findobj('Tag','RecupDebut'), 'Enable','on');
        set(findobj('Tag','RecupFin'), 'Enable','on');
      else
        set(findobj('Tag','RecupDebut'), 'Enable','off');
        set(findobj('Tag','RecupFin'), 'Enable','off');
      end
    end

    %----------------------------------------------
    % changement du fichier de sortie des résultats
    %-------------------------------------------
    function changeFichierSortie(tO, src, event)
      [f, p] =uiputfile('*.*', 'Sortie pour les résultats de Stat4COP');
      if length(p) == 1 && p == 0
        return;
      end
      tO.fichierSortie =fullfile(p, f);
      set(findobj('Tag','FichierSortie'), 'String',tO.fichierSortie);
    end

  end % methods
end % classdef
