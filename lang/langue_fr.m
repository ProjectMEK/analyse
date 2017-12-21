%
% Fonction langue
%
% Cr�ateur: MEK, mars 2009
% Repris plus s�rieusement en avril 2015
%
% FRAN�AIS
%
function varargout =langue_fr(varargin)
  if nargout | nargin

    %___________________________________________________________________________
  	% Variable r�p�titive
    %---------------------------------------------------------------------------
    auTravail='Au travail';

  	%___________________________________________________________________________
  	%POUR AFFICHER LA LANGUE DE TRAVAIL
    %---------------------------------------------------------------------------
  	S.langue ='Fran�ais';

  	%___________________________________________________________________________
  	% Variable mnuip
  	% MENU DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------
    S.mnuip.file ='&Fichier';
    S.mnuip.fileouvrir ='&Ouvrir';
    S.mnuip.fileouvrirot ='Ou&vrir autres';
    S.mnuip.fileouvrirottxt ='&Texte d�limit�';
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
    S.mnuip.fileecritresult ='�crit&ure des r�sultats';
    S.mnuip.fileprint ='&Imprimer';
    S.mnuip.fileprintcopiecoller ='&Copier-Coller';
    S.mnuip.fileprintjpeg ='Fichier &JPEG';
    S.mnuip.fileprintimprimer ='&Imprimer';
    S.mnuip.filedernierouvert ='Ouvert &derni�rement';
    S.mnuip.filepreferences ='Pr�f�ren&ces';
    S.mnuip.fileredemarrer ='Red�&marrer Analyse';
    S.mnuip.fileterminus ='&Terminus';

    S.mnuip.edit ='&�dit';
    S.mnuip.editmajcan ='MAJ infos des canaux s�lectionn�s';
    S.mnuip.editcanal ='&Canal';
    S.mnuip.editcopiecanal ='Co&pie canal';
    S.mnuip.editdatautil ='Regrouper donn�es utiles';
    S.mnuip.editcatego ='C&at�gorie';
    S.mnuip.editrebatircatego ='&Reb�tir Cat�gories';
    S.mnuip.editecheltemps ='�chelle de &temps';

    S.mnuip.modif ='&Modifier';
    S.mnuip.modifsuppcan ='Supprimer canaux';
    S.mnuip.modifcorriger ='Corriger';
    S.mnuip.modifcouper ='&Couper';
    S.mnuip.modifdecouper ='&D�couper';
    S.mnuip.modifdecimate ='&D�cimer';
    S.mnuip.modifrebase ='&Rebase';
    S.mnuip.modifrotation ='R&otation';
    S.mnuip.modifsynchroess ='&Synchronyse les Essais';
    S.mnuip.modifsynchrocan ='&Synchronyse les Canaux';

    S.mnuip.math ='Ma&th.';
    S.mnuip.mathderivfil ='&D�riv�/Filtre';
    S.mnuip.mathderivfilbutter ='&ButterWorth';
    S.mnuip.mathderivfilsptool ='Compl�ment � SPTOOL';
    S.mnuip.mathderivfildiffer ='&Differ';
    S.mnuip.mathderivfilpolynom ='&Traitement Polynomiale';
    S.mnuip.mathintdef ='&Int�grale d�finie';
    S.mnuip.mathintcum ='Int�gral-Cumulative';
    S.mnuip.mathnormal ='&Normalise';
    S.mnuip.mathnormaltemp ='Normalisation Temporelle';
    S.mnuip.mathellipsconf ='Ellipse de confiance';
    S.mnuip.mathmoyectyp ='Moy./Ecart-type par cat�gorie';
    S.mnuip.mathmoyptmarq ='Moyenne autour des points marqu�s';
    S.mnuip.mathpentedrtregr ='Pente de la droite de r�gression';
    S.mnuip.mathcalcang ='Calcul d''angle';
    S.mnuip.mathtraitcan ='Traitement de canal';

    S.mnuip.emg ='Em&g';
    S.mnuip.emgrectif ='&Rectification';
    S.mnuip.emgliss ='&Lissage';
    S.mnuip.emgrms ='R&MS';
    S.mnuip.emgmav ='M&AV';
    S.mnuip.emgffm ='&F-M�d/Moy/Max';
    S.mnuip.emgnormal ='&Normalisation';
    S.mnuip.emgintegsucc ='Int�grations (successives)';
    S.mnuip.emgchgpolar ='&Changement de polarit�';
    S.mnuip.emgdistprbampl ='&Distribution de probabilit� d''Amplitude';

    S.mnuip.fplt ='&FPlt';
    S.mnuip.fpltcop ='Centre de Pression(COP) et COG AMTI';
    S.mnuip.fpltcopparammanuel ='Entr�e des param manuelle';
    S.mnuip.fpltcopparamfichier ='Entr�e des param par fichier';
    S.mnuip.fpltcopoptima ='COP et COG OPTIMA';
    S.mnuip.fpltstat4cop ='Stat-4-COP';

    S.mnuip.trajet ='T&rajectoire';
    S.mnuip.trajetgps ='GPS';
    S.mnuip.trajetgpsecef2lla ='(GPS)ECEF vers LLA';
    S.mnuip.trajetecart ='&�cart';
    S.mnuip.trajetdiffinterpt ='&Diff�rence de points';
    S.mnuip.trajetdistparcour ='Distance parcourue &X-Y-(Z)';
    S.mnuip.trajetamplmvt ='&Amplitude de mvt';
    S.mnuip.trajetdirect ='D&irection';
    S.mnuip.trajetcourb ='&Courbure';

    S.mnuip.ou ='O&utils';
    S.mnuip.ouechtempo ='�chelle &temporelle';
    S.mnuip.ouechtempodefaut ='Retour � la normale';
    S.mnuip.ouimportpoint ='&Importer point (Y vs X)';
    S.mnuip.outrierpt ='Trier les points marqu�s';
    S.mnuip.oumark ='&Marquer';
    S.mnuip.ouzoom ='Zoom';
    S.mnuip.ouaffichercoord ='Afficher les Coordonn�es';
    S.mnuip.oucouleur ='Afficher la couleur pour ';
    S.mnuip.oucouleurcan ='Diff�rencier les canaux';
    S.mnuip.oucouleuress ='Diff�rencier les essais';
    S.mnuip.oucouleurcat ='Diff�rencier les cat�gories';
    S.mnuip.oulegend ='Afficher L�gende';
    S.mnuip.ouechant ='Afficher les �chantillons';
    S.mnuip.ouptmarkatexte ='Afficher Points marqu�s avec texte';
    S.mnuip.ouptmarkstexte ='Afficher Points marqu�s sans texte';
    S.mnuip.ouaffprop ='Affichage proportionnel des courbes';
    S.mnuip.ouxy ='Afficher (Canal-Y vs Canal-X)';

    S.mnuip.quelfichier ='&Quel Fichier';

    S.mnuip.hlp ='&Aide';
    S.mnuip.hlpdoc ='Rappel en cas de panique  :-)';
    S.mnuip.hlplog ='Historique';
    S.mnuip.hlplogbook ='Journal des actions';
    S.mnuip.hlpabout ='� propos de';

  	%___________________________________________________________________________
  	% Variable guiip
  	% BOUTON DE L'INTERFACE PRINCIPAL
    %---------------------------------------------------------------------------

    S.guiip.gntudebut ='Vous devez ouvrir un fichier pour commencer.';
    S.guiip.pbvide ='vide';
    S.guiip.pbcanmarktip ='Choix du canal pour le marquage manuel';
    S.guiip.pbdelpttip ='Effacer le point s�lectionn�';
    S.guiip.pbmarmantip ='Marquage manuel avec la souris';
    S.guiip.pbcoord ='Coord.';
    S.guiip.pbcoordtip ='Afficher un curseur et ses coordonn�es (X,Y)';

    %___________________________________________________________________________
    % Variable lire
    % GUI POUR LA LECTURE DES DIFF�RENTS FORMATS SUPPORT�S
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
    S.lire.concatinfo ='Concat�nation des infos: ';
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
    % GUI DE LA GESTION DES PR�F�RENCES
    %---------------------------------------------------------------------------
    S.guipref.name ='Pr�f�rences';

    S.guipref.ongen ='G�n�ral';
    S.guipref.ongenconserv =['Conserver les pr�f�rences d''une session � l''autre.'];
    S.guipref.ongenlang ='Nom du fichier pour la langue de travail (dans le dossier "doc"): ';
    S.guipref.ongenrecent ='Nombre de fichier dans le menu "Ouvert derni�rement": ';
    S.guipref.ongenerr =['Affichage des messages d''erreur dans la console: '];
    S.guipref.ongenerrmnu ={'Aucun affichage', 'Message complet','Message partiel'};

    S.guipref.onaff ='Affichage';
    S.guipref.onafftip ='Configuration des options graphiques';
    S.guipref.onafftxfix =sprintf('Fixer \nconfig.');
    S.guipref.onafftxactiv =sprintf('Activ� \nsi coch�');
    S.guipref.onaffactxy ='Activer le mode XY';
    S.guipref.onaffpt ='Afficher les points marqu�s';
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
    S.guipref.onottip ='Au del� des rumeurs...';
    S.guipref.onottit ='Pr�f�rences';
    S.guipref.onotp1 =sprintf(['\nLes pr�f�rences sauvegard�es vont faire en sorte que l''interface ' ...
                    'de travail sera le "m�me" ou "� votre main" � chaque ouverture. ' ...
                    'N''oubliez pas de cliquer sur le bouton "Appliquer" afin de sauvegarder les modifications.']);
    S.guipref.onotp2 =sprintf(['\nDans l''onglet "G�n�ral", la case "Conserver les pr�f�rences..."' ...
                    '\n si coch�e, vous permet de garder les pr�f�rences pour les futures sessions. ' ...
                    '\n si non-coch�e, vous recommencerez avec les valeurs par d�fauts de base.']);
    S.guipref.onotp3 =sprintf(['\nL''affichage des messages d''erreur, peut prendre plusieurs formes. ' ...
                    'Cela vous permet d''avoir plus ou moins de texte affich� pour les erreurs sans importances.']);
    S.guipref.onotp4 =sprintf(['\nDans l''onglet "Affichage", il y a deux colonnes: "Fixer config." (FC) et ' ...
                    '"Activ� si coch�" (AC). Si vous cochez la case de la colonne "FC", vous ' ...
                    'imposerez la valeur de la case "AC" pour cette variable.']);
    S.guipref.onotp5 =sprintf(['\nPar contre, si vous ne cochez pas la case de la colonne "FC", la valeur ' ...
                    'pour cette variable sera celle � la fermeture de l''application.' ...
                    '\n\n(Par exemple, pour la ligne "Activer le zoom"' ...
                    '\n  si la case "FC" est coch�e' ...
                    '\n    avec la case "AC" coch�e: le zoom sera actif' ...
                    '\n    avec la case "AC" d�coch�e: le zoom sera inactif' ...
                    '\n\n  si la case "FC" n''est pas coch�e' ...
                    '\n    � la fermeture d''Analyse, l''�tat du zoom' ...
                    '\n    d�cidera de la valeur lors de la r�-ouverture.)']);
    S.guipref.onotp6 =sprintf(['\nNota bene: afin de sauvegarder les modifications, vous devez cliquer sur le bouton "Appliquer" ']);

    S.guipref.onstat ='Entrez vos pr�f�rences afin d''am�liorer votre session de travail';

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

    S.guimoypentri.lesep ='S�parateur:';
    S.guimoypentri.selsep ={'virgule','point virgule','Tab'};

    S.guimoypentri.fentrav ='Fen�tre de travail';
    S.guimoypentri.rangtrav ='Range de points � trier';
    S.guimoypentri.fentravtip1 =sprintf('Valeur num�rique --> temps\n\np0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p3 ... --> point marqu�');
    S.guimoypentri.fentravtip2 =sprintf('p0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p3 ... --> point marqu�');
    S.guimoypentri.rangtravtip =sprintf('P0, Pi, P1 --> premier point\nPf ou end --> dernier point\nP1 P2 P3 ... --> point marqu�');

    S.guimoypentri.autpts ='Autour des points';
    S.guimoypentri.autpttip =sprintf('Valeur num�rique pour indiquer l''�tendue avant et\napr�s le point � consid�rer pour faire la moyenne');
    S.guimoypentri.valneg ='Valeur � n�gliger';
    S.guimoypentri.valnegtip =sprintf('Valeur num�rique pour modifier la plage utile --> [(1er point + Valeur) jusqu''� (2i�me point - Valeur)]');
    S.guimoypentri.tipunit ={'�chantillons','secondes'};
    S.guimoypentri.maw =auTravail;

    S.guimoypentri.info1 ='Par d�faut, si on ne coche pas "Autour des points", la moyenne se fera sur les valeurs entre les deux bornes de la fen�tre de travail /si on la coche/ on fera les moyennes autour des points marqu�s.';
    S.guimoypentri.info2 ='Le calcul de la pente sera effectu� selon la fen�tre de travail fournie et le "pairage de point" demand�. La valeur � n�gliger r�duira la plage de travail � droite du premier point et � gauche du second.';
    S.guimoypentri.info3 ='Pour trier en ordre croissant, on �crira: [P1  Pf]. En ordre d�croissant se sera: [Pf  P1]. De m�me, pour trier les 5 derniers: [end-4 end]';

    % Partie Au Travail
    S.guimoypentri.wbar1 ='Moyennage en cours';
    S.guimoypentri.wbar2 ='Calcul en cours';
    S.guimoypentri.wbar3 ='Trie des points en cours';

    S.guimoypentri.putfich1 ='R�sultat des Moyennes';
    S.guimoypentri.putfich2 ='R�sultat des Pentes';
    S.guimoypentri.errfich ='Erreur dans le fichier de sortie.';

    S.guimoypentri.fichori ='Fichier d''origine';
    S.guimoypentri.legcan ='L�gende des canaux';
    S.guimoypentri.vnegli =S.guimoypentri.valneg;
    S.guimoypentri.moyfait1 ='La moyenne a �t� faite sur';
    S.guimoypentri.moyfait2 ='La moyenne est faite sur l''espace d�fini ci-haut';
    S.guimoypentri.autpt ='autour du point';
    S.guimoypentri.penfait ='La pente est calcul�e sur l''espace d�fini ci-haut';
    S.guimoypentri.titess ='Essai';

    S.guimoypentri.m2pt ='Moins de 2 points, pas de triage';
    S.guimoypentri.errsyn ='Erreur dans la syntaxe du "Range de points � trier"';
    S.guimoypentri.lecan ='pour le canal';
    S.guimoypentri.less ='et l''essai';

    %___________________________________________________________________________
    % Variable guitretcan
    % GUI DU TRAITEMENT DE CANAL
    %---------------------------------------------------------------------------
    S.guitretcan.name ='Traitement de canal';

    S.guitretcan.title ='Calcul sur les canaux';
    S.guitretcan.alltrial ='Appliquer � tous les essais';
    S.guitretcan.keeppt ='Conserver les points';
    S.guitretcan.keeppttip ='Conserver les points lorsque vous �crivez le r�sultat dans un canal existant';
    S.guitretcan.seless ='Choix des essais';
    S.guitretcan.selcat ='Choix des cat�gories';
    S.guitretcan.ligcommtip ='Chaque �l�ment doit �tre s�par� par une virgule';
    S.guitretcan.delstr ='Supp';
    S.guitretcan.canal ='Choix des canaux';
    S.guitretcan.clavnum ='Clavier num�rique/op�rateurs';
    S.guitretcan.clavfnctip =',  sera interpr�t� comme: C1 ';
    S.guitretcan.fonction ='Choix des fonctions';
    S.guitretcan.fnctlist ={'Pi','constante trigonom�trique';...
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
                'Exp',sprintf('Fonction exp de Matlab,\nEx:\n-  Si on �crit:  C1,N,exp,\n-  ce sera interpr�t� comme:  C1^N')};

    S.guitretcan.triginv ='Inv';
    S.guitretcan.triginvtip ='Pour les fonctions trigonom�trique seulement, coch� pour avoir: asin, acos ou atan';
    S.guitretcan.deg ='Degr�';
    S.guitretcan.degtip ='Si non coch�, les angles sont en radians';
    S.guitretcan.buttonGo =auTravail;

    %___________________________________________________________________________
    % Variable guimark
    % GUI DU MARQUAGE
    %---------------------------------------------------------------------------
    S.guimark.name ='POUR QUITTER LE MARQUAGE, cliquez sur le X � droite  > > > >';

    %(PP) PANEL PERMAMENT
    S.guimark.ppaid ='?';
    S.guimark.ppaidtip ='Documentation sur le marquage';
    S.guimark.ppcansrc ='Source';
    S.guimark.ppptsmrk ='Pts';
    S.guimark.ppdelptall ='Tous les pts';
    S.guimark.ppdelptalltip ='Choisir tous les points des canaux et essais s�lectionn�s, pour la suppression';
    S.guimark.ppdelenumtip =sprintf('No des points � supprimer, en ordre croissant,\nEx: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12');
    S.guimark.ppdelpthide ='Cacher';
    S.guimark.ppdelpthidetip =sprintf('Supprimera le point voulu sans changer l''ordre des points suivants.\nLes points supprim�s deviendront Bidons.');
    S.guimark.ppdelbutton ='Suppr';
    S.guimark.ppdelbuttontip ='Supprimera tous les points s�lectionn�s ci-haut.';
    S.guimark.ppesscat ='Marquage par essai(s) ou cat�gorie(s)';
    S.guimark.ppesscattip ='Si non coch�, tous les essais sont s�lectionn�s';
    S.guimark.ppreplace ='Remplacer les points choisis ci-haut';
    S.guimark.ppreplacetip ='En mode Exporter: point source(i)-->point destination(i)';

    % BOUTON GO...START...AU TRAVAIL
    S.guimark.buttonGo =auTravail;

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    S.guimark.poexpletit ='Exp.';
    S.guimark.poexpletittip ='Exportation d''un canal � l''autre';
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

    % ONGLET MONT�...
    S.guimark.pomonteletit ='Mont�.';
    S.guimark.pomonteletittip ='D�but - fin: Mont�e -Descente';
    S.guimark.pomontenom ='Mont�e-Descente';
    S.guimark.pomontemnt ='Mont�e';
    S.guimark.pomontedbt ='D�but';
    S.guimark.pomontefin ='Fin';
    S.guimark.pomontedsc ='Descente';
    S.guimark.pomontedytxt ='Delta Y';
    S.guimark.pomontedytxttip ='Diff�rence d''Amplitude n�cessaire pour consid�rer une mont�e ou une descente';
    S.guimark.pomontedytip =sprintf('Valeur de la variation d''amplitude (ex: 10, 150, etc)\n ou pourcentage du max-min (ex: 10%%, 45%%, etc)\n � partir de laquelle vous consid�rez qu''il y a une mont�e ou une descente.\n Par d�faut (si laiss� � 0), 50%% : (Max - Min) X 50%% ');
    S.guimark.pomontedxtxt ='Delta X';
    S.guimark.pomontedxtxttip ='Diff�rence temporelle (sec) n�cessaire pour monter ou descendre de Delta Y';
    S.guimark.pomontedxtip ='largeur en seconde afin d''avoir une variation d''amplitude de DeltaY. Si laiss� � 0: � sec.';
    S.guimark.pomontedttxt ='Delta T';
    S.guimark.pomontedttxttip ='Nb d''�chantillon � consid�rer pour discriminer les "petits pics" (bruit)';
    S.guimark.pomontedttip ='Nombre d''�chantillon � consid�rer pour d�clarer un d�but ou une fin. Par d�faut = 3 (Si laiss� � z�ro)';
    S.guimark.pomontedef ='D';
    S.guimark.pomontedeftip ='Valeurs par d�faut (ou z�ro) pour ce cadre';

    % ONGLET TEMPOREL
    S.guimark.potmpletit ='Temps.';
    S.guimark.potmpletittip ='Marquage temporel';
    S.guimark.potmpnom ='Marquage temporel';
    S.guimark.potmpvaltxt ='Temps pr�cis ou no du pt: ';
    S.guimark.potmpvaltip ='Premier temps pr�cis � marquer (peut �tre le no d''un point pour le marquage successif, ex: p1)';
    S.guimark.potmpstep ='Intervalle entre les pts subs�quents: ';
    S.guimark.potmpsteptip ='� partir du temps ci-haut, nombre de seconde pour le prochain point';

    % ONGLET AMPLITUDE
    S.guimark.poampletit ='Amplit.';
    S.guimark.poampletittip ='Marquer une amplitude';
    S.guimark.poampnom ='Marquage d''amplitude';
    S.guimark.poampvaltxt ='Amplitude (ou no. de point) � marquer: ';
    S.guimark.poampvaltip =sprintf('Valeur num�rique --> Amplitude\n\np0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p... --> point marqu�');
    S.guimark.poamppcenttxt ='% de l''amplitude du point ci-haut: ';
    S.guimark.poamppcenttip =sprintf('Si vous avez inscrit un point plut�t qu''une amplitude ci-haut,\nvous pouvez vouloir un pourcentage de l''amplitude correspondante');
    S.guimark.poampdectxt ='D�calage temporel +/-: ';
    S.guimark.poampdectip =sprintf('L''amplitude consid�r� sera celle du point demand� ci-haut,\nd�cal� de la valeur temporelle en sec ci-contre.');
    S.guimark.poampdirtxt ='Direction: ';
    S.guimark.poampdir ={'du d�but vers la fin >>>', '<<< de la fin vers le d�but'};
    S.guimark.poampdirtip ='Par o� commencer � marquer le point no 1, de la gauche ou de la droite';

    % ONGLET EMG
    S.guimark.poemgletit ='Emg.';
    S.guimark.poemgletittip ='Marquer les d�buts et fins de l''activit� musculaire dans un signal EMG';
    S.guimark.poemgnom ='Marquage EMG';
    S.guimark.poemgrefdoc ='Ref/Doc';
    S.guimark.poemgaglrhtxt ='Seuil de d�tection (h):';
    S.guimark.poemgaglrhtip =sprintf('Plus la valeur de h est petite, moins on d�tecte d''�v�nement, et\nplus elle est grande, plus on peut g�n�rer de fausse d�tection.');
    S.guimark.poemgaglrltxt ='Largeur de fen�tre en Nb d''�chantillon (L):';
    S.guimark.poemgaglrltip =sprintf('S�lectionner L aussi grand que possible (afin d''obtenir une estimation\nde la variance fiable), mais plus petite que la plus courte p�riode\nstationnaire (p�riode avec une variance constante) � d�tecter.');
    S.guimark.poemgaglrdtxt ='Nombre minimum d''�chantillon (d):';
    S.guimark.poemgaglrdtip =sprintf('Nombre minimum d''�chantillon utilis� pour l''estimation ML.\nS�lectionner d telle que ta+d sera encore situ� � l''int�rieur de\nla p�riode stationnaire indiqu�e par le temps d''alarme actuelle (ta).\nCe param�tre n''est pas tr�s critique. Habituellement, un petit\nnombre d''�chantillons (par exemple, d = 10) sera Ok.');
    S.guimark.poemgvoir ='Voir';
    S.guimark.poemgvoirtip ='Pour tester les param�tres sur le premier canal/essai s�lectionn�';

    % ONGLET BIDON
    S.guimark.pobidletit ='Bidon';
    S.guimark.pobidletittip ='Ajouter un point bidon';
    S.guimark.pobidnom ='Point Bidon';
    S.guimark.pobidpostxt ='Position qu''occupera le point bidon: ';
    S.guimark.pobidposmantip ='Si laiss� vide, la ListBox � droite sera lu';
    S.guimark.pobidposmantxt ='(Ou, avec le clavier): ';

    % ONGLET TEST
    S.guimark.potestletit ='Test';
    S.guimark.potestletittip ='D�tection des changements';
    S.guimark.potestnom ='D�tection Changement';
    S.guimark.potestdoctxt ='Pour explication, allez voir: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    S.guimark.potestseuiltxt ='Seuil, Threshold';
    S.guimark.potestseuiltxttip ='Valeur minimum pour la d�tection d''un changement';
    S.guimark.potestseuiltip ='Valeur � d�passer lors de la somme cumulative';
    S.guimark.potestgplus ='Mont�e (+)';
    S.guimark.potestgmoins ='Descente (-)';
    S.guimark.potestdriftxt ='D�rive, Drift';
    S.guimark.potestdriftxttip ='Pour �viter les faux positifs ou les longues pentes douces';
    S.guimark.potestdriftip ='Valeur de d�rive, peux aussi annuler une partie du bruit du signal';
    S.guimark.potestvoir ='Voir';
    S.guimark.potestvoirtip ='Teste le seuil et la d�rive sur le premier essai s�lectionn� et affiche g+ et g-';

    % TEXTE COMMUN
    S.guimark.pocommunrepet ='Nb de r�p�tition: ';
    S.guimark.pocommunint ='tout l''intervalle';
    S.guimark.pocommuninttip ='r�p�ter le marquage successif sur tout l''intervalle de travail';
    S.guimark.pocommunintertxt ='[ Intervalle de travail ]';
    S.guimark.pocommunintertxttip =sprintf('p0 ou pi --> premier �chantillon\npf --> le dernier\nvaleur num�rique --> temps en sec\np1 p2 p... --> point marqu�');
    S.guimark.pocommuninterdbttip ='Pour commencer au premier �chantillon, laissez � P0 ou Pi';
    S.guimark.pocommuninterfintip ='Si laiss� � Pf, le dernier �chantillon de ce canal sera utilis�';
    S.guimark.pocommuncanexttip ='Mettre une copie des points � marquer ci-haut vers les canaux choisis ci-contre';
    S.guimark.pocommunrempltip ='Copier en rempla�ant le point si n�cessaire';

    % EN COURS DE ROUTE
    S.guimark.po_ou ='ou';
    S.guimark.po_et ='et';
    S.guimark.po_debut ='d�but';
    S.guimark.po_fin ='fin';
    S.guimark.potravchmnm ='Il faut choisir Min et/ou Max';
    S.guimark.potravchmddm ='Il faut faire au moins un choix Mont�e/Descente/D�but/Fin';
    S.guimark.potravchmd ='Il faut faire au moins un choix Mont�e/Descente';
    S.guimark.potravchmontdesc ='Mont�e/Descentes';
    S.guimark.potravcan ='canal';
    S.guimark.potravess ='essai';
    S.guimark.potravnpt ='no.point';
    S.guimark.potravdfinterr ='D�but et/ou fin de l''interval mal d�fini';
    S.guimark.potraverrfnc ='Erreur dans la fonction';
    S.guimark.potravemgrech ='Recherche activit� musc. pour le';
    S.guimark.potravafflon ='L''affichage des courbes et des points peuvent �tre long...';
    S.guimark.potravetmperr ='Expression temporelle non valide';
    S.guimark.potraveincerr ='Expression d''incr�ment non valide';
    S.guimark.potravexpr ='Expression';
    S.guimark.potravnvalid ='non valide';
    S.guimark.potravsderiv ='Les valeurs du seuil et de la d�rive ne peuvent �tre � z�ro en m�me temps';
    S.guimark.potravcusumrech ='Recherche des changements en cours...';
    S.guimark.potravfermer ='Le retour � l''affichage r�gulier peut �tre assez long lorsqu''il y a plusieurs points � afficher';
    S.guimark.potravmaw ='Silicone au travail';

    % BAR DE STATUS
    S.guimark.barstatus ='Commencez par choisir le type de marquage, puis remplissez les options n�cessaires';

    %___________________________________________________________________________
    % Variable 
    % 

    % dlg.ctrgrdat     EDIT REGROUPER DATAS UTILES
    dlg.ctrgrdat.nom ='Regroupement des donn�es utiles';
    dlg.ctrgrdat.titre ='Type de s�paration';
    dlg.ctrgrdat.choix1 =['Autour d''un seul point'];
    dlg.ctrgrdat.choix1 ='� partir de deux points';
    dlg.ctrgrdat.choix1 ='';
    

    dlg.ctrl.status ='Vous devez ouvrir un fichier pour commencer.';
    dlg.ctxt.zoomxy ='Zoom en X et Y';
    dlg.ctxt.zoomx ='Zoom en X Seulement';
    dlg.ctxt.zoomy ='Zoom en Y Seulement';
    dlg.ctxt.zoomplein ='Pleine page';
    dlg.ctxt.zoomoff ='D�sactivez le Zoom';

    %�criture des textes dans le fichier
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
  	disp({'Donnez un nom de fichier en entr�e ou une variable pour la sortie';...
  	      'Ex.'; 'langue_fr(''fr.mat'') ou bien';'test =langue_fr'});
  end
end
