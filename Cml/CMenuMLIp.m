%
% Classe CMenuMLIp
%
% G�re les informations du menu du GUI principale
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
    fileouvrirottxt ='Texte d�limit�';
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
    fileecritresult ='�criture des &r�sultats';
    fileprint ='&Imprimer';
    fileprintcopiecoller ='Copier-Coller';
    fileprintjpeg ='Fichier JPEG';
    fileprintimprimer ='Imprimer';
    filedernierouvert ='Derniers ouverts';
    filepreferences ='Pr�f�ren&ces';
    fileredemarrer ='&Red�marrer Analyse';
    fileterminus ='&Terminus';

    %edit
    edit ='&Edit';
    editmajcan ='MAJ infos des canaux s�lectionn�s';
    editcanal ='&Canal';
    editcopiecanal ='Co&pie canal';
    editcatego ='C&at�gorie';
    editrebatircatego ='&Reb�tir Cat�gories';
    editecheltemps ='�chelle de &temps';

    %modifier
    modif ='&Modifier';
    modifsuppcan ='Supprimer canaux';
    modifcorriger ='Corriger';
    modifcouper ='&Couper';
    modifdecouper ='&D�couper';
    modifdecimate ='&Decimer';
    modifrebase ='&Rebase';
    modifrotation ='R&otation';
    modifsynchroess ='&Synchronyse les Essais';
    modifsynchrocan ='&Synchronyse les Canaux';

    %math
    math ='Ma&th.';
    mathderivfil ='&D�riv�/Filtre';
    mathderivfilbutter ='&ButterWorth';
    mathderivfilsptool ='Compl�ment � SPTOOL';
    mathderivfildiffer ='&Differ';
    mathderivfilpolynom ='&Traitement Polynomiale';
    mathintdef ='&Int�grale d�finie';
    mathintcum ='Int�gral-Cumulative';
    mathnormal ='&Normalise';
    mathnormaltemp ='Normalisation Temporelle';
    mathellipsconf ='Ellipse de confiance';
    mathmoyectyp ='Moy./Ecart-type par cat�gorie';
    mathmoyptmarq ='Moyenne autour des points marqu�s';
    mathpentedrtregr ='Pente de la droite de r�gression'
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
    emgintegsucc ='Int�grations (successives)';
    emgchgpolar ='&Changement de polarit�';
    emgdistprbampl ='&Distribution de probabilit� d''Amplitude';

    %fplt
    fplt ='&FPlt';
    fpltcop ='Centre de Pression(COP) et COG AMTI';
    fpltcopparammanuel ='Entr�e des param manuelle';
    fpltcopparamfichier ='Entr�e des param par fichier';
    fpltcopoptima ='COP et COG OPTIMA';
    fpltstat4cop ='Stat-4-COP';

    %trajectoire
    trajet ='T&rajectoire';
    trajetgps ='GPS';
    trajetgpsecef2lla ='(GPS)ECEF vers LLA';
    trajetecart ='&Ecart';
    trajetdiffinterpt ='&Diff�rence de points';
    trajetdistparcour ='Distance parcourue &X-Y-(Z)';
    trajetamplmvt ='&Amplitude de mvt';
    trajetdirect ='D&irection';
    trajetcourb ='&Courbure';

    %outil
    ou ='O&utils';
    ouechtempo ='�chelle &temporelle';
    ouechtempodefaut ='Retour � la normale';
    ouimportpoint ='&Importer point (Y vs X)';
    outrierpt ='Trier les points marqu�s';
    oumark ='&Marquer';
    ouzoom ='Zoom';
    ouaffichercoord ='Afficher Coordonn�es';
    oucouleur ='Afficher couleurs pour';
    oucouleurcan ='Diff�rencier canaux';
    oucouleuress ='Diff�rencier essais';
    oucouleurcat ='Diff�rencier cat�gories';
    oulegend ='Afficher L�gende';
    ouechant ='Afficher �chantillons';
    ouptmarkatexte ='Afficher Points marqu�s avec texte';
    ouptmarkstexte ='Afficher Points marqu�s sans texte';
    ouaffprop ='Affichage proportionnel';
    ouxy ='Afficher (Canal-Y vs Canal-X)';

    %quel fichier
    quelfichier ='&Quel Fichier';

    %aide
    hlp ='&Aide';
    hlpdoc ='Rappel en cas de panique  :-)';
    hlplog ='Historique';
    hlplogbook ='Journal des actions';
    hlpabout ='� propos de';

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
