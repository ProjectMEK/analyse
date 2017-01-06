%
% Classe CPoints
%
% gestion des point � afficher dans l'axe (canal Vs temps)
%
classdef CPoints < CPts

  events
    RAffiche
  end

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTR�E
    %   H   --> handle de la ligne dans l'axe
    %   fid --> handle du CFichier
    %   ess --> essai rattach� � ce point
    %   can --> canal rattach� � ce point
    %   N   --> num�ro du point
    %-----------------------------------------
    function obj =CPoints(H, fid, ess, can, N)
      obj =obj@CPts(H, fid, ess, can, N);
      obj.typtxt =' ';
    end

    %-----------------------------------
    % initialise les propri�t�s du point
    %   I  --> index de l'�chantillon dans ce canal
    %   A  --> 'on' ou 'off' d�pendant si on affiche
    %--------------------------
    function initial(obj, I, A)
      cmnu =uicontextmenu;
      mnu =uimenu(cmnu,'Label','Appliquer', 'Callback',@obj.mnuapplique);
      mnu =uimenu(cmnu,'Label','D�placer', 'Callback',@obj.deplace);
      mnu =uimenu(cmnu,'Label','Effacer', 'Callback',@obj.efface,'separator','on');
      mnu =uimenu(cmnu,'Label','Point bidon', 'Callback',@obj.bidon);
      if obj.fichier.Vg.pt == 1
        mnu =uimenu(cmnu,'Label','Font-Plus', 'Callback',@obj.fontplus,'separator','on');
        mnu =uimenu(cmnu,'Label','Font-Moins','Callback',@obj.fontmoins);
        obj.dttip.StringFcn =@obj.Eltexto;
      else
      	obj.dttip.StringFcn =@obj.EltextoVide;
      end
      mnu =uimenu(cmnu,'Label','Marqueur-Plus', 'Callback',@obj.marqueurplus,'separator','on');
      mnu =uimenu(cmnu,'Label','Marqueur-Moins','Callback',@obj.marqueurmoins);
      obj.dttip.UIContextMenu =cmnu;
      ptchnl =obj.fichier.Ptchnl;
      hdchnl =obj.fichier.Hdchnl;
      obj.type =ptchnl.Dato(obj.numero,hdchnl.point(obj.canal,obj.essai),2);
      typo ='';
      switch obj.type
        case 1
          typo ='FM�d';
        case 2
          typo ='FMoy';
        case 3
          typo ='FMax';
      end
      obj.typtxt =['P:' num2str(obj.numero) obj.typtxt typo];
      obj.bouge(I);
      obj.dttip.Visible = char(A);
    end

    %---------------------------------
    % finalise l'effacement d'un point
    %--------------------
    function efface2(obj)
      obj.fichier.Vg.sauve =true;
      notify(obj,'RAffiche');
    end

    %-------------------------------------
    % finalise le "bidonnement" d'un point
    %-------------------
    function bidon2(obj)
      notify(obj,'RAffiche');
    end

    %-------------------------------------------------
    % callback appeler par le menu "appliquer" lorsque
    % l'on clique du bouton gauche sur un point marqu�
    %------------------------------
    function mnuapplique(obj,a,b,c)
      obj.applique(obj.dtcursor.DataIndex);
    end

  end % methods
end % classdef
