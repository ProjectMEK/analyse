%
% Classe CLirA21XML(CLiranalyse)
% MEK - mars 2012
%
% Description de la classe pour lire les fichier XML dans les projets
% de conduite "auto-21".
%
%
classdef CLirA21XML < CLirOutils & CStrucA21XML

  properties
    nbess =[];
    frq =4;
    leWb =[];
    lemax =[];
    iindx =[];
    Fid =[];
    laStr = [];
    eltypo =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    %---------------------------
    function tO = CLirA21XML(hF)
      tO.Typo =CFichEnum.A21XML;
      tO.Fich =hF;
      if isdir(tO.Fich.Info.prenom)
        cd(tO.Fich.Info.prenom);
      end
      if tO.selection('*.xml', tO.txtml.a21ouvfich, true)
        ILirA21XML(tO);
      else
        tO.Fermeture();
      end
    end

    %----------------------------------
    % lecture et assimilation des datas
    %-------------------------------
    function Lecture(tO, src, event)
      lirXML(tO);
      mnouvre2(tO.Fich, tO.Typo, tO.txtml);
    end

    %------------------------------------
    % modification de la fréquence du GPS
    %------------------------------------------------
    function TestFrecuencia(tO, src, event, varargin)
      S =str2double(get(src, 'String'));
      if isnan(S)
        set(src, 'String', num2str(tO.frq));
      else
        tO.frq =S;
      end
    end

  end % methods
end % classdef
