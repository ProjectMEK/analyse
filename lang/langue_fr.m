%
% Fonction langue
%
% Créateur: MEK, mars 2009
% Repris plus sérieusement en avril 2015
%
% FRANÇAIS
%
function varargout =langue_fr(varargin)
  if nargout | nargin

    %___________________________________________________________________________
  	% Variable répétitive
    %---------------------------------------------------------------------------
    auTravail='Au travail';

  	%___________________________________________________________________________
  	%POUR AFFICHER LA LANGUE DE TRAVAIL
    %---------------------------------------------------------------------------
  	S.langue ='Français';

  	%___________________________________________________________________________
  	% Variable mnuip
  	% MENU DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------
    S.mnuip.file ='&Fichier';
    S.mnuip.fileouvrir ='&Ouvrir';
    S.mnuip.fileouvrirot ='Ou&vrir autres';
    S.mnuip.fileouvrirottxt ='&Texte délimité';
    S.mnuip.fileouvrirotauto21 ='.&XML (Auto21)';
    S.mnuip.fileouvriroti2m ='.&H5 (I2M)';
    S.mnuip.fileouvrirotc3d ='.&C3D (Vicon)';
    S.mnuip.fileouvrirotemg ='.&MAT (Emg)';
    S.mnuip.fileouvrirotkeit ='.ADW (&Keitley)';
    S.mnuip.fileajout ='&Ajouter';
    S.mnuip.filebatch ='Traitement en &Batch';
    S.mnuip.filefermer ='&Fermer';
    S.mnuip.filesave ='&Enregistrer';
    S.mnuip.filesaveas ='En&registrer sous';
    S.mnuip.fileexport ='Ex&portation';
    S.mnuip.fileecritresult ='Écrit&ure des résultats';
    S.mnuip.fileprint ='&Imprimer';
    S.mnuip.fileprintcopiecoller ='&Copier-Coller';
    S.mnuip.fileprintjpeg ='Fichier &JPEG';
    S.mnuip.fileprintimprimer ='&Imprimer';
    S.mnuip.filedernierouvert ='Ouvert &dernièrement';
    S.mnuip.filepreferences ='Préféren&ces';
    S.mnuip.fileredemarrer ='Redé&marrer Analyse';
    S.mnuip.fileterminus ='&Terminus';

    S.mnuip.edit ='&Édit';
    S.mnuip.editmajcan ='MAJ infos des canaux sélectionnés';
    S.mnuip.editcanal ='&Canal';
    S.mnuip.editcopiecanal ='Co&pie canal';
    S.mnuip.editdatautil ='Regrouper données utiles';
    S.mnuip.editcatego ='C&atégorie';
    S.mnuip.editrebatircatego ='&Rebâtir Catégories';
    S.mnuip.editecheltemps ='Échelle de &temps';

    S.mnuip.modif ='&Modifier';
    S.mnuip.modifsuppcan ='Supprimer canaux';
    S.mnuip.modifcorriger ='Corriger';
    S.mnuip.modifcouper ='&Couper';
    S.mnuip.modifdecouper ='&Découper';
    S.mnuip.modifdecimate ='&Décimer';
    S.mnuip.modifrebase ='&Rebase';
    S.mnuip.modifrotation ='R&otation';
    S.mnuip.modifsynchroess ='&Synchronyse les Essais';
    S.mnuip.modifsynchrocan ='&Synchronyse les Canaux';

    S.mnuip.math ='Ma&th.';
    S.mnuip.mathderivfil ='&Dérivé/Filtre';
    S.mnuip.mathderivfilbutter ='&ButterWorth';
    S.mnuip.mathderivfilsptool ='Complément à SPTOOL';
    S.mnuip.mathderivfildiffer ='&Differ';
    S.mnuip.mathderivfilpolynom ='&Traitement Polynomiale';
    S.mnuip.mathintdef ='&Intégrale définie';
    S.mnuip.mathintcum ='Intégral-Cumulative';
    S.mnuip.mathnormal ='&Normalise';
    S.mnuip.mathnormaltemp ='Normalisation Temporelle';
    S.mnuip.mathellipsconf ='Ellipse de confiance';
    S.mnuip.mathmoyectyp ='Moy./Ecart-type par catégorie';
    S.mnuip.mathmoyptmarq ='Moyenne autour des points marqués';
    S.mnuip.mathpentedrtregr ='Pente de la droite de régression';
    S.mnuip.mathcalcang ='Calcul d''angle';
    S.mnuip.mathtraitcan ='Traitement de canal';

    S.mnuip.emg ='Em&g';
    S.mnuip.emgrectif ='&Rectification';
    S.mnuip.emgliss ='&Lissage';
    S.mnuip.emgrms ='R&MS';
    S.mnuip.emgmav ='M&AV';
    S.mnuip.emgffm ='&F-Méd/Moy/Max';
    S.mnuip.emgnormal ='&Normalisation';
    S.mnuip.emgintegsucc ='Intégrations (successives)';
    S.mnuip.emgchgpolar ='&Changement de polarité';
    S.mnuip.emgdistprbampl ='&Distribution de probabilité d''Amplitude';

    S.mnuip.fplt ='&FPlt';
    S.mnuip.fpltcop ='Centre de Pression(COP) et COG AMTI';
    S.mnuip.fpltcopparammanuel ='Entrée des param manuelle';
    S.mnuip.fpltcopparamfichier ='Entrée des param par fichier';
    S.mnuip.fpltcopoptima ='COP et COG OPTIMA';
    S.mnuip.fpltstat4cop ='Stat-4-COP';

    S.mnuip.trajet ='T&rajectoire';
    S.mnuip.trajetgps ='GPS';
    S.mnuip.trajetgpsecef2lla ='(GPS)ECEF vers LLA';
    S.mnuip.trajetecart ='&Écart';
    S.mnuip.trajetdiffinterpt ='&Différence de points';
    S.mnuip.trajetdistparcour ='Distance parcourue &X-Y-(Z)';
    S.mnuip.trajetamplmvt ='&Amplitude de mvt';
    S.mnuip.trajetdirect ='D&irection';
    S.mnuip.trajetcourb ='&Courbure';

    S.mnuip.ou ='O&utils';
    S.mnuip.ouechtempo ='Échelle &temporelle';
    S.mnuip.ouechtempodefaut ='Retour à la normale';
    S.mnuip.ouimportpoint ='&Importer point (Y vs X)';
    S.mnuip.outrierpt ='Trier les points marqués';
    S.mnuip.oumark ='&Marquer';
    S.mnuip.ouzoom ='Zoom';
    S.mnuip.ouaffichercoord ='Afficher les Coordonnées';
    S.mnuip.oucouleur ='Afficher la couleur pour ';
    S.mnuip.oucouleurcan ='Différencier les canaux';
    S.mnuip.oucouleuress ='Différencier les essais';
    S.mnuip.oucouleurcat ='Différencier les catégories';
    S.mnuip.oulegend ='Afficher Légende';
    S.mnuip.ouechant ='Afficher les Échantillons';
    S.mnuip.ouptmarkatexte ='Afficher Points marqués avec texte';
    S.mnuip.ouptmarkstexte ='Afficher Points marqués sans texte';
    S.mnuip.ouaffprop ='Affichage proportionnel des courbes';
    S.mnuip.ouxy ='Afficher (Canal-Y vs Canal-X)';

    S.mnuip.quelfichier ='&Quel Fichier';

    S.mnuip.hlp ='&Aide';
    S.mnuip.hlpdoc ='Rappel en cas de panique  :-)';
    S.mnuip.hlplog ='Historique';
    S.mnuip.hlplogbook ='Journal des actions';
    S.mnuip.hlpabout ='À propos de';

  	%___________________________________________________________________________
  	% Variable guiip
  	% BOUTON DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------

    S.guiip.gntudebut ='Vous devez ouvrir un fichier pour commencer.';
    S.guiip.pbvide ='vide';
    S.guiip.pbcanmarktip ='Choix du canal pour le marquage manuel';
    S.guiip.pbdelpttip ='Effacer le point sélectionné';
    S.guiip.pbmarmantip ='Marquage manuel avec la souris';
    S.guiip.pbcoord ='Coord.';
    S.guiip.pbcoordtip ='Afficher un curseur et ses coordonnées (X,Y)';

    %___________________________________________________________________________
    % Variable lire
    % GUI POUR LA LECTURE DES DIFFÉRENTS FORMATS SUPPORTÉS
    %---------------------------------------------------------------------------

    % mnouvre2
    S.lire.txtwbar ='Ouverture du fichier: ';

    % Waitbar
    S.lire.lectfich ='Lecture du fichier ';
    S.lire.lectfichs ='Lecture des fichiers ';
    S.lire.vide ='';
    S.lire.vides ='';
    S.lire.patience =', veuillez patienter';
    S.lire.lectcanal ='Lecture du canal: ';
    S.lire.fichier ='Fichier: ';
    S.lire.concatinfo ='Concaténation des infos: ';
    S.lire.canal ='Canal ';
    S.lire.fairess ='Construction des essais: ';

    % Keithley
    S.lire.kiname ='Lecture des fichiers Keithley';
    S.lire.kichoixfich ='Choix du fichier keithley';
    S.lire.kiinscripath ='Inscrire le PATH au complet';
    S.lire.kiutilisezvous ='Utilisez-vous plusieurs...?';
    S.lire.kitxtsess ='session';
    S.lire.kitxtcond ='condition';
    S.lire.kitxtseqtyp ='seq-type';
    S.lire.kibuttonGo =auTravail;
    S.lire.kinomfich ='fichier d''acquisition de la Keithley';
    S.lire.kilectwbar ='Lecture du fichier Keithley, veuillez patienter';

    % HDF5
    S.lire.h5ouvfich ='Ouverture d''un fichier H5 ()';
    S.lire.h5wbarinfocan ='Lecture des informations sur les canaux';

    % A21XML
    S.lire.a21ouvfich ='Ouverture d''un fichier XML (Auto 21)';

    %___________________________________________________________________________
    % Variable guipref
    % GUI DE LA GESTION DES PRÉFÉRENCES
    %---------------------------------------------------------------------------
    S.guipref.name ='Préférences';

    S.guipref.ongen ='Général';
    S.guipref.ongenconserv =['Conserver les préférences d''une session à l''autre.'];
    S.guipref.ongenlang ='Nom du fichier pour la langue de travail (dans le dossier "doc"): ';
    S.guipref.ongenrecent ='Nombre de fichier dans le menu "Ouvert dernièrement": ';
    S.guipref.ongenerr =['Affichage des messages d''erreur dans la console: '];
    S.guipref.ongenerrmnu ={'Aucun affichage', 'Message complet','Message partiel'};

    S.guipref.onaff ='Affichage';
    S.guipref.onafftip ='Configuration des options graphiques';
    S.guipref.onafftxfix =sprintf('Fixer \nconfig.');
    S.guipref.onafftxactiv =sprintf('Activé \nsi coché');
    S.guipref.onaffactxy ='Activer le mode XY';
    S.guipref.onaffpt ='Afficher les points marqués';
    S.guipref.onaffpttyp ={'Masquer les points', 'Points avec texte', ...
                         'Points sans texte'};
    S.guipref.onaffzoom ='Activer le Zoom';
    S.guipref.onaffcoord =S.mnuip.ouaffichercoord;
    S.guipref.onaffsmpl =S.mnuip.ouechant;
    S.guipref.onaffccan =[S.mnuip.oucouleur S.mnuip.oucouleurcan];
    S.guipref.onaffcess =[S.mnuip.oucouleur S.mnuip.oucouleuress];
    S.guipref.onaffccat =[S.mnuip.oucouleur S.mnuip.oucouleurcat];
    S.guipref.onaffleg =S.mnuip.oulegend;
    S.guipref.onaffproport =S.mnuip.ouaffprop;

    S.guipref.onot =['M' char(225) 's all' char(225) ' rumores '];
    S.guipref.onottip ='Au delà des rumeurs...';
    S.guipref.onottit ='Préférences';
    S.guipref.onotp1 =sprintf(['\nLes préférences sauvegardées vont faire en sorte que l''interface ' ...
                    'de travail sera le "même" ou "à votre main" à chaque ouverture. ' ...
                    'N''oubliez pas de cliquer sur le bouton "Appliquer" afin de sauvegarder les modifications.']);
    S.guipref.onotp2 =sprintf(['\nDans l''onglet "Général", la case "Conserver les préférences..."' ...
                    '\n si cochée, vous permet de garder les préférences pour les futures sessions. ' ...
                    '\n si non-cochée, vous recommencerez avec les valeurs par défauts de base.']);
    S.guipref.onotp3 =sprintf(['\nL''affichage des messages d''erreur, peut prendre plusieurs formes. ' ...
                    'Cela vous permet d''avoir plus ou moins de texte affiché pour les erreurs sans importances.']);
    S.guipref.onotp4 =sprintf(['\nDans l''onglet "Affichage", il y a deux colonnes: "Fixer config." (FC) et ' ...
                    '"Activé si coché" (AC). Si vous cochez la case de la colonne "FC", vous ' ...
                    'imposerez la valeur de la case "AC" pour cette variable.']);
    S.guipref.onotp5 =sprintf(['\nPar contre, si vous ne cochez pas la case de la colonne "FC", la valeur ' ...
                    'pour cette variable sera celle à la fermeture de l''application.' ...
                    '\n\n(Par exemple, pour la ligne "Activer le zoom"' ...
                    '\n  si la case "FC" est cochée' ...
                    '\n    avec la case "AC" cochée: le zoom sera actif' ...
                    '\n    avec la case "AC" décochée: le zoom sera inactif' ...
                    '\n\n  si la case "FC" n''est pas cochée' ...
                    '\n    À la fermeture d''Analyse, l''état du zoom' ...
                    '\n    décidera de la valeur lors de la ré-ouverture.)']);
    S.guipref.onotp6 =sprintf(['\nNota bene: afin de sauvegarder les modifications, vous devez cliquer sur le bouton "Appliquer" ']);

    S.guipref.onstat ='Entrez vos préférences afin d''améliorer votre session de travail';

    S.guipref.btapplic ='Appliquer';

    %___________________________________________________________________________
    % Variable guimoypentri
    % GUI POUR MOYENNE/PENTE/TRIER POINTS
    %---------------------------------------------------------------------------
    S.guimoypentri.name1 ='MENU MOYENNE AUTOUR...';
    S.guimoypentri.name2 ='MENU PENTE ENTRE DEUX POINTS';
    S.guimoypentri.name3 ='MENU TRIER POINTS...';

    S.guimoypentri.selcan ='Choix du/des canal/aux';
    S.guimoypentri.seless ='Choix du/des essais:';
    S.guimoypentri.toutess ='tous les essais';

    S.guimoypentri.lesep ='Séparateur:';
    S.guimoypentri.selsep ={'virgule','point virgule','Tab'};

    S.guimoypentri.fentrav ='Fenêtre de travail';
    S.guimoypentri.rangtrav ='Range de points à trier';
    S.guimoypentri.fentravtip1 =sprintf('Valeur numérique --> temps\n\np0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p3 ... --> point marqué');
    S.guimoypentri.fentravtip2 =sprintf('p0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p3 ... --> point marqué');
    S.guimoypentri.rangtravtip =sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1 P2 P3 ... --> point marqué');

    S.guimoypentri.autpts ='Autour des points';
    S.guimoypentri.autpttip =sprintf('Valeur numérique pour indiquer l''étendue avant et\naprès le point à considérer pour faire la moyenne');
    S.guimoypentri.valneg ='Valeur à négliger';
    S.guimoypentri.valnegtip =sprintf('Valeur numérique pour modifier la plage utile --> [(1er point + Valeur) jusqu''à (2ième point - Valeur)]');
    S.guimoypentri.tipunit ={'échantillons','secondes'};
    S.guimoypentri.maw =auTravail;

    S.guimoypentri.info1 ='Par défaut, si on ne coche pas "Autour des points", la moyenne se fera sur les valeurs entre les deux bornes de la fenêtre de travail /si on la coche/ on fera les moyennes autour des points marqués.';
    S.guimoypentri.info2 ='Le calcul de la pente sera effectué selon la fenêtre de travail fournie et le "pairage de point" demandé. La valeur à négliger réduira la plage de travail à droite du premier point et à gauche du second.';
    S.guimoypentri.info3 ='Pour trier en ordre croissant, on écrira: [P1  Pf]. En ordre décroissant se sera: [Pf  P1]. De même, pour trier les 5 derniers: [end-4 end]';

    % Partie Au Travail
    S.guimoypentri.wbar1 ='Moyennage en cours';
    S.guimoypentri.wbar2 ='Calcul en cours';
    S.guimoypentri.wbar3 ='Trie des points en cours';

    S.guimoypentri.putfich1 ='Résultat des Moyennes';
    S.guimoypentri.putfich2 ='Résultat des Pentes';
    S.guimoypentri.errfich ='Erreur dans le fichier de sortie.';

    S.guimoypentri.fichori ='Fichier d''origine';
    S.guimoypentri.legcan ='Légende des canaux';
    S.guimoypentri.vnegli =S.guimoypentri.valneg;
    S.guimoypentri.moyfait1 ='La moyenne a été faite sur';
    S.guimoypentri.moyfait2 ='La moyenne est faite sur l''espace défini ci-haut';
    S.guimoypentri.autpt ='autour du point';
    S.guimoypentri.penfait ='La pente est calculée sur l''espace défini ci-haut';
    S.guimoypentri.titess ='Essai';

    S.guimoypentri.m2pt ='Moins de 2 points, pas de triage';
    S.guimoypentri.errsyn ='Erreur dans la syntaxe du "Range de points à trier"';
    S.guimoypentri.lecan ='pour le canal';
    S.guimoypentri.less ='et l''essai';

    %___________________________________________________________________________
    % Variable guitretcan
    % GUI DU TRAITEMENT DE CANAL
    %---------------------------------------------------------------------------
    S.guitretcan.name ='Traitement de canal';

    S.guitretcan.title ='Calcul sur les canaux';
    S.guitretcan.alltrial ='Appliquer à tous les essais';
    S.guitretcan.keeppt ='Conserver les points';
    S.guitretcan.keeppttip ='Conserver les points lorsque vous écrivez le résultat dans un canal existant';
    S.guitretcan.seless ='Choix des essais';
    S.guitretcan.selcat ='Choix des catégories';
    S.guitretcan.ligcommtip ='Chaque élément doit être séparé par une virgule';
    S.guitretcan.delstr ='Supp';
    S.guitretcan.canal ='Choix des canaux';
    S.guitretcan.clavnum ='Clavier numérique/opérateurs';
    S.guitretcan.clavfnctip =',  sera interprété comme: C1 ';
    S.guitretcan.fonction ='Choix des fonctions';
    S.guitretcan.fnctlist ={'Pi','constante trigonométrique';...
                'Sin',sprintf('Fonction sin de Matlab,\nEx:\n-  Si on écrit:  C1,sin,\n-  ce sera interprété comme:  sin(C1)');...
                'Cos',sprintf('Fonction cos de Matlab,\nEx:\n-  Si on écrit:  C1,cos,\n-  ce sera interprété comme:  cos(C1)');...
                'Tan',sprintf('Fonction tan de Matlab,\nEx:\n-  Si on écrit:  C1,tan,\n-  ce sera interprété comme:  tan(C1)');...
                'Diff',sprintf('Fonction diff de Matlab,\nEx:\n-  Si on écrit:  C1,diff,\n-  ce sera interprété comme:  diff(C1)\n \nAttention, la fonction diff nous retourne un vecteur\nde longueur N-1, Analyse ajoute "0" comme premier échantillon\n (gardant ainsi le même nombre d''échantillon que le canal source).');...
                'Abs',sprintf('Fonction abs de Matlab,\nEx:\n-  Si on écrit:  C1,abs,\n-  ce sera interprété comme:  abs(C1)');...
                'Distance 1D',sprintf('Calcule la distance entre deux points sur une ligne.\n- Nécessitera deux canaux (C1 et C2).\n- On calculera ainsi:\n \n__  OUT = abs( C1 - C2 )');...
                'Distance 2D',sprintf('Calcule la distance entre deux points dans un plan.\n- Nécessitera quatre canaux (C1,C2 et C3,C4).\n- On calculera ainsi:\n \n__  OUT = sqrt( (C1-C3)^2 + (C2-C4)^2 )');...
                'Distance 3D',sprintf('Calcule la distance entre deux points dans un volume.\n- Nécessitera six canaux (C1,C2,C3 et C4,C5,C6).\n- On calculera ainsi:\n \n__  OUT = sqrt( (C1-C4)^2 + (C2-C5)^2 + (C3-C6)^2 )');...
                'Long. Vect.',sprintf('Calcule la longueur du vecteur dont l''origine est à [0 0 0].\n- Nécessitera trois canaux (C1,C2,C3).\n- On calculera ainsi:\n \n__  OUT = sqrt( C1^2 + C2^2 + C3^2 )');...
                'Somm. cum.',sprintf('Fonction cumsum de Matlab,\nEx:\n-  Si on écrit:  C1,csum,\n-  ce sera interprété comme:  cumsum(C1)');...
                'Sqrt',sprintf('Fonction sqrt de Matlab,\nEx:\n-  Si on écrit:  C1,sqrt,\n-  ce sera interprété comme:  sqrt(C1)');...
                'Exp',sprintf('Fonction exp de Matlab,\nEx:\n-  Si on écrit:  C1,N,exp,\n-  ce sera interprété comme:  C1^N')};

    S.guitretcan.triginv ='Inv';
    S.guitretcan.triginvtip ='Pour les fonctions trigonométrique seulement, coché pour avoir: asin, acos ou atan';
    S.guitretcan.deg ='Degré';
    S.guitretcan.degtip ='Si non coché, les angles sont en radians';
    S.guitretcan.buttonGo =auTravail;

    %___________________________________________________________________________
    % Variable guimark
    % GUI DU MARQUAGE
    %---------------------------------------------------------------------------
    S.guimark.name ='POUR QUITTER LE MARQUAGE, cliquez sur le X à droite  > > > >';

    %(PP) PANEL PERMAMENT
    S.guimark.ppaid ='?';
    S.guimark.ppaidtip ='Documentation sur le marquage';
    S.guimark.ppcansrc ='Source';
    S.guimark.ppptsmrk ='Pts';
    S.guimark.ppdelptall ='Tous les pts';
    S.guimark.ppdelptalltip ='Choisir tous les points des canaux et essais sélectionnés, pour la suppression';
    S.guimark.ppdelenumtip =sprintf('No des points à supprimer, en ordre croissant,\nEx: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12');
    S.guimark.ppdelpthide ='Cacher';
    S.guimark.ppdelpthidetip =sprintf('Supprimera le point voulu sans changer l''ordre des points suivants.\nLes points supprimés deviendront Bidons.');
    S.guimark.ppdelbutton ='Suppr';
    S.guimark.ppdelbuttontip ='Supprimera tous les points sélectionnés ci-haut.';
    S.guimark.ppesscat ='Marquage par essai(s) ou catégorie(s)';
    S.guimark.ppesscattip ='Si non coché, tous les essais sont sélectionnés';
    S.guimark.ppreplace ='Remplacer les points choisis ci-haut';
    S.guimark.ppreplacetip ='En mode Exporter: point source(i)-->point destination(i)';

    % BOUTON GO...START...AU TRAVAIL
    S.guimark.buttonGo =auTravail;

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    S.guimark.poexpletit ='Exp.';
    S.guimark.poexpletittip ='Exportation d''un canal à l''autre';
    S.guimark.poexpnom ='Exportation';
    S.guimark.poexpcorr ='Correspondance canal source(i)-->canal destination(i)';
    S.guimark.poexpcorrtip ='On doit avoir: Nb de canaux sources = Nb de canaux destinations';
    S.guimark.poexpcandst ='Destination';

    % ONGLET MINMAX
    S.guimark.pominletit ='Min.';
    S.guimark.pominletittip ='Min Max';
    S.guimark.pominnom ='Min.Max.';
    S.guimark.pominmin ='Minimum';
    S.guimark.pominmax ='Maximum';

    % ONGLET MONTÉ...
    S.guimark.pomonteletit ='Monté.';
    S.guimark.pomonteletittip ='Début - fin: Montée -Descente';
    S.guimark.pomontenom ='Montée-Descente';
    S.guimark.pomontemnt ='Montée';
    S.guimark.pomontedbt ='Début';
    S.guimark.pomontefin ='Fin';
    S.guimark.pomontedsc ='Descente';
    S.guimark.pomontedytxt ='Delta Y';
    S.guimark.pomontedytxttip ='Différence d''Amplitude nécessaire pour considérer une montée ou une descente';
    S.guimark.pomontedytip =sprintf('Valeur de la variation d''amplitude (ex: 10, 150, etc)\n ou pourcentage du max-min (ex: 10%%, 45%%, etc)\n à partir de laquelle vous considérez qu''il y a une montée ou une descente.\n Par défaut (si laissé à 0), 50%% : (Max - Min) X 50%% ');
    S.guimark.pomontedxtxt ='Delta X';
    S.guimark.pomontedxtxttip ='Différence temporelle (sec) nécessaire pour monter ou descendre de Delta Y';
    S.guimark.pomontedxtip ='largeur en seconde afin d''avoir une variation d''amplitude de DeltaY. Si laissé à 0: ¼ sec.';
    S.guimark.pomontedttxt ='Delta T';
    S.guimark.pomontedttxttip ='Nb d''échantillon à considérer pour discriminer les "petits pics" (bruit)';
    S.guimark.pomontedttip ='Nombre d''échantillon à considérer pour déclarer un début ou une fin. Par défaut = 3 (Si laissé à zéro)';
    S.guimark.pomontedef ='D';
    S.guimark.pomontedeftip ='Valeurs par défaut (ou zéro) pour ce cadre';

    % ONGLET TEMPOREL
    S.guimark.potmpletit ='Temps.';
    S.guimark.potmpletittip ='Marquage temporel';
    S.guimark.potmpnom ='Marquage temporel';
    S.guimark.potmpvaltxt ='Temps précis ou no du pt: ';
    S.guimark.potmpvaltip ='Premier temps précis à marquer (peut être le no d''un point pour le marquage successif, ex: p1)';
    S.guimark.potmpstep ='Intervalle entre les pts subséquents: ';
    S.guimark.potmpsteptip ='À partir du temps ci-haut, nombre de seconde pour le prochain point';

    % ONGLET AMPLITUDE
    S.guimark.poampletit ='Amplit.';
    S.guimark.poampletittip ='Marquer une amplitude';
    S.guimark.poampnom ='Marquage d''amplitude';
    S.guimark.poampvaltxt ='Amplitude (ou no. de point) à marquer: ';
    S.guimark.poampvaltip =sprintf('Valeur numérique --> Amplitude\n\np0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p... --> point marqué');
    S.guimark.poamppcenttxt ='% de l''amplitude du point ci-haut: ';
    S.guimark.poamppcenttip =sprintf('Si vous avez inscrit un point plutôt qu''une amplitude ci-haut,\nvous pouvez vouloir un pourcentage de l''amplitude correspondante');
    S.guimark.poampdectxt ='Décalage temporel +/-: ';
    S.guimark.poampdectip =sprintf('L''amplitude considéré sera celle du point demandé ci-haut,\ndécalé de la valeur temporelle en sec ci-contre.');
    S.guimark.poampdirtxt ='Direction: ';
    S.guimark.poampdir ={'du début vers la fin >>>', '<<< de la fin vers le début'};
    S.guimark.poampdirtip ='Par où commencer à marquer le point no 1, de la gauche ou de la droite';

    % ONGLET EMG
    S.guimark.poemgletit ='Emg.';
    S.guimark.poemgletittip ='Marquer les débuts et fins de l''activité musculaire dans un signal EMG';
    S.guimark.poemgnom ='Marquage EMG';
    S.guimark.poemgrefdoc ='Ref/Doc';
    S.guimark.poemgaglrhtxt ='Seuil de détection (h):';
    S.guimark.poemgaglrhtip =sprintf('Plus la valeur de h est petite, moins on détecte d''évènement, et\nplus elle est grande, plus on peut générer de fausse détection.');
    S.guimark.poemgaglrltxt ='Largeur de fenêtre en Nb d''échantillon (L):';
    S.guimark.poemgaglrltip =sprintf('Sélectionner L aussi grand que possible (afin d''obtenir une estimation\nde la variance fiable), mais plus petite que la plus courte période\nstationnaire (période avec une variance constante) à détecter.');
    S.guimark.poemgaglrdtxt ='Nombre minimum d''échantillon (d):';
    S.guimark.poemgaglrdtip =sprintf('Nombre minimum d''échantillon utilisé pour l''estimation ML.\nSélectionner d telle que ta+d sera encore situé à l''intérieur de\nla période stationnaire indiquée par le temps d''alarme actuelle (ta).\nCe paramètre n''est pas très critique. Habituellement, un petit\nnombre d''échantillons (par exemple, d = 10) sera Ok.');
    S.guimark.poemgvoir ='Voir';
    S.guimark.poemgvoirtip ='Pour tester les paramètres sur le premier canal/essai sélectionné';

    % ONGLET BIDON
    S.guimark.pobidletit ='Bidon';
    S.guimark.pobidletittip ='Ajouter un point bidon';
    S.guimark.pobidnom ='Point Bidon';
    S.guimark.pobidpostxt ='Position qu''occupera le point bidon: ';
    S.guimark.pobidposmantip ='Si laissé vide, la ListBox à droite sera lu';
    S.guimark.pobidposmantxt ='(Ou, avec le clavier): ';

    % ONGLET TEST
    S.guimark.potestletit ='Test';
    S.guimark.potestletittip ='Détection des changements';
    S.guimark.potestnom ='Détection Changement';
    S.guimark.potestdoctxt ='Pour explication, allez voir: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    S.guimark.potestseuiltxt ='Seuil, Threshold';
    S.guimark.potestseuiltxttip ='Valeur minimum pour la détection d''un changement';
    S.guimark.potestseuiltip ='Valeur à dépasser lors de la somme cumulative';
    S.guimark.potestgplus ='Montée (+)';
    S.guimark.potestgmoins ='Descente (-)';
    S.guimark.potestdriftxt ='Dérive, Drift';
    S.guimark.potestdriftxttip ='Pour éviter les faux positifs ou les longues pentes douces';
    S.guimark.potestdriftip ='Valeur de dérive, peux aussi annuler une partie du bruit du signal';
    S.guimark.potestvoir ='Voir';
    S.guimark.potestvoirtip ='Teste le seuil et la dérive sur le premier essai sélectionné et affiche g+ et g-';

    % TEXTE COMMUN
    S.guimark.pocommunrepet ='Nb de répétition: ';
    S.guimark.pocommunint ='tout l''intervalle';
    S.guimark.pocommuninttip ='répéter le marquage successif sur tout l''intervalle de travail';
    S.guimark.pocommunintertxt ='[ Intervalle de travail ]';
    S.guimark.pocommunintertxttip =sprintf('p0 ou pi --> premier échantillon\npf --> le dernier\nvaleur numérique --> temps en sec\np1 p2 p... --> point marqué');
    S.guimark.pocommuninterdbttip ='Pour commencer au premier échantillon, laissez à P0 ou Pi';
    S.guimark.pocommuninterfintip ='Si laissé à Pf, le dernier échantillon de ce canal sera utilisé';
    S.guimark.pocommuncanexttip ='Mettre une copie des points à marquer ci-haut vers les canaux choisis ci-contre';
    S.guimark.pocommunrempltip ='Copier en remplaçant le point si nécessaire';

    % EN COURS DE ROUTE
    S.guimark.po_ou ='ou';
    S.guimark.po_et ='et';
    S.guimark.po_debut ='début';
    S.guimark.po_fin ='fin';
    S.guimark.potravchmnm ='Il faut choisir Min et/ou Max';
    S.guimark.potravchmddm ='Il faut faire au moins un choix Montée/Descente/Début/Fin';
    S.guimark.potravchmd ='Il faut faire au moins un choix Montée/Descente';
    S.guimark.potravchmontdesc ='Montée/Descentes';
    S.guimark.potravcan ='canal';
    S.guimark.potravess ='essai';
    S.guimark.potravnpt ='no.point';
    S.guimark.potravdfinterr ='Début et/ou fin de l''interval mal défini';
    S.guimark.potraverrfnc ='Erreur dans la fonction';
    S.guimark.potravemgrech ='Recherche activité musc. pour le';
    S.guimark.potravafflon ='L''affichage des courbes et des points peuvent être long...';
    S.guimark.potravetmperr ='Expression temporelle non valide';
    S.guimark.potraveincerr ='Expression d''incrément non valide';
    S.guimark.potravexpr ='Expression';
    S.guimark.potravnvalid ='non valide';
    S.guimark.potravsderiv ='Les valeurs du seuil et de la dérive ne peuvent être à zéro en même temps';
    S.guimark.potravcusumrech ='Recherche des changements en cours...';
    S.guimark.potravfermer ='Le retour à l''affichage régulier peut être assez long lorsqu''il y a plusieurs points à afficher';
    S.guimark.potravmaw ='Silicone au travail';

    % BAR DE STATUS
    S.guimark.barstatus ='Commencez par choisir le type de marquage, puis remplissez les options nécessaires';

    %___________________________________________________________________________
    % Variable 
    % 

    % dlg.ctrgrdat     EDIT REGROUPER DATAS UTILES
    dlg.ctrgrdat.nom ='Regroupement des données utiles';
    dlg.ctrgrdat.titre ='Type de séparation';
    dlg.ctrgrdat.choix1 =['Autour d''un seul point'];
    dlg.ctrgrdat.choix1 ='À partir de deux points';
    dlg.ctrgrdat.choix1 ='';
    

    dlg.ctrl.status ='Vous devez ouvrir un fichier pour commencer.';
    dlg.ctxt.zoomxy ='Zoom en X et Y';
    dlg.ctxt.zoomx ='Zoom en X Seulement';
    dlg.ctxt.zoomy ='Zoom en Y Seulement';
    dlg.ctxt.zoomplein ='Pleine page';
    dlg.ctxt.zoomoff ='Désactivez le Zoom';

    %Écriture des textes dans le fichier
    if nargin
      if isempty(dir(varargin{1}))
    	  save(varargin{1},'-struct','S', '-v6');
    	else
    	  save(varargin{1},'-struct','S','-append');
    	end
    else
    	varargout(1) =S;
    end
  else
  	disp({'Donnez un nom de fichier en entrée ou une variable pour la sortie';...
  	      'Ex.'; 'langue_fr(''fr.mat'') ou bien';'test =langue_fr'});
  end
end
