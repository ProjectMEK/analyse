%
% Lecture des fichiers textes délimités
% 
% Laboratoire GRAME
% MEK - Juillet 2000
%
% Est appelé par une instance de  CLirTexte() et le GUI en cause est
% décrit dans le fichier GUILirTexte.m
%
% Permet de lire un ou des fichiers textes délimités.
%
% Parmi les champs de l'interface à remplir, il faut donner le
% nombre de canaux, le nombre d'essais par fichier (si on a qu'un
% seul essai par fichier, on laisse le champ à 1). De plus, si on
% a plus d'un essai par fichier, il faut donner le nombre de lignes
% par essai (autrement on laisse ce champ à 0). Le champ
% "Seconde coupées au début" est le frontcut habituel. Pour terminer,
% il faut faire le bon choix de délimiteur.
%
% Bonne lecture!
%
function lirtext(ltx);
  var =strtrim(get(findobj('tag','NomdeFichier'),'String'));  % nom de fichier
  vartmp =get(findobj('tag','MultiFichier'),'String');
  if ~strncmp(vartmp{1}, '---', 3)
  	ltx.nbf =length(vartmp);
  else
    return;
  end
  hA =CAnalyse.getInstance();
  [Va Vb Vc] =fileparts(vartmp{1});
  ltx.Fich.Info.fitmp =fullfile(tempdir(), [Vb '.mat']);
  test =isempty(dir(ltx.Fich.Info.fitmp));
  Inc =0;
  while ~test
    ltx.Fich.Info.fich =[Vb num2str(Inc) '.mat'];
    ltx.Fich.Info.fitmp =fullfile(tempdir(), ltx.Fich.Info.fich);
    test =isempty(dir(ltx.Fich.Info.fitmp));
    Inc =Inc+1;
  end
  [Va Vb Vc] =fileparts(ltx.Fich.Info.fitmp);
  ltx.Fich.Info.prenom =Va;
  ltx.Fich.Info.finame =[Vb Vc];
  for U =1:ltx.nbf
  	nom(U).name =vartmp{U};
  	rrr =dir(vartmp{U});
  	nom(U).bytes =rrr(1).bytes;
  end
  ltx.horvert =get(findobj('tag','toggleModEss'),'value');
  ltx.iscol1 =get(findobj('tag','elprimero'),'value');
  ltx.nbess =str2num(get(findobj('tag','NombreEssFich'),'String'));   % nb ess/fich
  ltx.fcut =str2num(get(findobj('tag','ElCorte'),'String'));    % frontcut
  ltx.col =str2num(get(findobj('tag','NumerodeCanales'),'String'));     % NAD
  ltx.lpe =str2num(get(findobj('tag','NombredeLignes'),'String'));    % lignes/essai
  ltx.frq =str2num(get(findobj('tag','ElFrecuencia'),'String'));    % fréquence d'échantill.
  delimit(ltx);                                   % délimiteur
  ltx.nlnom =str2num(get(findobj('tag','ElLineaNombre'),'string')); % no ligne des noms de canaux
  ltx.nle =str2num(get(findobj('tag','NbdeLigneEntete'),'String'));    % Nb de lignes d'entête au début du fichier
  ltx.nlepe =str2num(get(findobj('tag','NbdeLigneEnteteEss'),'String'));  % nb de lignes d'entête au début de chaques essais
  if ltx.horvert
    lirtexthoriz(nom,ltx);
  else
    lirtextverti(nom,ltx);
  end
  ltx.Fich.Info.fitmp =[];
  tii =findobj('tag','AnomalieTexte');
  if ~isempty(tii)
  	figure(tii);
  end
end

function [leretour] = sortdir(fnom)
  leretour =fnom;
  enordre =cell(size(fnom,1),1);
  for U =1:size(fnom,1)
    enordre{U} = upper(fnom(U).name);
  end
  [enordre,lindex] = sort(enordre);
  for i=1:size(fnom,1)
    leretour(i).name = fnom(lindex(i)).name;
    leretour(i).bytes = fnom(lindex(i)).bytes;
  end
end

function delimit(ltx)
  delimitador =[',;' char(32) char(9)];  % Virgule, Point virgule, Espace, tab
  ltx.delim =delimitador(get(findobj('tag','ElDelimitador'),'Value'));
end

%-------------------------------------------------------------------------------
% Les essais sont un au dessus de l'autre
% ou dans des fichiers séparés
%-------------------------------------------------------------------------------
function lirtextverti(fnom,tO)
  hF =tO.Fich;
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;
  if tO.nbess == 0  % pour éviter les erreurs d'incompréhension
  	tO.nbess =1;
  end;
  hVg.ess =tO.nbf*tO.nbess;
  hVg.nst =0;
  hVg.sauve =0;
  hVg.nomstim ={};
  %****LECTURE DES DATAS****
  hVg.nad =tO.col;
  % Lecture des noms de canaux
  if tO.nle && tO.nlnom && (tO.nle >= tO.nlnom)
    fid = fopen(fnom(1).name, 'r');
    if fid == -1
      return;
    end
    for U =1:tO.nlnom
      lobuena =fgetl(fid);
    end;
    fclose(fid);
    ptmp =find(lobuena == tO.delim);
    ptmp =[0 ptmp length(lobuena)];
  	for U =1:tO.col
  		elnombre{U} =lobuena(ptmp(U)+1:ptmp(U+1)-1);
  		hHdchnl.cindx{U} =['C' num2str(U)];
  	end
  else
  	for U =1:tO.col
  		elnombre{U} =['canal ', num2str(U)];
  		hHdchnl.cindx{U} =['C' num2str(U)];
  	end
  end
  hHdchnl.adname =elnombre;
  hHdchnl.sweeptime(hVg.nad,hVg.ess) =0;
  hHdchnl.rate(1:hVg.nad, 1:hVg.ess) =tO.frq;
  hHdchnl.nsmpls(hVg.nad,hVg.ess) =0;
  hHdchnl.max(hVg.nad,hVg.ess) =0;
  hHdchnl.min(hVg.nad,hVg.ess) =0;
  hHdchnl.npoints(hVg.nad,hVg.ess) =0;
  hHdchnl.point(hVg.nad,hVg.ess) =0;
  hHdchnl.frontcut(1:hVg.nad,1:hVg.ess) =tO.fcut;
  hHdchnl.numstim(1:hVg.ess) =1;
  hdchnl =hHdchnl.databrut();
  vg =hVg.databrut();
  laver ='-V7';
  ptchnl =[];
  tpchnl =[];
  catego =[];
  autre =[];
  % Préparation pour la sauvegarde des entêtes
  save(hF.Info.fitmp, 'vg','hdchnl','ptchnl','tpchnl','catego','autre', laver);
  % Initialisation de la matrice des datas pour la lecture
  if tO.lpe
    tO.smpl =tO.lpe;
    dtchnl(tO.smpl, tO.col) =0;
    bonbon =tO.nbess*tO.smpl*1.2;
    lignedd =tO.smpl;
  else
    fid =fopen(fnom(1).name, 'r');
    % on saute les lignes d'entêtes
    for u =1:tO.nle
      pasbon =fgetl(fid);
    end
    ppasbon =length(fgetl(fid));
    fclose(fid);
    tO.smpl =ceil(fnom(1).bytes/ppasbon);
    for g =1:tO.nbf
      if ceil(fnom(g).bytes/ppasbon) > tO.smpl
        tO.smpl =ceil(fnom(g).bytes/ppasbon);
      end
    end
    dtchnl(tO.smpl, tO.col) =0;
  end
  Dt =CDtchnl();
  %leformat =['%f' tO.delim];
  tranche =1;
  transh =1;
  tO.smpl =1;
  if ~ isempty(tO.Fig)
	  delete(tO.Fig);
  end

  % handle sur le waitbar
  hT =tO.txtml;
  lapos =positionfen('G','C',360,75);
  dd1 =waitbar(0.01, [hT.lectfichs hT.vides hT.patience],...
                'units','pixels','position',lapos);
  lapos(2) =lapos(2)-(lapos(4)*1.25);
  dd2 =findall(0, 'type','figure', 'name','WBarLecture');
  TextLocal =[hT.fichier fnom(1).name];
  delwb =false;
  if isempty(dd2)
    delwb =true;
    dd2 =waitbar(0.001, TextLocal, 'Units','pixels', 'Position',lapos);
  else
    waitbar(0.001, dd2, TextLocal, 'Units','pixels', 'Position',lapos);
  end
  for Z =1:tO.nbf
    waitbar(0.01, dd2, [hT.fichier fnom(Z).name]);
    if ~ tO.lpe
      bonbon =ceil(fnom(Z).bytes/ppasbon)*1.25;
    end
    fid =fopen(fnom(Z).name, 'r');
    % on fait sauter les lignes d'entête au début du fichier
    if tO.nle
      for u =1:tO.nle
        pasbon =fgetl(fid);
      end
    end
    buf =fgetl(fid);
    ligne =1;
    % si un essai par fichier
    if tO.nbess == 1
      tranche =Z;
    end
    ULtim =false;
    while (buf ~= -1)
      if tO.nbess > 1
        if ligne == tO.lpe    % on arrive à la dernière ligne de l'essai
          for j =1:tO.col  % boucle pour lire les canaux
            hHdchnl.sweeptime(j,tranche) =ligne/tO.frq;
            hHdchnl.nsmpls(j,tranche) =ligne;
            hHdchnl.comment{j,tranche} =[fnom(Z).name ':' elnombre{j} '//'];
          end % for j =1:tO.col
          ULtim =true;
        end % if dernière ligne
        if ligne > tO.lpe    % on arrive au changement d'essai
          tO.sauveEssai(dtchnl, Dt, tranche);
          dtchnl(:) =0;
          ligne =1;
          transh =transh+1;
          tranche =tranche+1;
          % on fait sauter les lignes d'entêtes avant chacun des essais
          for u =1:tO.nlepe
            buf =fgetl(fid);
          end
          ULtim =false;
        end
      end % tO.nbess > 1
      [A,CNT] =txtlirnumverti(buf,tO.delim,tO.col,1);
      dtchnl(ligne,1:CNT) =A'; %'
      buf =fgetl(fid);
      ligne =ligne+1;
      if tO.lpe
        waitbar( (((transh-1)*lignedd + ligne))/bonbon,dd2);
      else
        waitbar(ligne/bonbon,dd2);
      end
    end % while
    fclose(fid);
    if tO.nbess == 1
      for j =1:tO.col  % boucle pour lire les canaux
        hHdchnl.sweeptime(j,tranche) =(ligne - 1)/tO.frq;
        hHdchnl.nsmpls(j,tranche) =ligne - 1;
        hHdchnl.comment{j,tranche} =[fnom(Z).name ':' elnombre{j} '//'];
        waitbar(((bonbon*0.8)+((j/tO.col)*(bonbon*0.2)))/bonbon,dd2);
      end
      tO.sauveEssai(dtchnl, Dt, tranche);
      tranche =tranche+1;
    elseif ULtim
      tO.sauveEssai(dtchnl, Dt, tranche);
      dtchnl(:) =0;
      tranche =tranche+1;
    end
    if (ligne - 1) > tO.smpl
      tO.smpl =ligne-1;
    end
    waitbar(Z/tO.nbf,dd1);
    transh =1;
  end
  if delwb
    close(dd2);
  end
  hVg.ess =tranche-1;
  hVg.valeur =1;
  P.hdchnl =hHdchnl.databrut();
  P.vg =hVg.databrut();
  save(hF.Info.fitmp, '-struct', 'P', '-append');
  delete(Dt);
  close(dd1);
end

function [lamat,como] =txtlirnumverti(lalign,dlmt,como,afaire)
  if dlmt ~=','
  	valor =findstr(lalign, dlmt);
  	if ~isempty(valor)
  		lalign(valor) =',';
  		dlmt =',';
  	end
  end
  lamat =str2num(lalign);
  if length(lamat) == 0
    switch afaire
    case 1 % recherche des caractères non-numériques
      ee =find(char(lalign)>59);
      if length(ee)
        lalign(ee) ='0';
      end
    case 2 % recherche des délimiteurs sans valeurs numériques entre
    	pb1 =[dlmt dlmt];
      ee =findstr(lalign, pb1);
      while length(ee)
        lalign =[lalign(1:ee(1)) '0' lalign(ee(1)+1:end)];
        ee =findstr(lalign, pb1);
      end
      if strncmp(lalign, dlmt, 1)  % débute avec un délimiteur
        lalign=['0' lalign];
      end
      if strcmp(lalign(end), dlmt) % fini avec un délimiteur
        lalign=[lalign '0'];
      end
    case 3 % peine perdu on retourn des zéros
      lamat =zeros(1,como);
      return
    end
    [lamat,como] =txtlirnumverti(lalign,dlmt,como,afaire+1);
  elseif length(lamat) > como
    lamat =lamat(1:como);
  else
    como =length(lamat);
  end
end

%-------------------------------------------------------------------------------
% N'A PAS ÉTÉ IMPLÉMENTÉ DANS LA NOUVELLE VERSION
%_______________________________________________________________________________
function vg = lirtexthoriz(fnom,tO)
  if tO.nbess == 1
  	tO.col =tO.col+tO.iscol1;
  	lirtextverti(fnom,tO);
    return;
  end
  hF =tO.Fich;
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;
  if tO.nbess == 0  % pour éviter les erreurs d'incompréhension
  	tO.nbess =1;
  end;
  hVg.ess =tO.nbf*tO.nbess;
  hVg.nst =0;
  hVg.sauve =0;
  hVg.nomstim ={};
  %****LECTURE DES DATAS****
  hVg.nad =tO.col;
  % Lecture des noms de canaux
  if tO.nle && tO.nlnom && (tO.nle >= tO.nlnom)
    fid = fopen(fnom(1).name, 'r');
    if fid == -1
      return;
    end
    for U =1:tO.nlnom
      lobuena =fgetl(fid);
    end;
    lpe =0;
    buf =fgetl(fid);
    while (buf ~= -1)
    	lpe =lpe+1;
      buf =fgetl(fid);
    end
    fclose(fid);
    ptmp =find(lobuena == tO.delim);
    if tO.iscol1
    	ptmp =[ptmp length(lobuena)];
    else
    	ptmp =[0 ptmp length(lobuena)];
    end
  	for U =1:tO.col
  		elnombre{U} =lobuena(ptmp(U)+1:ptmp(U+1)-1);
  	end
  else
  	for U =1:tO.col
  		elnombre{U} =['canal ', int2str(U)];
  	end
  end
  if tO.lpe
    tO.smpl=tO.lpe;
  else
    tO.smpl=lpe;
  end
  hHdchnl.adname =elnombre;
  dtchnl=[];
  dtchnl(tO.smpl,tO.col,tO.nbess*tO.nbf)=0; % Initialisation de la matrice des datas
  bonbon = tO.smpl*1.2;
  %leformat = ['%f' tO.delim];
  lignedd = tO.smpl;
  tO.smpl = 1;

  % position de la waitbar
  Pp =[360 75];
  lafig =findobj('tag','LireTexte');
	if ~ isempty(lafig)
	  postmp =get(lafig, 'Position');
	  Pp =[postmp(1)+round(postmp(3)/2) postmp(2)+round(postmp(4)/2)];
	  delete(lafig);
  end
  % texte pour la Wbar
  hT =tO.txtml;
  lapos =positionfen('G','C',Pp(1),Pp(2));
  dd1 =waitbar(0.01,[hT.lectfichs hT.vides hT.patience],...
                'units','pixels','position',lapos);
  lapos(2)=lapos(2)-(lapos(4)*1.25);
  set(dd1,'position',lapos,'visible','on');
  lapos(2)=lapos(2)-(lapos(4)*1.1);
  debess =1-tO.nbess;
  finess =0;
  problema =[];
  tO.nbdelim =tO.col*tO.nbess-1+tO.iscol1;
  for i=1:tO.nbf
    dd2 =waitbar(0,[hT.fichier fnom(i).name],'units','pixels','position',lapos);
    debess =debess+tO.nbess;
    finess =finess+tO.nbess;
    fid =fopen(fnom(i).name, 'r');
    % on fait sauter les lignes d'entête au début du fichier
    if tO.nle
      for u =1:tO.nle
        pasbon =fgetl(fid);
      end
    end
    buf =fgetl(fid);
    ligne =0;
    probtmp =0;
    while (buf ~= -1) & (ligne ~= lignedd)
      [A,CNT] =txtlirnumhori(buf,tO.delim,tO,1);
      probtmp =probtmp+CNT;
      ligne =ligne + 1;
      dtchnl(ligne,1:tO.col,debess:finess) =A;
      buf =fgetl(fid);
      waitbar(ligne/bonbon,dd2);
    end % while
    fclose(fid);
    if probtmp
      problema{end+1} =fnom(i).name;
    end
    for V =debess:finess
      for U=1:tO.col  % boucle pour lire les canaux
        hHdchnl(U,V).sweeptime =ligne/tO.frq;
        hHdchnl(U,V).nsmpls =ligne;
        hHdchnl(U,V).npoints =0;
        hHdchnl(U,V).point =0;
        hHdchnl(U,V).frontcut =tO.fcut;
        hHdchnl(U,V).nomstim =nomstim;
        hHdchnl(U,V).numero =0;
        hHdchnl(U,V).spcode =0;
        hHdchnl(U,V).rate =tO.frq;
        hHdchnl(U,V).comment ={strcat(fnom(i).name,':',elnombre{U},'//')};
      end
      waitbar(((bonbon*0.8)+(((V-debess+1)/(finess-debess+1))*(bonbon*0.2))),dd2);
    end
    if ligne > tO.smpl
      tO.smpl =ligne;
    end
    waitbar(i/tO.nbf,dd1);
    close(dd2);
  end % for i=1:tO.nbf
  if length(problema)
  	elarge =220; ehaut =200;
  	lapos =positionfen('G','B',elarge,ehaut);
  	lapos(1) =lapos(1)-10;
  	efig =figure('Name','Anomalie', 'tag','AnomalieTexte',...
	      'Position',lapos, 'Resize','off',...
        'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
        'defaultUIControlunits','pixels',...
        'defaultUIControlFontSize',11);
    uicontrol('parent',efig,'style','text','position',[10 135 200 60],...
              'HorizontalAlignment','Center','string',...
              {'Erreur de format:';'ligne vide ou';'caractère non numérique'});
    uicontrol('parent',efig,'style','listbox','position',[10 15 200 120],...
              'string',problema);
  end
  vg.ess =finess;
  if size(dtchnl,1) > tO.smpl
    dtchnl(tO.smpl+1:end,:,:) =[];
  end
  vg.valeur =1;
  close(dd1);
end

function [lamat,como]=txtlirnumhori(lalign,dlmt,ltx,afaire)
  valor =findstr(lalign, dlmt);
  if length(valor) < ltx.nbdelim
  	lamat =zeros(1,ltx.col,ltx.nbess);
    como =1;
    return;
  end
  if dlmt ~= ','
		lalign(valor) =',';
		dlmt =',';
  end
  lamat = str2num(lalign);
  if length(lamat) == 0
    switch afaire
    case 1 % recherche des caractères non-numériques
      ee=find(char(lalign)>59);
      if length(ee)
        lalign(ee) = '0';
      end
    case 2 % recherche des délimiteurs sans valeurs numériques entre
    	pb1 =[dlmt dlmt];
      ee =findstr(lalign, pb1);
      while length(ee)
        lalign =[lalign(1:ee(1)) '0' lalign(ee(1)+1:end)];
        ee =findstr(lalign, pb1);
      end
      if strncmp(lalign, dlmt, 1)  % débute avec un délimiteur
        lalign=['0' lalign];
      end
      if strcmp(lalign(end), dlmt) % fini avec un délimiteur
        lalign=[lalign '0'];
      end
    case 3 % peine perdu on retourn des zéros
      lamat =zeros(1,ltx.col,ltx.nbess);
      como =1;
      return;
    end
    [lamat,como] =txtlirnumhori(lalign,dlmt,ltx,afaire+1);
  elseif length(lamat) == (ltx.col*ltx.nbess)+ltx.iscol1
  	refmat =lamat;
  	lamat =[];
  	for V =1:ltx.nbess
  		donde =(V-1)*ltx.col +1+ltx.iscol1;
  		lamat(1,1:ltx.col,V)=refmat(donde:donde+ltx.col-1);
  	end
  	como =0;
  else
    lamat =zeros(1,ltx.col,ltx.nbess);
    como =1;
  end
end
