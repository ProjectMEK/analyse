%
% classdef CGmenu < handle
%
% Class pour la gestion des menus de l'interface (GUI) principale
%
% METHODS disponibles
%   Absolue(thisObj, src, event)
%   ajouterFichier(thisObj,src,event)
%   angulo(thisObj,src,event)
%   thisObj =CGmenu(papa)
%   CentreDePressionFichier(thisObj,src,event)
%   CentreDePressionManuel(thisObj,src,event)
%   corrige(thisObj,src,event)
%   couper(thisObj,src,event)
%   decime(thisObj,src,event)
%   decouper(thisObj,src,event)
%   derive(thisObj,src,event)
%   DistParcourueXYZ(thisObj,src,event)
%   Distrib(thisObj, src, event)
%   ecef2lla(thisObj,src,event)
%   echeltmp(thisObj,src,event)
%   EcritResultat(thisObj,src,event)
%   EditCategorie(thisObj,src,event)
%   EditEchelTps(thisObj, src,event)
%   ellipse(thisObj,src,event)
%   Emgmoyen(thisObj, src, event)
%   Exportation(thisObj,src,event)
%   filtre(thisObj,src,event)
%   importpt(tO, src, event)
%   intcum(thisObj,src,event)
%   integr(thisObj,src,event)
%   Intesucc(thisObj, src, event)
%   lesPreferencias(tO)
%   Lissage(thisObj, src, event)
%   marquage(thisObj,src,event)
%   moindre(thisObj,src,event)
%   moyectype(thisObj,src,event)
%   moypoint(thisObj,src,event)
%   Normalis(thisObj, src, event)
%   normalise(thisObj,src,event)
%   normaltemps(thisObj,src,event)
%   ProjetGPS(thisObj,src,event)
%   rebase(thisObj,src,event)
%   RebatirCategorie(thisObj,src,event)
%   Rootmeansquare(thisObj, src, event)
%   rotation(thisObj,src,event)
%   sptoul(thisObj,src,event)
%   statPourCOP(thisObj,src,event)
%   synchro(thisObj,src,event)
%   synchrocan(thisObj,src,event)
%   tretcanal(thisObj,src,event)
%   Trio(thisObj, src, event)
%   ZerosCrossing(thisObj, src, event)
%
% MEK - juillet 2009
% Gestion des fonction du menu principal
%
classdef CGmenu < handle

  properties
    hA =[];         % handle pour un objet de la classe CAnalyse
  end

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTRÉE on veut: papa un objet de la classe CAnalyse
    %-----------------------------
    function thisObj =CGmenu(papa)
      thisObj.hA =papa;
    end

    %__________________________
    % ------- MENU FICHIER *****
    function ajouterFichier(thisObj,src,event)
      ajoutFichAnalyse();
    end
    %-------
    function Exportation(thisObj,src,event)
      exportacion();                            % --> Exportation (des données d'une courbe ds un fichier texte)
    end
    %-------
    function EcritResultat(thisObj,src,event)
      resultats();
    end
    %------------------------
    % Gestion des préférences
    %-------
    function lesPreferencias(tO, src, evnt)
      foo =CPreference();
    end
    %_______________________
    % ------- MENU EDIT *****
    function EditCategorie(thisObj,src,event)
      hEC =CEditCateg(true);
    end
    %-------
    function RebatirCategorie(thisObj,src,event)
      hEC =CEditCateg(false);
      hEC.RebatirCategorie();
      delete(hEC);
    end
    %-------
    function EditEchelTps(thisObj, src,event)
      ITpchnl();
    end
    %___________________________
    % ------- MENU MODIFIER *****
    function corrige(thisObj,src,event)               % Correction des datas perturbées
      Otmp =CCorrige();
    end
    %-------
    function couper(thisObj,src,event)
      couperData();
    end
    %-------
    function decouper(thisObj,src,event)
      OW =CDecoup();
    end
    %-------
    function decime(thisObj,src,event)
      decimage();
    end
    %-------
    function rebase(thisObj,src,event)
      rebase();
    end
    %-------
    function rotation(thisObj,src,event)
      rotationPlan();
    end
    %-------
    function synchro(thisObj,src,event)        % les essais
      synchroEss();
    end
    %-------
    function synchrocan(thisObj,src,event)     % les canaux
      synchroCan();
    end
    %_______________________
    % ------- MENU MATH *****
    function filtre(thisObj,src,event)         % ButterWorth
      filtreBW();
    end
    %-------
    function sptoul(thisObj,src,event)         % Complément à SPTOOL
      fiFilt();
    end
    %-------
    function derive(thisObj,src,event)         % Le même DIFFER que dans DATAC.DOS
      fncDiffer();
    end
    %-------
    function moindre(thisObj,src,event)        % Menu Polynomial-Fit
      moindreCarre();                          % dérivé par la méthode des moindres carrés
    end
    %-------
    function integr(thisObj,src,event)         % Intégrale définie
      integSuc(0,1);
    end
    %-------
    function intcum(thisObj,src,event)         % Intégrale Cumulative
      integCum();
    end
    %-------
    function normalise(thisObj,src,event)      % Normalisation
      normalise();
    end
    %-------
    function normaltemps(thisObj,src,event)    % Normalisation Temporelle
      normTemporel();
    end
    %-------
    function ellipse(thisObj,src,event)        % Ellipse de confiance
      ellipse();
    end
    %-------
    function moyectype(thisObj,src,event)      % Moyenne et Ecart-type par catégorie
      essmoy();
    end
    %-------
    function moypoint(thisObj,src,event)       % Moyenne autour des points marqués
      hMoy =CMoyAutourPt();
    end
    %-------
    function angulo(thisObj,src,event)         % Calcul d'angle
      angulo();
    end
    %-------
    function tretcanal(thisObj,src,event)      % Traitement de canal
      OW =CTretcan();
    end
    %_________________
    % ------- EMG *****
    function Absolue(thisObj, src, event)      % --> Rectification
      ValAbs();
    end
    %-------
    function Lissage(thisObj, src, event)
      EMGLissage();                            % --> Lissage
    end
    %-------
    function Rootmeansquare(thisObj, src, event)
      EMGRms();                                % --> RMS
    end
    %-------
    function Emgmoyen(thisObj, src, event)
      EMGMav();                                % --> MAV
    end
    %-------
    function Trio(thisObj, src, event)
      EMGTrio();                               % --> FM-FMoy-Max
    end
    %-------
    function Normalis(thisObj, src, event)
      EMGNorm();                               % --> Normalisation
    end
    %-------
    function Intesucc(thisObj, src, event)
      integSuc(1,0);                               % --> Integrations successives
    end
    %-------
    function ZerosCrossing(thisObj, src, event)
      EMGZero();                                   % --> Changement de polarité
    end
    %-------
    function Distrib(thisObj, src, event)          % --> Distrib de prob d'amplit       OK
      EMGDistrib();
    end
    %_______________________
    % ------- MENU FPLT *****
    % pour le call de CCalculCOP(type, manuel)
    %     type: vielle plateforme(0),  Optima(1)
    %   manuel: call le GUI(1),  call un fichier(0)
    %
    function CentreDePressionManuel(thisObj,src,event)   % Calcul la position du COP avec GUI
      hDP =CCalculCOP(true);
    end
    %-------
    function CentreDePressionFichier(thisObj,src,event)  % Calcul la position du COP sans GUI
      hDP =CCalculCOP(false);
    end
    %-------
    function COPoptimaManuel(thisObj,src,event)          % Calcul la position du COP avec GUI (Optima)
      hDP =CCalculCOPoptima(true);
    end
    %-------
    function COPoptimaFichier(thisObj,src,event)         % Calcul la position du COP sans GUI (Optima)
      hDP =CCalculCOPoptima(false);
    end
    %-------
    function statPourCOP(thisObj,src,event)              % Calcul statistique à partir du COP
      hDP =CStat4COP();
    end
    %______________________________
    % ------- MENU TRAJECTOIRE *****
    function ProjetGPS(thisObj,src,event)   % Calcul la distance parcourue
      hDP =CProjetGPS();
    end
    %-------
    function ecef2lla(thisObj,src,event)       % (GPS)ECEF vers LLA
      CGPSecef2lla.ouverture();
    end
    %-------
    function DistParcourueXYZ(thisObj,src,event)   % Calcul la distance parcourue
      hDP =CDistParcourXYZ();
    end
    %_________________________
    % ------- MENU OUTILS *****
    function echeltmp(thisObj,src,event)
      hF =thisObj.hA.findcurfich();
      hF.Tpchnl.OnMenuClicked(0);
      thisObj.hA.OFig.affiche();
    end
    %-------
    function importpt(tO, src, event)
      V =CImportPoint();
    end
    %-------
    function marquage(thisObj,src,event)           % Interface pour marquer automatiquement
      OM =CMark.getInstance();
    end

  end %methods
end

