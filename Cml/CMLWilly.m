%
% Classe CMLWilly
%
% Gère les informations "communes" ou diverses pas trop spécifiques
%
% MEK
% 2015/12/14
%
classdef CMLWilly < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    % GÉNÉRAL
    genlecfich ='Lecture du fichier';
    genveuillezpat ='veuillez patienter';

    % WAJOUT.M
    ajfichtyp ={'*.mat', 'Ajouter comme nouveaux essais';...
                '*.mat', 'Ajouter comme nouveaux canaux'};
    ajfichtyptit ='Choix du fichier à ajouter';

  end  %properties


  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CMLWilly()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('willy');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
