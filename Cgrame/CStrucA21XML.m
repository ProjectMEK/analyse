%
% Classe CStrucA21XML()
% MEK - mars 2012
%
% Les properties sont les champs à lire dans le fichier XML
%
% METHODS
%   InitStruc(tO, N)
%
%
classdef CStrucA21XML < handle

  properties
    FrameNum;
    Date;
    Heure;
    TempsPC;
    Type;
    Latitude;
    Longitude;
    AltitudeMSL;
    GeoidSep;
    HAcc;
    VAcc;
    Vitesse3D;
    VitesseN;
    VitesseE;
    VitesseD;
    Vitesse;
    Cap;
    MTMZone;
    MTMEasting;
    MTMNorthing;
    ECEFx;
    ECEFy;
    ECEFz;
    PAcc;
    ECEFvx;
    ECEFvy;
    ECEFvz;
    SAcc;
  end % properties

  methods

    %------------------------
    function InitStruc(tO, N)
      G =CStrucA21XML();

      K =CParamGlobal.getInstance();
      if K.matlab
        % Matlab permet l'utilisation de la commande "properties"
        U =getProp(G);
      else
        % Octave ne le permet pas
        U =fieldnames(G);
      end

      delete(G);
      for V =1:length(U)
        tO.(U{V}) =zeros(N, 1);
      end
    end

  end  % methods
end  % classdef
