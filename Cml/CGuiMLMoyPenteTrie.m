%
% Classe CGuiMLMoyPenteTrie
%
% G�re les informations du GUI (1) Moyenne autour des points
%                              (2) Pente de r�gression
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

    lesep ='S�parateur:';
    selsep ={'virgule','point virgule','Tab'};

    fentrav ='Fen�tre de travail';
    rangtrav ='Range de points � trier';
    fentravtip1 =sprintf('Valeur num�rique --> temps\n\np0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p3 ... --> point marqu�');
    fentravtip2 =sprintf('p0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p3 ... --> point marqu�');
    rangtravtip =sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1 P2 P3 ... --> point marqu�');

    autpts ='Autour des points';
    autpttip =sprintf('Valeur num�rique pour indiquer l''�tendue avant et\napr�s le point � consid�rer pour faire la moyenne');
    valneg ='Valeur � n�gliger';
    valnegtip =sprintf('Valeur num�rique pour modifier la plage utile --> [(1er point + Valeur) jusqu''� (2i�me point - Valeur)]');
    tipunit ={'�chantillons','secondes'};
    maw ='Au travail';

    info1 ='Par d�faut, si on ne coche pas "Autour des points", la moyenne se fera sur les valeurs entre les deux bornes de la fen�tre de travail /si on la coche/ on fera les moyennes autour des points marqu�s.';
    info2 ='Le calcul de la pente sera effectu� selon la fen�tre de travail fournie et le "pairage de point" demand�. La valeur � n�gliger r�duira la plage de travail � droite du premier point et � gauche du second.';
    info3 ='Pour trier en ordre croissant, on �crira: [P1  Pf]. En ordre d�croissant se sera: [Pf  P1]. De m�me, pour trier les 5 derniers: [end-4 end]';

    % Partie Au Travail
    wbar1 ='Moyennage en cours';
    wbar2 ='Calcul en cours';
    wbar3 ='Trie des points en cours';

    putfich1 ='R�sultat des Moyennes';
    putfich2 ='R�sultat des Pentes';
    errfich ='Erreur dans le fichier de sortie.';

    fichori ='Fichier d''origine';
    legcan ='L�gende des canaux';
    vnegli ='Valeur � n�gliger';
    moyfait1 ='La moyenne a �t� faite sur';
    moyfait2 ='La moyenne est faite sur l''espace d�fini ci-haut';
    autpt ='autour du point';
    penfait ='La pente est calcul�e sur l''espace d�fini ci-haut';
    titess ='Essai';

    m2pt ='Moins de 2 points, pas de triage';
    errsyn ='Erreur dans la syntaxe du "Range de points � trier"';
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
