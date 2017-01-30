%
% Classe CGuiMLAnalyse
%
% Gère les informations du GUI principal
%
% MEK
% 2016/11/16
%
classdef CGuiMLAnalyse < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='traitement';

    %(GN) GÉNÉRAL
    gntudebut ='Vous devez ouvrir un fichier pour commencer.';

    %(pb) PANEL ET SES BOUTONS
    pbvide ='vide';
    pbcanmarktip ='Choix du canal pour le marquage manuel';
    pbdelpttip ='Effacer le point sélectionné';
    pbmarmantip ='Marquage manuel avec la souris';
    pbcoord ='Coord.';
    pbcoordtip ='Afficher un curseur avec les coordonnées (X,Y)';

  end  %properties

  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %___________________________________________________________________________
    % CONSTRUCTOR
    %---------------------------------------------------------------------------

    function tO =CGuiMLAnalyse()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('guiip');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
