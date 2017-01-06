%
% classdef COngletUtil < handle
%
% gestion des onglets dans certains GUI
% les classes comme CGUICalculCOP ou CGUIMark etc... en h�rite
%
% METHODS
%    V =getCurPan(tO)
%    V =getCurPanTag(tO)
%       setCurPan(tO, V)
%       setCurPanTag(tO, V)
%       showPanel(tO, src, event)
%
classdef COngletUtil < handle

  properties (Access =protected)
    curPan =[];       % handle du Panel actif
    curPanTag;        % tag du uipanel actif
  end

  properties (Constant)
    couleurRef =[0.8 0.8 0.8];
    couleurPan =[0.94 0.92 0.92];
  end

  methods

    %--------------
    % GETTER/SETTER
    %------------------------
    function v =getCurPan(tO)
      v =tO.curPan;
    end

    %------------------------
    function setCurPan(tO, v)
      tO.curPan =v;
    end

    %---------------------------
    function v =getCurPanTag(tO)
      v =tO.curPanTag;
    end

    %---------------------------
    function setCurPanTag(tO, v)
      tO.curPanTag =v;
    end

    %-------------------------------------%
    %   GESTION DU CHANGEMENT D'ONGLETS   %
    %-------------------------------------%
    function showPanel(tO, src, event)
      % On r�cup�re le handle de tous les onglets
      S =findobj('Tag','BoutonOnglet');
      % On leur donne la couleur par d�faut
      set(S, 'BackgroundColor',tO.couleurRef);
      % On cache le panel ant�rieur
      set(tO.curPan, 'Visible','off');
      % On r�cup�re le handle du panel � afficher
      tO.curPan =get(src, 'Userdata');
      % On change la couleur du nouvel onglet s�lectionn�
      set(src, 'BackgroundColor',tO.couleurPan);
      % On affiche le nouveau panel s�lectionn�
      set(tO.curPan, 'Visible','on');
      % On r�cup�re le Tag du panel actif
      tO.curPanTag =get(tO.curPan, 'Tag');
    end

  end % methods
end % classdef
