%
% classdef CCalculCOPParam < handle
%
% METHODS
%    V =getAmtiMC(tO)
%    V =getCanFx(tO)
%    . = . . . . . .
%    V =getCanMz(tO)
%    V =getGainFx(tO)
%    . = . . . . . .
%    V =getGainMz(tO)
%    V =getVFx(tO)
%    . = . . . . .COPseul
%    V =getVMz(tO)
%    V =getZOff(tO)
%       importation(tO, p)
%       setGain(tO, V)
%       setVext(tO, V)
%
classdef CCalculCOPParam < handle

  properties (Access =protected)
    % Avec quelle plateforme on travaille
    newplt =0;        % (0)ancienne plateforme. (1) Optima
    % Calcul du COP seulement
    COPseul =true;
    % Numéro des canaux lus
    canFx =0;         % canal Fx
    canFy =0;         % canal Fy
    canFz =0;         % canal Fz
    canMx =0;         % canal Mx
    canMy =0;         % canal My
    canMz =0;         % canal Mz
    % Matrice de calibration de la AMTI
    amtiMC =[0.734  0.001 -0.001  0.000  0.001  0.001;...
             0.004  0.728  0.001  0.002 -0.001 -0.000;...
             0.002 -0.002  0.396 -0.007 -0.003 -0.002;...
            -0.010  0.000 -0.009  1.545  0.000  0.000;...
             0.010  0.005 -0.001  0.007  1.545  0.007;...
            -0.035 -0.020  0.037 -0.053  0.033  6.005];
    % Matrice des facteurs de conversion (Optima). (dans la doc: Analog Scale Factor)
    optimaFC =[15.0 15.0 2.5 13.5 13.5 40.0];
    % --- Paramètre amplificateur MSA-6
    vFx = 10.004;
    vFy = 10.004;
    vFz = 4.988;
    vMx = 10.004;
    vMy = 10.004; 
    vMz = 10.004;
    % GAIN
    gainFx = 4018.1;
    gainFy = 3988.8;
    gainFz = 1979.9;
    gainMx = 1998.6;
    gainMy = 1996.4;
    gainMz = 4006.8;
    % --- Offset sur l'axe Z
    zOff =0.035;
  end

  methods

    %-----------------------------
    % importation des propriétés à
    % partir de la structure "p"
    %--------------------------
    function importation(tO, p)
      if isa(p,'struct')
        obj =CCalculCOPParam();
        champ =fields(p);
        for u =1:length(champ)
          if ~isempty(obj.findprop(champ{u}))
            tO.(champ{u}) =p.(champ{u});
          end
        end
      end
    end

    %---------------------------------------
    % Gain
    % initialisation des propriétés "gain**"
    % à partir de la matrice V
    %----------------------
    function setGain(tO, V)
      if length(V) == 6
        tO.gainFx =V(1);
        tO.gainFy =V(2);
        tO.gainFz =V(3);
        tO.gainMx =V(4);
        tO.gainMy =V(5);
        tO.gainMz =V(6);
      end
    end

    %---------------------------------------
    % Paramètre amplificateur
    % initialisation des propriétés "v**"
    % à partir de la matrice V
    %----------------------
    function setVext(tO, V)
      if length(V) == 6
        tO.vFx =V(1);
        tO.vFy =V(2);
        tO.vFz =V(3);
        tO.vMx =V(4);
        tO.vMy =V(5);
        tO.vMz =V(6);
      end
    end

    %-------
    % GETTER
    %------------------------
    function V =getNewplt(tO)
      V =tO.newplt;
    end

    %------------------------
    function V =getAmtiMC(tO)
      V =tO.amtiMC;
    end

    %--------------------------
    function V =getOptimaFC(tO)
      V =tO.optimaFC;
    end

    %-----------------------
    function V =getCanFx(tO)
      V =tO.canFx;
    end

    %-----------------------
    function V =getCanFy(tO)
      V =tO.canFy;
    end

    %-----------------------
    function V =getCanFz(tO)
      V =tO.canFz;
    end

    %-----------------------
    function V =getCanMx(tO)
      V =tO.canMx;
    end

    %-----------------------
    function V =getCanMy(tO)
      V =tO.canMy;
    end

    %-----------------------
    function V =getCanMz(tO)
      V =tO.canMz;
    end

    %---------------------
    function V =getVFx(tO)
      V =tO.vFx;
    end

    %---------------------
    function V =getVFy(tO)
      V =tO.vFy;
    end

    %---------------------
    function V =getVFz(tO)
      V =tO.vFz;
    end

    %---------------------
    function V =getVMx(tO)
      V =tO.vMx;
    end

    %---------------------
    function V =getVMy(tO)
      V =tO.vMy;
    end

    %---------------------
    function V =getVMz(tO)
      V =tO.vMz;
    end

    %--------------------------
    function V =getCOPseul(tO)
      V =tO.COPseul;
    end


    %------------------------
    function V =getGainFx(tO)
      V =tO.gainFx;
    end

    %------------------------
    function V =getGainFy(tO)
      V =tO.gainFy;
    end

    %------------------------
    function V =getGainFz(tO)
      V =tO.gainFz;
    end

    %------------------------
    function V =getGainMx(tO)
      V =tO.gainMx;
    end

    %------------------------
    function V =getGainMy(tO)
      V =tO.gainMy;
    end

    %------------------------
    function V =getGainMz(tO)
      V =tO.gainMz;
    end

    %----------------------
    function V =getZOff(tO)
      V =tO.zOff;
    end

  end % methods
end % classdef
