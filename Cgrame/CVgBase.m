%
% Classe CVgBase
%
% Variables Globales pour l'application Analyse
%
classdef CVgBase < handle

  properties
    la_pos =[0.2 0.2 0.7 0.7];
    affiche =uint16(790);     % base2dec('1100010110',2) voir CPref.m
    peinture =0;
    nextkey =0;
    key =0;
  end

  methods

    %------------------------------------
    % Mise à zéro de certaines Propriétés
    %-------------------
    function mazero(obj)
      obj.peinture =false;
      obj.nextkey =0;
      obj.key =0;
    end

  end % methods
end % classdef
