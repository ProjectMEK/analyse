%
% classdef CCalculCOPoptimaBat < CCalculCOPcommunBat & CCalculCOPoptima
%
% Classe pour le calcul du COP pour la plateforme Optima
% Il sera appel� pour la configuration avec le CalculCOPGUI
% � la sortie du GUI il faudra r�cup�rer les param�tres
% puis on va le rappeler en lui passant les param pour faire le travail
%
%
% METHODS
%         tO = CCalculCOPoptimaBat()  % CONSTRUCTOR
%              aFaire(tO,queHacer,H1)
%          V = lectureTotalProp(tO)
%              onDessine(tO,N,L)
%              reagirSiModifMajeur(tO,N)
%              reInitProp(tO,S)
%              sauveGUI(tO,varargin)
%          V = getCOPseulCommun(tO)
%
classdef CCalculCOPoptimaBat < CCalculCOPcommunBat & CCalculCOPoptima

  methods

    %-------------------------
    % CONSTRUCTOR
    %-------------------------
    function tO = CCalculCOPoptimaBat()
      % pour l'instant, rien � faire
    end

    %---------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:cPartiCommun()
    % En Entr�e
    %   hF  --> handle du fichier � travailler
    %    S  --> Structure des param du GUI
    %  Bat  --> true si on est en mode batch
    %---------------------------------------------------------
    function cPartiCommun(tO,hF,S,Bat)
      tO.cParti(hF, S, Bat);
    end

    %------------------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:syncObjetConGuiCommun()
    %------------------------------------------------------------------
    function syncObjetConGuiCommun(tO)
      tO.syncObjetConGui();
    end

    %-------------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:verifNbCanCommun()
    %-------------------------------------------------------------
    function V = verifNbCanCommun(tO)
      V =tO.verifNbCan();
    end

    %-----------------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:avantDeQuitterCommun()
    %-----------------------------------------------------------------
    function avantDeQuitterCommun(tO)
      delete(tO.fig);
      tO.fig =[];
    end

    %-------------------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:lectureTotalPropCommun()
    %-------------------------------------------------------------------
    function V = lectureTotalPropCommun(tO)
      V =tO.lectureTotalProp();
    end

    %-------------------------------------------------------------
    % Fonction qui overload CCalculCOPcommunBat:getCOPseulCommun()
    %-------------------------------------------------------------
    function V = getCOPseulCommun(tO)
      V =tO.getCOPseul();
    end

  end  % methods

end