%
% INTERFACE (GUI) POUR LE MARQUAGE AUTOMATIQUE
%
%  Exp.    --> Exporter d'un canal à l'autre
%  Min.    --> Le Min, Le Max
%  Monté.  --> Montée, descente
%  Temps.  --> Marquage Temporel
%  Amplit. --> Marquage d'amplitude
%  Emg.    --> Marquage Emg
%  Bidon   --> Insérer point Bidon
%  Test    --> fonction test ou à l'essai
%_________________________________________________
function tt = GuiMark(Ppa)
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;

  %______________________________________________________________________________
  % on lit la structure contenant le texte à afficher selon le choix de la langue
  %------------------------------------------------------------------------------
  tt =CGuiMLMark();

  Ppa.prepareWmhVg(vg);
  vg.valeur =1;
  Ofich.lesess();
  Ofich.lescats();
  if vg.ess > 2;letopess =vg.ess;else letopess =vg.ess+1;end
  lapos =get(findobj('tag','IpTraitement'),'position').*[1 1 1 1.03];
  lafig =figure('Name',tt.name, 'tag','WmFig', 'units','normalized', 'Position',lapos, ...
                'DefaultUIPanelTitlePosition','rightbottom', ...
                'defaultAxesColor',[1 1 1], 'defaultAxesunits','normalized',...
                'CloseRequestFcn',@Ppa.fermer, 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','normalized', 'DefaultUIControlFontSize',11,...
                'DefaultUIPanelBackgroundColor',Ppa.couleurRef, 'Resize', 'on');
  OA.OFig.mkfig =lafig;
  Ppa.fig =lafig;
  set(OA.OFig.fig,'visible','off');
  %_______________________________________________
  % PANEL PERMANENT
  lframe1 =0.44; ligne =0.00625; xframe1 =2*ligne; epais1 =0.033; epais2 =0.0416;
  hframe1 =0.36; yframe1 =1-hframe1-epais1; pPan =[xframe1 yframe1 lframe1 hframe1];
  lePan =uipanel('Parent',lafig,  'Position',pPan, 'title','');
  lAid =0.04; hAid =0.1;
  uicontrol('Parent',lePan, 'Position',[1-lAid 1-hAid lAid hAid], 'string',tt.ppaid, ...
            'TooltipString',tt.ppaidtip, 'backgroundcolor',[1 1 0],...
            'callback','web(''http://mouvement.kin.ulaval.ca/kinetu/index.php/Analyse#Marquer'')');
  %_______________________________________________
  % CANAL SOURCE
  M1 =0.01; M2 =2*M1; M3 =3*M1; M4 =4*M1; M5 =5*M1;
  L1 =0.5; L2 =0.15; L3 =1-(2*M2+M1+M3+L1+L2);
  L4 =L1+M1+L2; hLB =0.6; hBt =0.1; hEd =0.1;
  large =L1; haut =hEd; posx =M2; posy =1-haut-2*M2;
  uicontrol('Parent',lePan, 'Tag','TitreCanSrc', 'FontWeight','bold',...
            'Position',[posx posy large haut], 'String',tt.ppcansrc, 'Style','text');
  leY =posy-hLB;
  uicontrol('Parent',lePan, 'Tag','LBCanSrc', 'BackgroundColor',[1 1 1], 'Style','listbox', ...
            'Position',[posx leY large hLB], 'Callback',@Ppa.canelli, ...
            'String',hdchnl.Listadname, 'Min',1, 'Max',vg.nad, 'Value',Ppa.wmh.canSrc);
  %_______________________________________________
  % EFFACER DES POINTS
  posx =posx+large+M1; large =L2;
  uicontrol('Parent',lePan, 'FontWeight','bold', 'Position',[posx posy large haut], ...
            'String',tt.ppptsmrk, 'Style','text');

  % _____________________________________________________________________________________
  % ON VA CONSULTER LE NOMBRE MAX DE POINT QUE L'ON A POUR LES CANAUX/ESSAIS SÉLECTIONNÉS
  % -------------------------------------------------------------------------------------
  ptotal =max(max(hdchnl.npoints(Ppa.wmh.canSrc,:)));
  if ptotal
    for ii =ptotal:-1:1
      lespts{ii} =num2str(ii);
    end
  else
    lespts =['...'];
  end
  uicontrol('Parent',lePan, 'Tag','LBpts', 'BackgroundColor',[1 1 1], ...
            'Position',[posx leY large hLB], 'String',lespts, 'Style','listbox', 'Value',1);

  posx =posx+large+M3; haut =hBt; posy =posy-haut; large =L3;
  uicontrol('Parent',lePan, 'Tag','CBtodosPuntos', 'Position',[posx posy large haut], ...
            'FontSize',9, 'String',tt.ppdelptall, 'Style','checkbox', 'Value',0, ...
            'TooltipString',tt.ppdelptalltip);
  haut =hEd; posy =posy-haut;
  uicontrol('Parent',lePan, 'Tag','EnumPts', 'Style','edit', ...
            'Position',[posx posy large haut], 'backgroundcolor',[1 1 1],...
            'TooltipString',tt.ppdelenumtip);
  haut =hBt;posy =posy-haut;
  uicontrol('Parent',lePan, 'Tag','CBcacherPts', 'Style','checkbox', ...
            'Position',[posx posy large haut], 'FontSize',9, 'String',tt.ppdelpthide, 'Value',0, ...
            'TooltipString',tt.ppdelpthidetip);
  posy =leY-haut; oter =0.04;
  uicontrol('Parent',lePan, 'Callback',@Ppa.suppression, 'FontWeight','bold',...
            'Position',[posx+oter posy large-2*oter haut], 'String',tt.ppdelbutton, ...
            'TooltipString',tt.ppdelbuttontip, 'FontSize',10);
  posx =M2; large =L4;
  uicontrol('Parent',lePan, 'Tag','CBessCat', 'HorizontalAlignment','left', ...
            'Position',[posx posy large haut], 'Callback',@Ppa.activEss, 'Style','checkbox', ...
            'FontSize',9, 'Value',Ppa.wmh.parEss, 'String',tt.ppesscat, ...
            'TooltipString',tt.ppesscattip);
  posy =posy-haut-M1;
  uicontrol('Parent',lePan, 'Tag','CBremplacePts', 'String',tt.ppreplace, ...
            'Position',[posx posy large haut], 'FontSize',9, 'Value',0, ...
            'HorizontalAlignment','left', 'Style','checkbox', ...
            'TooltipString',tt.ppreplacetip);
  %_______________________________________________
  % AXE
  posx =0.5;large =1-posx-3*ligne;foo =0.04; posy =0.4+foo; haut =0.55-foo;
  Ppa.Axe =axes('Parent',lafig, 'CameraUpVector',[0 1 0], 'CameraUpVectorMode','manual', ...
          'DrawMode','fast', 'Position',[posx posy large haut], 'XColor',[0 0 0], 'YColor',[0 0 0]);
  %_______________________________________________
  % AFFICHE LES ESSAIS
  haut=posy-2.5*epais1-epais2-foo;posy=posy-1.5*epais1-haut;large=(large-3*ligne)/2;
  uicontrol('Parent',lafig, 'BackgroundColor',[1 1 1], 'Tag','LBQuelEss', ...
          'Position',[posx posy large haut], 'Callback',@Ppa.reaffiche, 'String',vg.lesess, ...
          'Min',1, 'Max',letopess, 'Style','listbox', 'Value',Ppa.wmh.tri);
  %_______________________________________________
  % AFFICHE LES CATÉGORIES
  uicontrol('Parent',lafig, 'Tag','LBQuelCat', 'BackgroundColor',[1 1 1], 'Style','listbox', 'Min',1, ...
            'Position',[posx+large+3*ligne posy large haut], 'Callback',@Ppa.categos, 'Enable','off');
  Ppa.showLesCat(vg);
  %_______________________________________________
  % AU TRAVAIL
  haut =epais2;posy =posy-0.5*epais1-haut;large =large*0.5;
  uicontrol('Parent',lafig, 'Callback',@Ppa.travail, 'FontWeight','bold',...
            'FontSize',9, 'Position',[posx posy large haut], 'String',tt.buttonGo);
  %_______________________________________________
  % Panel des onglets
  lpan =lframe1; hpan =0.04; posx =pPan(1); posy =pPan(2)-hpan-M1; ppan =[posx posy lpan hpan];
  pan =uipanel('Parent',lafig, 'Tag','PanelOnglet', 'title','', 'Position',ppan); %, 'BackgroundColor',Ppa.couleurPan+0.02);
  marg1 =0.02; marg2 =2*marg1; titX =0.018; titPlus =0.03; % =0.02;=.0275
      foncLtit =@(NOM) length(NOM)*titX+titPlus;
      %___________________________________________
      % onglet Exportation
      posx =0; posy =marg1; large =foncLtit(tt.poexpletit); haut =1-marg2;
      o1 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.poexpletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'BackgroundColor',Ppa.couleurPan, 'TooltipString',tt.poexpletittip);
      %___________________________________________
      % onglet MinMax
      letit ='Min.'; posx =posx+large; large =foncLtit(tt.pominletit);
      o2 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], 'String',tt.pominletit, ...
                    'FontSize',10, 'Callback',@Ppa.showPanel, 'TooltipString',tt.pominletittip);
      %___________________________________________
      % onglet Monté...
      posx =posx+large; large =foncLtit(tt.pomonteletit);
      o3 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.pomonteletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.pomonteletittip);
      %___________________________________________
      % onglet Temporel
      posx =posx+large; large =foncLtit(tt.potmpletit);
      o4 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.potmpletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.potmpletittip);
      %___________________________________________
      % onglet Amplitude
      posx =posx+large; large =foncLtit(tt.poampletit);
      o5 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.poampletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.poampletittip);
      %___________________________________________
      % onglet Emg
      posx =posx+large; large =foncLtit(tt.poemgletit);
      o6 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.poemgletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.poemgletittip);
      %___________________________________________
      % onglet Bidon
      posx =posx+large; large =foncLtit(tt.pobidletit);
      o7 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.pobidletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.pobidletittip);
      %___________________________________________
      % onglet test... changement dans le signal
      posx =posx+large; large =foncLtit(tt.potestletit);
      o8 =uicontrol('Parent',pan, 'Tag','BoutonOnglet', 'Position',[posx posy large haut], ...
                    'String',tt.potestletit, 'FontSize',10, 'Callback',@Ppa.showPanel, ...
                    'TooltipString',tt.potestletittip);
  %_______________________________________________
  %*****VARIABLES COMMUNES AUX PANEL*****
  %--------------------------------------
  ppan(4)=ppan(2)-epais1-marg1; ppan(2) =ppan(2)-ppan(4);
  hBout =0.075; leTag ='PanelExport';
  %_______________________________________________
  % Panel Export
  pan =uipanel('Parent',lafig, 'Tag',leTag, 'title',tt.poexpnom, 'Position',ppan, ...
               'BorderType','beveledin');
    set(o1, 'Userdata',pan);
    %_____________________________________________
    % ON SET CE PANEL COMME PREMIER PANEL ACTIF
    Ppa.setCurPan(pan);
    Ppa.setCurPanTag(leTag);
    posy =0.85; haut =hBout; posx =M5;
    uicontrol('Parent',pan, 'Tag','CBCanSrcCanDSt', 'Position',[posx posy 1-2*posx haut], ...
              'FontSize',9, 'HorizontalAlignment','left', 'Style','checkbox', 'Value',0, ...
              'String',tt.poexpcorr, 'TooltipString',tt.poexpcorrtip);
    letop =vg.nad;
    if letop == 2;letop =3;end
    %_____________________________________________
    % CANAL DESTINATION
    large =0.75; posx =(1-large)/2; posy =posy-haut-0.05;
    uicontrol('Parent',pan, 'Tag','TTitreDst', 'FontWeight','bold', 'Style','text', ...
              'Position',[posx posy large haut], 'String',tt.poexpcandst);
    haut =0.5; posy =posy-haut;
    uicontrol('Parent',pan, 'Tag','LBCanDst', 'BackgroundColor',[1 1 1], ...
              'Position',[posx posy large haut], 'String',hdchnl.Listadname, 'Min',1, 'Max', ...
              letop, 'Style','listbox', 'Value',Ppa.wmh.canDst, 'CallBack',@Ppa.changeCanDst);
  %_______________________________________________
  % Panel Min Max
  pan =uipanel('Parent',lafig, 'Tag','PanelMinMax', 'title',tt.pominnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o2, 'Userdata',pan);
    %_____________________________________________
    % MIN
    COMO =2.5*M2; haut =hBout; posx =M4; large =(1-4*posx)/3; posy =1-haut-COMO;
    uicontrol('Parent',pan, 'Tag','CBMin', 'Position',[posx posy large haut], ...
              'HorizontalAlignment','left', 'String',tt.pominmin, 'Style','checkbox', 'Value',0);
    %_____________________________________________
    % MAX
    posx =posx+large+2*posx;
    uicontrol('Parent',pan, 'Tag','CBMax', 'Position',[posx posy large haut], ...
              'HorizontalAlignment','left', 'String',tt.pominmax, 'Style','checkbox', 'Value',0);
    faireCanExtra(Ppa, pan, M2, M3, M5, hBout, hdchnl, vg, true, tt);
  %_______________________________________________
  % Panel Montée Descente
  pan =uipanel('Parent',lafig, 'Tag','PanelMontee', 'title',tt.pomontenom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o3, 'Userdata',pan);
    %_____________________________________________
    % MONTÉE
    ecart =M4; Mx =2*ecart; posx =Mx; larg1 =(1-6*ecart)/3; large =larg1; haut =hBout; posy =1-haut-.75*COMO;
    uicontrol('Parent',pan, 'Tag','TMontee', 'Position',[posx posy large haut], 'Style','text',...
              'HorizontalAlignment','left', 'String',tt.pomontemnt);
    %_____________________________________________
    % DÉBUT
    uicontrol('Parent',pan, 'Tag','CBMonteDebut', 'Position',[posx posy-haut large haut], 'Value',0, ...
              'HorizontalAlignment','left', 'String',tt.pomontedbt, 'Style','checkbox');
    %_____________________________________________
    % FIN
    uicontrol('Parent',pan, 'Tag','CBMonteFin', 'Position',[posx posy-2*haut large haut], 'Value',0, ...
              'HorizontalAlignment','left', 'String',tt.pomontefin, 'Style','checkbox');
    My =M1;
    %_____________________________________________
    % NOMBRE DE RÉPÉTITION
    %nombDeRepet(pan, Mx/8, My, posy-2.25*haut, haut, tt);
    nombDeRepet(pan, Mx, My, posy-2.25*haut, haut, tt);
    posx =posx+large+ecart;
    %_____________________________________________
    % DESCENTE
    uicontrol('Parent',pan, 'Tag','TDescente', 'HorizontalAlignment','left', ...
              'Position',[posx posy large haut], 'Style','text', 'String',tt.pomontedsc);
    %_____________________________________________
    % DÉBUT
    uicontrol('Parent',pan, 'Tag','CBDescenteDebut', 'HorizontalAlignment','left', 'Style','checkbox', ...
              'Position',[posx posy-haut large haut], 'String',tt.pomontedbt, 'Value',0);
    %_____________________________________________
    % FIN
    uicontrol('Parent',pan, 'Tag','CBDescenteFin', 'Position',[posx posy-2*haut large haut], ...
              'HorizontalAlignment','left', 'String',tt.pomontefin, 'Style','checkbox', 'Value',0);
    %_____________________________________________
    % DELTA Y
    posx =Mx; posy =posy-5.5*haut; larg1 =(1-4*Mx)/7; larg2 =larg1*2; large =larg2;
    corrY =M2;
    uicontrol('Parent',pan, 'Tag','TDeltaY', 'Position',[posx posy large haut-corrY], ...
              'Style','text', 'String',tt.pomontedytxt, 'TooltipString',tt.pomontedytxttip);
    uicontrol('Parent',pan, 'Tag','SDeltaY', 'Position',[posx posy-haut large haut], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','0', 'TooltipString',tt.pomontedytip);
    posx =posx+large;
    %_____________________________________________
    % DELTA X
    uicontrol('Parent',pan, 'Tag','TDeltaX', 'Position',[posx posy large haut-corrY], ...
              'Style','text', 'String',tt.pomontedxtxt, 'TooltipString',tt.pomontedxtxttip);
    uicontrol('Parent',pan, 'Tag','SDeltaX', 'Position',[posx posy-haut large haut], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','0', ...
              'TooltipString',tt.pomontedxtip);
    %_____________________________________________
    % DELTA T
    posx =posx+large+Mx;
    uicontrol('Parent',pan, 'Tag','TDeltaT', 'Position',[posx posy large haut-corrY], ...
              'Style','text', 'String',tt.pomontedttxt, ...
              'TooltipString',tt.pomontedttxttip);
    uicontrol('Parent',pan, 'Tag','SDeltaT', 'Position',[posx posy-haut large haut], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','3', ...
              'TooltipString',tt.pomontedttip);
    %_____________________________________________
    % VALEUR PAR DÉFAUT
    posx =posx+large+Mx; large =larg1; posy =posy-haut;
    uicontrol('Parent',pan, 'Tag','ValParDef', 'Callback',@Ppa.valpardef, 'FontSize',9, ...
              'TooltipString',tt.pomontedeftip, 'FontWeight','bold', ...
              'Position',[posx posy large haut], 'String',tt.pomontedef);
  %_______________________________________________
  % Panel Marquage temporel
  pan =uipanel('Parent',lafig, 'Tag','PanelTemporel', 'title',tt.potmpnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o4, 'Userdata',pan);
    %_____________________________________________
    % MARQUAGE TEMPOREL
    Mx =2*M5; My =M1; posx =Mx; haut =hBout; posy =1-haut-COMO; larg1 =(1-2*Mx)/4;
    larg2 =larg1*3; large =larg2;
    uicontrol('Parent',pan, 'Tag','TMarkTemp', 'Position',[posx posy large haut], ...
              'horizontalalignment','right', 'String',tt.potmpvaltxt, 'Style','text');
    %_____________________________________________
    % TEMPS À MARQUER
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Style', 'edit', 'Tag','SMarkTemp', 'TooltipString',tt.potmpvaltip,...
              'backgroundcolor',[1 1 1], 'Position',[posx posy large haut]);
    %_____________________________________________
    % INTERVALE POUR LES PTS SUBSÉQUENT
    posx =Mx; posy =posy-haut-My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TMarkTempInt', 'Position',[posx posy large haut], 'Style','text', ...
              'horizontalalignment','right', 'String',tt.potmpstep);
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SMarkTempInt', 'Style','edit', 'String','0', ...
              'TooltipString',tt.potmpsteptip, ...
              'backgroundcolor',[1 1 1], 'Position',[posx posy large haut]);
    nombDeRepet(pan, Mx, My, posy, haut, tt);
  %_______________________________________________
  % Panel Marquage d'amplitude
  pan =uipanel('Parent',lafig, 'Tag','PanelAmplitude', 'title',tt.poampnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o5, 'Userdata',pan);
    %_____________________________________________
    % MARQUER UNE AMPLITUDE PRÉCISE
    Mx =2*M5; My =M1; posx =Mx; haut =hBout; posy =1-haut-COMO; larg1 =(1-2*Mx)/4;
    larg2 =larg1*3; large =larg2;
    uicontrol('Parent',pan, 'Tag','TAmplit', 'Position',[posx posy large haut], ...
              'String',tt.poampvaltxt, 'horizontalalignment','right', 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SAmplitRef', 'Style','edit', 'backgroundcolor',[1 1 1],...
              'TooltipString',tt.poampvaltip, ...
   	          'Position', [posx posy large haut], 'String', '0');
    posx =Mx; posy =posy-haut-My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TAmplitRefPc', 'Position',[posx posy large haut], ...
              'String',tt.poamppcenttxt, 'horizontalalignment','right', 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SAmplitRefPc', 'Style', 'edit', 'backgroundcolor',[1 1 1],...
   	          'Position', [posx posy large haut], 'String', '100', ...
              'TooltipString',tt.poamppcenttip);
    posx =Mx; posy =posy-haut-My; large =larg2;
    uicontrol('Parent',pan,  'Style','text', 'Tag','TAmplitDelai', 'horizontalalignment','right', ...
   	          'Position',[posx posy large haut], 'String',tt.poampdectxt);
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Style','edit', 'Tag','SAmplitDelai', 'backgroundcolor',[1 1 1],...
              'TooltipString',tt.poampdectip,...
   	          'Position',[posx posy large haut], 'String','0');
    %_____________________________________________
    % DIRECTION
    posx =Mx; posy =posy-haut-2*My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TDirection', 'Position',[posx posy large haut], ...
              'horizontalalignment','right', 'String',tt.poampdirtxt, 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','PuMDirection', 'BackgroundColor',[1 1 1], 'Value',1, ...
              'Position',[posx posy large haut], 'String',tt.poampdir, 'Style','popupmenu', ...
              'TooltipString',tt.poampdirtip);
    nombDeRepet(pan, Mx, My, posy, haut, tt);
  %_______________________________________________
  % Panel Marquage activité EMG
  pan =uipanel('Parent',lafig, 'Tag','PanelEmg', 'title',tt.poemgnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o6, 'Userdata',pan);
    %_____________________________________________
    % Référence/Documentation
    Mx =2*M5; My =M1; haut =hBout; posy =1-haut-COMO; larg1 =(1-2*Mx)/4;
    larg2 =larg1*3; large =larg1; posx =(1-large)/2;
    uicontrol('Parent',pan, 'Tag','MontrerRef', 'Position',[posx posy large haut], ...
              'String',tt.poemgrefdoc, 'horizontalalignment','center', 'Callback',@quiEstLeChef);
    %_____________________________________________
    % AGLR Decision Rule (h)
    posx =Mx; posy =posy-haut-6*My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TEmgAGLRh', 'Position',[posx posy large haut], ...
              'String',tt.poemgaglrhtxt, 'horizontalalignment','right', 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SEmgAGLRh', 'Style', 'edit', 'backgroundcolor',[1 1 1],...
   	          'Position', [posx posy large haut], 'String', '15', ...
              'TooltipString',tt.poemgaglrhtip);
    %_____________________________________________
    % AGLR Decision Rule (L)
    posx =Mx; posy =posy-haut-My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TEmgAGLRl', 'Position',[posx posy large haut], ...
              'String',tt.poemgaglrltxt, 'horizontalalignment','right', 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SEmgAGLRl', 'Style', 'edit', 'backgroundcolor',[1 1 1],...
   	          'Position', [posx posy large haut], 'String', '50', ...
              'TooltipString',tt.poemgaglrltip);
    %_____________________________________________
    % AGLR Decision Rule (d)
    posx =Mx; posy =posy-haut-My; large =larg2;
    uicontrol('Parent',pan, 'Tag','TEmgAGLRd', 'Position',[posx posy large haut], ...
              'String',tt.poemgaglrdtxt, 'horizontalalignment','right', 'Style','text');
    posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','SEmgAGLRd', 'Style', 'edit', 'backgroundcolor',[1 1 1],...
   	          'Position', [posx posy large haut], 'String', '10', ...
              'TooltipString',tt.poemgaglrdtip);
    %_____________________________________________
    % Voir
    posy =posy-haut-3*My; large =larg1; posx =(1-large)/2;
    uicontrol('Parent',pan, 'Tag','VoirTest', 'Position',[posx posy large haut], ...
              'String',tt.poemgvoir, 'horizontalalignment','center', 'Callback',@Ppa.testAGLR);
  %_______________________________________________
  % Panel Point Bidon
  pan =uipanel('Parent',lafig, 'Tag','PanelBidon', 'title',tt.pobidnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o7, 'Userdata',pan);
    %_____________________________________________
    % INSÉRER POINT BIDON
    Mx =M5; posx =Mx; haut =hBout; posy =1-haut-COMO; larg1 =(1-3*Mx)/6; larg2 =larg1*5; large =larg2;
    uicontrol('Parent',pan, 'Tag','TPtBidon', 'Style','text', 'Position', [posx posy large haut], ...
   	          'String',tt.pobidpostxt, 'horizontalalignment','right');
    ht =0.3; posy =posy+haut-ht; haut =ht; posx =posx+large; large =larg1;
    uicontrol('Parent',pan, 'Tag','LBPtBidon', 'BackgroundColor',[1 1 1], 'Min',1, 'Max',1, ...
              'Position',[posx posy large haut], 'String','1', 'Style','listbox', 'Value',1);
    haut =hBout; posx =posx-large-Mx;
    uicontrol('Parent',pan, 'Style','edit', 'Tag','SPtBidon', 'backgroundcolor',[1 1 1],...
              'TooltipString',tt.pobidposmantip,...
   	          'Position',[posx posy large haut], 'String','');
   	large =larg1*3; posx =posx-large;
    uicontrol('Parent',pan,  'Style','text', 'Tag','TPtBidon', 'horizontalalignment','right', ...
   	          'Position',[posx posy large haut], 'String',tt.pobidposmantxt);
  %_______________________________________________
  % Panel Test, Détection Changement
  pan =uipanel('Parent',lafig, 'Tag','PanelCUSUM', 'title',tt.potestnom, 'Position',ppan, ...
               'BorderType','beveledin', 'Visible','off');
    set(o8, 'Userdata',pan);
    %_____________________________________________
    % DOCUMENTATION
    %---------------------------------------------
    ecart =M4; Mx =2*ecart; posx =ecart; large =(1-4*ecart); haut =hBout; posy =1-haut-.75*COMO;
    uicontrol('Parent',pan, 'Tag','TDocChangement', 'Style','edit', 'Position',[posx posy large haut], ...
              'HorizontalAlignment','left', 'String',tt.potestdoctxt, 'UserData',tt.potestdoctxt);
    %_____________________________________________
    % SEUIL, THRESHOLD
    %---------------------------------------------
    posx =Mx; posy =posy-1.5*haut; larg1 =(1-4*Mx)/6; larg2 =larg1*2; large =larg2;
    corrY =M2;
    uicontrol('Parent',pan, 'Position',[posx posy large haut-corrY], ...
              'Style','text', 'String',tt.potestseuiltxt, ...
              'TooltipString',tt.potestseuiltxttip);
    uicontrol('Parent',pan, 'Tag','SSeuil', 'Position',[posx posy-haut large haut], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','1', ...
              'TooltipString',tt.potestseuiltip);
    %_____________________________________________
    % MONTÉE g+
    %---------------------------------------------
    uicontrol('Parent',pan, 'Tag','CBMonteCUSUM', 'Position',[posx posy-2.5*haut large haut], 'Value',1, ...
              'HorizontalAlignment','left', 'String',tt.potestgplus, 'Style','checkbox', 'ForegroundColor','r');
    posx =posx+1.5*large;
    %_____________________________________________
    % DÉRIVE, DRIFT
    %---------------------------------------------
    uicontrol('Parent',pan, 'Position',[posx posy large haut-corrY], ...
              'Style','text', 'String',tt.potestdriftxt, ...
              'TooltipString',tt.potestdriftxttip);
    uicontrol('Parent',pan, 'Tag','SDeriveDrift', 'Position',[posx posy-haut large haut], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','0', ...
              'TooltipString',tt.potestdriftip);
    %_____________________________________________
    % DESCENTE g-
    %---------------------------------------------
    uicontrol('Parent',pan, 'Tag','CBDescenteCUSUM', 'Position',[posx posy-2.5*haut large haut], 'Value',1, ...
              'HorizontalAlignment','left', 'String',tt.potestgmoins, 'Style','checkbox', 'ForegroundColor','g');
    My =M1;
    %_____________________________________________
    % NOMBRE DE RÉPÉTITION
    %---------------------------------------------
    %nombDeRepet(pan, Mx/8, My, posy-3*haut, haut, tt);
    nombDeRepet(pan, Mx, My, posy-3*haut, haut, tt);
    posx =posx+large+ecart;
    %_____________________________________________
    % VOIR
    %---------------------------------------------
    large =larg1; posx =1-large-Mx; posy =posy-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.testCUSUM, 'FontSize',9, ...
              'TooltipString',tt.potestvoirtip, 'FontWeight','bold', ...
              'Position',[posx posy large haut], 'String',tt.potestvoir);

  %_______________________________________________
  % barre de status au bas de la figure
  uicontrol('Parent',lafig, 'Tag','MarkStatus', 'Position',[0 0 0.998 epais1], 'Style','text', ...
            'FontSize',10, 'HorizontalAlignment','center', 'BackgroundColor',[0.95 0.95 0.95]);
  OA.OFig.montrerMarquage();
  Ppa.afficheStatus();
  OA.OFig.affiche();
end

%_______________________________________________________________________________
% Comme on a plusieurs panel qui utilise les même boutons de façon non
% dépendante, plutôt que de créer un set de bouton identique par panel,
% on va changer le "parent"...
%-------------------------------------------------------------------------------
function faireCanExtra(tO, pan, M2, M3, M5, hBout, hdchnl, vg, IT, txt)
  ecart =M2; larg3 =0.04; larg1 =(1-4*ecart-larg3)/2; larg2 =larg1/2;
  posx =1-larg1-larg3-ecart; haut =0.3; posy =M3;
  pGlobB =[];
  pGlob =[];
  if IT
    %_____________________________________________
    % INTERVALE DE TRAVAIL
    posx =ecart; large =larg1; ht =hBout; py =posy+haut-ht; 
    pGlob(end+1) =uicontrol('Parent',pan, 'Position',[posx py large ht], ...
              'String',txt.pocommunintertxt, 'Style','text',...
              'TooltipString',txt.pocommunintertxttip);
    %_____________________________________________
    % DÉBUT
    pGlob(end+1) =uicontrol('Parent',pan, 'Tag','SMMMDIntDebut', 'Position',[posx py-ht larg2 ht], ...
              'backgroundcolor',[1 1 1], 'Style','edit', 'string','p0', ...
              'TooltipString',txt.pocommuninterdbttip);
    %_____________________________________________
    % FIN
    posx =posx+larg2;
    pGlob(end+1) =uicontrol('Parent',pan, 'Tag','SMMMDIntFin', 'Position',[posx py-ht larg2 ht], ...
              'backgroundcolor',[1 1 1], 'string','pf', 'Style','edit', ...
              'TooltipString',txt.pocommuninterfintip);
    posx =posx+larg2+2*ecart;
  end
  %_______________________________________________
  % CANAUX EXTRAS
  pGlob(end+1) =uicontrol('Parent',pan, 'Tag','LBCanalExtra', 'BackgroundColor',[1 1 1], ...
            'Position',[posx posy larg1 haut], 'String',hdchnl.Listadname, 'Min',1, 'Max',vg.nad, ...
            'Style','listbox', 'Value',tO.wmh.canExtra, 'CallBack',@tO.changeCanExtra);
  posx =posx+larg1; posy =posy+haut; haut =hBout/2; posy =posy-haut;
  pGlob(end+1) =uicontrol('Parent',pan, 'Tag','LBCanalExportPt', 'Position',[posx posy larg3 haut], ...
            'TooltipString',txt.pocommuncanexttip, 'String','', 'Style','checkbox', 'Value',0);
  posy =posy-haut-M5;
  pGlob(end+1) =uicontrol('Parent',pan, 'Tag','LBCanalExportRemplace', 'Position',[posx posy larg3 haut], ...
            'TooltipString',txt.pocommunrempltip, 'String','',...
            'Style','checkbox', 'Value',0);
  tO.hndGlob =pGlob;
end

%_______________________________________________________________________________
% Affiche la ligne pour demander le nombre de répétition voulu
%-------------------------------------------------------------------------------
function nombDeRepet(pan, Mx, My, posy, haut, txt)
  %_____________________________________________
  % NOMBRE DE RÉPÉTITION
  posx =2.25*Mx; posy =posy-haut-3*My; large =(1-3*Mx); L1 =large/9*5;
  uicontrol('Parent',pan, 'horizontalalignment','right', 'Style','text', ...
            'Position',[posx posy-.2*haut L1 haut], 'String',txt.pocommunrepet);
  posx =posx+L1; L1 =large/9;
  uicontrol('Parent',pan, 'Style','edit', 'Tag','SMarkTempRepet', 'String','1', ...
            'backgroundcolor',[1 1 1], 'Position',[posx posy L1 haut]);
  %_____________________________________________
  % TOUT L'INTERVALE
  posx =posx+L1; L1 =large/9*3;
  uicontrol('Parent',pan, 'Tag','CBToutInt', 'Position',[posx posy L1 haut], 'FontSize',9, ...
            'HorizontalAlignment','left', 'String',txt.pocommunint, 'Style','checkbox', 'Value',0,...
            'TooltipString',txt.pocommuninttip);
end

%_______________________________________________________________________________
% Affiche les références pour la section sur le marquage EMG
%-------------------------------------------------------------------------------
function quiEstLeChef(varargin)

  fig =findobj('Tag','UneRRREF');
  if ~isempty(fig)
    figure(fig);
    return;
  end

  a ={''};
  a{end+1} ='[1]   Staude G., Kafka V., Wolf W.,';
  a{end+1} ='      "Determination of premotor silent periods from myoelectric signals",';
  a{end+1} ='      Biomed. Tech. Suppl. 2, 45:228-232, 2000';
  a{end+1} ='';
  a{end+1} ='[2]   G. Staude and W. Wolf,';
  a{end+1} ='      "Objective motor response onset detection in surface myoelectric signals",';
  a{end+1} ='      Med Eng Physics 21, 449-467, 1999';
  a{end+1} ='';
  a{end+1} ='[3]   Staude G., Flachenecker C., Daumer M., and Wolf W.';
  a{end+1} ='      "Onset detection in surface electromyographic signals:';
  a{end+1} ='      a systematic comparison of methods",';
  a{end+1} ='      Applied Sig. Process., 2001(2):67-81, 2001.';
  a{end+1} ='';
  a{end+1} ='';
  a{end+1} ='Version 3.2,    by gerhard.staude@unibw-muenchen.de,  May 2010';
  a{end+1} ='';
  a{end+1} ='';
  a{end+1} ='AGLR DECISION RULE';
  a{end+1} ='';
  a{end+1} ='  The threshold h represents a tradeoff between nondetection of small';
  a{end+1} ='  events (large h) and false alarms (small h):';
  a{end+1} ='';
  a{end+1} ='  => choose a value h as small as possible which still produces';
  a{end+1} ='     a tolerable rate of false alarms.';
  a{end+1} ='';
  a{end+1} ='  The size L of the sliding test window determines the minimum distance';
  a{end+1} ='  of subsequent changes that can be detected:';
  a{end+1} ='';
  a{end+1} ='  => select L as large as possible (in order to obtain reliable variance';
  a{end+1} ='     estimates after change), but smaller than the shortest stationary epoch';
  a{end+1} ='     (i.e., epoch with constant variance) to be detected.';
  a{end+1} ='';
  % pour la signification de ML: maximum likelyhood, voir l'article de Staude 1999
  a{end+1} ='  The parameter d confines parameter estimation of the ML change time';
  a{end+1} ='  estimation procedure after change to a minimum number of d samples:';
  a{end+1} ='';
  a{end+1} ='  => choose d such that ta+d still will be located within the stationary';
  a{end+1} ='     epoch indicated by the current Alarm Time ta. This parameter is not';
  a{end+1} ='     very critical. Usually, a small number of samples (e.g, d=10) will do.';
  a{end+1} ='';
  % On affiche
  lapos =positionfen('C','C',575,545);
  colo =[0.9 0.9 0.9];
  F =dialog('Tag','UneRRREF', 'Units','pixels', 'position',lapos, 'Name','Références.', ...
            'Color',colo, 'WindowStyle','normal', 'Units','normalized', ...
            'DefaultUIControlBackgroundColor',colo, 'DefaultUIControlFontSize',10);
  uicontrol('Parent',F, 'Style','listbox', 'Units','normalized', 'Position',[0.07 0.1 0.85 0.8], ...
            'HorizontalAlignment','left', 'String',a, 'Max',length(a));
end

%  a =sprintf('[1]   Staude G., Kafka V., Wolf W.,\n      "Determination of premotor silent periods from myoelectric signals",\n      Biomed. Tech. Suppl. 2, 45:228-232, 2000');
%  b =sprintf('[2]   G. Staude and W. Wolf,\n      "Objective motor response onset detection in surface myoelectric signals",\n      Med Eng Physics 21, 449-467, 1999');
%  c =sprintf('[3]   Staude G., Flachenecker C., Daumer M., and Wolf W.\n      "Onset detection in surface electromyographic signals:\n      a systematic comparison of methods",\n      Applied Sig. Process., 2001(2):67-81, 2001.');
%  d =sprintf('Version 3.2,    by gerhard.staude@unibw-muenchen.de,  May 2010');
%  final =sprintf('%s\n\n%s\n\n%s\n\n\n\n%s',a,b,c,d);
