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
    LesPan;               % handles des panels de param�tres
    ecraser =false;       % on veut la r�ponse dans le m�me canal
    Ess =true;            % Tous les essais sont choisis
    LbEss;                % handle de la listbox Essai
    CualCan =1;           % Value canaux � corriger
    Interv =true;         % on travaille sur tous le canal
    lecan =1;             % Canal de r�f�rence
    LbPti;                % handle du �dit du point initials
    LbPtf;                % handle du �dit du point final
    LbCan;                % handle du �dit du canal de r�f�rence
    DebFin =false;        % Trabaja sur les d�buts et fins solamente
    critere =false;       % on ne choisi pas plus de crit�re dans nouvel valeur
    choixcritere =1;      % le crit�re � appliquer
    vcritere =0;          % valeur du crit�re � respecter
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
    % Callback pour s�lectionner si on travaille
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
    % Callback pour s�lectionner si on travaille
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
    % Callback pour changer le canal de r�f�rence 
    % pour le choix des points marqu�s.
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
    % on �crase --> on �crit dans le canal source
    % la propri�t� "ecraser" conserve la s�lection
    %--------------------------------
    function OnEcrase(tO, src, event)
      tO.ecraser =get(src, 'Value');
    end

    %------------------------------------------------------
    % Callback pour choisir si on utilise les crit�res lors
    % de la correction "Nouvelle valeur entre deux points"
    %-------------------------------------
    function toggleCritere(tO, src, event)
      tO.critere =get(src, 'Value');
      set(findobj('Tag','LBChoixCritere'), 'Enable',char(CEOnOff(tO.critere)));
    end

    %--------------------------------------------
    % Callback pour choisir le crit�re lors de la
    % correction "Nouvelle valeur entre deux points"
    %-------------------------------------
    function ChangeCritere(tO, src, event)
      tO.choixcritere =get(src, 'Value');
    end

    %----------------------------------------------
    % Callback pour �diter la valeur de comparaison 
    % pour le travail avec crit�re
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
    % Toggle entre le choix: D�but-Fin/Tout l'interval
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
    % au type de correction s�lectionn� � gauche.
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
