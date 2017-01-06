%
% classdef CGuiPreference < CBasePourFigureAnalyse & COngletUtil & CPref
%
% Gestion des callback du GUI GuiPreference
%
% METHODS
%       activAmigo(tO, src, evnt)
%       afficheStatus(tO, leStatus)
%       auTravail(tO, src, event)
%       getPropduGui(tO)
%       initGui(tO)
%  cur =lireLesOnglets(tO)
%
classdef CGuiPreference < CBasePourFigureAnalyse & COngletUtil & CPref

  methods

    %------------------------------------------
    % met à jour les propriétés des Préférences
    % et création du GUI
    %-------------------
    function initGui(tO)
      OA =CAnalyse.getInstance();
      tO.maj(OA.Fic.pref.getObjData());
      tO.fig =GuiPreference(tO);
    end

    %-----------------------------------------------------
    % Dans l'onglet "affichage", si on clique sur une case
    % de la colonne "Fixer...", on doit activer/désactiver
    % la case dela colonne de droite correspondante.
    %---------------------------------
    function activAmigo(tO, src, evnt)
      leTag =get(src, 'Tag');
      leTag(end-2:end) =[];
      ONOFF =CEOnOff(get(src, 'Value'));
      set(findobj('Tag',leTag), 'Enable',char(ONOFF));  % {get(src, 'Value')+1});
    end

    %---------------------------------------
    % "synchronisation" de l'objet "tO" avec
    % les valeurs du GUI
    %------------------------
    function getPropduGui(tO)

      % lecture des uicontrol type "Value"
      for U =1:length(tO.lstPropV)
        tO.(tO.lstPropV{U}) =get(findobj('Tag',tO.lstPropV{U}), 'Value');
      end

      tO.setDispError(tO.dispError-1);
      tO.setPt(tO.pt-1);

      % lecture des uicontrol type "Numéric"
      for U =1:length(tO.lstPropN)
        tO.(tO.lstPropN{U}) =str2num(get(findobj('Tag',tO.lstPropN{U}), 'String'));
      end

      % lecture des uicontrol type "Texte"
      for U =1:length(tO.lstPropT)
        tO.(tO.lstPropT{U}) =get(findobj('Tag',tO.lstPropT{U}), 'String');
      end

    end

    %-----------------------------------------------
    % gestion de l'affichage dans la barre de status
    %-----------------------------------
    function afficheStatus(tO, leStatus)
      if nargin == 1
        leStatus ='Entrez vos préférences afin d''améliorer votre session de travail';
      end
      set(findobj('Tag','TextStatus'), 'String',leStatus);
    end

    %--------------------------------------
    % On a cliqué sur le bouton "Appliquer"
    % on synchronise les propriétés avec les
    % valeurs dans le GUI
    %------------------------------
    function auTravail(tO, varargin)
      tO.getPropduGui();
    end

  end % methods
end % classdef
