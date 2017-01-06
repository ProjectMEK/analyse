%
% Classe CGrVar
%
% On conserve les "variables/properties" pour l'affichage graphique
%
classdef CGrVar < handle

  properties
    xy =[];
    max2 =[];
    min2 =[];
    max2x =[];
    min2x =[];
    filtmp =[];
    lesdim =[];
    max1 =[];
    min1 =[];
    max1x =[];
    min1x =[];
    leshdls =[];
    lalegend =[];
    tri =[];
    y =[];
    x =[];
    lescats =[];
    nbniv =[];
    comment =[];
    status =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    %---------------------
    function obj =CGrVar()
      obj.reset();
    end

    %---------------------------------------
    % fait un reset de toutes les propriétés
    %------------------
    function reset(obj)
      obj.xy =0;
      obj.max2 =0;
      obj.min2 =0;
      obj.max2x =0;
      obj.min2x =0;
      obj.filtmp =[];
      obj.lesdim =[0 0];
      obj.max1 =0;
      obj.min1 =0;
      obj.max1x =0;
      obj.min1x =0;
      obj.leshdls =[];
      obj.lalegend =[];
      obj.tri =1;
      obj.y =1;
      obj.x =1;
      obj.lescats =[0 0];
      obj.nbniv =1;
      obj.comment ='/';
      obj.status =true;
    end

  end % methods
end % classdef
