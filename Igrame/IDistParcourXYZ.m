%
% Interface (GUI) pour demander les paramètres du calcul de distance parcourue
%
% EN ENTRÉE on a  Ppa --> un objet de la classe CDistParcourXYZ
%
function fig =IDistParcourXYZ(Ppa)
  hA =CAnalyse.getInstance();
  Ofich =hA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  Lfen =300; Hfen =450;
  posfig =positionfen('G','C',Lfen,Hfen,hA.OFig.fig);
  lalista ={'Intervalle entier','Intervalle à déterminer'};
  fig = figure('Name', 'MENU DISTANCE PARCOURUE', 'Position',posfig, ...				
          'CloseRequestFcn',@Ppa.Terminus, 'Resize', 'off',...
          'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
          'DefaultUIControlunits','pixels', 'DefaultUIControlFontSize',10);
  db1 =5; db2 =38; db3 =50; offsetxt =3;
  % TITRE
  posx =db1; haut =30; posy =Hfen-haut-10; large =Lfen-2*posx;
  uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy large haut], 'HorizontalAlignment','center',...
          'String','Choix des canaux pour le calcul de la distance', 'Style','text');
  % CANAL X
  posx =db2; posy =posy-haut-10; haut =25; large =10;
  uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy-offsetxt large haut],...
          'HorizontalAlignment','left', 'String','X', 'Style','text');
  posx =db3; large =Lfen-2*posx;
  uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
          'String',hdchnl.adname, 'Min',1, 'Style','popupmenu', ...	
          'Value',Ppa.canX, 'callback',@Ppa.ChangeX);				       
  % CANAL Y
  posx =db2; posy =posy-haut-10; large =10;
  uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy-offsetxt large haut],...
          'HorizontalAlignment','left', 'String','Y', 'Style','text');
  posx =db3; large =Lfen-2*posx;
  uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
          'String',hdchnl.adname, 'Min',1, 'Style','popupmenu', ...	
          'Value',Ppa.canY, 'callback',@Ppa.ChangeY);				       
  % CANAL Z
  posx =db2; posy =posy-haut-10; large =10;
  uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy-offsetxt large haut],...
          'HorizontalAlignment','left', 'String','Z', 'Style','text');
  posx =db3; large =Lfen-2*posx;
  V{1} ='Calcul 2D seulement';
  V(2:length(hdchnl.adname)+1) =hdchnl.adname;
  uicontrol('Parent',fig, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut],...
          'String',V, 'Min',1, 'Style','popupmenu',...
          'Value',Ppa.canZ+1, 'callback',@Ppa.ChangeZ);
  % INTERVALLE
  large =150; posx =round((Lfen-large)/2); posy =posy-haut-20;
  uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[posx posy large haut], ...
          'String','Intervalle de calcul:', 'Style','text', 'HorizontalAlignment','center');
  posy =posy-haut; retourY =posy;
  uicontrol('Parent',fig, 'Position',[posx posy large haut], 'FontSize',9, 'String',lalista,...
          'Style','popupmenu', 'Value',Ppa.Interv, 'callback',@Ppa.ChangeInterv);
  % PANEL 1
  Lpan =Lfen-2*db1; espV =5; Hpan =posy-2*espV;
  haut =Hpan; posx =db1; posy =espV; large =Lpan;
  pan =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut],...
               'DefaultUIControlBackgroundColor',[0.8 0.8 0.8]);
  Ppa.Pan1 =pan;
  % AU TRAVAIL
  large =100; posx =round((Lpan-large)/2); posy =floor(Hpan/2); haut =25;
  uicontrol('Parent',pan, 'tag','AuTravailHOP', 'Callback',@Ppa.AuTravail,...
            'Position',[posx posy large haut], 'String','Au travail');
  % COMMENTAIRE
  haut =30; posy =posy-haut-3*espV; colores =get(pan, 'BackgroundColor');
  uicontrol('Parent',pan, 'FontSize',9, 'Position',[25 posy 250 haut], 'Style','text', 'BackgroundColor',colores,...
          'String','Mesure la distance absolue de la trajectoire en fonction du temps');
  % PANEL 2
  haut =Hpan; posx =db1; posy =espV; large =Lpan;
  pan =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut],...
               'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], 'visible','off');
  Ppa.Pan2 =pan;
  db4 =floor(Lpan*0.05);
  % TITRE
  posx =db4; large =Lpan-2*posx; haut =15; posy =Hpan-haut-10; retourY =posy;
  uicontrol('Parent',pan, 'FontWeight','bold', 'Position',[posx posy large haut], 'HorizontalAlignment','left',...
          'String','Canal des points marqués', 'BackgroundColor',colores, 'Style','text');
  % CANAL DES POINTS
  large =floor(Lpan*0.5); haut =floor(Hpan*.6); posy =posy-haut-5;
  lescan ={'CANAL-X','CANAL-Y','CANAL-Z'};
  lescan(4:length(hdchnl.adname)+3) =hdchnl.adname;
  uicontrol('Parent',pan, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut], ...
          'String',lescan, 'Min',1, 'Style','listbox', 'callback',@Ppa.ChangeCanPoint, 'Value',Ppa.lecan);
  % TITRE NO POINT
  posx =posx+large+db4; large =3*db4; haut =15; posy =retourY-haut-5;
  uicontrol('Parent',pan, 'FontSize',11, 'Position',[posx posy large haut], 'BackgroundColor',colores, ...
          'String','Début', 'Style','text', 'HorizontalAlignment','left');
  uicontrol('Parent',pan, 'FontSize',11, 'Position',[posx+large+db4 posy large haut], 'BackgroundColor',colores, ...
          'String','Fin', 'Style','text', 'HorizontalAlignment','left');
  % CHOIX DES POINTS
  haut =floor(Hpan*.53); posy =posy-haut;
  Ppa.Pt1 =uicontrol('Parent',pan, 'BackgroundColor',[1 1 1], 'Position',[posx posy large haut], ...
          'String',{'...'}, 'Min',1, 'max',1, 'Style','listbox', 'Value',1);
  Ppa.Pt2 =uicontrol('Parent',pan, 'BackgroundColor',[1 1 1], 'Position',[posx+large+db4 posy large haut], ...
          'String',{'...'}, 'Min',1, 'max',1, 'Style','listbox', 'Value',1);
  % AU TRAVAIL
  large =100; posx=round((Lpan-large)/2); haut =25; posy=posy-haut-20;
  uicontrol('Parent',pan, 'tag','AuTravailHOP', 'Callback',@Ppa.AuTravail, ...
         'Position',[posx posy large haut], 'String','Au travail');
  set(fig,'WindowStyle','modal');
end
