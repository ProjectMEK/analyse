function lirmatri(varargin);
%
% Lecture des matrice MATLAB
% 
% Laboratoire GRAME
% MEK - Août 2002... jamais terminé!
%                    l'ancienne forme des matrices y est utilisé.
%                    Faudrait voir ce que Mathieu G. a fait pour 
%                    transformer des matrice matlab en format
%                    lisible par Analyse.
%
% Permet de lire une matrice sauvegardé avec Matlab.
%
% Bonne lecture!
%
global hdchnl dtchnl ptchnl lma;
if nargin == 0
   commande = 'ouverture';
else
   commande =varargin{1};
   vg =varctrl('vg');
end
%
switch(commande)
%---------------
case 'ouverture'
vg.valeur=1;
lma.choix=0;
large = 650;                                 % largeur fenêtre totale
haut  = 300;                                 % hauteur fenêtre totale
epais = 25;                                  % épaisseur normale d'un objet
ptitepais=15;                                % épaisseur pour écriture avec font 6
bordure=25;                                  % bordure de la deuxième colonne
lebord1= 50;                                 % marge colonne de gauche
lebord2= (large/2) + bordure;                % marge colonne de droite
bouton = 20;                                 % largeur d'un bouton
largfen=50;                                  % largeur fenêtre input texte
fenetre = [largfen epais];                   % dimension fenêtre input
largeur1= (large/2)-lebord1-bordure-largfen; % largeur description
letexte= [largeur1 epais];                   % dimension description
adroite =0;
lma.fig = figure('Name','Matrice', ...
	'Position',[50 100 large haut], ...
        'CloseRequestFcn','lirmatri(''fermer'')',...
        'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
        'defaultUIControlunits','pixels',...
        'defaultUIControlFontSize',11,...
	'Resize','off');
  haut = haut - 35;
largeur= large - (2*lebord1);
lma.c1 = uicontrol('Parent',lma.fig, ...
        'HorizontalAlignment','Center', ...
        'Position',[lebord1 haut largeur epais], ...
        'FontSize',13,...
        'Style','text',...
        'String','Choix du fichier contenant la matrice');
  haut = haut - 30;
largeur= large - bouton - (2*lebord1);
lma.c2 = uicontrol('Parent',lma.fig, ...
        'BackgroundColor',[1 1 1], ...
        'FontSize',10, ...
        'HorizontalAlignment','Left', ...
        'Position',[lebord1 haut largeur epais], ...
        'Style','edit');  % entrée du nom de fichier
largeur= lebord1 + largeur;
lma.c3 = uicontrol('Parent',lma.fig, ...
	'Callback','lirmatri(''selection'')', ...
	'Position',[largeur haut-1 bouton epais], ...
        'TooltipString','Choix du fichier par interface graphique',...
	'String','...');
  haut = haut - 15;
largeur= large - (2*lebord1);
lma.c1 = uicontrol('Parent',lma.fig, ...
        'Position',[lebord1 haut largeur ptitepais], ...
        'HorizontalAlignment','Left', ...
        'FontSize',6,...
        'Style','text',...
        'String','Inscrire le PATH au complet');
  haut = haut - 5;
  % ****************on étale de gauche à droite
  if adroite
    lebord = lebord2;
    adroite=0;
  else
    lebord = lebord1;
    haut = haut - 35;
    adroite=1;
  end
lma.c1 = uicontrol('Parent',lma.fig, ...
        'HorizontalAlignment','Right', ...
        'Position',[lebord haut letexte], ...
        'Style','text',...
        'String','Fréquence d''échantillonage: ');
lma.c7 = uicontrol('Parent',lma.fig, ...   % Fréquence 
        'BackgroundColor',[1 1 1], ...
        'FontSize',10, ...
        'HorizontalAlignment','Center', ...
        'Position',[largeur1+lebord haut fenetre], ...
        'Style','edit', ...
        'String','100');
  if adroite
    lebord = lebord2;
    adroite=0;
  else
    lebord = lebord1;
    haut = haut - 35;
    adroite=1;
  end
lma.c1 = uicontrol('Parent',lma.fig, ...
        'HorizontalAlignment','Right', ...
        'Position',[lebord haut letexte], ...
        'Style','text',...
        'String','Secondes coupées au début: ');
lma.c6 = uicontrol('Parent',lma.fig, ...    % Frontcut
        'BackgroundColor',[1 1 1], ...
        'FontSize',10, ...
        'HorizontalAlignment','Center', ...
        'Position',[largeur1+lebord haut fenetre], ...
        'Style','edit', ...
        'String','0');
  if adroite
    lebord = lebord2;
    adroite=0;
  else
    lebord = lebord1;
    haut = haut - 35;
    adroite=1;
  end
lma.c1 = uicontrol('Parent',lma.fig, ...
        'Position',[lebord haut letexte], ...
        'HorizontalAlignment','Right', ...
        'Style','text',...
        'String','Numéro d''utilisateur: ');
lma.c5 = uicontrol('Parent',lma.fig, ...    % No d'utilisateur
        'BackgroundColor',[1 1 1], ...
        'FontSize',10, ...
        'HorizontalAlignment','Center', ...
        'Position',[largeur1+lebord haut fenetre], ...
        'Style','edit', ...
        'String','0');
  if adroite
    lebord = lebord2;
    adroite=0;
  else
    lebord = lebord1;
    haut = haut - 35;
    adroite=1;
  end
  letype=strcat('Nouveaux essais','|','nouveaux canaux');
lma.c1 = uicontrol('Parent',lma.fig, ...
        'Position',[lebord haut largeur1-25 epais], ...
        'HorizontalAlignment','Right', ...
        'Style','text',...
        'String','Si plusieurs fichiers: ');
lma.c8= uicontrol('Parent',lma.fig, ...
        'BackgroundColor',[1 1 1], ...
        'FontSize',9, ...
        'Position',[largeur1+lebord-25 haut largfen+25 epais], ...
        'String',letype, ...
        'Style','popupmenu', ...
        'Value',1);
  if adroite
    lebord = lebord2;
    adroite=0;
  else
    lebord = lebord1;
    haut = haut - 35;
    adroite=1;
  end
lma.c1 = uicontrol('Parent',lma.fig, ...
        'Position',[lebord haut largeur1-25 epais], ...
        'HorizontalAlignment','Right', ...
        'Style','text',...
        'String','Si plusieurs Matrice/fichier: ');
lma.c9= uicontrol('Parent',lma.fig, ...
        'BackgroundColor',[1 1 1], ...
        'FontSize',9, ...
        'Position',[largeur1+lebord-25 haut largfen+25 epais], ...
        'String',letype, ...
        'Style','popupmenu', ...
        'Value',1);
% ***********Fin des fenêtres d'édition
haut = haut-60; largeur=100;posx=floor((large-largeur)/2);
lma.c10 = uicontrol('Parent',lma.fig, ...     % Au Travail
	'Callback','lirmatri(''lecture'')', ...
        'FontSize',11, ...
	'Position',[posx haut largeur epais], ...
	'String','Au Travail');
  set(lma.fig,'WindowStyle','modal');
%---------------
case 'selection'
  [fname,pname,vg.valeur] =quelfich('*.*','Ouverture d''un fichier Matlab',0);
  if vg.valeur
  	finame =fullfile(pname,fname);
    vg.finame =fname;
    vg.prenom =pname;
    set(lma.c2,'String',finame);
  end
%-------------
case 'lecture'
  var=get(lma.c2,'String');  % nom de fichier
  if ~ lirpath(var)
    return;
  end
  nom=dir(var);
  lma.nbf=size(nom,1);  % nombre de fichier à traiter
  if lma.nbf & ~isempty(var)
    lma.nus=str2num(get(lma.c5,'String'));     % no usager
    lma.fcut=str2num(get(lma.c6,'String'));    % frontcut
    lma.frq=str2num(get(lma.c7,'String'));     % fréquence d'échantill.
    lma.newf=get(lma.c8,'value');              % Où place t-on les nouveaux fichiers (ess/can)
    lma.newm=get(lma.c9,'value');              % Où place t-on les nouvelles matrices (ess/can)
    lma.erreur = 0;
    i=1;
    while i<=lma.nbf
      if nom(i).isdir
        nom(i)=[];
        lma.nbf=lma.nbf-1;
      else
        i=i+1;
      end
    end
    if lma.nbf
      nom=sortdir(nom);
      lirlamatte(nom);
      %
        if ~ lma.erreur
        delete(lma.fig);
        clear global lma;
        vg.valeur=1;
        analyse('finlect')
        end
      %
    end
  end
  %------------
  case 'fermer'
    delete(lma.fig);
    clear global lma;
    vg.valeur=0;
  end
end

function lirpath(complet) % positionnement dans le bon répertoire
  ilEstLa =false;
  [a,b,c] =fileparts(complet);
  if isdir(a)
    cd(a);
    ilEstLa =true;
  end
end

function [leretour] = sortdir(fnom)
  leretour=fnom;
  enordre=cell(size(fnom,1),1);
  for i=1:size(fnom,1)
    enordre{i} = upper(fnom(i).name);
  end
  [enordre,lindex] = sort(enordre);
  for i=1:size(fnom,1)
    leretour(i).name = fnom(lindex(i)).name;
    leretour(i).bytes = fnom(lindex(i)).bytes;
  end
end

function lirlamatte(fnom)
  global hh vg hdchnl dtchnl lma
  vg.finame =fnom(1).name;
  vg.foname = vg.finame;
  %%
  vg.nst=0;
  vg.sauve=0;
  nomstim=char(ones(1,19)*32);
  %****LECTURE DES DATAS****
  pepe=fnom(1).name;
  lesdat=load(pepe);  % lesdat est une structure dont les champs sont les matrices du fichier
  nomdat=fieldnames(lesdat);  % nomdat est une cell dont les champs sont les nom de matrices du fichier
  ordre=manymatriss(nomdat);
  vg.nad=0;
  vg.ess=0;
  size_test = size(getfield(lesdat, nomdat{1} ) );
  %
    for i=1:length(ordre)
    grosse=size(getfield(lesdat, nomdat{ordre(i)} ) );
    %
      if lma.newm = 1       % les matrices sont des essais
      %                       On test pour le même nb de canaux
        if size_test(2) ~= grosse(2)
        lma.erreur=1;
        break
        end
      %
      vg.ess=vg.nad+grosse(3);
      vg.nad=size_test(2);
      elseif lma.newm = 2   % les matrices sont des canaux
      %                       On test pour le même nb d'essais
        if size_test(3) ~= grosse(3)
        lma.erreur=1;
        break
        end
      %
      vg.nad=vg.nad+grosse(2);
      vg.ess=size_test(3);
      end
    %
    end
  %
  %
    if lma.erreur
      error('Incohérence des dimensions de matrice')
      return
    end
  %

  %
    if lma.lpe
    lma.smpl=lma.lpe;
    dtchnl=[];
    dtchnl(lma.smpl,lma.col,lma.nbess*lma.nbf)=0;
    else
    fid = fopen(fnom(1).name, 'r');
    %%
      for u=1:lma.nle; pasbon=fgetl(fid); end
    pasbon=length(fgetl(fid));
    fclose(fid);
    lma.smpl = ceil(fnom(1).bytes/pasbon);
    dtchnl=[];
    dtchnl(lma.smpl,lma.col,lma.nbess*lma.nbf)=0; % Initialisation de la matrice des datas
    end
  %
  leformat = ['%f' lma.delim];
  tranche = 1;
  bonbon = lma.nbf*lma.nbess*lma.smpl*1.1;
  bbase=bonbon/11;
  lignedd = lma.smpl;
  lma.smpl = 1;
  dd = waitbar(bbase/bonbon,'Lecture des essais, veuillez patienter');
  %
    for i=1:lma.nbf
    fid = fopen(fnom(i).name, 'r');
    % on fait sauter les lignes d'entête au début du fichier
      if lma.nle
      %
        for u=1:lma.nle
          pasbon=fgetl(fid);
        end
      %
      end
    %
    buf=fgetl(fid);
    ligne=1;
    %%
    if lma.nbess == 1; tranche=i; end  % si un essai par fichier
    %
      while (buf~=-1)
      %
        if lma.nbess > 1
        %
          if ligne == lma.lpe    % on arrive à la dernière ligne de l'essai
          %
            for j=1:lma.col  % boucle pour lire les canaux
            chnom=['canal ', int2str(j)];
            hdchnl(j,tranche).sweeptime= ligne/lma.frq;
            hdchnl(j,tranche).nsmpls=ligne;
            hdchnl(j,tranche).npoints=0;
            hdchnl(j,tranche).point=0;
            hdchnl(j,tranche).frontcut=lma.fcut;
            hdchnl(j,tranche).nomstim=nomstim;
            hdchnl(j,tranche).numero=0;
            hdchnl(j,tranche).spcode=0;
            hdchnl(j,tranche).rate=lma.frq;
            hdchnl(j,tranche).usercode=lma.nus;
            hdchnl.adname{j} =deblank(chnom);
            hdchnl(j,tranche).comment=[hdchnl.adname{j} '://'];
            end % for j=1:lma.col
          %
          end % if ligne ==
        %
        %
          if ligne > lma.lpe    % on arrive au changement d'essai
          ligne   = 1;
          tranche = tranche + 1;
          % on fait sauter les lignes d'entêtes avant chacunes des essais
            for u=1:lma.nlepe
            pasbon=fgetl(fid);
            end
          %
          end
        %
        end % lma.nbess > 1
      %
      [A,CNT]=sscanf(buf,leformat,lma.col);  % afin de lire des fichiers de diff. dimensions
      dtchnl(ligne,1:CNT,tranche)=A';
      buf=fgetl(fid);
      ligne = ligne + 1;
      waitbar( (((tranche-1)*lignedd + ligne)+bbase)/bonbon);
      end % while
    %
    fclose(fid);
    %
      if lma.nbess == 1
      waitbar(.96);
      %
        for j=1:lma.col  % boucle pour lire les canaux
        chnom=['canal ', int2str(j)];
        hdchnl(j,tranche).sweeptime=(ligne - 1)/lma.frq;
        hdchnl(j,tranche).nsmpls=ligne - 1;
        hdchnl(j,tranche).npoints=0;
        hdchnl(j,tranche).point=0;
        hdchnl(j,tranche).frontcut=lma.fcut;
        hdchnl(j,tranche).nomstim=nomstim;
        hdchnl(j,tranche).numero=0;
        hdchnl(j,tranche).spcode=0;
        hdchnl(j,tranche).rate=lma.frq;
        hdchnl(j,tranche).usercode=lma.nus;
        hdchnl.adname{j} =deblank(chnom);
        hdchnl(j,tranche).comment=[hdchnl.adname{j} '://'];
        end
      %
      end
    %
    tranche = tranche +1;
    %%
    if (ligne - 1) > lma.smpl; lma.smpl=ligne - 1; end
    end
  %
  close(dd);
  vg.ess=tranche - 1;
  %
    if size(dtchnl,1) > lma.smpl
    dtchnl(lma.smpl+1:size(dtchnl,1),:,:)=[];
    end
  %
  vg.valeur=1;
end

function [orde]=manymatriss(nom_mat);
  %
  % ici on va indexer sur la grosseur des matrices présentent dans le fichier
  % en retournant l'ordre croissant dans la variable: ORDE
  %
  orde=1;
  %
    if length(nom_mat) > 1
    orde=1:length(nom_mat);
    end
  %
end
