%
% classdef CGUIBatchEditExec < CBasePourFigureAnalyse & CParamBatchEditExec
%
% Classe de gestion du GUI GUIBatchEditExec
% prendra en charge tous les callback du GUI
%
% METHODS
%       initGui(tO)
%
%
classdef CGUIBatchEditExec < CBasePourFigureAnalyse & CParamBatchEditExec

  methods

    %-------------------
    % Création du GUI
    %-------------------
    function initGui(tO)
      tO.fig =GUIBatchEditExec(tO);
    end

    %-----------------------------------
    % Ajouter une action
    %-----------------------------------
    function ajouterAction(tO, varargin)
    end

    %-----------------------------------
    % Effacer une action
    %-----------------------------------
    function effacerAction(tO, varargin)
    end

    %-------------------------------------------------
    % Monter une action
    % pour déplacer vers le haut la tache sélectionnée
    %-------------------------------------------------
    function monterAction(tO, varargin)
    end

    %------------------------------------------------
    % Descendre une action
    % pour déplacer vers le bas la tache sélectionnée
    %------------------------------------------------
    function descendreAction(tO, varargin)
    end

    %-----------------------------------
    % Modifier une action
    %-----------------------------------
    function modifierAction(tO, varargin)
    end

  end  % methods

end
