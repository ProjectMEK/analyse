%
% Classe CLirHDF5(CLiranalyse)
%
% MEK - août 2012
%
% METHODS
%         tO = CLirHDF5(hF)                 % CONSTRUCTOR
%              Fermeture(tO, src, event)
%              Lecture(tO)
%              prepare(tO)
%    EsBueno = Selection(tO)
%
classdef CLirHDF5 < CLirOutils

  properties
    frq =[];                    % tableau des fréquences
    nad =[];                    % nb de segment (3D)
    canTot =[];                 % nb de sous-canaux
    sscan =[];                  % nb de sous canaux par segment
    nsmpl =[];                  % nb d'échantillon par canaux
    lescan =[];                 % cell des noms de canaux
    leWb =[];                   % handle du waitbar
  end

  methods

    %------------
    % CONSTRUCTOR
    %------------------------
    function tO =CLirHDF5(hF)
      tO.Typo =CEFich('HDF5');
      tO.Fich =hF;
      if isdir(tO.Fich.Info.prenom)
        cd(tO.Fich.Info.prenom);
      end
      if tO.selection('*.h5', tO.txtml.h5ouvfich, true)
        tO.Lecture();
      else
        tO.Fermeture();
      end
    end

    %--------------------------------
    % ouverture et lecture du fichier
    %-------------------
    function Lecture(tO)
      try
        tO.prepare();
        if lirHDF5(tO)
          mnouvre2(tO.Fich, tO.Typo, tO.txtml);
        else
          tO.Fermeture();
        end
      catch moo;
        rethrow(moo);
      end
    end

  end % methods
end % classdef
