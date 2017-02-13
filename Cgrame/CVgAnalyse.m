%
% classdef CVgAnalyse < CVgFichier
%
% Variables globales des fichiers format Analyse
%
% METHODS
%          initial(tO, vg)
%          majVgWmh(tO)
%          majWmhVg(tO)
%      v = getWmh(tO)
%          setWmh(tO, v)
%
classdef CVgAnalyse < CVgFichier

  properties (Access =protected)
    wmh =CParamMark();  % Utilisé par le Gui du marquage automatique
  end

  methods

    %-----------------------------------
    % Initialisation des properties "vg"
    % et celles de wmh
    %-----------------------
    function initial(tO, vg)
      initial@CVgFichier(tO, vg);
      tO.majWmhVg();
    end

    %-------------------------------
    % Mise à jour wmh à partir de vg
    %--------------------
    function majWmhVg(tO)
      vg =tO.databrut();
      tO.wmh.initial(vg);
      if isempty(tO.wmh.allTri)
        tO.wmh.setAllTri(1:tO.ess);
      end
    end

    %-------------------------------
    % Mise à jour vg à partir de wmh
    %--------------------
    function majVgWmh(tO)
      v =CParamMark();
      K =CParamGlobal.getInstance();
      if K.matlab
        % Matlab permet l'utilisation de la commande "properties"
        p =getProp(v);
      else
        % Octave ne le permet pas
        p =fieldnames(v);
      end
      delete(v);
      vg =tO.databrut();
      for u =1:length(p)
        if isfield(vg, p{u})
          tO.(p{u}) =tO.wmh.(p{u});
        end
      end
      tO.can =tO.wmh.canSrc;
    end

    %--------------
    % GETTER/SETTER
    % ou v --> CParamMark()
    %---------------------------------------
    function v = getWmh(tO)
      v =tO.wmh;
    end
    %-------------------
    function setWmh(tO, v)
      tO.wmh =v;
    end

  end  % methods
end % classdef
