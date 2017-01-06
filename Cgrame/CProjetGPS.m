%
% classdef CProjetGPS < CBasePourFigureAnalyse
%
% Calcul des distances parcourues
%        virage à gauche et à droite.
%
% METHODS
%       AuTravail(tO, src, event)
%       ChangeCanPoint(tO, src, event)
%       ChangeDist(tO, src, event)
%       ChangeEss(tO, src, event)
%       ChangeInterv(tO, src, event)
%       ChangeLAT(tO, src, event)
%       ChangeLON(tO, src, event)
%       ChangeUnit(tO, src, event)
%       ChangeViraD(tO, src, event)
%       ChangeViraG(tO, src, event)
%  tO = CProjetGPS()     % CONSTRUCTOR
%   V = GetCanPoint(tO)
%       QuelFonction(tO)
%
classdef CProjetGPS < CBasePourFigureAnalyse

  properties
    cLON =1;              % canal des longitudes
    cLAT =1;              % canal des latitudes
    Unit =1;              % Unité -> degré ou radian
    Interv =true;         % Valeur du radiobutton des intervalles
    Ess =true;            % Valeur du radiobutton des essais
    LbEss =[];            % Handle de la listbox des essais
    LbCan =[];            % Handle de la listbox des canaux
    LbPti =[];            % Handle de la listbox del primero punto
    LbPtf =[];            % Handle de la listbox del punto ultimo
    LbCanVit =[];         % Handle du ListBox du canal de vitesse
    PI ='Pi';             % Valeur du pt initial
    PF ='Pf';             % Valeur du pt final
    Distance =false;      % Valeur du radiobutton Calcul de la distance
    Vgauche =false;       % Valeur du radiobutton Marquage virage à gauche
    Vdroite =false;       % Valeur du radiobutton Marquage virage à droite
    lecan =1;             % Valeur du canal de référence
    CdistP =[];           % numéro du canal de la distance parcourue (en sortie)
    CviraG =[];           % numéro du canal des virage à gauche (en sortie)
    CviraD =[];           % numéro du canal des virage à droite (en sortie)
    lesess =[];           % essai à traiter
    Fonction =[];         % handle de la fonction de travail
  end

  methods

    %------------
    % CONSTRUCTOR
    %------------------------
    function tO = CProjetGPS()
      tO.fig =IProjetGPS(tO);
      tO.afficheStatus();
    end

    %------------------------------------------
    % modifie le canal du choix de la longitude
    %---------------------------------
    function ChangeLON(tO, src, event)
      tO.cLON =get(src, 'value');
    end

    %----------------------------------------
    % modifie le canal du choix de la latitude
    %---------------------------------
    function ChangeLAT(tO, src, event)
      tO.cLAT =get(src, 'value');
    end

    %-------------------------------------------
    % modifie le choix des unités de travail, si le
    % radiobutton est coché on est en degré sinon en
    % radian (le GPS donne des degré habituellement).
    %----------------------------------
    function ChangeUnit(tO, src, event)
      tO.Unit =get(src, 'Value');
    end

    %-------------------------------------------------------------
    % si le radiobutton est coché, on travail sur tous les essais.
    % sinon, on "enable" la listebox pour le choix des essais.
    %---------------------------------
    function ChangeEss(tO, src, event)
      tO.Ess =get(src, 'Value');
      if tO.Ess
        set(tO.LbEss, 'Enable','off');
      else
        set(tO.LbEss, 'Enable','on');
      end
    end

    %----------------------------------------------------------------------------
    % si le radiobutton est coché, on travail sur tous les échantillons du canal.
    % sinon, on "enable" la listebox pour le choix du canal et des points initial et final.
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

    %-----------------------------
    % change le canal de référence
    % (si on utilise des points marqués)
    %--------------------------------------
    function ChangeCanPoint(tO, src, event)
      tO.lecan =get(src, 'Value');
    end

    %----------------------------------------------------
    % on a cliqué sur le radiobutton "Distance parcourue"
    % on modifie la propriété en conséquence 
    %----------------------------------
    function ChangeDist(tO, src, event)
      tO.Distance =get(src, 'Value');
    end

    %-------------------------------------------------
    % on a cliqué sur le radiobutton "Vitage à gauche"
    % on modifie la propriété en conséquence 
    %-----------------------------------
    function ChangeViraG(tO, src, event)
      tO.Vgauche =get(src, 'Value');
    end

    %-------------------------------------------------
    % on a cliqué sur le radiobutton "Vitage à droite"
    % on modifie la propriété en conséquence 
    %-----------------------------------
    function ChangeViraD(tO, src, event)
      tO.Vdroite =get(src, 'Value');
    end

    %------------------------------------------
    % En fonction du choix fait dans le GUI, on
    % initialise la propriété du handle de fonction
    %------------------------
    function QuelFonction(tO)
      if tO.Interv
        tO.Fonction =@Tout2D;
    	else
     		tO.Fonction =@parPoint2D;
     	end
    end

    %----------------------------------------------
    % on retourne le canal choisi dans la listebox.
    % il faut se rappeler que la listebox a deux lignes
    % supplémentaires au début:
    %   Canal de Longitude
    %   Canal de latitude
    %---------------------------
    function V = GetCanPoint(tO)
      V =tO.lecan-2;
      switch tO.lecan
      case 1
      	V =tO.cLON;
      case 2
      	V =tO.cLAT;
      end
    end

    %--------------------------------------------
    % affiche une string dans une barre de status
    %--------------------------------
    function afficheStatus(tO, texto)
      if nargin < 2
        texto ='Remplissez chacune des sections et cliquez sur "Au travail"';
      end
      set(findobj('Tag','LeStatus'), 'String',texto);
    end

    %-----------------------------------
    % On a cliqué le bouton "au travail"
    %---------------------------------
    function AuTravail(tO, src, event)
      try
        calculGPS(tO);
        gaglobal('editnom');
        tO.terminus();
      catch e
        tO.afficheStatus(e.message);
      end
    end

  end % methods
end % classdef
