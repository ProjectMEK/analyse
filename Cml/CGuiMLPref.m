%
% Classe CGuiMLPref
%
% Gère les informations du GUI Préférences
%
% MEK
% 2015/04/15
%
classdef CGuiMLPref < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='Préférences';

    ongen ='Général';
    ongenconserv =['Conserver les préférences d''une session à l''autre.'];
    ongenlang ='Nom du fichier pour la langue de travail (dans le dossier "doc"): ';
    ongenrecent ='Nombre de fichier récent dans le menu "Derniers ouverts": ';
    ongenerr =['Affichage des messages d''erreur dans la console: '];
    ongenerrmnu ={'Aucun affichage', 'Message complet', 'Nom de la fonction+Titre du message', 'Titre du message seulement'};

    onaff ='Affichage';
    onafftip ='Configuration des options graphiques';
    onafftxfix =sprintf('Fixer \nconfig.');
    onafftxactiv =sprintf('Activé \nsi coché');
    onaffactxy ='Activer le mode XY';
    onaffpt ='Afficher les points marqués';
    onaffpttyp ={'Masquer les points marqués', 'Afficher les points marqués avec texte', 'Afficher les points marqués sans texte'};
    onaffzoom ='Activer le Zoom';
    onaffcoord ='Afficher les Coordonnées';
    onaffsmpl ='Afficher les Échantillons';
    onaffccan ='Afficher la couleur pour Différencier les canaux';
    onaffcess ='Afficher la couleur pour Différencier les essais';
    onaffccat ='Afficher la couleur pour Différencier les catégories';
    onaffleg ='Afficher Légende';
    onaffproport ='Affichage proportionnel des courbes';


    onot ='Mas alla rumores ';
    onottip ='Au delà des rumeurs...';
    onottit ='Préférences';
    onotp1 =sprintf(['\nLes préférences sauvegardées vont faire en sorte que l''interface ' ...
          'de travail sera le "même" ou "à votre main" à chaque ouverture. ' ...
          'N''oubliez pas de cliquer sur le bouton "Appliquer" afin de '...
          'sauvegarder les modifications.']);
    onotp2 =sprintf(['\nDans l''onglet "Général", la case "Conserver les préférences..."' ...
          '\n si cochée, vous permet de garder les préférences pour les futures sessions. ' ...
          '\n si non-cochée, vous recommencerez avec les valeurs par défauts de base.']);
    onotp3 =sprintf(['\nL''affichage des messages d''erreur, peut prendre plusieurs formes. ' ...
          'Cela vous permet d''avoir plus ou moins de texte affiché pour les erreurs sans importances.']);
    onotp4 =sprintf(['\nDans l''onglet "Affichage", il y a deux colonnes: "Fixer config." et ' ...
          '"Activé si coché". Si vous cochez la case de la colonne "Fixer...", vous ' ...
          'imposerez la valeur de la case "Activé..." pour cette variable.']);
    onotp5 =sprintf(['\nPar contre, si vous ne cochez pas la case de la colonne "Fixer...", la valeur ' ...
          'pour cette variable sera celle à la fermeture de l''application.' ...
          '\n\n(Par exemple, pour la ligne "Activer le zoom"' ...
          '\n  si la case "fixer" est cochée' ...
          '\n    avec la case "Activé" cochée: le zoom sera actif' ...
          '\n    avec la case "Activé" décochée: le zoom sera inactif' ...
          '\n\n  si la case "fixer" n''est pas cochée' ...
          '\n    À la fermeture d''Analyse, l''état du zoom' ...
          '\n    décidera de la valeur lors de la ré-ouverture.)']);
    onotp6 =sprintf(['\nNota bene: afin de sauvegarder les modifications, vous devez cliquer sur le bouton "Appliquer" ']);

    onstat ='Entrez vos préférences afin d''améliorer votre session de travail';

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
