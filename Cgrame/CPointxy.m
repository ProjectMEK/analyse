%
% Classe CPointxy
%
% gestion des point à afficher dans l'axe (canal-X Vs canal-Y)
%
classdef CPointxy < CPoints

  properties
    cx =[];   % true -> canalX
    offset =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    % EN ENTRÉE
    %   H   --> handle de la ligne dans l'axe
    %   fid --> handle du CFichier
    %   ess --> essai rattaché à ce point
    %   can --> canal rattaché à ce point
    %   N   --> numéro du point
    %   O   --> valeur du offset
    %   Cx  --> canal pour X
    %-----------------------------------------
    function obj =CPointxy(H, fid, ess, can, N, O, Cx)
      % on call le constructor de notre héritage
      obj =obj@CPoints(H, fid, ess, can, N);
      obj.offset =O;
      obj.cx =Cx;
      if Cx
      	obj.typtxt =[' (X) '];
      else
      	obj.typtxt =[' (Y) '];
      end
    end

    %-------------------------------------------------
    % fonction overloadé
    % callback appeler par le menu "appliquer" lorsque
    % l'on clique du bouton gauche sur un point marqué
    %------------------------------
    function mnuapplique(obj,a,b,c)
      obj.applique(obj.dtcursor.DataIndex+obj.offset);
    end

  end % methods
end % classdef
