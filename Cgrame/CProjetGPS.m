%
% classdef CProjetGPS < CBasePourFigureAnalyse
%
% Calcul des distances parcourues
%        virage � gauche et � droite.
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
    Unit =1;              % Unit� -> degr� ou radian
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
    Vgauche =false;       % Valeur du radiobutton Marquage virage � gauche
    Vdroite =false;       % Valeur du radiobutton Marquage virage � droite
    lecan =1;             % Valeur du canal de r�f�rence
    CdistP =[];           % num�ro du canal de la distance parcourue (en sortie)
    CviraG =[];           % num�ro du canal des virage � gauche (en sortie)
    CviraD =[];           % num�ro du canal des virage � droite (en sortie)
    lesess =[];           % essai � traiter
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
    % modifie le choix des unit�s de travail, si le
    % radiobutton est coch� on est en degr� sinon en
    % radian (le GPS donne des degr� habituellement).
    %----------------------------------
    function ChangeUnit(tO, src, event)
      tO.Unit =get(src, 'Value');
    end

    %-------------------------------------------------------------
    % si le radiobutton est coch�, on travail sur tous les essais.
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
    % si le radiobutton est coch�, on travail sur tous les �chantillons du canal.
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
    % change le canal de r�f�rence
    % (si on utilise des points marqu�s)
    %--------------------------------------
    function ChangeCanPoint(tO, src, event)
      tO.lecan =get(src, 'Value');
    end

    %----------------------------------------------------
    % on a cliqu� sur le radiobutton "Distance parcourue"
    % on modifie la propri�t� en cons�quence 
    %----------------------------------
    function ChangeDist(tO, src, event)
      tO.Distance =get(src, 'Value');
    end

    %-------------------------------------------------
    % on a cliqu� sur le radiobutton "Vitage � gauche"
    % on modifie la propri�t� en cons�quence 
    %-----------------------------------
    function ChangeViraG(tO, src, event)
      tO.Vgauche =get(src, 'Value');
    end

    %-------------------------------------------------
    % on a cliqu� sur le radiobutton "Vitage � droite"
    % on modifie la propri�t� en cons�quence 
    %-----------------------------------
    function ChangeViraD(tO, src, event)
      tO.Vdroite =get(src, 'Value');
    end

    %------------------------------------------
    % En fonction du choix fait dans le GUI, on
    % initialise la propri�t� du handle de fonction
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
    % suppl�mentaires au d�but:
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
    % On a cliqu� le bouton "au travail"
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
