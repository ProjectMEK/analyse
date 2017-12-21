%
% Interface (GUI) pour la correction des datos
% en entr�e il faut fournir un handle sur un objet de classe CCorrige
% en sortie, on retourne le handle de la figure
%
function fig =GUICorrige(Ppa)
  hdchnl =Ppa.Hdchnl;
  vg =Ppa.Vg;
  vg.valeur =1;
  if vg.nad > 2; letop =vg.nad;
  else letop =vg.nad+1;
  end
  % CONSTANTES DE POSITION
  Lfen =557; Hpan1 =225; Hpan2 =200; Hfen =Hpan1+Hpan2+65; Lpan =Lfen-2; Lpan2 =round(Lpan/2);
  my =5; my2 =10; ltxt =40; htxt =20; hbtn =25; debutPan =2;

  posfig =positionfen('G','C',Lfen,Hfen);
  fig =figure('Name', 'CORRECTION', 'Position',posfig, 'Resize', 'off', ...				
          'CloseRequestFcn',{@quienllama,'terminus'}, 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8], ...
          'DefaultUIControlUnits','pixels', 'DefaultUIPanelBackgroundColor',[0.8 0.8 0.8], ...
          'DefaultUIControlFontUnits','pixels', 'DefaultUIControlFontSize',12, ...
          'DefaultUIControlFontName','MS Sans Serif');
  setappdata(fig,'Ppa',Ppa);
  % PANELS
  posx =debutPan; large =Lpan; posy =Hfen-Hpan1; haut =Hpan1;
  pan1 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], ...
                'Title','Canaux/Essais/Intervalles', 'TitlePosition','centertop');
  % R�SULTAT DANS LE M�ME CANAL
  large =round(Lpan2*0.7); posx =round(Lpan2*0.75); haut =htxt; posy =posy-haut-my2;
  uicontrol('Parent',fig, 'tag','CNouvCan', 'Position',[posx posy large haut], 'FontSize',9, ...
            'HorizontalAlignment','left', 'String','Placer le r�sultat dans le m�me canal',...
            'Style','checkbox', 'Value',Ppa.ecraser, 'callback',{@quienllama,'OnEcrase'});
  posx =debutPan; haut =Hpan2; posy =posy-haut-my; large =Lpan2;
  pan2 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], ...
                'Title','Type de correction', 'TitlePosition','centertop');
  posx =posx+large;
  pan3 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], 'tag','lePan3', ...
                'Title','(Param�tres)', 'TitlePosition','centertop', 'Visible','on');
  pan4 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], 'tag','lePan4', ...
                'Title','(Param�tres)', 'TitlePosition','centertop', 'Visible','off');
  pan5 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], 'tag','lePan5', ...
                'Title','(Param�tres)', 'TitlePosition','centertop', 'Visible','off');
  pan6 =uipanel('Parent',fig, 'units','pixels', 'Position',[posx posy large haut], 'tag','lePan6', ...
                'Title','(Param�tres)', 'TitlePosition','centertop', 'Visible','off');
  Ppa.LesPan =[pan3 pan4 pan5 pan6];
  % STATUS
  haut =htxt; posy =0; posx =2; large =Lpan;
  uicontrol('Parent',fig, 'Style','text', 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
            'String','Remplissez chacune des sections et cliquez sur "Au travail"');
  % CONSTANTES DE POSITION
  mx =10; mx2 =5; mx3 =25; hlbox12 =165; hlbox34 =145; llbox1 =140; llbox2 =125; llbox34 =45;
  %---------------------------------------
  % PANEL 1 {CANAUX ESSAIS ET INTERVALLES}
  pan =pan1;
  % CANAL � CORRIGER
  posx =mx; large =llbox1; posy =Hpan1-hbtn-15; posybu =posy;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large htxt],...
            'HorizontalAlignment','center', 'String','Canal � corriger');
  haut =hlbox12; posy =posybu-haut-mx2;
  uicontrol('Parent',pan, 'Style','listbox', 'FontSize',10, 'Position',[posx posy large haut], 'tag','LbCanaux', 'Min',1, ...
            'Max',letop, 'Fontname','courier', 'String',hdchnl.Listadname, 'callback',{@quienllama,'CualCanEs'}, 'BackgroundColor',[1 1 1], ...
            'TooltipString','Choississez les canaux qui n�cessitent une correction', 'Value',Ppa.CualCan);
  % TOUS ESSAI
  posx =posx+large+mx; haut =hbtn; large =110; posy =posybu;
  uicontrol('Parent',pan, 'Position',[posx posy large haut], 'String','Tous les essais', ...
            'Style', 'radiobutton', 'Value',Ppa.Ess, 'tag','CEssTous', 'callback',{@quienllama,'ChangeEss'}, ...
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
            'Style', 'radiobutton', 'Value',Ppa.Interv, 'callback',{@quienllama,'ChangeInterv'}, ...
            'TooltipString','Garder coch� pour agir sur tous les �chantillons (samples), sinon d�cocher pour choisir un point initial et final comme borne de calcul');
  % CANAL DE R�F�RENCE
  large =llbox1; haut =hlbox12; posy =posy-haut-mx2;
  lescan ={'Canal � corriger'};
  lescan(2:length(hdchnl.Listadname)+1) =hdchnl.Listadname;
  Ppa.LbCan =uicontrol('Parent',pan, 'Style','listbox', 'FontSize',10, 'Position',[posx posy large haut], ...
            'Min',1, 'Max',1, 'Fontname','courier', 'String',lescan, 'callback',{@quienllama,'ChangeCanPoint'}, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','Choississez le canal de r�f�rence pour les points de d�but et fin de l''intervalle');
  % POINT INITIAL
  posx =posx+large+2*mx2; large =Lpan-posx-2*mx2;  haut =htxt; posy =posybu-haut-2*mx2;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut],...
            'FontWeight','bold', 'HorizontalAlignment','center', 'String','D�but');
  posy =posy-haut;
  Ppa.LbPti =uicontrol('Parent',pan, 'Style','edit', 'Position',[posx posy large haut], ...
            'String','Pi', 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','(Pi ou P0 -premier �chantillon)(P1.P2..etc. -point marqu�)(Une valeur num�rique (ex. 3.25) signifie un temps en seconde)');
  % POINT FINAL
  posy =posy-haut-3*my2;
  uicontrol('Parent',pan, 'Style','text', 'Position',[posx posy large haut],...
            'FontWeight','bold', 'HorizontalAlignment','center', 'String','Fin');
  posy =posy-haut;
  Ppa.LbPtf =uicontrol('Parent',pan, 'Style','edit', 'Position',[posx posy large haut], ...
            'Fontname','courier', 'String','Pf', 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','(Pf -dernier �chantillon)(P1.P2..etc. -point marqu�)(Une valeur num�rique (ex. 3.25) signifie un temps en seconde)');
  %----------------------------------------
  % PANEL 2 TYPE DE CORRECTION (PARAM�TRES)
  pan =pan2;
  % GROUPE BOUTON
  posx =0; posy =0; large =Lpan2; haut =Hpan2-my2;
  gBout =[];
  try
  	% 'SelectionChangeFcn' pour Matlab
    % L'ordre des propri�t�s est crucial car on va rechercher le handle du uigroup selon
    % le "tag". Si �a plante dans Octave, il faut en tenir compte car 2 uigroup seront
    % quand m�me cr��s.
    gBout =uibuttongroup('Parent',pan, 'Units','pixels', 'Position',[posx posy large haut], ...
                         'SelectionChangeFcn',{@quienllama,'Voirpoints'},'tag','GroupBTN');
  catch rien;
  	% 'SelectionChangedFcn' pour Octave et on delete gBout s'il existe
  	if ~isempty(gBout)
  	  delete(gBout);
  	end
    gBout =uibuttongroup('parent',pan, 'units','pixels', 'position',[posx posy large haut], ...
                         'selectionchangedfcn',{@quienllama,'Voirpoints'},'tag','GroupBTN');
  end
  % RADIO-BUTTON CORRECTION
  letyp ={'Donn�es manquantes <= �';'Donn�es manquantes >= �';...
          'Donn�es manquantes == �';'Couper les Pics';...
          'Nouvelle valeur entre deux points';'Domaine fonctions Trigonom�triques'};
  posx =mx; large =large-2*mx; haut =hbtn; posy =Hpan2-3*my2;
  for U =1:length(letyp)
    posy =posy-haut;
    uicontrol('Parent',gBout,'Position',[posx posy large haut],'String',letyp{U},...
              'Style','radiobutton','tag',['RB-' num2str(U)]);
  end
  %----------------------
  % PANELS DES PARAM�TRES
  LaPos =get(pan3, 'Position');
  PosTrav =[mx3 5 80 htxt];
  pan =pan3;
  % MODIFIER LES D�BUTS ET LES FINS
  posx =mx3; large =LaPos(3)-2*mx3; haut =htxt; posy =LaPos(4)-haut-3*my2;
  uicontrol('Parent',pan, 'tag','CDebFin', 'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[posx posy large haut], 'FontWeight','bold', 'String','D�but et fin uniquement', ...
            'Style','radiobutton', 'Value',Ppa.DebFin, 'callback',{@quienllama,'VoirDebFin'});
  % UTILISER POLYNOMIAL FIT
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'tag','CPolyFit', 'callback',{@quienllama,'Voirpoly'}, 'Style','checkbox', ...
            'Position',[posx posy large haut], 'FontSize',9, 'HorizontalAlignment','left',...
            'String','Polynomial Fit,   (Par d�faut: Spline)', 'Value',0);
  % VALEUR � CORRIGER
  posy =posy-haut-my2; La =round(large*0.75); Lb =large-La;
  uicontrol('Parent',pan, 'tag','CValeurTitre', 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Valeur � corriger: ');
  uicontrol('Parent',pan, 'tag','CValeur', 'BackgroundColor',[1 1 1], 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'String', '0', 'TooltipString','Valeur � corriger');
  % FEN�TRE DE CALCUL
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'tag','CFenCalculTitre', 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Fen�tre de calcul: ');
  uicontrol('Parent',pan, 'tag','CFenCalcul', 'BackgroundColor',[1 1 1], ...
            'Position',[posx+La posy Lb haut], 'String', '10', 'Style','edit', ...
            'TooltipString','Nombre d''�chantillons utilis�s pour recalculer');
  % ORDRE DU POLYN�ME
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'tag','COrdrePolyTitre', 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Ordre du polyn�me: ', 'Visible', 'off');
  uicontrol('Parent',pan, 'tag','COrdrePoly', 'BackgroundColor',[1 1 1], 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'Visible', 'off', 'String','3');
  % AU TRAVAIL
  uicontrol('Parent',pan,'callback',{@quienllama,'AuTravail'},'Position',PosTrav,...
            'tag','MaW','enable','off','String','Au travail', ...
            'TooltipString','Utilisez pour recalculer les donn�es manquantes  >, <, ou = � une valeur');
  %________________
  % COUPER LES PICS
  %----------------
  pan =pan4;
  %_________________________
  % DIFF�RENCE INTER-SAMPLES
  posy =LaPos(4)-haut-3*my2;
  uicontrol('Parent',pan, 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Delta Y: ');
  uicontrol('Parent',pan, 'tag','CDiffIsmp', 'BackgroundColor',[1 1 1], 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'String', '0', ...
            'TooltipString','Diff�rence, entre 2 valeurs cons�cutives, consid�r�e comme excessive');
  % LARGEUR � MI-HAUTEUR
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Delta X: ');
  uicontrol('Parent',pan, 'tag','CLargePic', 'BackgroundColor',[1 1 1], 'String', '0', 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'TooltipString','Largeur maximum du pic (sec.), laissez � 0 pour agir sur toutes les mont�es/descentes');
  % NE PAS INTERPOLER
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'tag','CPicInterpol', 'BackgroundColor',[0.8 0.8 0.8], 'Style','radiobutton', ...
            'Position',[posx posy large haut], 'FontWeight','bold', 'String','Ne pas interpoler', ...
            'Value',false, 'TooltipString','Coch� pour faire une soustraction de la mont�e et une addition de la descente.');
  % AU TRAVAIL
  uicontrol('Parent',pan, 'callback',{@quienllama,'AuTravail'}, 'Position',PosTrav, 'String','Au travail', ...
            'TooltipString','Utilisez afin de corriger les pics ind�sirables');
  %---------
  pan =pan5;
  % NOUVELLE VALEUR ENTRE DEUX POINTS
  posy =LaPos(4)-haut-3*my2;
  %_____________________________________
  % crit�res plus pr�cis
  %-------------------------------------
  uicontrol('Parent',pan, 'tag','Cprecise_critere', 'Position',[posx posy large haut], 'callback',{@quienllama,'toggleCritere'}, ...
            'HorizontalAlignment','left', 'String','Tous les points qui ...', 'Style','checkbox', 'Value',0, ...
            'TooltipString','Cochez pour Modifier tous les points qui rencontrent le crit�re s�lectionn�');
  posy =posy-haut-my2;
  lesmots ={'  sont  >=  �: ';'  sont   =  �: ';'  sont  <=  �: '};
  ptiLa =La*.75; deltaLa =La-ptiLa;
  uicontrol('Parent',pan, 'tag','LBChoixCritere', 'Style','Popupmenu', 'FontSize',11, 'Position',[posx+deltaLa posy ptiLa haut], ...
            'Fontname','courier', 'String',lesmots, 'callback',{@quienllama,'ChangeCritere'}, 'BackgroundColor',[1 1 1], 'Enable','off', ...
            'TooltipString','Choississez le crit�re de s�lections afin de modifier les donn�es voules');
  uicontrol('Parent',pan, 'tag','CValeurCritere', 'BackgroundColor',[1 1 1], 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'String', '0', 'callback',{@quienllama,'valeurCritere'},...
            'TooltipString','Valeur � respecter pour le crit�re choisi');
  posy =posy-haut-2*my2;
  uicontrol('Parent',pan, 'Style','text', 'Horizontalalignment','right', ...
            'Position',[posx posy La haut], 'String','Valeur de remplacement: ');
  uicontrol('Parent',pan, 'tag','CNouvVal', 'BackgroundColor',[1 1 1], 'Style','edit', ...
            'Position',[posx+La posy Lb haut], 'String', '0', ...
            'TooltipString','Donnez la nouvelle valeur qui remplacera les points choisis');
  % AU TRAVAIL
  uicontrol('Parent',pan, 'callback',{@quienllama,'AuTravail'}, 'Position',PosTrav, 'String','Au travail', ...
            'TooltipString','Utilisez afin de remplacer les valeurs entre deux points (ex. Pi-->Pf), voir les options suppl�mentaires ');
  %---------
  pan =pan6;
  % RADIAN OU DEGR�
  posy =LaPos(4)-haut-3*my2;
  uicontrol('Parent',pan, 'tag','CRadianDegre', 'Position',[posx posy large haut], ...
            'HorizontalAlignment','left', 'String','Radian,   (Par d�faut: Degr�)',...
            'Style','checkbox', 'Value',0);
  % DOMAINE DE LA FONCTION TRIGONOM�TRIQUE
  posy =posy-haut-my2;
  uicontrol('Parent',pan, 'tag','CDomaine', 'Position',[posx posy large haut], ...
            'HorizontalAlignment','left', 'String','�Pi/2,   (Par d�faut: �Pi)',...
            'Style','checkbox', 'Value',0);
  % AU TRAVAIL
  uicontrol('parent',pan,'callback',{@quienllama,'AuTravail'},'position',PosTrav,...
            'String','Au travail','TooltipString',...
            'Utilisez afin de corriger les valeurs d''angles. Ex: les sauts de -180 � +180');
end

%
% on call la method "Ppa.(autre)"
%
function quienllama(src,evt, autre)
  Ppa =getappdata(gcf,'Ppa');
  switch autre
  case 'terminus'
    Ppa.terminus();
  case 'OnEcrase'
    Ppa.OnEcrase(src);
  case 'CualCanEs'
    Ppa.CualCanEs(src);
  case 'ChangeEss'
    Ppa.ChangeEss(src);
  case 'ChangeInterv'
    Ppa.ChangeInterv(src);
  case 'ChangeCanPoint'
    Ppa.ChangeCanPoint(src);
  case 'Voirpoints'
    Ppa.Voirpoints(src,evt);
  case 'VoirDebFin'
    Ppa.VoirDebFin(src);
  case 'Voirpoly'
    Ppa.Voirpoly(src);
  case 'AuTravail'
    Ppa.AuTravail(src);
  case 'toggleCritere'
    Ppa.toggleCritere(src);
  case 'ChangeCritere'
    Ppa.ChangeCritere(src);
  case 'valeurCritere'
    Ppa.valeurCritere(src);
  end
end
