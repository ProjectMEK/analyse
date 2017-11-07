%
% Classe CMenuMLIp
%
% Gère les informations du menu du GUI principale
%
% MEK
% 2015/04/13
%
classdef CMenuMLIp < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    %file
    file ='&Fichier';
    fileouvrir ='&Ouvrir';
    fileouvrirot ='Ou&vrir autres';
    fileouvrirottxt ='Texte délimité';
    fileouvrirotauto21 ='.XML (Auto21)';
    fileouvriroti2m ='.H5 (I2M)';
    fileouvrirotc3d ='.C3D (Vicon)';
    fileouvrirotemg ='.MAT (Emg)';
    fileouvrirotkeit ='.ADW (Keitley)';
    fileajout ='&Ajouter';
    filebatch ='&Traitement en Batch';
    filefermer ='&Fermer';
    filesave ='&Enregistrer';
    filesaveas ='En&registrer sous';
    fileexport ='Exportation';
    fileecritresult ='Écriture des &résultats';
    fileprint ='&Imprimer';
    fileprintcopiecoller ='Copier-Coller';
    fileprintjpeg ='Fichier JPEG';
    fileprintimprimer ='Imprimer';
    filedernierouvert ='Derniers ouverts';
    filepreferences ='Préféren&ces';
    fileredemarrer ='&Redémarrer Analyse';
    fileterminus ='&Terminus';

    %edit
    edit ='&Edit';
    editmajcan ='MAJ infos des canaux sélectionnés';
    editcanal ='&Canal';
    editcopiecanal ='Co&pie canal';
    editcatego ='C&atégorie';
    editrebatircatego ='&Rebâtir Catégories';
    editecheltemps ='Échelle de &temps';

    %modifier
    modif ='&Modifier';
    modifsuppcan ='Supprimer canaux';
    modifcorriger ='Corriger';
    modifcouper ='&Couper';
    modifdecouper ='&Découper';
    modifdecimate ='&Decimer';
    modifrebase ='&Rebase';
    modifrotation ='R&otation';
    modifsynchroess ='&Synchronyse les Essais';
    modifsynchrocan ='&Synchronyse les Canaux';

    %math
    math ='Ma&th.';
    mathderivfil ='&Dérivé/Filtre';
    mathderivfilbutter ='&ButterWorth';
    mathderivfilsptool ='Complément à SPTOOL';
    mathderivfildiffer ='&Differ';
    mathderivfilpolynom ='&Traitement Polynomiale';
    mathintdef ='&Intégrale définie';
    mathintcum ='Intégral-Cumulative';
    mathnormal ='&Normalise';
    mathnormaltemp ='Normalisation Temporelle';
    mathellipsconf ='Ellipse de confiance';
    mathmoyectyp ='Moy./Ecart-type par catégorie';
    mathmoyptmarq ='Moyenne autour des points marqués';
    mathpentedrtregr ='Pente de la droite de régression'
    mathcalcang ='Calcul d''angle';
    mathtraitcan ='Traitement de canal';

    %emg
    emg ='Em&g';
    emgrectif ='&Rectification';
    emgliss ='&Lissage';
    emgrms ='R&MS';
    emgmav ='M&AV';
    emgffm ='&FM-FMoy-Max';
    emgnormal ='&Normalisation';
    emgintegsucc ='Intégrations (successives)';
    emgchgpolar ='&Changement de polarité';
    emgdistprbampl ='&Distribution de probabilité d''Amplitude';

    %fplt
    fplt ='&FPlt';
    fpltcop ='Centre de Pression(COP) et COG AMTI';
    fpltcopparammanuel ='Entrée des param manuelle';
    fpltcopparamfichier ='Entrée des param par fichier';
    fpltcopoptima ='COP et COG OPTIMA';
    fpltstat4cop ='Stat-4-COP';

    %trajectoire
    trajet ='T&rajectoire';
    trajetgps ='GPS';
    trajetgpsecef2lla ='(GPS)ECEF vers LLA';
    trajetecart ='&Ecart';
    trajetdiffinterpt ='&Différence de points';
    trajetdistparcour ='Distance parcourue &X-Y-(Z)';
    trajetamplmvt ='&Amplitude de mvt';
    trajetdirect ='D&irection';
    trajetcourb ='&Courbure';

    %outil
    ou ='O&utils';
    ouechtempo ='Échelle &temporelle';
    ouechtempodefaut ='Retour à la normale';
    ouimportpoint ='&Importer point (Y vs X)';
    outrierpt ='Trier les points marqués';
    oumark ='&Marquer';
    ouzoom ='Zoom';
    ouaffichercoord ='Afficher Coordonnées';
    oucouleur ='Afficher couleurs pour';
    oucouleurcan ='Différencier canaux';
    oucouleuress ='Différencier essais';
    oucouleurcat ='Différencier catégories';
    oulegend ='Afficher Légende';
    ouechant ='Afficher Échantillons';
    ouptmarkatexte ='Afficher Points marqués avec texte';
    ouptmarkstexte ='Afficher Points marqués sans texte';
    ouaffprop ='Affichage proportionnel';
    ouxy ='Afficher (Canal-Y vs Canal-X)';

    %quel fichier
    quelfichier ='&Quel Fichier';

    %aide
    hlp ='&Aide';
    hlpdoc ='Rappel en cas de panique  :-)';
    hlplog ='Historique';
    hlplogbook ='Journal des actions';
    hlpabout ='À propos de';

  end  %properties

  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %_____________________________________________________________________________
    % CONSTRUCTOR
    %-----------------------------------------------------------------------------

    function tO =CMenuMLIp()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('mnuip');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
