%
% Lecture des fichiers HDF5
% 
% Laboratoire GRAME
% MEK - Août 2012
%
% Permet de lire un ou des fichiers H5.
% Un essai par fichier
%
% http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
%
% Bonne lecture!
%
function CoK =lirHDF5(H)
  global A D G V MOT;
  %----------------------------------
  % CONSTANTES DES NOMS DE STRUCTURES
  A ='Attributes';
  D ='Datasets';
  G ='Groups';
  V ='Value';
  MOT ={'/Virtual Driver'; 'Corrected'};
  %-------------------------------------
  CoK =false;
  H.leWb =findall(0, 'type','figure', 'name','WBarLecture');
  hT =H.txtml;
  TextLocal =hT.h5wbarinfocan;
  delwb =false;
  if isempty(H.leWb)
    delwb =true;
    H.leWb =laWaitbar(0.001, TextLocal, 'G', 'C');
  else
    waitbar(0.001, H.leWb, TextLocal);
  end
  if ~lirEntete(H)
    if delwb
      close(H.leWb);
    end
    return;
  end
  waitbar(0.05, H.leWb);
  hF =H.Fich;
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;
  hVg.ess =H.nbf;
  hVg.nst =0;
  hVg.sauve =0;
  hVg.nomstim ={};
  %****LECTURE DES DATAS****
  hVg.nad =H.canTot;
  % Lecture des noms de canaux
  for U =1:hVg.nad
    hHdchnl.cindx{U} =['C' num2str(U)];
  end
  elnombre ={};
  for U =1:H.nad
    if H.sscan(U) == 3
      elnombre{end+1} =[H.lescan{U} ' Flexion-ext'];
      elnombre{end+1} =[H.lescan{U} ' Abduction'];
      elnombre{end+1} =[H.lescan{U} ' Rot int-ext'];
    else
      elnombre{end+1} =H.lescan{U};
    end
  end
  hHdchnl.adname =elnombre;
  hHdchnl.sweeptime(hVg.nad,hVg.ess) =0;
  for U =1:hVg.nad
    hHdchnl.rate(U, 1:hVg.ess) =H.frq;
  end
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
  valWB =0.1;
  waitbar(valWB, H.leWb);
  CANf =0;
  Dt =CDtchnl();
  for U =1:H.nad
    CANi =CANf+1;
    CANf =CANf+H.sscan(U);
    Text1 =[hT.canal H.lescan{U}];
    valWB =(1-valWB)/(H.nad-U+1)+valWB;
    waitbar(valWB, H.leWb, Text1);
    % Initialisation de la matrice des datas pour la lecture
    smpls =max(H.nsmpl(U, :));
    dtchnl =zeros(smpls, hVg.ess, H.sscan(U));
    for Z =1:H.nbf
      waitbar(valWB, H.leWb, [Text1 ' -->' hT.fichier H.fname{Z}]);
      laMat =getData(H, Z, U);
      P =size(laMat);
      dtchnl(1:P(1), Z, 1:P(2)) =permute(laMat, [1 3 2]);
      for j =CANi:CANf        % boucle pour passer les sous-canaux
        hHdchnl.sweeptime(j, Z) =P(1)/H.frq(Z);
        hHdchnl.nsmpls(j, Z) =P(1);
        hHdchnl.comment{j, Z} =[H.fname{Z} ':' elnombre{j} '//'];
      end  % for j =CANi:CANf
    end  % for Z =1:H.nbf
    for j =CANi:CANf
      H.sauveCanal(dtchnl(:, :, j-CANi+1), Dt, j);
      %sauvelessai(dtchnl(:, :, j-CANi+1), Dt, H, j);
    end
    dtchnl =[];
  end  % for U =1:H.nad
  if delwb
    close(H.leWb);
  end
  hVg.valeur =1;
  PPP.hdchnl =hHdchnl.databrut();
  PPP.vg =hVg.databrut();
  save(hF.Info.fitmp, '-Struct', 'PPP', '-Append');
  delete(Dt);
  hF.Info.fitmp =[];
  CoK =true;
  clear global A D G V MOT;
end

%
% On va extraire les info utiles des fichiers
% pour pouvoir placer les bonnes infos aux bonnes places
%
function FOO =lirEntete(tO)
  global A D G V MOT;
  FOO =false;
  tO.frq(tO.nbf) =0;
  Fstat =false;
  % OUVERTURE DE CHACUN DES FICHIERS
  for U =1:tO.nbf
    ccc =hdf5info(tO.fname{U});
    H =ccc.GroupHierarchy.(G);
    % INFO FRÉQUENCE
    if strcmp(H(1).(G)(1).(A).Shortname, 'Frequency')
      NN =length(H(1).(G));  % nb de senseur
      tO.frq(U) =H(1).(G)(1).(A).Value;
      for BB =2:NN
        if ~(tO.frq(U) == H(1).(G)(BB).(A).Value)
          Fstat =true;
        end
      end
    end
    M =1;
    ss =true;
    while M <= length(H)              % '/Virtual Driver'
      if strcmp(H(M).Name, MOT{1})
        ss =false;
        break;
      end
      M =M+1;
    end
    if ss
      return;
    end
    Exp =H(M).(G).(G);
    M =1;
    ss =true;
    while M <= length(Exp)                % 'Corrected'
      bueno =strfind(Exp(M).Name, MOT{2});
      if ~isempty(bueno) & (length(Exp(M).Name)-length(MOT{2})+1 == bueno)
        ss =false;
        break;
      end
      M =M+1;
    end
    if ss
      return;
    end
    Can =Exp(M).(G);
    if U == 1
      tO.nad =length(Can);
      tO.sscan =zeros(tO.nad);
      for Q =1:tO.nad
        tO.lescan{Q} =CualEsTuNombre(Can(Q).Name);
        tO.sscan(Q) =Can(Q).(D).Dims(1);
      end
      tO.nsmpl =zeros(tO.nad, tO.nbf);
    end
    for Q =1:tO.nad
      tO.nsmpl(Q, U) =Can(Q).(D).Dims(2);
    end
  end
  tO.canTot =sum(tO.sscan(:));
  if Fstat
    warndlg('les senseurs ne sont pas tous à la même fréquence', 'ATTenTION');
  end
  FOO =true;
end

%
% Retourne le nom du canal (Ex.  /I2M Driver/SI-000793/Corrected/Accelerometers
%                                retournera:  Accelerometers)
%
function SS =CualEsTuNombre(M)
  SS =[];
  a =strfind(M, '/');
  if isempty(a)
    return;
  end
  SS =M(a(end)+1:end);
end

%
% Lecture des échantillons du canal Can du fichier Fich
%
function K =getData(tO, Fich, Can)
  global A D G V MOT;
  ccc =hdf5info(tO.fname{Fich});
  H =ccc.GroupHierarchy.(G);
  M =1;
  while M <= length(H)              % '/Virtual Driver'
    if strcmp(H(M).Name, MOT{1})
      break;
    end
    M =M+1;
  end
  Exp =H(M).(G).(G);
  M =1;
  while M <= length(Exp)                % 'Corrected'
    bueno =strfind(Exp(M).Name, MOT{2});
    if ~isempty(bueno) & (length(Exp(M).Name)-length(MOT{2})+1 == bueno)
      break;
    end
    M =M+1;
  end
  C =Exp(M).(G)(Can);
  K =hdf5read(C.(D))';
end

function sauvelessai(datos, hDt, hO, Creel)
  % Si on a des "NAN" dans la matrice, on les met à zéro
  datos(isnan(datos)) =0;
  hO.Fich.getcanal(hDt, Creel);
  hDt.Dato.(hDt.Nom) =datos;
  hO.Fich.setcanal(hDt, Creel);
end
