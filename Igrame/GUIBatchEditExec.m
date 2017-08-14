%
% ***GUI POUR L'EXÉCUTION EN BATCH***
%
%
function fig = GUIBatchEditExec(Ppa)
    lafig =gcf;
    large =700; haut =600;
    lapos =positionfen('C','C',large,haut,lafig);
    GRIS =[0.8 0.8 0.8];
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
    intx =0.03; inty =0.025; bouty =0.08; boutx =0.15; winx =0.7;
    hbox =1-5*bouty; margex =.075;
    % position des uipanel
    panhaut=[0.01 0.47 0.98 0.51]; panbas=[0.01 0.1 0.98 0.35];
    % PANEL HAUT
    pan =uipanel('Parent',fig, 'title','Fichier et path','Position',panhaut);
    % ********FICHIER/TÂCHES OU TÂCHE/FICHIERS  CHECKBOX
    posx=margex/3; large=0.4; haut=0.85; posy=0.05;
    lastr ='C:\Users\mek\Documents\work\SAM\Data\mabounneda.mat'; % '****Vide****'
    uicontrol('Parent',pan,'Tag','choixfichier','BackgroundColor',[1 1 1],'Style','listbox',...
              'fontsize',8,'Position',[posx posy large haut],'String',lastr,'Value',1);
    
    % PANEL BAS
    pan =uipanel('Parent',fig, 'title','Tâches à effectuer','Position',panbas);
    % ********BATCH À EXÉCUTER
    large=winx; haut=1-2*bouty; posy=bouty; debuty=posy+haut; finy=posy;
    conmnu = uicontextmenu;
    uicontrol('Parent',pan, 'Tag','batchafaire',...
              'BackgroundColor',[1 1 1], 'Callback','batchEditExec(''batchafaire'')',...
              'Style','listbox', 'Position',[posx posy large haut], ...
              'String','****Nouvelle action****','UIContextMenu', conmnu, 'Value',1);
    % Définition des ContextMenus
    uimenu(conmnu,'Label', 'Ajouter', 'Callback',@Ppa.ajouterAction);
    uimenu(conmnu,'Label', 'Supprimer', 'Callback',@Ppa.effacerAction);
    uimenu(conmnu,'Label', 'Monter', 'Callback',@Ppa.monterAction);
    uimenu(conmnu,'Label', 'Descendre', 'Callback',@Ppa.descendreAction);
    posx =posx+large+intx;large =boutx;haut=0.1;posy =debuty-((debuty-finy-5*haut)/2)-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.ajouterAction, ...
  	      'Position',[posx posy large haut], 'String','Ajouter');
    posy =posy-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.effacerAction, ...
  	      'Position',[posx posy large haut], 'String','Supprimer');
    posy =posy-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.monterAction, ...
  	      'Position',[posx posy large haut], 'String','Monter');
    posy =posy-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.descendreAction, ...
              'Position',[posx posy large haut], 'String','Descendre');
    posy =posy-haut;
    uicontrol('Parent',pan, 'Callback',@Ppa.modifierAction, ...
              'Position',[posx posy large haut], 'String','Modifier');
  % ********AU TRAFFAILLE, voyons, c qui kia encowe pis mes dents... :-B
    posx=(1-large)/2; posy=bouty/4; haut=bouty/2;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''allez_du_nerf'')', ...
              'Position',[posx posy large haut], 'String','Au travail');
    guidata(fig,Ppa);

end
