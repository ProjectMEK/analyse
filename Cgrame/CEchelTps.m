%
% Classe CEchelTps
%
% Gestion des �chelles de temps
% C'est le moyen de pouvoir afficher le z�ro temporel ailleur qu'au
% premier �chantillon. On d�termine un canal et un point marqu� de ceil
% canal et ce dernier devient le z�ro.
%
classdef CEchelTps < handle

  properties
    hMnu =[];            % handle du menu echelle de temps.
    papa =[];            % handle sur le conteneur CTpchnlAnalyse
    nom =[];             % nom de l'�chelle.
    canal =[];           % canal de r�f de l'�chelle.
    point =[];           % point de r�f de l'�chelle.
  end

  methods

    %------------
    % CONSTRUCTOR
    % cr�ation d'une nouvelle ligne de menu --> tO.hMnu
    % EN ENTR�E
    %   Lepapa   --> handle d'un objet CTpchnlAnalyse (conteneur)
    %   Lenom    --> nom affich� dans le menu
    %   Lecanal  --> canal de r�f
    %   Lepoint  --> point marqu� de r�f
    %-----------------------------------------------------------
    function tO =CEchelTps(Lepapa, Lenom, Lecanal, Lepoint)
      tO.papa =Lepapa;
      tO.nom =Lenom;
      tO.canal =Lecanal;
      tO.point =Lepoint;
      tO.hMnu =uimenu('Parent',Lepapa.hMnu,'callback',@tO.OnMenuClicked,'Label',tO.nom);
    end

    %-----------
    % DESTRUCTOR
    %-----------------------
    function delete(thisObj)
      delete(thisObj.hMnu);
    end

    %-------------------------------
    % on overload la fonction "find"
    %--------------------------------
    function Cok =find(thisObj, hndl)
      Cok =(thisObj == hndl);
    end

    %------------------------------------
    % modification de l'un des param�tres
    %--------------------------------------------------
    function Modifier(thisObj, Lenom, Lecanal, Lepoint)
      thisObj.ModNom(Lenom);
      thisObj.ModCanal(Lecanal);
      thisObj.ModPoint(Lepoint);
    end

    %----------------------------------
    % modification du nom de l'�chelle.
    %------------------------------
    function ModNom(thisObj, Lenom)
      thisObj.nom =Lenom;
      set(thisObj.hMnu, 'Label',thisObj.nom);
    end

    %----------------------
    % modification du canal
    %------------------------------
    function ModCanal(thisObj, Lecanal)
      thisObj.canal =Lecanal;
    end

    %----------------------
    % modification du point
    %------------------------------
    function ModPoint(thisObj, Lepoint)
      thisObj.point =Lepoint;
    end

    %------------------------------------
    % Callback associ� � la ligne du menu
    %------------------------------------------
    function OnMenuClicked(thisObj, src, event)
      thisObj.papa.OnMenuClicked(thisObj.papa.QuiSuisje(thisObj));
      hA =CAnalyse.getInstance();
      hA.OFig.affiche();
    end

    %----------------------
    % sert � cocher le menu
    %------------------------
    function checkon(thisObj)
      set(thisObj.hMnu, 'Checked','on');
    end

    %------------------------------
    % sert � rendre ce menu visible
    %------------------------
    function montrer(thisObj)
      set(thisObj.hMnu, 'visible','on');
    end

  end  %methods
end