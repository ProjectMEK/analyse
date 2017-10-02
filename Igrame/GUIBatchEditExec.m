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
    delete(findobj('tag', 'IpBatch'));
    pause(0.5);
    fig  =figure('Name','TRAITEMENT EN LOT','tag','IpBatch',...
                 'Resize','on', 'Position', lapos, ...
                 'CloseRequestFcn',@Ppa.terminus,'MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',GRIS,...
                 'DefaultUIPanelBackgroundColor',GRIS,'DefaultUIPanelTitlePosition','centertop',...
                 'defaultUIControlFontSize',10);
    lemnu =uimenu('parent',fig, 'Label','&Fichier','enable','on');
    uimenu('parent',lemnu, 'Label','&Ouvrir fichier batch','callback','batchEditExec(''BOuvrir'')');
    uimenu('parent',lemnu, 'Label','&Sauvegarder fichier batch','callback','batchEditExec(''BSauve'')');
  % position des uipanel
    A.posx=0.01;Lpan=1-2*A.posx;A.large=Lpan;dy=0.005;A.posy=0.06;hpan3=0.315;hpan2=0.255;hpan1=0.35;A.haut=hpan3;
    panAction =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan2;
    panFichout =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan1;
    panFichin =A.pos;
  %-----------------------------
  %    PANEL FICHIER ENTRÉE
  %-----------------------------
  % les divisions horizontales se feront ainsi
  % marge de gauche: 2%
  % colonne de gauche: 54%
  % entre les 2 colonnes: 2%
  % colonne droite: 38%
  % marge de droite: 4%
    pan =uipanel('parent',fig, 'title','Sélection des fichiers à traiter',...
                 'titleposition','righttop','Position',panFichin);
  % FICHIER/DOSSIER ENTRÉE (TEXTE)
    margex=0.02;lcol1=0.54;lcol2=1-lcol1-3*margex;hbout=0.07;
    A.large=lcol1;A.posx=1-A.large-margex;A.haut=hbout;A.posy=1-1.5*A.haut;memy=A.posy;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Noms des fichiers/dossier');
  % FICHIER/DOSSIER ENTRÉE (LISTBOX)
    lastr ='****Vide****';
    A.haut=A.posy-0.06;A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'tag','choixfichier','BackgroundColor',BLANC,'Style','listbox',...
              'fontsize',9,'Position',A.pos,'String',lastr,'Value',1);
  % IMITATION D'UN BUTTONGROUP
  % **************************
    A.posx=margex;A.large=lcol2;A.haut=0.5;A.posy=memy-A.haut;memA=A.pos;
    uibg =uipanel('parent',pan,'tag','BGfichIN','backgroundColor',GRIS,'position',A.pos);
    A.posx=0.05;A.large=1-2*A.posx;A.haut=1/7;A.posy=1-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','fichiermanuel','Value',0,...
              'string','Sélectionner les fichiers manuellement','callback',@Ppa.dossierFichierEntree);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','undosstousfich','Value',0,...
              'string','Un dossier contenant tous les fichiers','callback',@Ppa.dossierFichierEntree);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','dossousdoss','Value',0,...
              'string','Contenu d''un dossier+sous-dossiers','callback',@Ppa.dossierFichierEntree);
    %----------------------------
    %    PANEL FICHIER SORTIE
    %----------------------------
    pan =uipanel('parent',fig, 'title','Emplacement des fichiers de sortie','Position',panFichout);
    lcol1=0.37;lcol2=0.07;lcol4=0.2;lcol5=0.03;lcol3=1-(lcol1+lcol2+lcol4+lcol5+4*margex);
    hbout=0.128;
  % BUTTONGROUP (MÊME/NOUVEAU DOSSIER)
    A.posx=margex;A.large=lcol1;A.haut=0.8;A.posy=(1-A.haut)/2;memy=A.posy;
    uibg =uibuttongroup('parent',pan,'tag','BGfichOUT','backgroundColor',GRIS,...
                        'selectionchangefcn',@Ppa.dossierFichierSortie,'position',A.pos);
    A.large=1-1.25*A.posx;A.haut=1/9;A.posy=1-2*A.haut;membg=uibg;
    ico =imread('ptiteflechdrte.bmp','BMP');FO=9;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Ré-écrire sur le fichier d''entrée','Value',0,'tag','ecrase');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'Value',1,'fontsize',FO,...
              'string','Même dossier, changer le nom de fichier','cdata',ico,'tag','changfich');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier, même nom de fichier','Value',0,'tag','changdoss');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier et changer nom de fichier','Value',0,'tag','changtout');
  % TEXT/EDIT DOSSIER SAUVEGARDE
    A.posx=lcol1+2*margex;A.large=lcol2+lcol3+lcol4+margex;A.haut=hbout;A.posy=1-1.5*A.haut;memx=A.posx;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Dossier pour la sauvegarde des résultats');
    A.posy=A.posy-A.haut;memy2=A.posy;
    uicontrol('parent',pan,'tag','editdossierfinal','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','');
  % BOUTTON ... CHOIX DU DOSSIER
    A.posx=A.posx+A.large;A.large=lcol5;
    uicontrol('parent',pan,'position',A.pos,'string','...','tag','boutondossierfinal',...
              'tooltipstring','Pour faire la sélection du dossier de sortie');
  % TEXT AJOUTER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=memx;A.large=lcol2;A.posy=memy-A.haut+(memy2-memy)/2;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Ajouter: ','horizontalalignment','right');
  % TEXT/EDIT MODIFIER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=A.posx+A.large;A.large=lcol3;A.posy=A.posy+A.haut;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Modification au nom de fichier','horizontalalignment','center');
    A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'Tag','editfichierpresuf','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','_batch');
  % BUTTONGROUP PRÉ/SUFFIXE
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.posy=memy;A.haut=memy2-A.posy-hbout;
    uibg =uibuttongroup('parent',pan,'tag','BGnomfichOUT','backgroundColor',GRIS,...
                        'selectionchangefcn',@Ppa.changePosteRadio,'position',A.pos);
    A.posx=margex;A.large=1-2*A.posx;A.haut=1/5;A.posy=1-2*A.haut;
    ico =imread('ptiteflechdrte.bmp','BMP');
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Comme préfixe','Value',0,'tag','prefix');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'Value',1,...
              'string','Comme suffixe','cdata',ico,'tag','suffix');
  %---------------------
  %    PANEL ACTION
  %---------------------
    pan =uipanel('parent',fig, 'title','Actions à effectuer',...
                 'titleposition','lefttop','Position',panAction);
  % LISTE POUR LA SÉLECTION DES ACTIONS À EXÉCUTER
    lcol2=0.08;lcol4=0.12;lcol1=(1-lcol2-lcol4-4*margex)/2;lcol3=lcol1;bouty=0.08;hy=0.11;
    A.posx=margex;A.large=lcol1;A.posy=bouty;A.haut=1-1.75*A.posy;debuty=A.posy+A.haut;finy=A.posy;
    lapos=A.pos;
    lemax =length(Ppa.listChoixActions);
    uicontrol('parent',pan,'tag','listbatchafaire','backgroundcolor',BLANC,'style','listbox',...
              'Position',A.pos,'String',Ppa.listChoixActions,'max',lemax,'value',1);
  % BOUTON FLÈCHE: AJOUT D'UNE ACTION À FAIRE
    A.posx=A.posx+A.large+0.5*margex;A.large=lcol2;A.haut=hy;A.posy=lapos(2)+lapos(4)/2;
    ico =imread('longflechdrte.bmp','BMP');
    uicontrol('parent',pan,'Callback',@Ppa.ajouterAction,'Position',A.pos,'cdata',ico,...
  	          'tooltipstring','Ajouter l''action sélectionnée');
  % LISTBOX DES ACTIONS SÉLECTIONNÉES
  	A.posx=A.posx+A.large+0.5*margex;A.large=lcol3;A.posy=lapos(2);A.haut=lapos(4);
    uicontrol('parent',pan,'tag','batchafaire','BackgroundColor',BLANC,'Style','listbox',...
              'Position',A.pos,'String','','Value',1);
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.haut=hy;A.posy=debuty-((debuty-finy-4*A.haut)/2)-A.haut;
    uicontrol('parent',pan,'Callback',@Ppa.effacerAction,'Position',A.pos,'String','Supprimer');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',@Ppa.monterAction,'Position',A.pos,'String','Monter');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',@Ppa.descendreAction,'Position',A.pos,'String','Descendre');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',@Ppa.modifierAction,'Position',A.pos,'String','Modifier');
  % ********AU TWAFFAILLE, foyons, fé qui kia encowe pis mes dents... :-B
    A.posx=(1-A.large)/2; A.haut=bouty/3; A.posy=bouty/4;
    uicontrol('parent',fig,'Callback',@Ppa.auTravail,'Position',A.pos,'String','Au travail');
    guidata(fig,Ppa);
    delete(A);
    Ppa.dossierFichierSortie(membg);
end
