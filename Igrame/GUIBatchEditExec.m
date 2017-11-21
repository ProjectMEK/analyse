%
% ***GUI POUR L'EX�CUTION EN BATCH***
%
% Adapt� pour Octave/Matlab
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
                 'Position', lapos,'CloseRequestFcn',@terminus,'MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',GRIS,...
                 'DefaultUIPanelBackgroundColor',GRIS,'DefaultUIPanelTitlePosition','centertop',...
                 'defaultUIControlFontSize',10);
    setappdata(fig,'Ppa',Ppa);
    lemnu =uimenu('parent',fig, 'Label','&Fichier','enable','on');
    uimenu('parent',lemnu, 'Label','&Ouvrir fichier batch','callback',@ouvrirParamBatch);
    uimenu('parent',lemnu, 'Label','&Sauvegarder fichier batch','callback',@sauveParamBatch);
  % position des uipanel
    A.posx=0.01;Lpan=1-2*A.posx;A.large=Lpan;dy=0.005;A.posy=0.06;hpan3=0.315;hpan2=0.255;hpan1=0.35;A.haut=hpan3;
    panAction =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan2;
    panFichout =A.pos;
    A.posy=A.posy+A.haut+dy;A.haut=hpan1;
    panFichin =A.pos;
  %-----------------------------
  %    PANEL FICHIER ENTR�E
  %-----------------------------
  % les divisions horizontales se feront ainsi
  % marge de gauche: 2%
  % colonne de gauche: 54%
  % entre les 2 colonnes: 2%
  % colonne droite: 38%
  % marge de droite: 4%
    pan =uipanel('parent',fig, 'title','S�lection des fichiers � traiter',...
                 'titleposition','righttop','Position',panFichin);
  % FICHIER/DOSSIER ENTR�E (TEXTE)
    margex=0.02;lcol1=0.54;lcol2=1-lcol1-3*margex;hbout=0.07;
    A.large=lcol1;A.posx=1-A.large-margex;A.haut=hbout;A.posy=1-1.5*A.haut;memy=A.posy;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Noms des fichiers/dossier');
  % FICHIER/DOSSIER ENTR�E (LISTBOX)
    lastr ='****Vide****';
    A.haut=A.posy-0.06;A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'tag','choixfichier','BackgroundColor',BLANC,'Style','listbox',...
              'fontsize',9,'Position',A.pos,'String',lastr,'Value',1);
  % IMITATION D'UN BUTTONGROUP
  % **************************
    A.posx=margex;A.large=lcol2;A.haut=0.5;A.posy=memy-A.haut;memA=A.pos;
    uibg =uipanel('parent',pan,'tag','BGfichIN','backgroundColor',GRIS,'position',A.pos, ...
                  'titleposition','rightbottom','title',[num2str(Ppa.Nfich) ' fichiers � traiter']);
    A.posx=0.05;A.large=1-2*A.posx;A.haut=1/7;A.posy=1-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','fichiermanuel','Value',0,...
              'string','S�lectionner les fichiers manuellement','callback',@dossierFichierEntree);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','undosstousfich','Value',0,...
              'string','Un dossier contenant tous les fichiers','callback',@dossierFichierEntree);
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'tag','dossousdoss','Value',0,...
              'string','Contenu d''un dossier+sous-dossiers','callback',@dossierFichierEntree);
    %----------------------------
    %    PANEL FICHIER SORTIE
    %----------------------------
    pan =uipanel('parent',fig, 'title','Emplacement des fichiers de sortie','Position',panFichout);
    lcol1=0.37;lcol2=0.07;lcol4=0.2;lcol5=0.03;lcol3=1-(lcol1+lcol2+lcol4+lcol5+4*margex);
    hbout=0.128;
  % BUTTONGROUP (M�ME/NOUVEAU DOSSIER)
    A.posx=margex;A.large=lcol1;A.haut=0.8;A.posy=(1-A.haut)/2;memy=A.posy;
    uibg =uibuttongroup('parent',pan,'tag','BGfichOUT','backgroundColor',GRIS,...
                        'selectionchangefcn',@dossierFichierSortie,'position',A.pos);
    A.large=1-1.25*A.posx;A.haut=1/9;A.posy=1-2*A.haut;membg=uibg;
    ico =imread('ptiteflechdrte.bmp','BMP');FO=9;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','R�-�crire sur le fichier d''entr�e','Value',0,'tag','ecrase');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'Value',1,'fontsize',FO,...
              'string','M�me dossier, changer le nom de fichier','cdata',ico,'tag','changfich');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier, m�me nom de fichier','Value',0,'tag','changdoss');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'fontsize',FO,...
              'string','Nouveau dossier et changer nom de fichier','Value',0,'tag','changtout');
  % TEXT/EDIT DOSSIER SAUVEGARDE
    A.posx=lcol1+2*margex;A.large=lcol2+lcol3+lcol4+margex;A.haut=hbout;A.posy=1-1.5*A.haut;memx=A.posx;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Dossier pour la sauvegarde des r�sultats');
    A.posy=A.posy-A.haut;memy2=A.posy;
    uicontrol('parent',pan,'tag','editdossierfinal','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','');
  % BOUTTON ... CHOIX DU DOSSIER
    A.posx=A.posx+A.large;A.large=lcol5;
    uicontrol('parent',pan,'position',A.pos,'string','...','tag','boutondossierfinal',...
              'tooltipstring','Faire la s�lection du dossier de sortie','callback',@choixDossierSortie);
  % TEXT AJOUTER POUR LE (pr�/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=memx;A.large=lcol2;A.posy=memy-A.haut+(memy2-memy)/2;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Ajouter: ','horizontalalignment','right');
  % TEXT/EDIT MODIFIER POUR LE (pr�/suf)FIXE DU NOUVEAU NOM DE FICHIER
    A.posx=A.posx+A.large;A.large=lcol3;A.posy=A.posy+A.haut;
    uicontrol('parent',pan,'style','text','position',A.pos,'string','Modification au nom de fichier','horizontalalignment','center');
    A.posy=A.posy-A.haut;
    uicontrol('parent',pan,'Tag','editfichierpresuf','BackgroundColor',BLANC,...
              'Style','edit','Position',A.pos,'string','_batch');
  % BUTTONGROUP (PR�/SUF)FIXE
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.posy=memy;A.haut=memy2-A.posy-hbout;
    uibg =uibuttongroup('parent',pan,'tag','BGnomfichOUT','backgroundColor',GRIS,...
                        'selectionchangefcn',@changePosteRadio,'position',A.pos);
    A.posx=margex;A.large=1-2*A.posx;A.haut=1/5;A.posy=1-2*A.haut;
    ico =imread('ptiteflechdrte.bmp','BMP');
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,...
              'string','Comme pr�fixe','Value',0,'tag','prefix');
    A.posy=A.posy-2*A.haut;
    uicontrol('parent',uibg,'style','radiobutton','position',A.pos,'Value',1,...
              'string','Comme suffixe','cdata',ico,'tag','suffix');
  %---------------------
  %    PANEL ACTION
  %---------------------
    pan =uipanel('parent',fig, 'title','Actions � effectuer',...
                 'titleposition','lefttop','Position',panAction);
  % LISTE POUR LA S�LECTION DES ACTIONS � EX�CUTER
    lcol2=0.08;lcol4=0.12;lcol1=(1-lcol2-lcol4-4*margex)/2;lcol3=lcol1;bouty=0.08;hy=0.11;
    A.posx=margex;A.large=lcol1;A.posy=bouty;A.haut=1-1.75*A.posy;debuty=A.posy+A.haut;finy=A.posy;
    lapos=A.pos;
    lemax =length(Ppa.listChoixActions);
    uicontrol('parent',pan,'tag','listbatchafaire','backgroundcolor',BLANC,'style','listbox',...
              'Position',A.pos,'String',Ppa.listChoixActions,'max',lemax,'value',1);
  % BOUTON FL�CHE: AJOUT D'UNE ACTION � FAIRE
    A.posx=A.posx+A.large+0.5*margex;A.large=lcol2;A.haut=hy;A.posy=lapos(2)+lapos(4)/2;
    ico =imread('longflechdrte.bmp','BMP');
    uicontrol('parent',pan,'Callback',@ajouterAction,'Position',A.pos,'cdata',ico,...
  	          'tooltipstring','Ajouter l''action s�lectionn�e');
  % LISTBOX DES ACTIONS S�LECTIONN�ES
  	A.posx=A.posx+A.large+0.5*margex;A.large=lcol3;A.posy=lapos(2);A.haut=lapos(4);
    uicontrol('parent',pan,'tag','batchafaire','BackgroundColor',BLANC,'Style','listbox',...
              'Position',A.pos,'String','','max',1,'Value',1);
    A.posx=A.posx+A.large+margex;A.large=lcol4;A.haut=hy;A.posy=debuty-((debuty-finy-5*A.haut)/2)-A.haut;
    uicontrol('parent',pan,'Callback',@effacerAction,'Position',A.pos,'String','Supprimer');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',@monterAction,'Position',A.pos,'String','Monter');
    A.posy =A.posy-A.haut;
    uicontrol('parent',pan,'Callback',@descendreAction,'Position',A.pos,'String','Descendre');
    A.posy =A.posy-2*A.haut;
    uicontrol('parent',pan,'Callback',@modifierAction,'Position',A.pos,'String','Configurer');
  % ********AU TWAFFAILLE, foyons, f� qui kia encowe pis mes dents... :-B
    A.posx=(1-A.large)/2; A.haut=bouty/3; A.posy=bouty/4;
    uicontrol('parent',fig,'Callback',@auTravail,'Position',A.pos,'String','Au travail');
    % on fait le m�nage des objets inutiles
    delete(A);
    % on rend la figure modal
    Ppa.setFigModal();
    % on affiche la fl�che au choix par d�faut du dossier de sortie
    Ppa.dossierFichierSortie(membg);
end

%
% on call la method "Ppa.terminus"
%
function terminus(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.terminus();
end

%
% on call la method "Ppa.ouvrirParamBatch"
%
function ouvrirParamBatch(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.ouvrirParamBatch();
end

%
% on call la method "Ppa.sauveParamBatch"
%
function sauveParamBatch(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.sauveParamBatch();
end

%
% on call la method "Ppa.dossierFichierEntree"
%
function dossierFichierEntree(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.dossierFichierEntree();
end

%
% on call la method "Ppa.dossierFichierSortie"
%
function dossierFichierSortie(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.dossierFichierSortie();
end

%
% on call la method "Ppa.choixDossierSortie"
%
function choixDossierSortie(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.choixDossierSortie();
end

%
% on call la method "Ppa.changePosteRadio"
%
function changePosteRadio(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.changePosteRadio();
end

%
% on call la method "Ppa.ajouterAction"
%
function ajouterAction(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.ajouterAction();
end

%
% on call la method "Ppa.effacerAction"
%
function effacerAction(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.effacerAction();
end

%
% on call la method "Ppa.monterAction"
%
function monterAction(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.monterAction();
end

%
% on call la method "Ppa.descendreAction"
%
function descendreAction(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.descendreAction();
end

%
% on call la method "Ppa.modifierAction"
%
function modifierAction(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.modifierAction();
end

%
% on call la method "Ppa.auTravail"
%
function auTravail(varargin)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.auTravail();
end
