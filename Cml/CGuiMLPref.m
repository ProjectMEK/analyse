%
% Classe CGuiMLPref
%
% G�re les informations du GUI Pr�f�rences
%
% MEK
% 2015/04/15
%
classdef CGuiMLPref < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='Pr�f�rences';

    ongen ='G�n�ral';
    ongenconserv =['Conserver les pr�f�rences d''une session � l''autre.'];
    ongenlang ='Nom du fichier pour la langue de travail (dans le dossier "doc"): ';
    ongenrecent ='Nombre de fichier r�cent dans le menu "Derniers ouverts": ';
    ongenerr =['Affichage des messages d''erreur dans la console: '];
    ongenerrmnu ={'Aucun affichage', 'Message complet', 'Nom de la fonction+Titre du message', 'Titre du message seulement'};

    onaff ='Affichage';
    onafftip ='Configuration des options graphiques';
    onafftxfix =sprintf('Fixer \nconfig.');
    onafftxactiv =sprintf('Activ� \nsi coch�');
    onaffactxy ='Activer le mode XY';
    onaffpt ='Afficher les points marqu�s';
    onaffpttyp ={'Masquer les points marqu�s', 'Afficher les points marqu�s avec texte', 'Afficher les points marqu�s sans texte'};
    onaffzoom ='Activer le Zoom';
    onaffcoord ='Afficher les Coordonn�es';
    onaffsmpl ='Afficher les �chantillons';
    onaffccan ='Afficher la couleur pour Diff�rencier les canaux';
    onaffcess ='Afficher la couleur pour Diff�rencier les essais';
    onaffccat ='Afficher la couleur pour Diff�rencier les cat�gories';
    onaffleg ='Afficher L�gende';
    onaffproport ='Affichage proportionnel des courbes';


    onot ='Mas alla rumores ';
    onottip ='Au del� des rumeurs...';
    onottit ='Pr�f�rences';
    onotp1 =sprintf(['\nLes pr�f�rences sauvegard�es vont faire en sorte que l''interface ' ...
          'de travail sera le "m�me" ou "� votre main" � chaque ouverture. ' ...
          'N''oubliez pas de cliquer sur le bouton "Appliquer" afin de '...
          'sauvegarder les modifications.']);
    onotp2 =sprintf(['\nDans l''onglet "G�n�ral", la case "Conserver les pr�f�rences..."' ...
          '\n si coch�e, vous permet de garder les pr�f�rences pour les futures sessions. ' ...
          '\n si non-coch�e, vous recommencerez avec les valeurs par d�fauts de base.']);
    onotp3 =sprintf(['\nL''affichage des messages d''erreur, peut prendre plusieurs formes. ' ...
          'Cela vous permet d''avoir plus ou moins de texte affich� pour les erreurs sans importances.']);
    onotp4 =sprintf(['\nDans l''onglet "Affichage", il y a deux colonnes: "Fixer config." et ' ...
          '"Activ� si coch�". Si vous cochez la case de la colonne "Fixer...", vous ' ...
          'imposerez la valeur de la case "Activ�..." pour cette variable.']);
    onotp5 =sprintf(['\nPar contre, si vous ne cochez pas la case de la colonne "Fixer...", la valeur ' ...
          'pour cette variable sera celle � la fermeture de l''application.' ...
          '\n\n(Par exemple, pour la ligne "Activer le zoom"' ...
          '\n  si la case "fixer" est coch�e' ...
          '\n    avec la case "Activ�" coch�e: le zoom sera actif' ...
          '\n    avec la case "Activ�" d�coch�e: le zoom sera inactif' ...
          '\n\n  si la case "fixer" n''est pas coch�e' ...
          '\n    � la fermeture d''Analyse, l''�tat du zoom' ...
          '\n    d�cidera de la valeur lors de la r�-ouverture.)']);
    onotp6 =sprintf(['\nNota bene: afin de sauvegarder les modifications, vous devez cliquer sur le bouton "Appliquer" ']);

    onstat ='Entrez vos pr�f�rences afin d''am�liorer votre session de travail';

    btapplic ='Appliquer';

  end  %properties


  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CGuiMLPref()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('guipref');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
