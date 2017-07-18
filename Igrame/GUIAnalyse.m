%
% fonction pour Dessiner la figure principale
% 18 d�c 2003, On passe en mode Normalized
% J'ai fait mes conversion avec une fen�tre de 300X250 mm
%
% GUIAnalyse(Ppa)
% En entr� on devra donner le handle d'un objet CDessine
%
%
function GUIAnalyse(Ppa)

  %______________________________________________________________________________
  % on lit la structure contenant le texte � afficher selon le choix de la langue
  %------------------------------------------------------------------------------
  ML =CGuiMLAnalyse();

  % handle de l'objet principal de l'application
  OA =CAnalyse.getInstance();

  % Octave se plaint si la position n'est pas un array lin�aire
  if size(OA.Vg.la_pos, 1) > 1
    OA.Vg.la_pos =OA.Vg.la_pos';
  end

  epay =0.028;
  %
  % SI on a units = pixel
  if max([OA.Vg.la_pos]) > 1
    % configuration, on prend en compte si plusieurs moniteurs
   	moniteur =get(0,'MonitorPositions');
    lexmax =max(moniteur(:,3));
    leymax =max(moniteur(:,4));
    if ((OA.Vg.la_pos(2)+OA.Vg.la_pos(4)))>leymax || ((OA.Vg.la_pos(1)+OA.Vg.la_pos(3)))>lexmax
      OA.Vg.la_pos=[0.2 0.2 0.7 0.7];
      lafig =figure('units','Normalized', 'Resize','on', 'Position',OA.Vg.la_pos);
    else
      lafig =figure('units','pixels', 'Resize','on', 'Position',OA.Vg.la_pos);
    end
  else
    lafig =figure('units','Normalized', 'Resize','on', 'Position',OA.Vg.la_pos);
  end

  % initialisation des valeurs par d�fauts de la figure
  set(lafig, 'Name',ML.name, 'tag', 'IpTraitement',...
            'units','Normalized', 'keypressfcn','kbPress', ...
            'DoubleBuffer','on', 'CloseRequestFcn','analyse(''terminus'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','Normalized',...
            'DefaultUIPanelBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIPanelunits','Normalized', 'visible','off');
  Ppa.fig =lafig;

  % Ajout d'une barre de status au bas de la FIG
  posx=0.0025;posy=0.0025; largeur=1-2*posx;hauteur=epay;
  uicontrol('Parent',lafig, 'tag', 'IpStatus', 'BackgroundColor',[0.95 0.95 0.95], ...
            'FontWeight','bold', 'Position',[posx posy largeur hauteur], ...
            'Style','text', 'String',ML.gntudebut);

  % Ajout d'un panel pour l'ensemble de la fen�tre moins la barre de status
  pp =uipanel('parent',lafig,'position',[0 hauteur 1 1-hauteur],'Visible','off');
  Ppa.Lepan =pp;

  set(lafig,'windowstyle','normal');
  la_pos = get(lafig,'position');
  lafonte1 = 10;
  dist = 0.003;    % distance pour emp�cher de chevaucher 1
  epay = 0.028;    % �paisseur des boutons 6.5
  bordurx=0.013*la_pos(3);   % bordure gauche/droite
  bordury=0.013*la_pos(4);   % bordure haut/bas
  nbor =2/(sqrt(5)+1);
  lfrm =nbor;   % largeur du frame (ma contribution au monde artistique...)
  lpfs =0.125;  % largeur petite fen�tre de s�lection (canaux et essais) 37.5
  lgfs =0.22;   % largeur grande fen�tre de s�lection (cat�gories) 66
  lbsp =0.0535; % largeur de boutons "suivant-pr�c�dent" 16
  lbt1 =0.045;  % largeur des boutons "supprim� et marquer" 13
  lbgo =0.035;  % largeur des boutons "AV" 10
  lcst =0.018;  % largeur d'un checkBox sans texte 5.5
  lpu1 =0.07;   % largeur popup 1 (ex: choix de zoom) 20
  lpu2 =0.095;  % largeur popup 2 (ex: points marqu�s) 30
  bas  =0.09;   % bordure du bas 22
  hfrm =epay+2.2*bordury; % hauteur frame

  % R�f�rence de l'AXE
  posx =1-lfrm-lcst-bordurx/4; posy =4*epay;
  largeur =lfrm; hauteur =1-posy-3*epay-2*bordury;
  OA.Hautaxe =hauteur;
  laxe =[posx posy largeur hauteur];

  %*******************************************************
  % FABRICATION DU PANEL ET SES BOUTONS (en haut � droite)
  posx =laxe(1); posy =1-hfrm;
  largeur =laxe(3); hauteur =hfrm;
  lepan= uipanel('Parent',pp, 'Position',[posx posy largeur hauteur],...
            'bordertype','beveledin', 'tag', 'IpFrame');

  bidon=posy;espd=0.015;
  largeur=0.05;posx = 1-largeur-espd;
  posy = 0.12; hauteur=0.7;
  largeur=0.25;posx=espd;
  lesnoms ={ML.pbvide};
  
  % fabrication du listbox pour afficher les canaux pour le marquage manuel
  texte ={'Parent';lepan; 'tag';'IpFrameChoixCan'; 'Position';[posx posy largeur hauteur]; ...
          'TooltipString';ML.pbcanmarktip;...
          'String';lesnoms; 'Style';'popupmenu'; 'Value';1};
  Ppa.canopts =CListBox2(texte);

  % fabrication du listbox pour effacer les points marqu�s
  posx=posx+largeur+espd;
  uicontrol('Parent',lepan, 'tag','IpFrameEnleverpt', 'Position',[posx posy largeur hauteur], ...
            'Callback','guiToul(''enleve_marque'')', 'TooltipString',ML.pbdelpttip,...
            'String','...', 'Style','popupmenu', 'Value',1);

  % bouton pour le marquage manuel
  posx=posx+largeur+espd; largeur=0.07;
  uicontrol('Parent',lepan, 'tag','IpFrameMarquerpt', 'Callback','guiToul(''outil_marque'')', ...
            'TooltipString',ML.pbmarmantip,...
            'Position',[posx posy largeur hauteur], 'String','__|__');

  % bouton pour l'affichage des coordonn�es
  posx=posx+largeur+espd; largeur=0.075;
  uicontrol('Parent',lepan, 'tag','IpFrameAfficherCoord', 'Callback','guiToul(''affichecoord'')', ...
            'TooltipString',ML.pbcoordtip,...
            'Position',[posx posy largeur hauteur], 'String',ML.pbcoord);

  % bouton pour l'activation/d�sactivation du zoom
  posx=posx+largeur+espd;largeur=0.05;
  uicontrol('Parent',lepan, ...
            'tag','IpFrameQZoom',...
            'Callback','guiToul(''zoomonoff'')', ...
            'TooltipString','Activer..d�sactiver le Zoom',...
            'Position',[posx posy largeur hauteur], ...
            'String','Z');

  % popupmenu pour le type d'affichage. Auto., Manuel ou barr�
  posx=posx+largeur+espd; largeur=0.15;
  uicontrol('Parent',lepan, ...
            'tag','IpFrameLock',...
            'Callback','guiToul(''loque'')', ...
            'TooltipString','D�finir la portion du graphique � afficher',...
            'Position',[posx posy largeur hauteur], ...
            'Style','popupmenu',...
            'String','autom.|barrer|manuel');

  % bouton pour l'activation/d�sactivation du zoom
  largeur=0.02; posx=1-largeur-espd;
  lesMOTS =sprintf('Sert � montrer si l''affichage est en travail:\n\tVert\t--> l''affichage est termin�e\n\tRouge\t--> patientez, affichage en cours');
  fui =uicontrol('Parent',lepan, 'tag','IpFrameEnAffichage', 'TooltipString',lesMOTS,...
                 'Position',[posx posy largeur hauteur], 'string','!');
  Ppa.statusaff =fui;

  %**********************************
  % FEN�TRE POUR AFFICHER LES COURBES
  % Axe Principale
  Ppa.Lax =axes('Parent',pp, 'tag','IpAxe',...
            'Position',laxe,...
            'XColor',[0 0 0], 'YColor',[0 0 0]);

  % Slider Vertical
  posx=laxe(1)+laxe(3);largeur=lcst;hauteur=laxe(4);posy=laxe(2);
  uicontrol('Style','Slider', 'Parent',pp, ...
            'tag','IpAxeSliderY',...
            'Callback','guiToul(''deroully'')', ...
            'Position',[posx posy largeur hauteur], ...
            'SliderStep', [0.05 0.15],...
            'Visible','Off');
  % Slider Horizontal
  posx=laxe(1);largeur=laxe(3);hauteur=epay;posy=laxe(2)-(2*epay);
  uicontrol('Style','Slider', 'Parent',pp, ...
            'tag','IpAxeSlider',...
            'Callback','guiToul(''deroull'')', ...
            'Position',[laxe(1) posy largeur hauteur], ...
            'SliderStep', [0.05 0.15],...
            'Visible','Off');

  %**********************************************************************
  % FABRICATION DES UICONTROL DE S�LECTION CANAUX/ESSAIS ET LEURS BOUTONS
  posx=bordurx; posy=laxe(2)+laxe(4);
  largeur=lpfs; hauteur=epay;
  uicontrol('Parent',pp, ...
            'tag', 'IpTextCanaux',...
            'HorizontalAlignment','center', ...
            'Position',[posx posy largeur hauteur], ...
            'Style','text', ...
            'String','Canaux');
  posx=posx+largeur+(2*dist);
  uicontrol('Parent',pp, ...
            'tag', 'IpTextEssais',...
            'HorizontalAlignment','center', ...
            'Position',[posx posy largeur hauteur], ...
            'Style','text', ...
            'String','Essais');
  posx=bordurx; posy=posy-hauteur;
  largeur=lbsp;
  Ppa.Bcano(1) =uicontrol('Parent',pp, 'tag','IpCanPrecedent',...
            'Callback','guiToul(''canal_precedent'')', ...
            'TooltipString','Aller au canal pr�c�dent',...
            'Position',[posx posy largeur hauteur], 'String','<--');
  posx=posx+largeur; largeur=lcst;
  Ppa.Bcano(2) =uicontrol('Parent',pp, 'tag','IpCanTous',...
            'Callback','guiToul(''tout_canaux'')', ...
            'TooltipString','Afficher tous les canaux',...
            'Position',[posx posy largeur hauteur], ...
            'String','', 'Style','checkbox', 'Value',0);
  posx=posx+largeur; largeur=lbsp;
  Ppa.Bcano(3) =uicontrol('Parent',pp, 'tag','IpCanSuivant',...
            'Callback','guiToul(''canal_suivant'')', ...
            'TooltipString','Aller au canal suivant',...
            'Position',[posx posy largeur hauteur], 'String','-->');
  %--------------------------
  posx=posx+largeur+(2*dist);
  Ppa.Bess(1) =uicontrol('Parent',pp, 'tag','IpEssPrecedent',...
            'Callback','guiToul(''essai_precedent'')', ...
            'TooltipString','Aller � l''essai pr�c�dent',...
            'Position',[posx posy largeur hauteur], 'String','<--');
  posx=posx+largeur; largeur=lcst;
  Ppa.Bess(2) =uicontrol('Parent',pp, 'tag','IpEssTous',...
            'Callback','guiToul(''tout_essai'')', ...
            'TooltipString','Afficher tous les essais',...
            'Position',[posx posy largeur hauteur], ...
            'String','', 'Style','checkbox', 'Value',0);
  posx=posx+largeur; largeur=lbsp;
  Ppa.Bess(3) =uicontrol('Parent',pp, 'tag','IpEssSuivant',...
            'Callback','guiToul(''essai_suivant'')', ...
            'TooltipString','Aller � l''essai suivant',...
            'Position',[posx posy largeur hauteur], 'String','-->');
  %_____________________________________________
  % Affichage du nom des canaux dans une ListBox
  posx =bordurx;posy =laxe(2)+(0.45*laxe(4));
  largeur =lpfs;hauteur =0.51*laxe(4);
  textcan ={'Parent';pp; 'BackgroundColor';[1 1 1]; 'Position';[posx posy largeur hauteur]; 'Style';'listbox'; ...
           'Callback';'guiToul(''choix_canaux'')'; 'Fontname';'courier'; 'String';lesnoms; 'Min';1; 'Max';1};  %'tag';'IpCanLesnoms';
  Ppa.cano =CListBox1(textcan);
  Ppa.Bcano(4) =Ppa.cano.hnd;
  %_____________________________________________
  % Affichage du nom des essais dans une ListBox
  posx =posx+largeur+(2*dist);
  textess ={'Parent';pp; 'BackgroundColor';[1 1 1]; 'Fontname';'courier';...
           'Position';[posx posy largeur hauteur]; 'Callback';'guiToul(''choix_essai'')'; ...
           'String';lesnoms; 'Min';1; 'Max';1; 'Style';'listbox'};  %'tag';'IpEssLesnoms';
  Ppa.essai =CListBox1(textess);
  Ppa.Bess(4) =Ppa.essai.hnd;
  largeur =lbt1;hauteur=epay;
  posx =bordurx+((lpfs-largeur)/2);posy =posy-hauteur-bordury;
  %________________________________
  % Affichage des BOUTONS Supprimer
  Ppa.Bcano(5) =uicontrol('Parent',pp, 'tag','IpCanEnleve',...
            'Callback','guiToul(''canal_enleve'')', ...
            'TooltipString','Supprimer les canaux s�lectionn�s',...
            'Position',[posx posy largeur hauteur], 'String','Suppr');
  posx =posx+lpfs+(2*dist);
  Ppa.Bess(5) =uicontrol('Parent',pp, 'tag','IpEssEnleve',...
            'Callback','guiToul(''essai_enleve'')', ...
            'TooltipString','Supprimer les essais s�lectionn�s',...
            'Position',[posx posy largeur hauteur], 'String','Suppr');
  %_________________________________________________
  % Affichage du nom des cat�gories dans une fen�tre
  posx=bordurx; posy=posy-bas;
  largeur=lgfs;
  uicontrol('Parent',pp, ...
            'tag','IpTextCats',...
            'HorizontalAlignment','Center', ...
            'Visible','Off', ...
            'Style','text', ...
            'Position',[posx posy largeur hauteur], ...
            'String','Cat�gorie');
  hauteur=0.25*laxe(4); posy=posy-hauteur;
  textcat ={'Parent';pp; 'tag';'IpCatsLesnoms'; 'BackgroundColor';[1 1 1]; ...
          'FontSize';lafonte1; 'Position';[posx posy largeur hauteur]; 'Callback';'guiToul(''niveau'')'; ...
          'String';'aucun'; 'Visible';'Off'; 'Min';1; 'Max';1; 'Style';'listbox'; 'Value';1};
  Ppa.nivo =CListBox1(textcat);
  Ppa.Bcato(1) =Ppa.nivo.hnd;
  posx=bordurx+largeur-lbgo;hauteur=epay;
  posy=posy-hauteur;largeur=lbgo;
  Ppa.Bcato(2) =uicontrol('Parent',pp, 'tag','IpCatsPermute',...
            'Callback','guiToul(''permutation'')', ...
            'TooltipString','Changer la r�f�rence pour l''affichage des cat�gories en couleurs',...
            'Position',[posx posy largeur hauteur], ...
            'Visible','Off', 'String','1');
  Ppa.Btous =[Ppa.Bcano Ppa.Bess Ppa.Bcato];
end
