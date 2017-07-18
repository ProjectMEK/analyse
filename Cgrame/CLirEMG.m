%
% Classe CLirEMG(CLiranalyse)
%
% MEK - mars 2015
%
classdef CLirEMG < CLirOutils & CStrucA21XML

  properties
    nbess =[];
    frq =[];
    activ =[];
    lescan =[];
    leWb =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    %-----------------------
    function tO =CLirEMG(hF)
      try
        tO.Typo =CEFich('EMG');
        tO.Fich =hF;
        if isdir(tO.Fich.Info.prenom)
          cd(tO.Fich.Info.prenom);
        end
        if tO.selection('*.mat', 'Ouverture d''un fichier EMG', true)
          lirEMG(tO);
          mnouvre2(tO.Fich, tO.Typo);
        else
          tO.Fermeture();
        end
      catch moo;
        rethrow(moo);
      end
    end

  end % methods
end % classdef
