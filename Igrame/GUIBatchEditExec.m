%
% ***GUI POUR L'EXÉCUTION EN BATCH***
%
% Adapté pour Octave/Matlab
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
    pause(0.25);
    fig  =figure('Name','TRAITEMENT EN LOT','tag','IpBatch','Resize','on',...
                 'Position', lapos,'CloseRequestFcn',{@quienllama,'terminus'},'MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',GRIS,...
                 'DefaultUIPanelBackgroundColor',GRIS,'DefaultUIPanelTitlePosition','centertop',...
                 'defaultUIControlFontSize',10);
    setappdata(fig,'Ppa',Ppa);
    lemnu =uimenu('parent',fig, 'Label','&Fichier','enable','on');
    uimenu('parent',lemnu, 'Label','&Ouvrir fichier batch','callback',{@quienllama,'ouvrirParamBatch'});
    uimenu('parent',lemnu, 'Label','&Sauvegarder fichier batch','callback',{@quienllama,'sauveParamBatch'});
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
              'fontsize',9,'Position',A.pos,'String',lastr,'value',1);
  % IMITATION D'UN BUTTONGROUP
  % **************************
    A.posx=margex;A.large=lcol2;A.haut=0.5;A.posy=memy-A.haut;memA=A.pos;
    uibg =uipanel('parent',pan,'tag','BGfichIN','backgroundColor',GRIS,'position',A.pos, ...
                  'titleposition','rightbottom','title',[num2str(Ppa.Nfich) ' fichiers à traiter']);
    A.posx=0.05;A.large=1-2*A.posx;A.haut=1/7;A.posy=1-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','fichiermanuel','value',0,...
              'string','Sélectionner les fichiers manuellement','callback',{@quienllama,'dossierFichierEntree'});
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','undosstousfich','value',0,...
              'string','Un dossier contenant tous les fichiers','callback',{@quienllama,'dossierFichierEntree'});
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','dossousdoss','value',0,...
              'string','Contenu d''un dossier+sous-dossiers','callback',{@quienllama,'dossierFichierEntree'});
    %----------------------------
    %    PANEL FICHIER SORTIE
    %----------------------------
    pan =uipanel('parent',fig, 'title','Emplacement des fichiers de sortie','Position',panFichout);
    lcol1=0.37;lcol2=0.07;lcol4=0.2;lcol5=0.03;lcol3=1-(lcol1+lcol2+lcol4+lcol5+4*margex);
    hbout=0.128;
  % BUTTONGROUP (MÊME/NOUVEAU DOSSIER)
    A.posx=margex;A.large=lcol1;A.haut=0.8;A.posy=(1-A.haut)/2;memy=A.posy;
    try
      % 'selectionchangefcn' pour Matlab
      uibg =uibuttongroup('parent',pan,'tag','BGfichOUT','backgroundColor',GRIS,...
                          'selectionchangefcn',{@quienllama,'dossierFichierSortie'},'position',A.pos);
    catch sss;
      % 'selectionchangedfcn' pour Octave
      uibg =uibuttongroup('parent',pan,'tag','BGfichOUT','backgroundColor',GRIS,...
                          'selectionchangedfcn',{@quienllama,'dossierFichierSortie'},'position',A.pos);
    end
    A.large=1-1.25*A.posx;A.haut=1/9;A.posy=1-2*A.haut;membg=uibg;
    FO=9;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Ré-écrire sur le fichier d''entrée','value',0,'tag','ecrase');
    A.posy=A.posy-2*A.haut;
    % Valeur par défaut
    try
      % Octave ne supporte pas encore la propriété "cdata"
      ico =imread('ptiteflechdrte.bmp','BMP');
      uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'value',1,'fontsize',FO,...
                'string','Même dossier, changer le nom de fichier','cdata',ico,'tag','changfich');
    catch sss;
      uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'value',1,'fontsize',FO,...
                'string','Même dossier, changer le nom de fichier','tag','changfich');
    end
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier, même nom de fichier','value',0,'tag','changdoss');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier et changer nom de fichier','value',0,'tag','changtout');
  % TEXT/EDIT DOSSIER SAUVEGARDE
    A.posx=lcol1+2*margex;A.large=lcol2+lcol3+lcol4+margex;A.haut=hbout;A.posy=1-1.5*A.haut;memx=A.posx;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Dossier pour la sauvegarde des résultats');
    A.posy=A.posy-A.haut;memy2=A.posy;
    uicontrol('parent',pan,'tag','editdossierfinal','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','');
  % BOUTTON ... CHOIX DU DOSSIER
    A.posx=A.posx+A.large;A.large=lcol5;
    uicontrol('parent',pan,'position',A.pos,'string','...','tag','boutondossierfinal',...
              'tooltipstring','Faire la sélection du dossier de sortie','callback',{@quienllama,'choixDossierSortie'});
  % TEXT AJOUTER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=memx;A.large=lcol2;A.posy=memy-A.haut+(memy2-memy)/2;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Ajouter: ','horizontalalignment','right');
  % TEXT/EDIT MODIFIER POUR LE (pré/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=A.posx+A.large;A.large=lcol3;A.posy=A.posy+A.haut;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Modification au nom de fichier','horizontalalignment','center');
    A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'tag','editfichierpresuf','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','_batch');
  % BUTTONGROUP (PRÉ/SUF)FIXE
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.posy=memy;A.haut=memy2-A.posy-hbout;
    try
      % 'selectionchangefcn' pour Matlab
      uibg =uibuttongroup('parent',pan,'tag','BGnomfichOUT','backgroundColor',GRIS,...
                          'selectionchangefcn',{@quienllama,'changePosteRadio'},'position',A.pos);
    catch sss;
      % 'selectionchangedfcn' pour Octave
      uibg =uibuttongroup('parent',pan,'tag','BGnomfichOUT','backgroundColor',GRIS,...
                          'selectionchangedfcn',{@quienllama,'changePosteRadio'},'position',A.pos);
    end
    A.posx=margex;A.large=1-2*A.posx;A.haut=1/5;A.posy=1-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Comme préfixe','value',0,'tag','prefix');
    A.posy=A.posy-2*A.haut;
    try
      % Octave ne supporte pas encore la propriété "cdata"
      ico =imread('ptiteflechdrte.bmp','BMP');
      uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'value',1,...
                'string','Comme suffixe','cdata',ico,'tag','suffix');
    catch sss;
      uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'value',1,...
                'string','Comme suffixe','tag','suffix');
    end
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
    try
      % Octave ne supporte pas encore la propriété "cdata"
      ico =imread(which('longflechdrte.bmp'),'BMP');
      uicontrol('parent',pan,'Callback',{@quienllama,'ajouterAction'},'Position',A.pos,'cdata',ico,...
  	            'tooltipstring','Ajouter l''action sélectionnée');
    catch sss;
      uicontrol('parent',pan,'Callback',{@quienllama,'ajouterAction'},'Position',A.pos,'string','==>',...
  	            'tooltipstring','Ajouter l''action sélectionnée');
    end
    % LISTBOX DES ACTIONS SÉLECTIONNÉES
  	A.posx=A.posx+A.large+0.5*margex;A.large=lcol3;A.posy=lapos(2);A.haut=lapos(4);
    uicontrol('parent',pan,'tag','batchafaire','BackgroundColor',BLANC,'Style','listbox',...
              'Position',A.pos,'String','','max',1,'value',1);
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.haut=hy;A.posy=debuty-((debuty-finy-5*A.haut)/2)-A.haut;
    uicontrol('parent',pan,'Callback',{@quienllama,'effacerAction'},'Position',A.pos,'String','Supprimer');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',{@quienllama,'monterAction'},'Position',A.pos,'String','Monter');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',{@quienllama,'descendreAction'},'Position',A.pos,'String','Descendre');
    A.posy =A.posy-2*A.haut;
    uicontrol('parent',pan,'Callback',{@quienllama,'modifierAction'},'Position',A.pos,'String','Configurer');
  % ********AU TWAFFAILLE, foyons, fé qui kia encowe pis mes dents... :-B
    A.posx=(1-A.large)/2; A.haut=bouty/3; A.posy=bouty/4;
    uicontrol('parent',fig,'Callback',{@quienllama,'auTravail'},'Position',A.pos,'String','Au travail');
    % on fait le ménage des objets inutiles
    delete(A);
    % on rend la figure modal
    Ppa.setFigModal();
    % on affiche la flèche au choix par défaut du dossier de sortie
    Ppa.dossierFichierSortie(membg);
end

%
% on call la method "Ppa.(autre)"
%
function quienllama(src,evt, autre)
  Ppa =getappdata(gcf,'Ppa');
  switch autre
  case 'terminus'
    Ppa.terminus();
  case 'ouvrirParamBatch'
    Ppa.ouvrirParamBatch(src);
  case 'sauveParamBatch'
    Ppa.sauveParamBatch(src);
  case 'dossierFichierEntree'
    Ppa.dossierFichierEntree(src);
  case 'dossierFichierSortie'
    Ppa.dossierFichierSortie(src);
  case 'choixDossierSortie'
    Ppa.choixDossierSortie(src);
  case 'changePosteRadio'
    Ppa.changePosteRadio(src);
  case 'ajouterAction'
    Ppa.ajouterAction(src);
  case 'effacerAction'
    Ppa.effacerAction(src);
  case 'monterAction'
    Ppa.monterAction(src);
  case 'descendreAction'
    Ppa.descendreAction(src);
  case 'modifierAction'
    Ppa.modifierAction(src);
  case 'auTravail'
    Ppa.auTravail(src);
  end
end
