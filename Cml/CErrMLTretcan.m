%
% Classe CErrMLTretcan
%
% Gère les messages d'erreurs dans traitement de canal
%
% MEK
% 2015/06/10
%
classdef CErrMLTretcan < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------
    % ERREUR DE SYNTAXE
    case1 ='La syntaxe de l''équation est invalide, revérifier SVP';
    case1tit ='Erreur de syntaxe';

    % IL N'Y A QU'UNE VIRGULE DANS LA STRING
    case2 ='L''équation est incomplète, revérifier SVP';
    case2tit ='Erreur de syntaxe';

    % RUN-TIME ERROR
    case3 =', revérifier SVP';
    case3tit ='Erreur lors de l''exécution';
    case3m01 ='Pour avoir la réponse dans un nouveau canal, n''inscrivez pas de no de canal.';
    case3m02 ='Trop de valeurs dans la pile, vérifiez le nombre d''opérateur.';
    case3m03 ='La syntaxe du canal de sortie est erronée: ';
    case3m04 ='La syntaxe d''un des canaux est erronée: ';
    case3m05 ='Vous avez tapé un caractère inconnu du système';
    case3m06 =', j''ai besoin de 2 variables';
    case3m07 ='Pour additionner';
    case3m08 ='Pour soustraire';
    case3m09 ='Pour multiplier';
    case3m10 ='Pour diviser';
    case3m11 =', j''ai besoin de 1 variable';
    case3m12 =', j''ai besoin de 3 variables';
    case3m13 =', j''ai besoin de 4 variables';
    case3m14 =', j''ai besoin de 6 variables';
    case3m15 ='Pour extraire la racine carrée';
    case3m16 ='Pour élever à une puissance';
    case3m17 ='Pour calculer la distance';
%    case3m18 =;
%    case3m19 =;

  end  %properties


  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CErrMLTretcan()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('errtretcan');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
