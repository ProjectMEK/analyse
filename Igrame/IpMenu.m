%
% CR�ATION DES MENUS DE L'INTERFACE (GUI) PRINCIPALE
function IpMenu(obj)
%#function mnouvre, wimprime, wedit, wcpcan, wgroupdata, traitraject, wtoul, waide
% �DITION DES MENUS: dlg.mnuip
  OA =CAnalyse.getInstance();
  GM =OA.Gmenu;
  elfig =obj.fig;

  % on lit la structure contenant le texte � afficher selon le choix de la langue
  tt =CMenuMLIp();

% FICHIER
  mnu = uimenu('Parent',elfig, 'tag','IpmnuFichier', 'Label',tt.file);
  % OUVRIR
  uimenu('Parent',mnu, 'Callback','mnouvre(CFichEnum.analyse,false)', 'Label',tt.fileouvrir);
  % OUVRIR AUTRES
  mmnu = uimenu('Parent',mnu, 'Label',tt.fileouvrirot, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','mnouvre(CFichEnum.Texte, false)', 'Label',tt.fileouvrirottxt);
  uimenu('Parent',mmnu, 'Callback','mnouvre(CFichEnum.A21XML, false)', 'Label',tt.fileouvrirotauto21, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','mnouvre(CFichEnum.HDF5, false)', 'Label',tt.fileouvriroti2m, 'enable','on');
  uimenu('Parent',mmnu, 'Callback','mnouvre(CFichEnum.EMG, false)', 'Label',tt.fileouvrirotemg, 'Enable','on');
  uimenu('Parent',mmnu, 'Callback','mnouvre(CFichEnum.Keithley, false)', 'Label',tt.fileouvrirotkeit, 'Enable','on');
  % AJOUTER
  uimenu('Parent',mnu, 'tag', 'IpmnuAjouter', 'Label',tt.fileajout, 'Callback',@GM.wajout, 'enable','off');
  % BATCH
  uimenu('Parent',mnu, 'tag', 'IpmnuBatch', 'Label',tt.filebatch, ...
         'Callback','wbatch', 'Enable','off');
  % FERMER
  uimenu('Parent',mnu, 'tag', 'IpmnuFermer', 'Callback',@OA.fermerfich, ...
         'Label',tt.filefermer, 'Enable','off');
  % Sauvegarder
  uimenu('Parent',mnu, 'tag', 'IpmnuSave', 'Callback',@OA.sauverfich, ...
         'separator','on', 'Label',tt.filesave, 'Enable','off');
  % Sauvegarder sous
  uimenu('Parent',mnu, 'tag', 'IpmnuSaveas', 'Callback',@OA.sauversousfich, ...
         'Label',tt.filesaveas, 'Enable','off');
  % Exportation
  uimenu('Parent',mnu, 'tag','IpmnuExportation', 'Label',tt.fileexport,...
         'Callback',@GM.Exportation, 'enable','off');
  % �criture des r�sultats
  uimenu('Parent',mnu, 'tag', 'IpmnuEcritureResultats', 'Callback',@GM.EcritResultat, ...
         'Enable','off', 'Label',tt.fileecritresult);
  % PRINT
  mmnu =uimenu('Parent',mnu, 'separator','on', 'Label',tt.fileprint);
  uimenu('Parent',mmnu, 'Callback','wimprime(''copcol'')', 'Label',tt.fileprintcopiecoller);
  uimenu('Parent',mmnu, 'Callback','wimprime(''jpeg'')', 'Label',tt.fileprintjpeg);
  uimenu('Parent',mmnu, 'Callback','wimprime(''imprimer'')', 'Label',tt.fileprintimprimer);
  % FICHIERS R�CENTS
  mmnu =uimenu('Parent',mnu, 'tag','FRmnu','separator','on', 'Label',tt.filedernierouvert);
  for U =1:OA.Fic.como
  	Elfich =num2str(U);
    uimenu('Parent',mmnu, 'Callback',['mnouvre(CFichEnum.analyse,' Elfich ')'],...
           'tag','FRecent', 'Label',OA.Fic.recent{U});
  end
  % Pr�f�rences
  uimenu('Parent',mnu, 'Callback',@GM.lesPreferencias, 'Label',tt.filepreferences);
  % 'arcommence'
  uimenu('Parent',mnu, 'Callback','grame(''arcommence'')', 'separator','on', 'Label',tt.fileredemarrer);
  % TERMINUS
  uimenu('Parent',mnu, 'Callback','grame(''terminus'')', 'Label',tt.fileterminus);
% EDIT
  mnu =uimenu('Parent',elfig, 'tag','IpmnuEdit', 'Label',tt.edit, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.editcanal, 'Callback','wedit');
  uimenu('Parent',mnu, 'Label',tt.editcopiecanal, 'Callback','wcpcan');
  uimenu('Parent',mnu, 'Label',tt.editdatautil, 'Callback','wgroupdata','visible','off'); %***OFF
  uimenu('Parent',mnu, 'Label',tt.editcatego, 'separator','on', 'Callback',@GM.EditCategorie);
  uimenu('Parent',mnu, 'Label',tt.editrebatircatego, 'Callback',@GM.RebatirCategorie);
  uimenu('Parent',mnu, 'Label',tt.editecheltemps, 'separator','on', 'Callback',@GM.EditEchelTps);
% MODIFIER
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuModifier', 'Label',tt.modif, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.modifcorriger, 'Callback',@GM.corrige);
  uimenu('Parent',mnu, 'Label',tt.modifcouper, 'Callback',@GM.couper);
  uimenu('Parent',mnu, 'Label',tt.modifdecouper, 'Callback',@GM.decouper);
  uimenu('Parent',mnu, 'Label',tt.modifdecimate, 'Callback',@GM.decime);
  uimenu('Parent',mnu, 'Label',tt.modifrebase, 'Callback',@GM.rebase);
  uimenu('Parent',mnu, 'Label',tt.modifrotation, 'Callback',@GM.rotation);
  uimenu('Parent',mnu, 'Label',tt.modifsynchroess, 'Callback',@GM.synchro);
  uimenu('Parent',mnu, 'Label',tt.modifsynchrocan, 'Callback',@GM.synchrocan);
% MATH
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuMath', 'Label',tt.math, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'Label',tt.mathderivfil);
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilbutter, 'Callback',@GM.filtre);
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilsptool, 'Callback',@GM.sptoul);
  uimenu('Parent',mmnu, 'Label',tt.mathderivfildiffer, 'Callback',@GM.derive);
  uimenu('Parent',mmnu, 'Label',tt.mathderivfilpolynom, 'Callback',@GM.moindre);
  uimenu('Parent',mnu, 'Label',tt.mathintdef, 'Callback',@GM.integr);
  uimenu('Parent',mnu, 'Label',tt.mathintcum, 'Callback',@GM.intcum);
  uimenu('Parent',mnu, 'Label',tt.mathnormal, 'Callback',@GM.normalise);
  uimenu('Parent',mnu, 'Label',tt.mathnormaltemp, 'Callback',@GM.normaltemps);
  uimenu('Parent',mnu, 'Label',tt.mathellipsconf, 'Callback',@GM.ellipse);
  uimenu('Parent',mnu, 'Label',tt.mathmoyectyp, 'Callback',@GM.moyectype);
  uimenu('Parent',mnu, 'Label',tt.mathcalcang, 'Callback',@GM.angulo);
  uimenu('Parent',mnu, 'Label',tt.mathtraitcan, 'Callback',@GM.tretcanal);
% EMG
  mnu =uimenu('Parent',elfig, 'tag','IpmnuEmg', 'Label',tt.emg, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.emgrectif, 'Callback',@GM.Absolue);
  uimenu('Parent',mnu, 'Label',tt.emgliss, 'Callback',@GM.Lissage);
  uimenu('Parent',mnu, 'Label',tt.emgrms, 'Callback',@GM.Rootmeansquare);
  uimenu('Parent',mnu, 'Label',tt.emgmav, 'Callback',@GM.Emgmoyen);
  uimenu('Parent',mnu, 'Label',tt.emgffm, 'Callback',@GM.Trio);
  uimenu('Parent',mnu, 'Label',tt.emgnormal, 'Callback',@GM.Normalis);
  uimenu('Parent',mnu, 'Label',tt.emgintegsucc, 'Callback',@GM.Intesucc);
  uimenu('Parent',mnu, 'Label',tt.emgchgpolar, 'Callback',@GM.ZerosCrossing);
  uimenu('Parent',mnu, 'Label',tt.emgdistprbampl, 'Callback',@GM.Distrib);
% FPLT
  mnu =uimenu('Parent',elfig, 'tag','IpmnuFPlt', 'Label',tt.fplt, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'Label',tt.fpltcop);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparammanuel, 'Callback',@GM.CentreDePressionManuel);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparamfichier, 'Callback',@GM.CentreDePressionFichier);
  mmnu =uimenu('Parent',mnu, 'Label',tt.fpltcopoptima);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparammanuel, 'Callback',@GM.COPoptimaManuel);
  uimenu('Parent',mmnu, 'Label',tt.fpltcopparamfichier, 'Callback',@GM.COPoptimaFichier);
  uimenu('Parent',mnu, 'Label',tt.fpltstat4cop, 'Callback',@GM.statPourCOP);
% TRAJECTOIRE
  mnu =uimenu('Parent',elfig, 'tag', 'IpmnuTrajectoire', 'Label',tt.trajet, 'Enable','off');
  uimenu('Parent',mnu, 'Label',tt.trajetgps, 'Callback',@GM.ProjetGPS,'enable','on');
  uimenu('Parent',mnu, 'Label',tt.trajetgpsecef2lla, 'Callback',@GM.ecef2lla);
  uimenu('Parent',mnu, 'Label',tt.trajetecart, 'Callback','traitraject(''ecart'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdiffinterpt, 'Callback','traitraject(''difference'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdistparcour, 'Callback',@GM.DistParcourueXYZ,'enable','on');
  uimenu('Parent',mnu, 'Label',tt.trajetamplmvt, 'Callback','traitraject(''amplimvt'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetdirect, 'Callback','traitraject(''direction'')','enable','off'); % *****off
  uimenu('Parent',mnu, 'Label',tt.trajetcourb, 'Callback','traitraject(''courbur'')','enable','off'); % *****off
% OUTILS
  mnu =uimenu('Parent',elfig, 'tag','IpmnuOutils', 'Label',tt.ou, 'Enable','off');
  mmnu =uimenu('Parent',mnu, 'tag','IpmnuTemps', 'Label',tt.ouechtempo);
  uimenu('Parent',mmnu, 'callback',@GM.echeltmp,...
         'tag','IpmnutempsNormal', 'checked','on', 'Label',tt.ouechtempodefaut);
  uimenu('Parent',mnu, 'tag','IpmnuFig', 'callback','wtoul(''letinew'')', 'Label',tt.ouajoutaxe,'enable','off'); % *****off
  uimenu('Parent',mnu, 'Callback',@GM.importpt, 'Separator','on', 'Label',tt.ouimportpoint);
  uimenu('Parent',mnu, 'Callback',@GM.marquage, 'Label',tt.oumark);
  uimenu('parent',mnu,'tag','IpmnuZoom','Separator','on', 'Label',tt.ouzoom,'callback','wtoul(''zoomonoff'')');
  uimenu('parent',mnu,'tag','IpmnuCoord', 'Label',tt.ouaffichercoord,'callback','wtoul(''affichecoord'')');
  mmnu =uimenu('parent',mnu,'Label',tt.oucouleur);
  uimenu('Parent',mmnu, 'tag','IpmnuColcan', 'Callback','wtoul(''colore_canal'')',...
         'Label',tt.oucouleurcan);
  uimenu('Parent',mmnu, 'Label',tt.oucouleuress, 'tag','IpmnuColess', 'Callback','wtoul(''colore_essai'')');
  uimenu('Parent',mmnu, 'Label',tt.oucouleurcat, 'tag','IpmnuColcat',...
         'Callback','wtoul(''colore_categorie'')');
  uimenu('Parent',mnu, 'tag','IpmnuLegende', 'Label',tt.oulegend, ...
         'Callback','wtoul(''la_legende'')', 'Separator','on');
  uimenu('Parent',mnu, 'Label',tt.ouechant, 'tag','IpmnuSmpl',...
         'Callback','wtoul(''ligne_type'')');
  uimenu('Parent',mnu, 'Label',tt.ouptmarkatexte, 'tag','IpmnuPoint', ...
         'Callback','wtoul(''outil_point'')');
  uimenu('Parent',mnu, 'Label',tt.ouptmarkstexte, 'tag','IpmnuPointSansTexte', ...
         'Callback','wtoul(''AffichePointSansTexte'')');
  uimenu('Parent',mnu, 'Label',tt.ouaffprop, 'tag','Ipmnutrich',...
         'Callback','wtoul(''la_trich'')');
  uimenu('Parent',mnu, 'Label',tt.ouxy,'tag','IpmnuXy', 'Separator','on',...
         'Callback','wtoul(''modexy'')');
% QUEL FICHIER
  mnu =uimenu('Parent',elfig, 'Label',tt.quelfichier, 'tag','QuelFichierMnu');
% AIDE
  mnu =uimenu('Parent',elfig, 'Label',tt.hlp);
  uimenu('Parent',mnu, 'Label',tt.hlpdoc, 'Enable','On', 'Callback','waide(''leweb'')');
  uimenu('Parent',mnu, 'Label',tt.hlplog, 'Callback','waide(''histoire'')');
  uimenu('Parent',mnu, 'Label',tt.hlpabout, 'Callback','waide');
  uimenu('Parent',mnu, 'Label',tt.hlprecup, 'Callback',@OA.recuperer, 'Separator','on');
end
