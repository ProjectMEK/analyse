%
% Classe CCorrige < CBasePourFigureAnalyse
%
% methods
%        tO = CCorrige()                % CONSTRUCTOR
%             CualCanEs(tO, src, event)
%
classdef CCorrige < CBasePourFigureAnalyse

  properties
    Ofich;
    Hdchnl;
    Vg;
    figP;                 % figure principale
    LesPan;               % handles des panels de paramètres
    ecraser =false;       % on veut la réponse dans le même canal
    Ess =true;            % Tous les essais sont choisis
    LbEss;                % handle de la listbox Essai
    CualCan =1;           % Value canaux à corriger
    Interv =true;         % on travaille sur tous le canal
    lecan =1;             % Canal de référence
    LbPti;                % handle du Édit du point initials
    LbPtf;                % handle du Édit du point final
    LbCan;                % handle du Édit du canal de référence
    DebFin =false;        % Trabaja sur les débuts et fins solamente
    critere =false;       % on ne choisi pas plus de critère dans nouvel valeur
    choixcritere =1;      % le critère à appliquer
    vcritere =0;          % valeur du critère à respecter
  end

  methods

    %-----------------------
    % CONSTRUCTOR
    %-----------------------
    function tO = CCorrige()
      OA =CAnalyse.getInstance();
      tO.Ofich =OA.findcurfich();
      tO.Hdchnl =tO.Ofich.Hdchnl;
      tO.Vg =tO.Ofich.Vg;
      tO.figP =OA.OFig;
      tO.fig =GUICorrige(tO);
      tO.setFigModal();
    end

    %-----------------------
    % DESTRUCTOR
    %-----------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %---------------------------------
    % Callback pour changer le canal
    %---------------------------------
    function CualCanEs(tO, src, event)
      tO.CualCan =get(src, 'Value');
      tO.ChangeCanPoint(tO.LbCan);
    end

    %-------------------------------------------
    % Callback pour sélectionner si on travaille
    % sur tous les essais ou sur certains
    %---------------------------------
    function ChangeEss(tO, src, event)
      tO.Ess =get(src, 'Value');
      if tO.Ess
        set(tO.LbEss, 'Enable','off');
      else
        set(tO.LbEss, 'Enable','on');
      end
    end

    %-------------------------------------------
    % Callback pour sélectionner si on travaille
    % sur tout le canal ou seulement une section
    %------------------------------------
    function ChangeInterv(tO, src, event)
      tO.Interv =get(src, 'value');
      if tO.Interv
      	set(tO.LbCan, 'Enable','off');
      	set(tO.LbPti, 'Enable','off');
      	set(tO.LbPtf, 'Enable','off');
      else
      	set(tO.LbCan, 'Enable','on');
      	set(tO.LbPti, 'Enable','on');
      	set(tO.LbPtf, 'Enable','on');
      end
    end

    %--------------------------------------------
    % Callback pour changer le canal de référence 
    % pour le choix des points marqués.
    %--------------------------------------
    function ChangeCanPoint(tO, src, event)
      tO.lecan =get(src, 'Value')-1;
      if ~ tO.lecan
        tO.lecan =tO.CualCan;
      else
        tO.lecan =ones(size(tO.CualCan))*tO.lecan;
      end
    end

    %--------------------------------------------
    % on écrase --> on écrit dans le canal source
    % la propriété "ecraser" conserve la sélection
    %--------------------------------
    function OnEcrase(tO, src, event)
      tO.ecraser =get(src, 'Value');
    end

    %------------------------------------------------------
    % Callback pour choisir si on utilise les critères lors
    % de la correction "Nouvelle valeur entre deux points"
    %-------------------------------------
    function toggleCritere(tO, src, event)
      tO.critere =get(src, 'Value');
      set(findobj('Tag','LBChoixCritere'), 'Enable',char(CEOnOff(tO.critere)));
    end

    %--------------------------------------------
    % Callback pour choisir le critère lors de la
    % correction "Nouvelle valeur entre deux points"
    %-------------------------------------
    function ChangeCritere(tO, src, event)
      tO.choixcritere =get(src, 'Value');
    end

    %----------------------------------------------
    % Callback pour éditer la valeur de comparaison 
    % pour le travail avec critère
    %-------------------------------------
    function valeurCritere(tO, src, event)
      v =str2num(get(src, 'String'));
      if ~isempty(v)
        tO.vcritere =v(1);
      end
      set(src, 'String',num2str(tO.vcritere));
    end

    %---------------------------------------------
    % Toggle entre le choix: spline/polynomial fit
    %--------------------------------
    function Voirpoly(tO, src, event)
      if tO.Vg.valeur == 1
        set(findobj('tag','COrdrePolyTitre'),'Visible','on');
        set(findobj('tag','COrdrePoly'),'Visible','on');
        tO.Vg.valeur = 0;
      else
        set(findobj('tag','COrdrePolyTitre'),'Visible','off');
        set(findobj('tag','COrdrePoly'),'Visible','off');
        tO.Vg.valeur = 1;
      end
    end

    %-------------------------------------------------
    % Toggle entre le choix: Début-Fin/Tout l'interval
    %----------------------------------
    function VoirDebFin(tO, src, event)
      tO.DebFin =get(src, 'Value');
      if tO.DebFin
        set(findobj('tag','CPolyFit'), 'Enable','off');
        set(findobj('tag','CFenCalcul'), 'Enable','off');
        set(findobj('tag','COrdrePoly'), 'Enable','off');
      else
        set(findobj('tag','CPolyFit'), 'Enable','on');
        set(findobj('tag','CFenCalcul'), 'Enable','on');
        set(findobj('tag','COrdrePoly'), 'Enable','on');
      end
    end

    %-----------------------------------------------------------
    % Callback pour afficher le uiPanel de droite qui correspond
    % au type de correction sélectionné à gauche.
    %----------------------------------
    function Voirpoints(tO, src, event)
      set(tO.LesPan, 'visible','off');
      switch get(event.NewValue, 'tag')
      %---
      case {'RB-1', 'RB-2', 'RB-3'}
        set(findobj('tag','MaW'),'enable','on');
        set(findobj('tag','lePan3'), 'Visible','on');
      %---
      case 'RB-4'
        set(findobj('tag','lePan4'), 'Visible','on');
      %---
      case 'RB-5'
        set(findobj('tag','lePan5'), 'Visible','on');
      %---
      case 'RB-6'
        set(findobj('tag','lePan6'), 'Visible','on');
      end
    end

    %--------------------------------
    % Callback du bonton "Au travail"
    %---------------------------------
    function AuTravail(tO, src, event)
      K =corrigeData(tO);
      if K
        tO.Vg.sauve=1;
        tO.Vg.valeur=0;
        if ~tO.ecraser
          gaglobal('editnom');
        else
          tO.figP.affiche();
        end
        tO.terminus();
      end
    end

  end  % methods
end % classdef
