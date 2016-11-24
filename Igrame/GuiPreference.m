%
% ***INTERFACE (GUI) POUR LA GESTION DES PRÉFÉRENCES***
%
% EN ENTRÉE on aura  Ppa  -->  un objet de la classe CGuiPreference
%
function fig =GuiPreference(Ppa)
  hA =CAnalyse.getInstance();

  % on lit la structure contenant le texte à afficher selon le choix de la langue
  tt =CGuiMLPref();

  largeur =560; hauteur =475;
  posfig =positionfen('G','C',largeur,hauteur,hA.OFig.fig);
  fig =figure('Name',tt.name, 'Position',posfig, 'Resize', 'off', ...				
          'CloseRequestFcn',@Ppa.terminus, 'DefaultUIControlBackgroundColor',Ppa.couleurRef, ...
          'DefaultUIPanelBackgroundColor',Ppa.couleurRef, 'DefaultUIControlUnits','pixels', ...
          'DefaultUIPanelUnits','pixels', 'DefaultUIPanelBorderType','beveledin', 'DefaultUIControlFontUnits','pixels', ...
          'DefaultUIControlFontSize',12, 'DefaultUIPanelTitlePosition','rightbottom', ...
          'DefaultUIControlFontName','MS Sans Serif', 'DefaultUITableFontName','FixedWidth');

  % dimension pour construire le GUI
  mx =25; my =15; hbout =25; bordure =2*hbout; dx =15; dy =20; dy2 =dy-5; dy3 =dy2-5; lbout =100;
  %------------------
  % Panel des onglets
  lpan =largeur; hpan =hbout; posx =0; posy =hauteur-hpan; ppan =[posx posy lpan hpan];
  pan =uipanel('Parent',fig, 'Tag','PanelOnglet', 'title','', 'BorderType','etchedin', ...
               'Position',ppan, 'BackgroundColor',Ppa.couleurPan+0.02);
      %---------------
      % onglet Général
      letit =tt.ongen; posx =0; posy =0; large =length(letit')*6+30; haut =hpan-2;
      oGen =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], 'String',letit, ...
                      'Callback',@Ppa.showPanel, 'BackgroundColor',Ppa.couleurPan);
      %-----------------
      % onglet Affichage
      letit =tt.onaff; posx =posx+large-1; large =length(letit')*6+30;
      oAff =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], 'String',letit, ...
                      'TooltipString',tt.onafftip, 'Callback',@Ppa.showPanel);
      %-------------
      % onglet Autre
      letit =tt.onot; posx =posx+large-1; large =length(letit')*6+30;
      oAut =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], 'String',letit, ...
                      'TooltipString',tt.onottip, 'Callback',@Ppa.showPanel);
  posx =2; lpan =largeur-2*posx+1; posy =2*bordure; hpan =hauteur-posy-ppan(4); posPan =[posx posy lpan hpan];
  %--------------
  % Panel Général
  pan =uipanel('Parent',fig, 'Tag','PanelGeneral', 'title',tt.ongen, 'Position',posPan);
    set(oGen, 'Userdata',pan);
    Ppa.setCurPan(pan);
    % CONSERVER
    ecart =7; posx =mx; ldispo =lpan-2*mx-ecart; ltx =0.8; large =round(ldispo*ltx); haut =22; posy =hpan-haut-3*my;
    leTexte =tt.ongenconserv;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','conserver', 'String',leTexte, ...
              'Position',[posx posy large haut], 'Value',Ppa.conserver);
    % LANGUE DE TRAVAIL
    lttx =(1/ltx)-1; posy =posy-haut-2*my;
    leTexte =tt.ongenlang;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    uicontrol('Parent',pan, 'Tag','langue', 'Position',[posx+large+ecart posy round(large*lttx) haut], ...
              'backgroundcolor',[1 1 1], 'string',Ppa.langue, 'Style','edit');
    % DERNIERS OUVERTS
    posy =posy-haut-my;
    leTexte =tt.ongenrecent;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    uicontrol('Parent',pan, 'Tag','maxfr', 'Position',[posx+large+ecart posy round(large*lttx) haut], ...
              'backgroundcolor',[1 1 1], 'string',num2str(Ppa.maxfr), 'Style','edit');
    % DISP ERROR
    posy =posy-haut-my;
    leTexte =tt.ongenerr;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    lesChoix =tt.ongenerrmnu;
    uicontrol('Parent',pan, 'Tag','dispError', 'Position',[posx+large+ecart posy round(large*lttx) haut], ...
              'backgroundcolor',[1 1 1], 'Style','popupmenu', 'string',lesChoix , 'Value',Ppa.dispError+1);
  %________________
  % Panel Affichage
  pan =uipanel('Parent',fig, 'Tag','PanelAffichage', 'title',tt.onaff, 'Position',posPan, 'Visible','off');
    set(oAff, 'Userdata',pan);
    posx =mx; largtot =lpan-2*posx; larg1 =round(largtot*.65); larg2 =round((largtot-larg1)*.4); larg3 =largtot-larg1-larg2;
    haut =2*hbout; posy =hpan-2*haut; posx1 =mx; posx2 =posx1+larg1; posx3 =posx2+larg2;
    leTexte=tt.onafftxfix; titoffset=10; posx=posx2-titoffset;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy larg2 haut]);
    leTexte=tt.onafftxactiv; posx=posx3-titoffset;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy larg3 haut]);
    % MODE XY
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffactxy;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.xyFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','xyFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','xy', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.xy, 'Enable',char(ONOFF));
    % AFFICHER LES POINTS
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffpt;
    lesType =tt.onaffpttyp;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.ptFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','ptFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','popupmenu', 'Tag','pt', 'String',lesType, ...
              'Position',[posx posy large haut], 'Value',Ppa.pt+1, 'Enable',char(ONOFF));
    % ZOOM
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffzoom;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.zoomonoffFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','zoomonoffFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','zoomonoff', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.zoomonoff, 'Enable',char(ONOFF));
    % AFFICHER COORD
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffcoord;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.affcoordFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','affcoordFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','affcoord', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.affcoord, 'Enable',char(ONOFF));
    % ÉCHANTILLON
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffsmpl;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.ligneFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','ligneFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','ligne', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.ligne, 'Enable',char(ONOFF));
    % COULEUR CANAUX
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffccan;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colcanFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','colcanFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','colcan', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.colcan, 'Enable',char(ONOFF));
    % COLEUR ESSAIS
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffcess;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colessFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','colessFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','coless', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.coless, 'Enable',char(ONOFF));
    % COULEUR CATÉGORIE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffccat;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colcatFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','colcatFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','colcat', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.colcat, 'Enable',char(ONOFF));
    % LÉGENDE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffleg;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.legendeFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','legendeFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','legende', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.legende, 'Enable',char(ONOFF));
    % AFFICHAGE PROPORTIONNELLE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffproport;
    uicontrol('Parent',pan, 'Style','text', 'HorizontalAlignment','left', 'String',leTexte, ...
              'Position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.trichFix);
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','trichFix', 'String','', ...
              'Position',[posx posy large haut], 'Value',ONOFF, 'Callback',@Ppa.activAmigo);
    large =larg3; posx =posx3;
    uicontrol('Parent',pan, 'Style','checkbox', 'Tag','trich', 'String','', ...
              'Position',[posx posy large haut], 'Value',Ppa.trich, 'Enable',char(ONOFF));
  %_______________
  % Panel mas alla
  pan =uipanel('Parent',fig, 'Tag','PanelMasAllaRumores', 'title',tt.onot, 'Position',posPan, 'Visible','off');
    set(oAut, 'Userdata',pan);
    %_____
    % Aide
    leTexte =lireLeHelp(tt);
    posx =mx; large =lpan-2*posx; haut =hbout; posy =hpan-3*haut;
    uicontrol('Parent',pan, 'Position',[posx posy large haut], 'FontWeight','bold', ...
              'HorizontalAlignment','center', 'String',tt.onottit, 'Style','text');
    haut =posy-hbout; posy =posy-haut;
    uicontrol('Parent',pan, 'Position',[posx posy large haut], 'Max',15, 'Min',1, ...
              'HorizontalAlignment','left', 'String',leTexte, 'Style','edit', 'FontName','FixedWidth');
  %----------------
  % Panel du Status
  lpan =largeur; hpan =hbout; posx =0; posy =0;
  pan =uipanel('Parent',fig, 'Tag','PanelStatus', 'title','', 'Position',[posx posy lpan hpan], ...
               'BackgroundColor',Ppa.couleurPan, 'BorderType','beveledout');
      %-------
      % Status
      posx =dx; large =lpan-2*dx; haut =hpan;
      ss =uicontrol('Parent',pan, 'Style','text', 'position',[posx posy large haut], 'FontSize',14, ...
                    'BackgroundColor',Ppa.couleurPan, 'String','', ...
                    'Tag','TextStatus', 'HorizontalAlignment','center');
      Ppa.afficheStatus(tt.onstat);
  % AU TRAVAIL
  large =lbout; posx =round((lpan-large)/2); posy =2*haut;
  uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Callback',@Ppa.auTravail, 'String',tt.btapplic);
  set(fig,'WindowStyle','modal');
end

function t =lireLeHelp(ht)
  t ={ht.onotp1; ht.onotp2; ht.onotp3; ht.onotp4; ht.onotp5; ht.onotp6};
end