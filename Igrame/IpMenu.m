%
% CRÉATION DES MENUS DE L'INTERFACE (GUI) PRINCIPALE
%
% Tous les Callback des menus sont dirigés vers "appel.m"
%
% En entrée on veut un objet de la classe CDessine()
%
function IpMenu(obj)

  OA =CAnalyse.getInstance();
  elfig =obj.fig;

  % on lit la structure contenant le texte à afficher selon le choix de la langue
  tt =CMenuMLIp();

%-------------------
% ÉDITION DES MENUS
%-------------------

% FICHIER
  mnu = uimenu('Parent',elfig, 'tag','IpmnuFichier', 'Label',tt.file, 'enable','on');

  % OUVRIR
  uimenu('Parent',mnu, 'Callback','appel(''ouvrirfich'', ''analyse'')', 'Label',tt.fileouvrir);
  % OUVRIR AUTRES
  mmnu = uimenu('Parent',mnu, 'Label',tt.fileouvrirot, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','appel(''ouvrirfich'', ''Texte'')', 'Label',tt.fileouvrirottxt);
  uimenu('Parent',mmnu, 'Callback','appel(''ouvrirfich'', ''A21XML'')', 'Label',tt.fileouvrirotauto21, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','appel(''ouvrirfich'', ''HDF5'')', 'Label',tt.fileouvriroti2m, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','appel(''ouvrirfich'', ''EMG'')', 'Label',tt.fileouvrirotemg, 'Enable','on');
  uimenu('Parent',mmnu, 'Callback','appel(''ouvrirfich'', ''Keithley'')', 'Label',tt.fileouvrirotkeit, 'Enable','on');
  % AJOUTER
  uimenu('Parent',mnu, 'tag', 'IpmnuAjouter', 'Label',tt.fileajout, 'Callback','appel(''ajoutfich'')', 'enable','off');
  % BATCH
  uimenu('Parent',mnu, 'tag', 'IpmnuBatch', 'Label',tt.filebatch, ...
         'Callback','appel(''editbatch'')', 'Enable','on');
  % FERMER
  uimenu('Parent',mnu, 'tag', 'IpmnuFermer', 'Callback','appel(''fermerfich'')', ...
         'Label',tt.filefermer, 'Enable','off');
  % Sauvegarder
  uimenu('Parent',mnu, 'tag', 'IpmnuSave', 'Callback','appel(''sauverfich'')', ...
         'separator','on', 'Label',tt.filesave, 'Enable','off');
  % Sauvegarder sous
  uimenu('Parent',mnu, 'tag', 'IpmnuSaveas', 'Callback','appel(''sauversousfich'')', ...
         'Label',tt.filesaveas, 'Enable','off');
  % Exportation  (des données d'une courbe ds un fichier texte)
  uimenu('Parent',mnu, 'tag','IpmnuExportation', 'Label',tt.fileexport,...
         'Callback','appel(''exportdata'')', 'enable','off');
  % Écriture des résultats
  uimenu('Parent',mnu, 'tag', 'IpmnuEcritureResultats', 'Callback','appel(''resultats'')', ...
         'Enable','off', 'Label',tt.fileecritresult);
  % PRINT
  mmnu =uimenu('Parent',mnu, 'separator','on', 'Label',tt.fileprint);
  uimenu('Parent',mmnu, 'Callback','appel(''impression'',''copcol'')', 'Label',tt.fileprintcopiecoller);
  uimenu('Parent',mmnu, 'Callback','appel(''impression'',''jpeg'')', 'Label',tt.fileprintjpeg);
  uimenu('Parent',mmnu, 'Callback','appel(''impression'',''imprimer'')', 'Label',tt.fileprintimprimer);
  % FICHIERS RÉCENTS
  mmnu =uimenu('Parent',mnu, 'tag','FRmnu','separator','on', 'Label',tt.filedernierouvert);
  for U =1:OA.Fic.como
  	Elfich =num2str(U);
    uimenu('Parent',mmnu, 'Callback',['appel(''ouvfichrecent'',''analyse'',' Elfich ')'],...
           'tag','FRecent', 'Label',OA.Fic.recent{U});
  end
  % Préférences
  uimenu('Parent',mnu, 'Callback','appel(''lesPreferencias'')', 'Label',tt.filepreferences);
  % 'ARcommence'
  uimenu('Parent',mnu, 'Callback','appel(''redemarrer'')', 'separator','on', 'Label',tt.fileredemarrer);
  % TERMINUS
  uimenu('Parent',mnu, 'Callback','appel(''terminus'')', 'Label',tt.fileterminus);
% EDIT
  mnu =uimenu('Parent',elfig, 'tag','IpmnuEdit', 'Label',tt.edit, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.editmajcan, 'Callback','appel(''majcan'')');
  uimenu('Parent',mnu, 'Label',tt.editcanal, 'Callback','appel(''editcan'')');
  uimenu('Parent',mnu, 'Label',tt.editcopiecanal, 'Callback','appel(''copiecan'')');
  uimenu('Parent',mnu, 'Label',tt.editcatego, 'separator','on', 'Callback','appel(''EditCategorie'')');
  uimenu('Parent',mnu, 'Label',tt.editrebatircatego, 'Callback','appel(''RebatirCategorie'')');
  uimenu('Parent',mnu, 'Label',tt.editecheltemps, 'separator','on', 'Callback','appel(''EditEchelTps'')');
% MODIFIER
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuModifier', 'Label',tt.modif, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.modifsuppcan, 'Callback','appel(''supprimecan'')');
  uimenu('Parent',mnu, 'Label',tt.modifcorriger, 'Callback','appel(''corrige'')');
  uimenu('Parent',mnu, 'Label',tt.modifcouper, 'Callback','appel(''couper'')');
  uimenu('Parent',mnu, 'Label',tt.modifdecouper, 'Callback','appel(''decouper'')');
  uimenu('Parent',mnu, 'Label',tt.modifdecimate, 'Callback','appel(''decime'')');
  uimenu('Parent',mnu, 'Label',tt.modifrebase, 'Callback','appel(''rebase'')');
  uimenu('Parent',mnu, 'Label',tt.modifrotation, 'Callback','appel(''rotation'')');
  uimenu('Parent',mnu, 'Label',tt.modifsynchroess, 'Callback','appel(''syncess'')');
  uimenu('Parent',mnu, 'Label',tt.modifsynchrocan, 'Callback','appel(''synccan'')');
% MATH
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuMath', 'Label',tt.math, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'Label',tt.mathderivfil);
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilbutter, 'Callback','appel(''filtre'')');
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilsptool, 'Callback','appel(''sptoul'')');
  uimenu('Parent',mmnu, 'Label',tt.mathderivfildiffer, 'Callback','appel(''derive'')');
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilpolynom, 'Callback','appel(''moindre'')');
  uimenu('Parent',mnu, 'Label',tt.mathintdef, 'Callback','appel(''integr'')');
  uimenu('Parent',mnu, 'Label',tt.mathintcum, 'Callback','appel(''intcum'')');
  uimenu('Parent',mnu, 'Label',tt.mathnormal, 'Callback','appel(''normalise'')');
  uimenu('Parent',mnu, 'Label',tt.mathnormaltemp, 'Callback','appel(''normaltemps'')');
  uimenu('Parent',mnu, 'Label',tt.mathellipsconf, 'Callback','appel(''ellipse'')');
  uimenu('Parent',mnu, 'Label',tt.mathmoyectyp, 'Callback','appel(''moyectype'')');
  uimenu('Parent',mnu, 'Label',tt.mathmoyptmarq, 'Callback','appel(''moypoint'')');
  uimenu('Parent',mnu, 'Label',tt.mathpentedrtregr, 'Callback','appel(''droiteregress'')');
  uimenu('Parent',mnu, 'Label',tt.mathcalcang, 'Callback','appel(''angulo'')');
  uimenu('Parent',mnu, 'Label',tt.mathtraitcan, 'Callback','appel(''tretcanal'')');
% EMG
  mnu =uimenu('Parent',elfig, 'tag','IpmnuEmg', 'Label',tt.emg, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.emgrectif, 'Callback','appel(''Absolue'')');
  uimenu('Parent',mnu, 'Label',tt.emgliss, 'Callback','appel(''Lissage'')');
  uimenu('Parent',mnu, 'Label',tt.emgrms, 'Callback','appel(''Rootmeansquare'')');
  uimenu('Parent',mnu, 'Label',tt.emgmav, 'Callback','appel(''Emgmoyen'')');
  uimenu('Parent',mnu, 'Label',tt.emgffm, 'Callback','appel(''Trio'')');
  uimenu('Parent',mnu, 'Label',tt.emgnormal, 'Callback','appel(''Normalis'')');
  uimenu('Parent',mnu, 'Label',tt.emgintegsucc, 'Callback','appel(''Intesucc'')');
  uimenu('Parent',mnu, 'Label',tt.emgchgpolar, 'Callback','appel(''ZerosCrossing'')');
  uimenu('Parent',mnu, 'Label',tt.emgdistprbampl, 'Callback','appel(''Distrib'')');
% FPLT
  mnu =uimenu('Parent',elfig, 'tag','IpmnuFPlt', 'Label',tt.fplt, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'Label',tt.fpltcop);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparammanuel, 'Callback','appel(''CentreDePressionManuel'')');
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparamfichier, 'Callback','appel(''CentreDePressionFichier'')');
  mmnu =uimenu('Parent',mnu, 'Label',tt.fpltcopoptima);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparammanuel, 'Callback','appel(''COPoptimaManuel'')');
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparamfichier, 'Callback','appel(''COPoptimaFichier'')');
  uimenu('Parent',mnu, 'Label',tt.fpltstat4cop, 'Callback','appel(''statPourCOP'')');
% TRAJECTOIRE
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuTrajectoire', 'Label',tt.trajet, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.trajetgps, 'Callback','appel(''ProjetGPS'')','enable','on');
  uimenu('Parent',mnu, 'Label',tt.trajetgpsecef2lla, 'Callback','appel(''ecef2lla'')');
  uimenu('Parent',mnu, 'Label',tt.trajetecart, 'Callback','traitraject(''ecart'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdiffinterpt, 'Callback','traitraject(''difference'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdistparcour, 'Callback','appel(''DistParcourueXYZ'')','enable','on');
  uimenu('Parent',mnu, 'Label',tt.trajetamplmvt, 'Callback','traitraject(''amplimvt'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdirect, 'Callback','traitraject(''direction'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetcourb, 'Callback','traitraject(''courbur'')','enable','off'); % *****off
% OUTILS
  mnu =uimenu('Parent',elfig, 'tag','IpmnuOutils', 'Label',tt.ou, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'tag','IpmnuTemps', 'Label',tt.ouechtempo);
  uimenu('Parent',mmnu, 'callback','appel(''echeltmp'')', ...
         'tag','IpmnutempsNormal', 'checked','on', 'Label',tt.ouechtempodefaut);
  uimenu('Parent',mnu, 'Callback','appel(''importpt'')', 'Separator','on', 'Label',tt.ouimportpoint);
  uimenu('Parent',mnu, 'Callback','appel(''trierpt'')', 'Label',tt.outrierpt);
  uimenu('Parent',mnu, 'Callback','appel(''marquage'')', 'Label',tt.oumark);
  uimenu('parent',mnu,'tag','IpmnuZoom','Separator','on', 'Label',tt.ouzoom,'callback','appel(''zoomonoff'')');
  uimenu('parent',mnu,'tag','IpmnuCoord', 'Label',tt.ouaffichercoord,'callback','appel(''affichecoord'')');
  mmnu =uimenu('parent',mnu,'Label',tt.oucouleur);
  uimenu('Parent',mmnu, 'tag','IpmnuColcan', 'Callback','appel(''colore_canal'')',...
         'Label',tt.oucouleurcan);
  uimenu('Parent',mmnu, 'Label',tt.oucouleuress, 'tag','IpmnuColess', 'Callback','appel(''colore_essai'')');
  uimenu('Parent',mmnu, 'Label',tt.oucouleurcat, 'tag','IpmnuColcat',...
         'Callback','appel(''colore_categorie'')');
  uimenu('Parent',mnu, 'tag','IpmnuLegende', 'Label',tt.oulegend, ...
         'Callback','appel(''la_legende'')', 'Separator','on');
  uimenu('Parent',mnu, 'Label',tt.ouechant, 'tag','IpmnuSmpl',...
         'Callback','appel(''ligne_type'')');
  uimenu('Parent',mnu, 'Label',tt.ouptmarkatexte, 'tag','IpmnuPoint', ...
         'Callback','appel(''outil_point'')');
  uimenu('Parent',mnu, 'Label',tt.ouptmarkstexte, 'tag','IpmnuPointSansTexte', ...
         'Callback','appel(''AffichePointSansTexte'')');
  uimenu('Parent',mnu, 'Label',tt.ouaffprop, 'tag','Ipmnutrich',...
         'Callback','appel(''la_trich'')');
  uimenu('Parent',mnu, 'Label',tt.ouxy,'tag','IpmnuXy', 'Separator','on',...
         'Callback','appel(''modexy'')');
% QUEL FICHIER
  % menu dynamique en fonction des fichiers ouverts.
  mnu =uimenu('Parent',elfig, 'Label',tt.quelfichier, 'tag','QuelFichierMnu');
% AIDE
  mnu =uimenu('Parent',elfig, 'Label',tt.hlp);
  uimenu('Parent',mnu, 'Label',tt.hlpdoc, 'Enable','On', 'Callback','appel(''leweb'')');
  uimenu('Parent',mnu, 'Label',tt.hlplog, 'Callback','appel(''histoire'')');
  uimenu('Parent',mnu, 'Label',tt.hlplogbook, 'Callback','appel(''journalisation'')');
  uimenu('Parent',mnu, 'Label',tt.hlpabout, 'Callback','appel(''aidedoc'')');

  %
  % Octave 4.2 accepte mal 'DefaultFigureMenuBar','none' par défaut comme Matlab
  % Il faut au préalable définir un premier menu, puis enlever celui proposé par
  % la création d'une nouvelle figure.
  %
  lapos =get(elfig, 'position');
  set(elfig, 'menubar','none');
  pause(0.1);
  set(elfig, 'position',lapos);

end
