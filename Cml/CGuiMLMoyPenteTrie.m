%
% Classe CGuiMLMoyPenteTrie
%
% Gère les informations du GUI (1) Moyenne autour des points
%                              (2) Pente de régression
%                              (3) Trier les points
%
% MEK
% 2017/06/16
%
classdef CGuiMLMoyPenteTrie < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    % Partie pour le GUI
    name1 ='MENU MOYENNE AUTOUR...';
    name2 ='MENU PENTE ENTRE DEUX POINTS';
    name3 ='MENU TRIER POINTS...';

    selcan ='Choix du/des canal/aux';
    seless ='Choix du/des essais:';
    toutess ='tous les essais';

    lesep ='Séparateur:';
    selsep ={'virgule','point virgule','Tab'};

    fentrav ='Fenêtre de travail';
    rangtrav ='Range de points à trier';
    fentravtip1 =sprintf('Valeur numérique --> temps\n\np0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p3 ... --> point marqué');
    fentravtip2 =sprintf('p0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p3 ... --> point marqué');
    rangtravtip =sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1 P2 P3 ... --> point marqué');

    autpts ='Autour des points';
    autpttip =sprintf('Valeur numérique pour indiquer l''étendue avant et\naprès le point à considérer pour faire la moyenne');
    valneg ='Valeur à négliger';
    valnegtip =sprintf('Valeur numérique pour modifier la plage utile --> [(1er point + Valeur) jusqu''à (2ième point - Valeur)]');
    tipunit ={'échantillons','secondes'};
    maw ='Au travail';

    info1 ='Par défaut, si on ne coche pas "Autour des points", la moyenne se fera sur les valeurs entre les deux bornes de la fenêtre de travail /si on la coche/ on fera les moyennes autour des points marqués.';
    info2 ='Le calcul de la pente sera effectué selon la fenêtre de travail fournie et le "pairage de point" demandé. La valeur à négliger réduira la plage de travail à droite du premier point et à gauche du second.';
    info3 ='Pour trier en ordre croissant, on écrira: [P1  Pf]. En ordre décroissant se sera: [Pf  P1]. De même, pour trier les 5 derniers: [end-4 end]';

    % Partie Au Travail
    wbar1 ='Moyennage en cours';
    wbar2 ='Calcul en cours';
    wbar3 ='Trie des points en cours';

    putfich1 ='Résultat des Moyennes';
    putfich2 ='Résultat des Pentes';
    errfich ='Erreur dans le fichier de sortie.';

    fichori ='Fichier d''origine';
    legcan ='Légende des canaux';
    vnegli ='Valeur à négliger';
    moyfait1 ='La moyenne a été faite sur';
    moyfait2 ='La moyenne est faite sur l''espace défini ci-haut';
    autpt ='autour du point';
    penfait ='La pente est calculée sur l''espace défini ci-haut';
    titess ='Essai';

    m2pt ='Moins de 2 points, pas de triage';
    errsyn ='Erreur dans la syntaxe du "Range de points à trier"';
    lecan ='pour le canal';
    less ='et l''essai';

  end  %properties


  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CGuiMLMoyPenteTrie()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('guimoypentri');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
