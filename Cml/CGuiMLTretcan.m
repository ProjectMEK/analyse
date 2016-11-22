%
% Classe CGuiMLTretcan
%
% G�re les informations du GUI Traitement de canal
%
% MEK
% 2015/06/04
%
classdef CGuiMLTretcan < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='Traitement de canal';
    title ='Calcul sur les canaux';
    alltrial ='Appliquer � tous les essais';
    keeppt ='Conserver les points';
    keeppttip ='Lorsque vous �crivez le r�sultat dans un canal existant';
    seless ='Choix des essais';
    selcat ='Choix des cat�gories';
    ligcommtip ='Chaque �l�ment doit �tre s�par� par une virgule';
    delstr ='Supp';
    canal ='Choix des canaux';
    clavnum ='Clavier num�rique/op�rateurs';
    clavfnctip =',  sera interpr�t� comme: C1 ';
    fonction ='Choix des fonctions';
    fnctlist ={'Pi','constante trigonom�trique';...
               'Sin',sprintf('Fonction sin de Matlab,\nEx:\n-  Si on �crit:  C1,sin,\n-  ce sera interpr�t� comme:  sin(C1)');...
               'Cos',sprintf('Fonction cos de Matlab,\nEx:\n-  Si on �crit:  C1,cos,\n-  ce sera interpr�t� comme:  cos(C1)');...
               'Tan',sprintf('Fonction tan de Matlab,\nEx:\n-  Si on �crit:  C1,tan,\n-  ce sera interpr�t� comme:  tan(C1)');...
               'Diff',sprintf('Fonction diff de Matlab,\nEx:\n-  Si on �crit:  C1,diff,\n-  ce sera interpr�t� comme:  diff(C1)\n \nAttention, la fonction diff nous retourne un vecteur\nde longueur N-1, Analyse ajoute "0" comme premier �chantillon\n (gardant ainsi le m�me nombre d''�chantillon que le canal source).');...
               'Abs',sprintf('Fonction abs de Matlab,\nEx:\n-  Si on �crit:  C1,abs,\n-  ce sera interpr�t� comme:  abs(C1)');...
               'Distance 1D',sprintf('Calcule la distance entre deux points sur une ligne.\n- N�cessitera deux canaux (C1 et C2).\n- On calculera ainsi:\n \n__  OUT = abs( C1 - C2 )');...
               'Distance 2D',sprintf('Calcule la distance entre deux points dans un plan.\n- N�cessitera quatre canaux (C1,C2 et C3,C4).\n- On calculera ainsi:\n \n__  OUT = sqrt( (C1-C3)^2 + (C2-C4)^2 )');...
               'Distance 3D',sprintf('Calcule la distance entre deux points dans un volume.\n- N�cessitera six canaux (C1,C2,C3 et C4,C5,C6).\n- On calculera ainsi:\n \n__  OUT = sqrt( (C1-C4)^2 + (C2-C5)^2 + (C3-C6)^2 )');...
               'Long. Vect.',sprintf('Calcule la longueur du vecteur dont l''origine est � [0 0 0].\n- N�cessitera trois canaux (C1,C2,C3).\n- On calculera ainsi:\n \n__  OUT = sqrt( C1^2 + C2^2 + C3^2 )');...
               'Somm. cum.',sprintf('Fonction cumsum de Matlab,\nEx:\n-  Si on �crit:  C1,csum,\n-  ce sera interpr�t� comme:  cumsum(C1)');...
               'Sqrt',sprintf('Fonction sqrt de Matlab,\nEx:\n-  Si on �crit:  C1,sqrt,\n-  ce sera interpr�t� comme:  sqrt(C1)');...
               'Exp',sprintf('Fonction exp de Matlab,\nEx:\n-  Si on �crit:  C1,N,exp,\n-  ce sera interpr�t� comme:  C1^N')}

    triginv ='Inv';
    triginvtip ='Pour les fonctions trigonom�trique seulement, coch� pour avoir: asin, acos ou atan';
    deg ='Degr�';
    degtip ='Si non coch�, les angles sont en radians';
    buttonGo ='Au travail';

  end  %properties


  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CGuiMLTretcan()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('guitretcan');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
