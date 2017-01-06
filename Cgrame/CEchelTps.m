%
% Classe CEchelTps
%
% Gestion des échelles de temps
% C'est le moyen de pouvoir afficher le zéro temporel ailleur qu'au
% premier échantillon. On détermine un canal et un point marqué de ceil
% canal et ce dernier devient le zéro.
%
classdef CEchelTps < handle

  properties
    hMnu =[];            % handle du menu echelle de temps.
    papa =[];            % handle sur le conteneur CTpchnlAnalyse
    nom =[];             % nom de l'échelle.
    canal =[];           % canal de réf de l'échelle.
    point =[];           % point de réf de l'échelle.
  end

  methods

    %------------
    % CONSTRUCTOR
    % création d'une nouvelle ligne de menu --> tO.hMnu
    % EN ENTRÉE
    %   Lepapa   --> handle d'un objet CTpchnlAnalyse (conteneur)
    %   Lenom    --> nom affiché dans le menu
    %   Lecanal  --> canal de réf
    %   Lepoint  --> point marqué de réf
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
    % modification de l'un des paramètres
    %--------------------------------------------------
    function Modifier(thisObj, Lenom, Lecanal, Lepoint)
      thisObj.ModNom(Lenom);
      thisObj.ModCanal(Lecanal);
      thisObj.ModPoint(Lepoint);
    end

    %----------------------------------
    % modification du nom de l'échelle.
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
    % Callback associé à la ligne du menu
    %------------------------------------------
    function OnMenuClicked(thisObj, src, event)
      thisObj.papa.OnMenuClicked(thisObj.papa.QuiSuisje(thisObj));
      hA =CAnalyse.getInstance();
      hA.OFig.affiche();
    end

    %----------------------
    % sert à cocher le menu
    %------------------------
    function checkon(thisObj)
      set(thisObj.hMnu, 'Checked','on');
    end

    %------------------------------
    % sert à rendre ce menu visible
    %------------------------
    function montrer(thisObj)
      set(thisObj.hMnu, 'visible','on');
    end

  end  %methods
end