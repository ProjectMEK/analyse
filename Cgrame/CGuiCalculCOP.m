%
% classdef CGuiCalculCOP < CBasePourFigureAnalyse & COngletUtil & CParamCalculCOP
%
% Classe de gestion du GUI GuiCalculCOP
% prendra en charge tous les callback du GUI
%
% METHODS
%       afficheStatus(tO, leStatus)
%       auTravail(tO, src, event)
%       changeCanFx(tO, src, event)
%        . . . . . . .
%       changeCanMz(tO, src, event)
%       changeCOPseul(tO, src, event)
%       exportParam(tO, src, event)
%       formatDataUITable(tO, src, event)
%    V =getCurPan(tO)
%       lireParam(tO)
%       initGui(tO)
%       importParam(tO, src, event)
%       setCurPan(tO, V)
%       showPanel(tO, src, event)
%       surveilleZOffset(tO, src, event)
%
classdef CGuiCalculCOP < CBasePourFigureAnalyse & COngletUtil & CParamCalculCOP

  methods

    %-------------------
    % On va créer le GUI
    %-------------------
    function initGui(tO)
      tO.fig =GuiCalculCOP(tO);
    end

    %---------------------------------
    function auTravail(tO, src, event)
      % On fait rien ici, on laisse le parent travailler (peut-être CCalculCOP)
    end

    %-------------------------------------------------
    % affichage de "leStatus" dans une barre de status
    %-----------------------------------
    function afficheStatus(tO, leStatus)
      if nargin == 1
       leStatus ='Vérifiez les valeurs des paramètres (onglet: Calibration)';
      end
      set(findobj('Tag','TextStatus'), 'String',leStatus);
    end

    %-------------------------------------------------------
    % Fonction callback appelé si on modifie la valeur
    % "offset Z". On s'assure que c'est une valeur numérique
    %-------------------------------------------------------
    function surveilleZOffset(tO, src, event)
      V =str2double(get(src, 'String'));
      if isnan(V)
        set(src, 'String', num2str(tO.zOff));
      end
    end

    %----------------------------------------------------
    % on synchronise l'objet "tO" avec les valeurs du GUI
    %----------------------------------------------------
    function syncObjetConGui(tO)
      tO.amtiMC =convCellArray2Mat(get(findobj('tag','LaTableMC'), 'Data'));
      matGainVext =convCellArray2Mat(get(findobj('tag','LaTableGain'), 'Data'));
      tO.setGain(matGainVext(:, 1));
      tO.setVext(matGainVext(:, 2));
      tO.zOff =str2num(get(findobj('tag','EditZoff'), 'String'));
    end

    %-----------------------------------------------
    % exportation des valeurs du GUI dans un fichier
    % afin de pouvoir les ré-utilisés plus tard.
    %-----------------------------------
    function exportParam(tO, src, event)
      tO.syncObjetConGui();
      ExportCalculCOP(tO);
    end

    %------------------------------------
    % importation des valeurs pour le GUI
    % à partir d'un fichier.
    %-----------------------------------
    function importParam(tO, src, event)
      tO.lireParam();
      if ~isempty(tO.fig)
        delete(tO.fig);
        pause(0.5);
        tO.fig =[];
        tO.initGui();
      end
    end

    %------------------------------
    % lire les valeurs d'un fichier
    % et initialiser le GUI
    %------------------------------
    function lireParam(tO)
      param =importCalculCOP(tO);
      tO.importation(param);
    end

    %------------------------------------------------------------
    % vérification si on a sélectionné assez de canaux
    % pour les calculs demandés
    % COP seul
    %   - 3 canaux: Fz, Mx, My
    %   - 6 canaux: Fx, Fy, Fz, Mx, My, Mz
    % COP et COG
    %   - 3 canaux: Fz, Mx, My + Fx et/ou Fy
    %   - 6 canaux
    % En Sortie
    %   - REP.lesCan   --> Les 3 ou 6 canaux pour calculer le COP
    %   - REP.COG      --> true si on doit calculer le COG
    %   - REP.canFx    --> true si le canal Fx est déterminé
    %   - REP.canFy    --> true si le canal Fy est déterminé
    %------------------------------------------------------------
    function REP = verifNbCan(tO)
      con6Can =tO.canFx*tO.canFy*tO.canFz*tO.canMx*tO.canMy*tO.canMz;
      con3Can =tO.canFz*tO.canMx*tO.canMy;
      REP.lesCan =[];
      REP.COG =false;
      REP.canFx =0;
      REP.canFy =0;
      if con6Can > 0
        REP.lesCan =[tO.canFx tO.canFy tO.canFz tO.canMx tO.canMy tO.canMz];
      elseif con3Can > 0
        REP.lesCan =[tO.canFz tO.canMx tO.canMy];
      end
      if  ~tO.COPseul
        REP.COG =(tO.canFx>0 | tO.canFy>0);
        REP.canFx =REP.COG*tO.canFx;
        REP.canFy =REP.COG*tO.canFy;
      end
    end

    %------------------------------------
    % FONCTION CALLBACK
    % pour le choix des différents canaux
    %------------------------------------
    function changeCanFx(tO, src, event)
      tO.canFx =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCanFy(tO, src, event)
      tO.canFy =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCanFz(tO, src, event)
      tO.canFz =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCanMx(tO, src, event)
      tO.canMx =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCanMy(tO, src, event)
      tO.canMy =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCanMz(tO, src, event)
      tO.canMz =get(src, 'Value')-1;
    end

    %-----------------------------------
    function changeCOPseul(tO, src, event)
      tO.COPseul =get(src, 'Value');
    end

  end % methods
end % classdef
