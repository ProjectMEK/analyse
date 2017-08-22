%
% ***GUI POUR L'EXÉCUTION EN BATCH***
%
%
function fig = GUIBatchEditExec(Ppa)
    lafig =gcf;
    A =CAideGUI();
    large =800; haut =800;
    lapos =positionfen('C','C',large,haut,lafig);
    GRIS =[0.8 0.8 0.8];
    BLANC =[1 1 1];
    fig  =figure('Name','TRAITEMENT EN LOT','tag', 'IpBatch',...
                 'Resize','on', 'Position', lapos, ...
                 'CloseRequestFcn',@Ppa.terminus,'MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',GRIS,...
                 'DefaultUIPanelBackgroundColor',GRIS,'DefaultUIPanelTitlePosition','centertop',...
                 'defaultUIControlFontSize',10);
    lemnu =uimenu('Parent',fig, 'Label','&Fichier','enable','on');
    uimenu('Parent',lemnu, 'Label','&Ouvrir fichier batch','callback','batchEditExec(''BOuvrir'')');
    uimenu('Parent',lemnu, 'Label','&Sauvegarder fichier batch','callback','batchEditExec(''BSauve'')');
  % position des uipanel
    A.posx=0.01;Lpan=1-2*A.posx;A.large=Lpan;dy=0.005;A.posy=0.06;hpan3=0.315;hpan2=0.255;hpan1=0.35;A.haut=hpan3;
    panAction =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan2;
    panFichout =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan1;
    panFichin =A.pos;
    %-------------------
  % PANEL FICHIER ENTRÉE
  % les divisions horizontales se feront ainsi
  % marge de gauche: 2%
  % colonne de gauche: 54%
  % entre les 2 colonnes: 2%
  % colonne droite: 38%
  % marge de droite: 4%
    pan =uipanel('Parent',fig, 'title','Sélection des fichiers à traiter',...
                 'titleposition','righttop','Position',panFichin);
  % FICHIER/DOSSIER ENTRÉE (TEXTE)
    margex=0.02;lcol1=0.54;lcol2=1-lcol1-3*margex;hbout=0.07;
    A.posx=margex;A.large=lcol1;A.haut=hbout;A.posy=1-1.5*A.haut;memy=A.posy;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Noms des fichiers/dossier');
  % FICHIER/DOSSIER ENTRÉE (LISTBOX)
    lastr ='****Vide****';
    A.haut=A.posy-0.06;A.posy=A.posy-A.haut;
    uicontrol('Parent',pan,'Tag','choixfichier','BackgroundColor',BLANC,'Style','listbox',...
              'fontsize',8,'Position',A.pos,'String',lastr,'Value',1);
  % BUTTONGROUP
    A.posx=A.posx+A.large+margex;A.large=lcol2;A.haut=0.5;A.posy=memy-A.haut;memA=A.pos;
    uibg =uibuttongroup('parent',pan,'tag','BGfichIN','backgroundColor',GRIS,...
                        'selectionchangefcn',@Ppa.changePosteRadio,'position',A.pos);
    A.posx=0.05;A.large=1-2*A.posx;A.haut=1/7;A.posy=1-2*A.haut;
    ico =imread('ptiteflechdrte.bmp','BMP');
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Sélectionner les fichiers manuellement','cdata',ico);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Un dossier contenant tous les fichiers','Value',0);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Contenu d''un dossier+sous-dossiers','Value',0);
  % BOUTTON CHERCHER/SÉLECTIONNER
    A.large=memA(3)/2;A.posx=memA(1)+A.large/2;A.haut=hbout*1.5;A.posy=memA(2)-A.haut-0.01;
    uicontrol('parent',pan,'position',A.pos,'string','Chercher/Sélectionner',...
              'tooltipstring','Pour faire la sélection en fonction du choix défini ci-haut');
    %---------------------
    % PANEL FICHIER SORTIE
    pan =uipanel('Parent',fig, 'title','Emplacement des fichiers de sortie','Position',panFichout);
    lcol1=0.37;lcol2=0.07;lcol4=0.2;lcol5=0.03;lcol3=1-(lcol1+lcol2+lcol4+lcol5+4*margex);
    hbout=0.128;
  % BUTTONGROUP
    A.posx=margex;A.large=lcol1;A.haut=0.8;A.posy=(1-A.haut)/2;memy=A.posy;
    uibg =uibuttongroup('parent',pan,'tag','BGfichOUT','backgroundColor',GRIS,...
                        'selectionchangefcn',@Ppa.changePosteRadio,'position',A.pos);
    A.large=1-1.25*A.posx;A.haut=1/9;A.posy=1-2*A.haut;
    ico =imread('ptiteflechdrte.bmp','BMP');FO=9;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Ré-écrire sur le fichier d''entrée','Value',0);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'Value',1,'fontsize',FO,...
              'string','Même dossier, changer le nom de fichier','cdata',ico);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier, même nom de fichier','Value',0);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier, changer le nom de fichier','Value',0);
  % TEXT/EDIT DOSSIER SAUVEGARDE
    A.posx=lcol1+2*margex;A.large=lcol2+lcol3+lcol4+margex;A.haut=hbout;A.posy=1-1.5*A.haut;memx=A.posx;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Dossier pour la sauvegarde des résultats');
    A.posy=A.posy-A.haut;memy2=A.posy;
    uicontrol('parent',pan,'Tag','editdossierfinal','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','');
  % BOUTTON ... CHOIX DU DOSSIER
    A.posx=A.posx+A.large;A.large=lcol5;
    uicontrol('parent',pan,'position',A.pos,'string','...',...
              'tooltipstring','Pour faire la sélection du dossier de sortie');
  % TEXT AJOUTER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=memx;A.large=lcol2;A.posy=memy-A.haut+(memy2-memy)/2;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Ajouter: ','horizontalalignment','right');
  % TEXT/EDIT MODIFIER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=A.posx+A.large;A.large=lcol3;A.posy=A.posy+A.haut;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Modification au nom de fichier','horizontalalignment','center');
    A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'Tag','editfichierpresuf','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','');

  %-------------
  % PANEL ACTION
    pan =uipanel('Parent',fig, 'title','Actions à effectuer',...
                 'titleposition','lefttop','Position',panAction);
  % ********BATCH À EXÉCUTER
    bouty =0.08;A.posx=margex;A.large=0.4;A.posy=bouty;A.haut=1-2*A.posy;debuty=A.posy+A.haut;finy=A.posy;
    conmnu = uicontextmenu;
    uicontrol('Parent',pan, 'Tag','batchafaire',...
              'BackgroundColor',BLANC, 'Callback','batchEditExec(''batchafaire'')',...
              'Style','listbox', 'Position',A.pos, ...
              'String','****Nouvelle action****','UIContextMenu', conmnu, 'Value',1);
    % Définition des ContextMenus
    uimenu(conmnu,'Label', 'Ajouter', 'Callback',@Ppa.ajouterAction);
    uimenu(conmnu,'Label', 'Supprimer', 'Callback',@Ppa.effacerAction);
    uimenu(conmnu,'Label', 'Monter', 'Callback',@Ppa.monterAction);
    uimenu(conmnu,'Label', 'Descendre', 'Callback',@Ppa.descendreAction);
    intx =0.03; boutx =0.15;
    A.posx =A.posx+A.large+intx;A.large=boutx;A.haut=0.1;A.posy=debuty-((debuty-finy-4*A.haut)/2)-A.haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.effacerAction, ...
  	      'Position',A.pos, 'String','Supprimer');
    A.posy =A.posy-A.haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.monterAction, ...
  	      'Position',A.pos, 'String','Monter');
    A.posy =A.posy-A.haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.descendreAction, ...
              'Position',A.pos, 'String','Descendre');
    A.posy =A.posy-A.haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.modifierAction, ...
              'Position',A.pos, 'String','Modifier');
  % ********AU TRAFFAILLE, voyons, c qui kia encowe pis mes dents... :-B
    A.posx=(1-A.large)/2; A.haut=bouty/3; A.posy=bouty/4;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''allez_du_nerf'')', ...
              'Position',A.pos, 'String','Au travail');
    guidata(fig,Ppa);
    delete(A);
end
