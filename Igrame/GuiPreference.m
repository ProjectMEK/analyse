%
% ***INTERFACE (GUI) POUR LA GESTION DES PRÉFÉRENCES***
%
% EN ENTRÉE on aura  Ppa  -->  un objet de la classe CPreferenceGui
%
function fig =GuiPreference(Ppa)
  hA =CAnalyse.getInstance();

  % on lit la structure contenant le texte à afficher selon le choix de la langue
  tt =CGuiMLPref();

  largeur =560; hauteur =475;
  posfig =positionfen('G','C',largeur,hauteur,hA.OFig.fig);
  fig =figure('Name',tt.name, 'position',posfig, 'Resize', 'off', ...				
          'CloseRequestFcn',{@quienllama,'terminus'}, 'DefaultUIControlBackgroundColor',Ppa.couleurRef, ...
          'DefaultUIPanelBackgroundColor',Ppa.couleurRef, 'DefaultUIControlUnits','pixels', ...
          'DefaultUIPanelUnits','pixels', 'DefaultUIPanelBorderType','beveledin', 'DefaultUIControlFontUnits','pixels', ...
          'DefaultUIControlFontSize',11, 'DefaultUIPanelTitlePosition','rightbottom', ...
          'DefaultUIControlFontName','MS Sans Serif'); % , 'DefaultUITableFontName','FixedWidth');

  % dimension pour construire le GUI
  mx =25; my =15; hbout =25; bordure =2*hbout; dx =15; dy =20; dy2 =dy-5; dy3 =dy2-5; lbout =100;
  %------------------
  % Panel des onglets
  lpan=largeur;hpan=hbout;posx=0;posy=hauteur-hpan;ppan=[posx posy lpan hpan];suppL=30;
  pan =uipanel('parent',fig, 'tag','PanelOnglet', 'title','', 'BorderType','etchedin', ...
               'position',ppan, 'BackgroundColor',Ppa.couleurPan+0.02);
      %---------------
      % onglet Général
      letit =tt.ongen; posx =0; posy =0; large =suppL; haut =hpan-2;  % length(letit')*6+30;
      oGen =uicontrol('parent',pan, 'tag','BoutonOnglet', 'position',[posx posy large haut], 'string',letit, ...
                      'callback',{@quienllama,'showPanel'}, 'BackgroundColor',Ppa.couleurPan);
      Lreel =get(oGen,'extent');
      large =Lreel(3)+suppL;
      set(oGen,'position',[posx posy large haut]);
      %-----------------
      % onglet Affichage
      letit =tt.onaff; posx =posx+large-1; large =suppL; % length(letit')*6+30;
      oAff =uicontrol('parent',pan, 'tag','BoutonOnglet', 'position',[posx posy large haut], 'string',letit, ...
                      'TooltipString',tt.onafftip, 'callback',{@quienllama,'showPanel'});
      Lreel =get(oAff,'extent');
      large =Lreel(3)+suppL;
      set(oAff,'position',[posx posy large haut]);
      %-------------
      % onglet Autre
      letit =tt.onot; posx =posx+large-1; large =suppL; % length(letit')*6+30;
      oAut =uicontrol('parent',pan, 'tag','BoutonOnglet', 'position',[posx posy large haut], 'string',letit, ...
                      'TooltipString',tt.onottip, 'callback',{@quienllama,'showPanel'});
      Lreel =get(oAut,'extent');
      large =Lreel(3)+suppL;
      set(oAut,'position',[posx posy large haut]);
  posx =2; lpan =largeur-2*posx+1; posy =2*bordure; hpan =hauteur-posy-ppan(4); posPan =[posx posy lpan hpan];
  %--------------
  % Panel Général
  pan =uipanel('parent',fig,'tag','PanelGeneral','title',tt.ongen,'position',posPan);
    set(oGen, 'userdata',pan);
    Ppa.setCurPan(pan);
    % CONSERVER
    ecart =7; posx =mx; ldispo =lpan-2*mx-ecart; ltx =0.75; large =round(ldispo*ltx); haut =22; posy =hpan-haut-3*my;
    leTexte =tt.ongenconserv;
    uicontrol('parent',pan,'style','checkbox','tag','conserver','string',leTexte,...
              'position',[posx posy large haut],'fontsize',10,'value',Ppa.conserver);
    % LANGUE DE TRAVAIL
    lttx =(1/ltx)-1; posy =posy-haut-2*my;
    leTexte =tt.ongenlang;
    uicontrol('parent',pan,'style','text','horizontalalignment','left','fontsize',10,...
              'string',leTexte,'position',[posx posy large haut]);
    uicontrol('parent',pan,'tag','langue','position',[posx+large+ecart posy round(large*lttx) haut], ...
              'backgroundcolor',[1 1 1],'string',Ppa.langue,'style','edit');
    % DERNIERS OUVERTS
    posy =posy-haut-my;
    leTexte =tt.ongenrecent;
    uicontrol('parent',pan,'style','text','horizontalalignment','left','fontsize',10,...
              'string',leTexte,'position',[posx posy large haut]);
    uicontrol('parent',pan, 'tag','maxfr', 'position',[posx+large+ecart posy round(large*lttx) haut], ...
              'backgroundcolor',[1 1 1], 'string',num2str(Ppa.maxfr), 'style','edit');
    % DISP ERROR
    posy =posy-haut-my;
    leTexte =tt.ongenerr;
    uicontrol('parent',pan,'style','text','horizontalalignment','left','fontsize',10,...
              'string',leTexte,'position',[posx posy large haut]);
    lesChoix =tt.ongenerrmnu;
    uicontrol('parent',pan,'position',[posx+large+ecart posy round(large*lttx) haut],...
              'tag','dispError','fontsize',9,'backgroundcolor',[1 1 1],...
              'style','popupmenu','string',lesChoix ,'value',Ppa.dispError+1);
  %________________
  % Panel Affichage
  pan =uipanel('parent',fig, 'tag','PanelAffichage', 'title',tt.onaff, 'position',posPan, 'Visible','off');
    set(oAff, 'userdata',pan);
    posx =mx; largtot =lpan-2*posx; larg1 =round(largtot*.6); larg2 =round((largtot-larg1)*.35); larg3 =largtot-larg1-larg2;
    haut =2*hbout; posy =hpan-2*haut; posx1 =mx; posx2 =posx1+larg1; posx3 =posx2+larg2;
    leTexte=tt.onafftxfix; titoffset=10; posx=posx2-titoffset;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy larg2 haut]);
    leTexte=tt.onafftxactiv; posx=posx3-titoffset;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy larg3 haut]);
    % MODE XY
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffactxy;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.xyFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','xyFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.xyFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','xy', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.xy, 'enable',char(ONOFF));
    % AFFICHER LES POINTS
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffpt;
    lesType =tt.onaffpttyp;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.ptFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','ptFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.ptFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan,'style','popupmenu','tag','pt','string',lesType,'fontsize',9,...
              'position',[posx posy large haut], 'value',Ppa.pt+1, 'enable',char(ONOFF));
    % ZOOM
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffzoom;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.zoomonoffFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','zoomonoffFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.zoomonoffFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','zoomonoff', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.zoomonoff, 'enable',char(ONOFF));
    % AFFICHER COORD
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffcoord;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.affcoordFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','affcoordFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.affcoordFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','affcoord', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.affcoord, 'enable',char(ONOFF));
    % ÉCHANTILLON
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffsmpl;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.ligneFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','ligneFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.ligneFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','ligne', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.ligne, 'enable',char(ONOFF));
    % COULEUR CANAUX
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffccan;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colcanFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','colcanFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.colcanFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','colcan', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.colcan, 'enable',char(ONOFF));
    % COLEUR ESSAIS
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffcess;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colessFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','colessFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.colessFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','coless', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.coless, 'enable',char(ONOFF));
    % COULEUR CATÉGORIE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffccat;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.colcatFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','colcatFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.colcatFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','colcat', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.colcat, 'enable',char(ONOFF));
    % LÉGENDE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffleg;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.legendeFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','legendeFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.legendeFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','legende', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.legende, 'enable',char(ONOFF));
    % AFFICHAGE PROPORTIONNELLE
    haut =hbout; large =larg1; posx =posx1; posy =posy-haut;
    leTexte =tt.onaffproport;
    uicontrol('parent',pan, 'style','text', 'horizontalalignment','left', 'string',leTexte, ...
              'position',[posx posy large haut]);
    large =larg2; posx =posx2;
    ONOFF =CEOnOff(Ppa.trichFix);
    uicontrol('parent',pan, 'style','checkbox', 'tag','trichFix', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.trichFix, 'callback',{@quienllama,'activAmigo'});
    large =larg3; posx =posx3;
    uicontrol('parent',pan, 'style','checkbox', 'tag','trich', 'string','', ...
              'position',[posx posy large haut], 'value',Ppa.trich, 'enable',char(ONOFF));
  %_______________
  % Panel mas alla
  pan =uipanel('parent',fig, 'tag','PanelMasAllaRumores', 'title',tt.onot, 'position',posPan, 'Visible','off');
    set(oAut, 'userdata',pan);
    %_____
    % Aide
    leTexte =lireLeHelp(tt);
    posx =mx; large =lpan-2*posx; haut =hbout; posy =hpan-3*haut;
    uicontrol('parent',pan, 'position',[posx posy large haut], 'FontWeight','bold', ...
              'horizontalalignment','center', 'string',tt.onottit, 'style','text');
    haut =posy-hbout; posy =posy-haut;
    uicontrol('parent',pan, 'position',[posx posy large haut], 'Max',15, 'Min',1, ...
              'horizontalalignment','left', 'string',leTexte, 'style','edit', 'FontName','FixedWidth');
  %----------------
  % Panel du Status
  lpan =largeur; hpan =hbout; posx =0; posy =0;
  pan =uipanel('parent',fig, 'tag','PanelStatus', 'title','', 'position',[posx posy lpan hpan], ...
               'BackgroundColor',Ppa.couleurPan, 'BorderType','beveledout');
      %-------
      % Status
      posx =dx; large =lpan-2*dx; haut =hpan;
      ss =uicontrol('parent',pan, 'style','text', 'position',[posx posy large haut], 'FontSize',14, ...
                    'BackgroundColor',Ppa.couleurPan, 'string','', ...
                    'tag','TextStatus', 'horizontalalignment','center');
      Ppa.afficheStatus(tt.onstat);
  % AU TRAVAIL
  large =lbout; posx =round((lpan-large)/2); posy =2*haut;
  uicontrol('parent',fig, 'position',[posx posy large haut], 'callback',{@quienllama,'auTravail'}, 'string',tt.btapplic);
  setappdata(fig,'Ppa',Ppa);
  set(fig,'WindowStyle','modal');
end

%-----------------------------------------
% Callback des différents uicontrol du GUI
% on call la method "Ppa.(autre)"
%-----------------------------------------
function quienllama(src,evt, autre)
  Ppa =getappdata(gcf,'Ppa');
  try
    switch autre
    case 'terminus'
      Ppa.terminus();
    case 'showPanel'
      Ppa.showPanel(src);
    case 'activAmigo'
      Ppa.activAmigo(src);
    case 'auTravail'
      Ppa.auTravail();
    end
  catch ss;
    set(Ppa.fig,'WindowStyle','normal');
  end
end

function t =lireLeHelp(ht)
  t ={ht.onotp1; ht.onotp2; ht.onotp3; ht.onotp4; ht.onotp5; ht.onotp6};
end