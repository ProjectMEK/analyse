%
% Interface (GUI) pour demander les param�tres du calcul de distance parcourue
% lorsque les coordonn�es sont en Longitude/Latitude
%
% EN ENTR�E on a  Ppa --> un objet de la classe CProjetGPS
%
function fig =IProjetGPS(Ppa)
  hA =CAnalyse.getInstance();
  Ofich =hA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  Lfen =402; Hfen =600;
  posfig =positionfen('G','C',Lfen,Hfen,hA.OFig.fig);
  fig = figure('Name', 'MENU GPS', 'Position',posfig, 'Resize', 'off', ...				
          'CloseRequestFcn',@Ppa.terminus, 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], ...
          'DefaultUIControlUnits','pixels', 'DefaultUIPanelBackgroundColor',[0.8 0.8 0.8], ...
          'DefaultUIControlFontUnits','pixels', 'DefaultUIControlFontSize',12, ...
          'DefaultUIControlFontName','MS Sans Serif');
  % CONSTANTES DE POSITION
  Hpan1 =150; Hpan2 =225; Hpan3 =190; Lpan =Lfen-2; my =5; my2 =10;
  mx =100; ltxt =40; htxt =20; hbtn =25;
  % PANEL
  posx =2; large =Lpan; posy =Hfen-Hpan1; haut =Hpan1;
  pan1 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], ...
                'Title','Choix des canaux LON-LAT', 'TitlePosition','centertop');
  haut =Hpan2; posy =posy-haut-my;
  pan2 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], ...
                'Title','Essais et Intervalles', 'TitlePosition','centertop');
  haut =Hpan3; posy =posy-haut-my;
  pan3 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], ...
                'Title','T�ches � ex�cuter', 'TitlePosition','centertop');
  % STATUS
  haut =htxt; posy =0;
  uicontrol('Parent',fig, 'Style','text', 'Position',[posx posy large haut], ...
            'HorizontalAlignment','center', 'FontWeight','bold', 'Tag','LeStatus', ...
            'String','Remplissez chacune des sections et cliquez sur "Au travail"');
  % PANEL 1 {CHOIX DES CANAUX LON-LAT}
  pan =pan1;
  % CANAL LONGITUDE
  posx =mx-ltxt; haut =hbtn; posy =Hpan1-haut-35; large =200;
  uicontrol('Parent',pan, 'FontWeight','bold', 'Position',[posx posy ltxt htxt],...
          'HorizontalAlignment','right', 'String','LON: ', 'Style','text');
  posx =mx;
  uicontrol('Parent',pan, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
          'String',hdchnl.Listadname, 'Min',1, 'Style','popupmenu', 'Value',Ppa.cLON, ...	
          'TooltipString','Choix du canal pour la longitude', 'callback',@Ppa.ChangeLON);				       
  % CANAL LATITUDE
  posx =mx-ltxt; posy =posy-haut-my2;
  uicontrol('Parent',pan, 'FontWeight','bold', 'Position',[posx posy ltxt htxt],...
          'HorizontalAlignment','right', 'String','LAT: ', 'Style','text');
  posx =mx;
  uicontrol('Parent',pan, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
          'String',hdchnl.Listadname, 'Min',1, 'Style','popupmenu', 'Value',Ppa.cLAT, ...	
          'TooltipString','Choix du canal pour la latitude', 'callback',@Ppa.ChangeLAT);				       
  % UNIT� DEGR�/RADIAN
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Les donn�es sont en degr�s', ...
            'Style', 'radiobutton', 'Value',Ppa.Unit, 'callback',@Ppa.ChangeUnit, ...
            'TooltipString','Deux choix possible: degr� ou radian (Normalement, le GPS fournit des degr�s)');
  % CONSTANTES DE POSITION
  mx =10; mx2 =5; hlbox12 =165; hlbox34 =145; llbox1 =150; llbox2 =125; llbox34 =45;
  % PANEL 2 {ESSAIS ET INTERVALLES}
  pan =pan2;
  % TOUS ESSAI
  posx =mx; haut =hbtn; large =110; posy =Hpan2-haut-15; posybu =posy;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Tous les essais', ...
            'Style', 'radiobutton', 'Value',Ppa.Ess, 'callback',@Ppa.ChangeEss, ...
            'TooltipString','Garder coch� pour agir sur tous les essais, sinon d�cochez et choisissez les essais ci-dessous');
  % ESSAI
  large =llbox1; haut =hlbox12; posy =posy-haut-mx2;
  letop =max(2, length(vg.lesess));
  Ppa.LbEss =uicontrol('Parent',pan, 'Style','listbox', 'FontSize',10, 'Position',[posx posy large haut], ...
            'String',vg.lesess, 'Min',1, 'Max',letop, 'Fontname','courier', 'BackgroundColor',[1 1 1], ...
            'TooltipString','Choississez les essais � travailler', 'Enable','off');
  % INTERVAL
  posx =posx+large+mx; large =200; posy =posybu; haut =hbtn;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Utilisez tout le canal', ...
            'Style', 'radiobutton', 'Value',Ppa.Interv, 'callback',@Ppa.ChangeInterv, ...
            'TooltipString','Garder coch� pour agir sur tous les �chantillons (samples), sinon d�cocher pour choisir un point initial et final comme borne de calcul');
  % CANAUX
  large =llbox2; haut =hlbox12; posy =posy-haut-mx2;
  lescan ={'Canal de LONgitude','Canal de LATitude'};
  lescan(3:length(hdchnl.adname)+2) =hdchnl.Listadname;
  Ppa.LbCan =uicontrol('Parent',pan, 'Style','listbox', 'FontSize',10, 'Position',[posx posy large haut], ...
            'Min',1, 'Max',1, 'Fontname','courier', 'String',lescan, 'callback',@Ppa.ChangeCanPoint, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','Choississez le canal de r�f�rence pour les points de d�but et fin de l''intervalle');
  % POINT INITIAL
  posx =posx+large+mx2; large =2*llbox34; haut =htxt; posy =posybu-haut-mx2; posxbu =posx;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut],...
            'FontWeight','bold', 'HorizontalAlignment','center', 'String','Pt. initial', ...
            'TooltipString','Choississez le point initial de r�f�rence pour l''intervalle de calcul');
  large =llbox34; posx =posx+round(large/2); posy =posy-haut;
  Ppa.LbPti =uicontrol('Parent',pan, 'Style','edit', 'Position',[posx posy large haut], ...
            'Fontname','courier', 'String',Ppa.PI, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','Pi=1er �chantillon, P1=1er pt marqu�, P2=2i�me pt marqu�, etc... un chiffre indique un temps en seconde: 3.22 = 3.22 sec');
  % POINT FINAL
  posx =posxbu; large =2*llbox34; posy =posy-2*haut;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut],...
            'FontWeight','bold', 'HorizontalAlignment','center', 'String','Pt. final', ...
            'TooltipString','Choississez le dernier point de r�f�rence pour l''intervalle de calcul');
  large =llbox34; posx =posx+round(large/2); posy =posy-haut;
  Ppa.LbPtf =uicontrol('Parent',pan, 'Style','edit', 'Position',[posx posy large haut], ...
            'Fontname','courier', 'String',Ppa.PF, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','Pf=dernier �chantillon de ce canal, P1=1er pt marqu�, P2=2i�me pt marqu�, etc... un chiffre indique un temps en seconde: 3.22 = 3.22 sec');
  % CONSTANTES DE POSITION
  mx =15; lrb =150; my =5; mygauche =35; mydroite =30; ltxt2 =160; ldiv2 =round(Lpan/2);
  % PANEL 3
  pan =pan3;
  % DISTANCE PARCOURUE
  posx =mx; large =lrb; haut =hbtn; posy =Hpan3-mygauche-haut;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Distance parcourue', ...
            'Style', 'radiobutton', 'Value',Ppa.Distance, 'callback',@Ppa.ChangeDist, ...
            'TooltipString','Obtenir la distance parcourue en fonction du temps');
  % VIRAGE � GAUCHE
  posy =posy-my-haut;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Virage � gauche', ...
            'Style', 'radiobutton', 'Value',Ppa.Vgauche, 'callback',@Ppa.ChangeViraG, ...
            'TooltipString','Obtenir un point marqu� pour les virage � gauche');
  % VIRAGE � DROITE
  posy =posy-my-haut;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Virage � droite', ...
            'Style', 'radiobutton', 'Value',Ppa.Vdroite, 'callback',@Ppa.ChangeViraD, ...
            'TooltipString','Obtenir un point marqu� pour les virage � droite');
  % CANAL DE VITESSE
  posy =posy-2*my-haut; haut =htxt;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut],...
            'FontWeight','bold', 'HorizontalAlignment','center', 'String','Canal de la vitesse (Km/H)');
  posy =posy-haut+2;
  lescan ={'Ne pas utiliser'};
  lescan(2:length(hdchnl.adname)+1) =hdchnl.Listadname;
  Ppa.LbCanVit =uicontrol('Parent',pan, 'Style','popupmenu', 'FontSize',11, 'Position',[posx posy large haut], ...
            'Fontname','courier', 'String',lescan, 'BackgroundColor',[1 1 1], 'Tag','CanVitesse', ...
            'TooltipString','Choississez le canal de vitesse pour appliquer une correction lorsque la vitesse est nulle');
  % EXPLICATION
  large =ltxt2; posx =round(ldiv2+(ldiv2-large)/2); haut =55; posy =Hpan3-mydroite-haut;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
            'FontSize',13, 'String','Pour les explications, placer le curseur sur un objet et attendre un peu.');
  haut =25; posy =posy-haut-2*my;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
            'FontSize',10, 'String','Un jour... dans le Wiki-GRAME');
  % AU TRAVAIL
  large =100; posx =round(ldiv2+(ldiv2-large)/2); posy =mx; haut =hbtn;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'Callback',@Ppa.AuTravail, 'String','Au travail');
  set(fig,'WindowStyle','modal');
end
