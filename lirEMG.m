%
% LECTURE DES FICHIERS EMG EN FORMAT .MAT
%
% Laboratoire GRAME
% MEK - Mars 2015
%
% lirEMG(CLirEMG)
%
% Bonne lecture!
%
function lirEMG(H)
  hA =CAnalyse.getInstance();
  Fan =H.Fich.Info;
  %________________________________________________________
  % Fabrication d'un fichier temporaire de travail (Unique)
  %
  [Va Vb Vc] =fileparts(H.fname{1});
  Fan.fitmp =fullfile(tempdir(), [Vb '.mat']);
  test =isempty(dir(Fan.fitmp));
  Inc =0;
  while ~test
    Fan.fich =[Vb num2str(Inc) '.mat'];
    Fan.fitmp =fullfile(tempdir(), Fan.fich);
    test =isempty(dir(Fan.fitmp));
    Inc =Inc+1;
  end
  [Va Vb Vc] =fileparts(Fan.fitmp);
  Fan.prenom =Va;
  Fan.finame =[Vb Vc];
  H.nbf =length(H.fname);
  %_______________________
  % Ouverture d'un WaitBar
  %-----------------------
  H.leWb =findall(0, 'type','figure', 'name','WBarLecture');
  TextLocal =[H.txtml.fichier H.fname{1}];
  delwb =false;
  if isempty(H.leWb)
    delwb =true;
    H.leWb =laWaitbar(0.001, TextLocal, 'G', 'C');
  else
    waitbar(0.001, H.leWb, TextLocal);
  end
  lectureBrute(H);
  lirMatEMG(H);
  Fan.fitmp =[];
  if delwb
    close(H.leWb);
  end
end

%______________________________________________
% Il peut y avoir plusieurs essais par fichier.
% Un fichier ou plusieurs fichiers.
%----------------------------------------------
function lirMatEMG(tO)
  hF =tO.Fich;
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;
  hVg.nst =0;
  hVg.sauve =0;
  hVg.nomstim ={};
  elnombre ={};
  % Lecture des noms de canaux
  for U =1:hVg.nad
    hHdchnl.cindx{U} =['c' num2str(U)];
    tt =findstr(tO.lescan{U}, ',');
    ccc =strtrim(tO.lescan{U});
    if isempty(tt)
      elnombre{end+1} =ccc;
    else
      elnombre{end+1} =[ccc(1:tt-1) '(' strtrim(ccc(tt+1:end)) ')'];
    end
  end
  hHdchnl.adname =elnombre;
  hHdchnl.sweeptime(hVg.nad,hVg.ess) =0;
  hHdchnl.rate(1:hVg.nad, 1:hVg.ess) =0;
  hHdchnl.nsmpls(hVg.nad,hVg.ess) =0;
  hHdchnl.max(hVg.nad,hVg.ess) =0;
  hHdchnl.min(hVg.nad,hVg.ess) =0;
  hHdchnl.npoints(hVg.nad,hVg.ess) =0;
  hHdchnl.point(hVg.nad,hVg.ess) =0;
  hHdchnl.frontcut(1:hVg.nad,1:hVg.ess) =0;
  hHdchnl.numstim(1:hVg.ess) =1;
  p.hdchnl =hHdchnl.databrut();
  p.vg =hVg.databrut();
  p.ptchnl =[];
  p.tpchnl =[];
  p.catego =[];
  p.autre =[];
  save(hF.Info.fitmp, '-Struct', 'p', '-Append');
  hT =tO.txtml;
  TextLocal =hT.concatinfo;
  waitbar(0.001, tO.leWb, TextLocal);
  for U =1:hVg.nad
    lesess =1;
    t_ou =single(U)/single(hVg.nad);
    waitbar(t_ou, tO.leWb, [TextLocal hT.canal num2str(U)]);
    for F =1:tO.nbf
      for V =1:tO.nbess(F)
        hHdchnl.rate(U,lesess) =tO.frq(F);
        hHdchnl.nsmpls(U,lesess) =tO.activ(V+1,F)-tO.activ(V,F);
        hHdchnl.sweeptime(U,lesess) =hHdchnl.nsmpls(U,lesess)/tO.frq(F);
        hHdchnl.comment{U,lesess} =[tO.fname{F} ':' elnombre{U} '//'];
        lesess =lesess+1;
      end %
    end
  end
  hVg.valeur =1;
  P.hdchnl =hHdchnl.databrut();
  P.vg =hVg.databrut();
  save(hF.Info.fitmp, '-Struct', 'P', '-Append');
end

function lectureBrute(tO)
  %______________________________________________________
  % Dans la première partie, on récupère les infos utiles
  % et on sort les canaux de la grosse cellule. Si il y a
  % plusieurs fichiers, on fait la même chose fichier par
  % fichier.
  %------------------------------------------------------
  vg =tO.Fich.Vg;
  tO.frq(tO.nbf) =0;
  tO.nbess(tO.nbf) =int32(0);
  %____________________________________________
  % On fait le tour des fichiers pour dénombrer
  % les essais à lire.
  %--------------------------------------------
  afaire =single(tO.nbf*vg.nad);
  rendu =single(1);
  for F =1:tO.nbf
    load(tO.fname{F}, 'noChans', 'Activities', 'length_sec', 'samplingRate', 'Data');
    tO.frq(F) =samplingRate;
    if length(Activities) == 1
      tO.nbess(F) =1;
      Activities =[0 length_sec];
    else
      tO.nbess(F) =length(Activities)-1;
    end
    tO.activ(1:tO.nbess(F)+1, F) =int64(Activities*samplingRate);
    %_________________________________
    % Vérification du nombre de canaux
    %---------------------------------
    if F == 1
      load(tO.fname{F}, 'channelNames');
      vg.nad =noChans;
      tO.lescan =channelNames;
      afaire(:) =tO.nbf*vg.nad;
    elseif ~(vg.nad == noChans)
      disp('Nombre de canaux inégal au travers des essais');
      return;
    end
    %___________________________
    % On fait le tour des canaux
    %---------------------------
    for U =1:vg.nad
      rendu(1) =(F-1)*vg.nad+U;
      waitbar(rendu/afaire, tO.leWb, [tO.fname{F} ': ' channelNames{U}]);
      %_____________________________________________________
      % On copy le canal pour sortir les datas de la cellule
      %-----------------------------------------------------
      s =Data{U};
      %__________________________________________________
      % On sauvegarde le canal dans un fichier temporaire
      %--------------------------------------------------
      curtmp =fichierTmp(F, U);
      save(curtmp, 's');
    end
    clear noChans Data Activities length_sec samplingRate;
  end
  %____________________________________________________________________
  % Maintenant que tous les canaux sont séparés, on va bâtir nos essais
  %
  % On détermine le nombre max de sample pour un canal(en regardant tous ses essais)
  %---------------------------------------------------------------------------------
  lemax =int32(0);
  vg.ess =0;
  for F =1:tO.nbf
    vg.ess =vg.ess+tO.nbess(F);
    for V =1:tO.nbess(F)
      if lemax < (tO.activ(V+1, F)-tO.activ(V, F))
        lemax(1) =tO.activ(V+1, F)-tO.activ(V, F);
      end
    end
  end
  %______________________________________
  % On va traiter les canaux un à la fois
  %--------------------------------------
  texto =tO.txtml.fairess;
  waitbar(0.001, tO.leWb, texto);
  eltempo =tO.Fich.Info.fitmp;     % fichier temporaire de travail
  foo =zeros(lemax, vg.ess);
  tO.col =vg.nad;
  afaire(1) =vg.nad*vg.ess;
  for U =1:vg.nad
    lesess =int32(1);
    for F =1:tO.nbf
      curtmp =fichierTmp(F, U);
      load(curtmp, 's');
      for V =1:tO.nbess(F)
        rendu(1) =int32(U-1)*int32(vg.ess)+lesess;
        waitbar(rendu/afaire, tO.leWb, [texto 'C-' num2str(U) ' E-' num2str(lesess)]);
        foo(1:tO.activ(V+1,F)-tO.activ(V,F), lesess) =s(tO.activ(V,F)+1:tO.activ(V+1,F));
        lesess(:) =lesess+1;
      end
      clear s;
      delete(curtmp);
    end
    d.(['c' num2str(U)]) =foo;
    foo(:) =0;
    %__________________________________________
    % On conserve les canaux séparés par essais
    %------------------------------------------
    laver ='-V7';
    test =fopen(eltempo);
    if test == -1
    	save(eltempo, '-Struct', 'd', laver);
    else
    	fclose(test);
    	save(eltempo, '-Struct', 'd', '-Append');
    end
  end
end

function cur =fichierTmp(numFich, mot)
  if nargin == 1 || isempty(mot)
    mot ='';
  end
  if isnumeric(mot)
    mot =num2str(mot);
  end
  if isnumeric(numFich)
    numFich =num2str(numFich);
  end
  cur =['~L_G__EmG_f' numFich '_c' mot '.mat'];
end