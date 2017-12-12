%
% GRAME, avril 2002
% auteur: MEK
%         Participation de François Bonnetblanc pour les tests.
%
% fonction pour utiliser les paramètres d'un filtre créé avec l'outil SPTOOL
% MENU: SPTOOL
%
function fiFilt(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    sp =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  switch(commande)
  %---------------
  case 'ouverture'
    sp.ok =false;
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    if vg.ess > 2;top =vg.ess;else top =vg.ess+1;end
    ymax =325;
    ltit =250;
    htit =25;
    htex =20;
    ledit =50;
    lbtn =30;
    lebord1 =25;lebord2 =5;largeur1 =150;largeur2 =125; largeur3 =150; largeur4 =80;
    xmax =(4*lebord1)+largeur1+largeur2+largeur3; haut =125;
    lapos =positionfen('G','H',xmax,ymax);
    fiig =figure('Name','FILTRAGE', 'Position',lapos, ...
            'CloseRequestFcn','fiFilt(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',9, 'Resize','off');
    ypos =ymax-htit-5;xpos =round((xmax-ltit)/2);
    sp.tit(1) =uicontrol('Parent',fiig, ...
            'HorizontalAlignment','center',...
            'Position',[xpos ypos ltit htit], ...
            'FontSize',12,...
            'FontWeight','bold',...
            'Style','text',...
            'String','Utilisation des fichiers SpTool');
    %NOM DU FICHIER FILTRE
    ypos =ypos-40;xpos =lebord1;largeur =xmax-2*lebord1-lbtn-2*lebord2-largeur4;
    sp.ctrl(6) =uicontrol('Parent',fiig, ...
            'HorizontalAlignment','center', 'String',' ', ...
            'Position',[xpos ypos largeur htex], 'Style','text');
    xpos =xpos+largeur+lebord2;
    sp.ctrl(7)=uicontrol('Parent',fiig, ...
            'Callback','fiFilt(''choix_canal'')', ...
            'TooltipString','Choix du fichier de filtre exporté par SPTOOL',...
            'Position',[xpos ypos lbtn htit], ...
            'String','...');
    xpos =xpos+lbtn+lebord2;
    sp.ctrl(8) =uicontrol('Parent',fiig, 'Style','popupmenu', ...
             'Position',[xpos ypos largeur4 25], 'String','Aucun', ...
             'Callback','fiFilt(''choix_filtre'')', ...
             'TooltipString','Choix du filtre exporté par SPTOOL');
    ypos =ypos-40;xpos =lebord1;
    sp.ctrl(1) =uicontrol('Parent',fiig, ...
             'Callback','fiFilt(''aff_ess'')', ...
             'Position',[xpos ypos largeur1 25], ...
             'String','Traiter tous les essais', ...
             'Style','checkbox', ...
             'Value',1);
    ypos =ypos-30;
    sp.tit(1) =uicontrol('Parent',fiig, ...
            'HorizontalAlignment','center',...
            'Position',[xpos ypos largeur1 htex], ...
            'String','Choix des canaux', ...
            'Style','text');
    xpos =xpos+largeur1+lebord1;
    sp.tit(2) =uicontrol('Parent',fiig, ...
            'HorizontalAlignment','center',...
            'Visible','Off', ...
            'Position',[xpos ypos largeur2 htex], ...
            'String','Choix des essais', ...
            'Style','text');
    if vg.niveau
      xpos =xpos+largeur2+lebord1;
      sp.tit(3) =uicontrol('Parent',fiig, ...
              'HorizontalAlignment','center',...
              'Visible','Off', ...
              'Position',[xpos ypos largeur3 htex], ...
              'String','Choix des catégories', ...
              'Style','text');
    end
    ypos =ypos-haut;xpos =lebord1;
    sp.ctrl(4) =uicontrol('Parent',fiig, ...
            'BackgroundColor',[1 1 1], ...
            'Position',[xpos ypos largeur1 haut], ...
            'String',hdchnl.Listadname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox',...
            'Value',1);
    xpos =xpos+largeur1+lebord1;
    sp.ctrl(2) =uicontrol('Parent',fiig, ...
            'BackgroundColor',[1 1 1], ...
            'Position',[xpos ypos largeur2 haut], ...
            'String',vg.lesess, ...
            'Visible','Off', ...
            'Min',1,...
            'Max',top,...
            'Style','listbox',...
            'Value',1);
    xpos =xpos+largeur2+lebord1;
    if vg.niveau
    	ttt =length(vg.lescats);
    	if ttt <= 2, ttt =ttt+1; end
      sp.ctrl(3) =uicontrol('Parent',fiig, ...
              'BackgroundColor',[1 1 1], ...
              'Position',[xpos ypos largeur3 haut], ...
              'String',vg.lescats, ...
              'Callback','fiFilt(''aff_ess2'')', ...
              'Visible','Off', 'Min',1, 'Max',ttt,...
              'Style','listbox', 'Value',1);
    end
    xpos =lebord1; ypos =ypos-(2*htex);
    sp.ctrl(5) =uicontrol('Parent',fiig, ...
            'Position',[xpos ypos 2*largeur2 htex], ...
            'HorizontalAlignment','left',...
            'String','Placer le résultat dans le même canal',...
            'Style','checkbox', ...
            'Value',0);
    largeur =80; xpos =xmax-largeur-lebord1;
    sp.btn(1) =uicontrol('Parent',fiig, ...
            'Callback','fiFilt(''au travail'')', ...
            'FontSize',12,...
            'HorizontalAlignment','center',...
            'Position',[xpos ypos largeur 25], ...
            'String','Au travail');
    set(fiig,'WindowStyle','modal');
    guidata(gcf,sp);
    pause(0.5)
    fiFilt('choix_canal');
  %-------------
  case 'aff_ess'  % si on prend tous les essais ou non, on doit afficher les fen. cat et ess
    if get(sp.ctrl(1),'Value')
      set(sp.ctrl(2),'Visible','Off');
      set(sp.tit(2),'Visible','Off');
      if vg.niveau
        set(sp.ctrl(3),'Visible','Off');
        set(sp.tit(3),'Visible','Off');
      end
    else
      set(sp.ctrl(2),'Visible','On');
      set(sp.tit(2),'Visible','On');
      if vg.niveau
        set(sp.ctrl(3),'Visible','On');
        set(sp.tit(3),'Visible','On');
      end
    end
  %--------------
  case 'aff_ess2'
    lestri =lirfen(sp);
    if lestri
      set(sp.ctrl(2),'Value',lestri);
    end
  %-----------------
  case 'choix_canal'
    [sp,i] =quelfilt(sp);
    if i
      set(sp.ctrl(6), 'String',sp.finame);
      set(sp.ctrl(8), 'String',sp.lesfiltres, 'Value',sp.vfiltre);
      sp.ok =true;
      guidata(gcf,sp);
    end
  %----------------
  case 'choix_filtre'
    sp.vfiltre =get(sp.ctrl(8), 'Value');
    guidata(gcf,sp);
  %----------------
  case 'au travail'
    if ~sp.ok
      return
    end
    dtchnl =CDtchnl();
    pala =sp.finame;
    letout =load(pala);
    champ =sp.lesfiltres;
    SPden =letout.(champ{sp.vfiltre}).tf.den;
    SPnum =letout.(champ{sp.vfiltre}).tf.num;
    tous =get(sp.ctrl(1),'Value');            % affiche tous les essais ???
    if tous
      lestri =[1:vg.ess];                  % liste des essais à traiter
    else
      lestri =get(sp.ctrl(2),'Value');
    end
    Vcan =get(sp.ctrl(4),'Value');       % liste des canaux à modifier
    ecrase =get(sp.ctrl(5),'Value');
    scan =length(Vcan);
    if ecrase
      Ncan =Vcan;                   % contiendra le canal de sortie (la réponse)
    else
    	hdchnl.duplic(Vcan);
      Ncan =[vg.nad+1:vg.nad+scan];
      vg.nad =vg.nad+scan;
    end
    delete(gcf);
    wb =waitbar(0.01,'Filtrage en cours');
    stri =length(lestri);
    ptt =scan*stri;
    ptot =ptt*1.15;
    lehndl =findobj('type','figure','tag','IpTraitement');
    cccc =['FILT(' sp.prenom '\' champ{sp.vfiltre} ') '];
    for i =1:scan
    	Ofich.getcanal(dtchnl, Vcan(i));
    	N =dtchnl.Nom;
      if ~ecrase
        hdchnl.adname{Ncan(i)} =['FILTsp ' deblank(hdchnl.adname{Ncan(i)})];
      end
      for j =1:stri
        try
          long =hdchnl.nsmpls(Ncan(i),lestri(j));
          dtchnl.Dato.(N)(1:long,lestri(j)) = filtfilt(SPnum, SPden, double(dtchnl.Dato.(N)(1:long,lestri(j))));
          hdchnl.comment{Ncan(i), lestri(j)} =[cccc hdchnl.comment{Ncan(i), lestri(j)}];
          hdchnl.max(Ncan(i), lestri(j)) =max(dtchnl.Dato.(N)(1:long,lestri(j)));
          hdchnl.min(Ncan(i), lestri(j)) =min(dtchnl.Dato.(N)(1:long,lestri(j)));
          %disp(['essai réussi: ' num2str(lestri(j)) ' -- canal: ' num2str(Vcan(i))]);
        catch e
          disp(['essai: ' num2str(lestri(j)) ' -- canal: ' num2str(Vcan(i))]);
          disp(e.message)
        end
      end
      Ofich.setcanal(dtchnl, Ncan(i));
      waitbar(((j/scan*(ptot-ptt))+ptt)/ptot);
    end
    delete(wb);
    vg.sauve =1;
    vg.valeur =0;
    if ecrase
      OA.OFig.affiche();
    else
      gaglobal('editnom');
    end
  %--------------
  case 'fermer'
    delete(gcf);
    vg.valeur =0;
  end
return

function [sp,i] =quelfilt(sp)
  [fname,pname] =uigetfile('*.mat','Ouverture d''un fichier Exporté par SPTOOL');
  i =false;
  if ~ischar(fname)
    return;
  end
  pala =fullfile(pname,fname);
  letout =load(pala);
  champ =fieldnames(letout);
  spok =false;
  lesfiltres ={};
  for U =1:length(champ)
    if isfield(letout.(champ{U}),'tf')
      lesfiltres{end+1} =champ{U};
      spok =true;
    end
  end
  if spok
    sp.finame =pala;
    sp.prenom=fname;
    sp.lesfiltres =lesfiltres;
    sp.vfiltre =1;
    i=1;
  end
return

%
% Fonction pour lire les essais en fonction des catégories choisies
%
function [lestri] =lirfen(sp)
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  catego =Ofich.Catego;
  vg =Ofich.Vg;
  lalist =get(sp.ctrl(3),'Value')';
  lamat =zeros(vg.niveau,vg.ess);
  a =zeros(vg.niveau);
  niv =1;
  tot =catego.Dato(1,1,1).ncat;
  for i =1:size(lalist,1)
    while lalist(i) > tot
      niv =niv+1;
      tot =tot+catego.Dato(1,niv,1).ncat;
    end
    a(niv) =a(niv)+1;
    lacat =lalist(i)-(tot-catego.Dato(1,niv,1).ncat);
    lamat(niv,:) =lamat(niv,:)+catego.Dato(2,niv,lacat).ess(:)';
  end
  final =ones(vg.ess,1);
  for i =1:vg.niveau
    if a(i)
      for j =1:vg.ess
        final(j,1) =final(j,1) & lamat(i,j);
      end
    end
  end
  if max(final)>0
    i =1;
    while ~final(i,1)
      i =i+1;
    end
    lestri(1) =i;
    k =2;
    for j =i+1:vg.ess
      if final(j)
        lestri(k,1) =j;
        k =k+1;
      end
    end
  else
    lestri =0;
  end
return
