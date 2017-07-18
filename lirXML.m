%
% Lecture des fichiers XML pour Auto21
% 
% Laboratoire GRAME
% MEK - Mars 2012
%
% Permet de lire un ou des fichiers XML.
%
% En entrée, on aura un objet du type: CLirA21XML
%
% Bonne lecture!
%
function lirXML(H)
  if ishandle(H.Fig)
    delete(H.Fig);
    pause(0.1);
  end
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
  lirtextXML(H);
  Fan.fitmp =[];
end

%__________________________________________
% Les essais sont dans des fichiers séparés
%
function lirtextXML(tO)
  hF =tO.Fich;
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;
  hVg.ess =tO.nbf;
  hVg.nst =0;
  hVg.sauve =0;
  hVg.nomstim ={};
  %****LECTURE DES DATAS****
  G =CStrucA21XML();

  K =CParamGlobal.getInstance();
  if K.matlab
    % Matlab permet l'utilisation de la commande "properties"
    elnombre =getProp(G);
  else
    % Octave ne le permet pas
    elnombre =fieldnames(G);
  end

  delete(G);
  hVg.nad =length(elnombre);
  tO.col =hVg.nad;
  % Lecture des noms de canaux
  for U =1:hVg.nad
    hHdchnl.cindx{U} =['C' num2str(U)];
  end
  hHdchnl.adname =elnombre;
  hHdchnl.sweeptime(hVg.nad,hVg.ess) =0;
  hHdchnl.rate(1:hVg.nad, 1:hVg.ess) =tO.frq;
  hHdchnl.nsmpls(hVg.nad,hVg.ess) =0;
  hHdchnl.max(hVg.nad,hVg.ess) =0;
  hHdchnl.min(hVg.nad,hVg.ess) =0;
  hHdchnl.npoints(hVg.nad,hVg.ess) =0;
  hHdchnl.point(hVg.nad,hVg.ess) =0;
  hHdchnl.frontcut(1:hVg.nad,1:hVg.ess) =0;
  hHdchnl.numstim(1:hVg.ess) =1;
  hdchnl =hHdchnl.databrut();
  vg =hVg.databrut();
  laver ='-V7';
  ptchnl =[];
  tpchnl =[];
  catego =[];
  autre =[];
  save(hF.Info.fitmp, 'vg','hdchnl','ptchnl','tpchnl','catego','autre', laver);
  % Initialisation de la matrice des datas pour la lecture
  smpls =MaxSmp(tO);
  dtchnl(smpls, hVg.nad) =0;
  Dt =CDtchnl();
  tranche =1;
  transh =1;
  % Appel/création d'une waitbar
  tO.leWb =findall(0, 'type','figure', 'name','WBarLecture');
  hT =tO.txtml;
  TextLocal =[hT.fichier tO.fname{1}];
  delwb =false;
  if isempty(tO.leWb)
    delwb =true;
    tO.leWb =laWaitbar(0.001, TextLocal, 'G', 'C');
  else
    waitbar(0.001, tO.leWb, TextLocal);
  end
  for Z =1:tO.nbf
    waitbar(0.001, tO.leWb, [TextLocal tO.fname{Z}]);
    tO.Fid =fopen(tO.fname{Z}, 'r');
    % on se place au début des données à lire
    tO.laStr =Cherche(tO, '<Données ');
    if isempty(tO.laStr)
      fclose(tO.Fid);
      continue;
    end
    tO.lemax =str2double(getValeur(tO, 'NbDonnées'));
    tO.iindx =0;
    suivante(tO);
    while tO.iindx <= tO.lemax
      dtchnl(tO.iindx, 1) =str2double(getValeur(tO, 'FrameNum='));
      dtchnl(tO.iindx, 2) =datenum(getValeur(tO, 'Date'));
      dtchnl(tO.iindx, 3) =HeureMin2sec(getValeur(tO, 'Heure'));
      dtchnl(tO.iindx, 4) =str2double(getValeur(tO, 'TempsPC='));
      foo =getValeur(tO, 'Type=');
      switch foo
      case 'UBX'
        dtchnl(tO.iindx, 5) =1;
      case 'SPV'
        dtchnl(tO.iindx, 5) =2;
      case 'SPT'
        dtchnl(tO.iindx, 5) =3;
      case 'STV'
        dtchnl(tO.iindx, 5) =4;
      otherwise
        dtchnl(tO.iindx, 5) =5;
      end
      dtchnl(tO.iindx, 6) =str2double(getValeur(tO, 'Latitude='));
      dtchnl(tO.iindx, 7) =str2double(getValeur(tO, 'Longitude='));
      dtchnl(tO.iindx, 8) =str2double(getValeur(tO, 'AltitudeMSL='));
      dtchnl(tO.iindx, 9) =str2double(getValeur(tO, 'GeoidSep='));
      dtchnl(tO.iindx, 10) =str2double(getValeur(tO, 'HAcc='));
      dtchnl(tO.iindx, 11) =str2double(getValeur(tO, 'VAcc='));
      dtchnl(tO.iindx, 12) =str2double(getValeur(tO, 'Vitesse3D='));
      dtchnl(tO.iindx, 13) =str2double(getValeur(tO, 'VitesseN='));
      dtchnl(tO.iindx, 14) =str2double(getValeur(tO, 'VitesseE='));
      dtchnl(tO.iindx, 15) =str2double(getValeur(tO, 'VitesseD='));
      dtchnl(tO.iindx, 16) =str2double(getValeur(tO, 'Vitesse='));
      dtchnl(tO.iindx, 17) =str2double(getValeur(tO, 'Cap='));
      dtchnl(tO.iindx, 18) =str2double(getValeur(tO, 'MTMZone='));
      dtchnl(tO.iindx, 19) =str2double(getValeur(tO, 'MTMEasting='));
      dtchnl(tO.iindx, 20) =str2double(getValeur(tO, 'MTMNorthing='));
      dtchnl(tO.iindx, 21) =str2double(getValeur(tO, 'ECEFx='));
      dtchnl(tO.iindx, 22) =str2double(getValeur(tO, 'ECEFy='));
      dtchnl(tO.iindx, 23) =str2double(getValeur(tO, 'ECEFz='));
      dtchnl(tO.iindx, 24) =str2double(getValeur(tO, 'PAcc='));
      dtchnl(tO.iindx, 25) =str2double(getValeur(tO, 'ECEFvx='));
      dtchnl(tO.iindx, 26) =str2double(getValeur(tO, 'ECEFvy='));
      dtchnl(tO.iindx, 27) =str2double(getValeur(tO, 'ECEFvz='));
      dtchnl(tO.iindx, 28) =str2double(getValeur(tO, 'SAcc='));
      suivante(tO);
    end
    for j =1:tO.col  % boucle pour lire les canaux
      hHdchnl.sweeptime(j,tranche) =tO.lemax/tO.frq;
      hHdchnl.nsmpls(j,tranche) =tO.lemax;
      hHdchnl.comment{j,tranche} =[tO.fname{Z} ':' elnombre{j} '//'];
    end % for j =1:tO.col
    tO.sauveEssai(dtchnl, Dt, tranche);
    %sauvelessai(dtchnl, Dt, tO, tranche);
    dtchnl(:) =0;
    tranche =tranche+1;
    fclose(tO.Fid);
  end
  if delwb
    close(tO.leWb);
  end
  hVg.ess =tranche-1;
  hVg.valeur =1;
  P.hdchnl =hHdchnl.databrut();
  P.vg =hVg.databrut();
  save(hF.Info.fitmp, '-Struct', 'P', '-Append');
  delete(Dt);
end

%
% Trouve le nombre max d'échantillon à lire
%
function V =MaxSmp(H)
  V =0;
  M ='<Données ';
  for U =1:H.nbf
    H.Fid =fopen(H.fname{U}, 'r');
    if H.Fid == -1
      continue;
    end
    H.laStr =Cherche(H, M);
    if isempty(H.laStr)
      fclose(H.Fid);
      continue;
    end
    P =str2double(getValeur(H, 'NbDonnées'));
    if ~isnan(P) & V < P
      V =P;
    end
    fclose(H.Fid);
  end
end

function K =Cherche(F, Palabra)
  K =[];
  ligne =LirSuivante(F);
  while ligne ~= -1
    if strncmpi(ligne, Palabra, length(Palabra))
      K =ligne;
      break;
    end
    ligne =LirSuivante(F);
  end
end

function P =getValeur(H, Palabra)
  P =[];
  a =findstr(H.laStr, Palabra);
  if isempty(a)
    return;
  end
  T =length(H.laStr);
  a =a+length(Palabra);
  deb =0;
  fin =0;
  while a < T
    if H.laStr(a) == '"'
      deb =a+1;
      break;
    end
    a =a+1;
  end
  a =a+1;
  while a < T
    if H.laStr(a) == '"'
      fin =a-1;
      break;
    end
    a =a+1;
  end
  if deb & fin
    P =H.laStr(deb:fin);
  end
end

function li =LirSuivante(ff)
  li =fgetl(ff.Fid);
  if ~(li == -1)
    li =strtrim(li);
  end
end

function suivante(ff)
  ff.laStr =fgetl(ff.Fid);
  if ff.laStr == -1
    return
  end
  ff.laStr =strtrim(ff.laStr);
  waitbar(ff.iindx/ff.lemax, ff.leWb);
  ff.iindx =ff.iindx+1;
end

%
% on change l'heure en format texte HH:MM:SS.ss --> SS.ss
%
function V =HeureMin2sec(T);
  V =0;
  S =findstr(T, ':');
  if length(S) == 2
    H =str2num(T(1:S(1)-1))*3600;
    M =str2num(T(S(1)+1:S(2)-1))*60;
    V =str2num(T(S(2)+1:end))+H+M;
  end
end