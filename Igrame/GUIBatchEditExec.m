%
% ***GUI POUR L'EX�CUTION EN BATCH***
%
%
function fig = GUIBatchEditExec(Ppa)
    lafig =gcf;
    large =600; haut =300;
    lapos =positionfen('C','C',large,haut,lafig);
    fig  =figure('Name','TRAITEMENT EN LOT','tag', 'IpBatch',...
                 'Resize','on', 'Position', lapos, ...
                 'CloseRequestFcn',@Ppa.terminus,'MenuBar','none',...
                 'defaultuicontrolunits','Normalized',...
                 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                 'defaultUIControlFontSize',10);
    set(lafig,'Visible','Off');
    lemnu =uimenu('Parent',fig, 'Label','&Fichier','enable','on');
    uimenu('Parent',lemnu, 'Label','&Ouvrir fichier batch','callback','batchEditExec(''BOuvrir'')');
    uimenu('Parent',lemnu, 'Label','&Sauvegarder fichier batch','callback','batchEditExec(''BSauve'')');
    intx =0.03; inty =0.025; bouty =0.08; boutx =0.15; winx =0.7;
    hbox =1-5*bouty; margex =.075;
  % ********FICHIER/T�CHES OU T�CHE/FICHIERS  CHECKBOX
    posx =margex;large =1-2*margex;haut =bouty; posy =1-1.5*haut;
    uicontrol('Parent',fig, 'Tag','tacfictac',...
              'Position',[posx posy large haut], 'Style','checkbox',...
              'callback','batchEditExec(''tacfic'')','value', hh.tacfic, ...
              'tooltipstring','L''inverse serait: Ex�cuter premi�re t�che sur tous les fichiers, passer � la t�che suivante',...
              'String', 'Ouvrir premier fichier, ex�cuter toutes les t�ches, passer au fichier suivant');
  % ********BATCH � EX�CUTER
    large =winx; posy =posy-1.5*haut; debuty =posy;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], ...
              'HorizontalAlignment','Center', 'Style','text',...
              'String','T�ches � effectuer');
    haut =hbox;posy =posy-haut; finy =posy;
    conmnu = uicontextmenu;
    uicontrol('Parent',fig, 'Tag','batchafaire',...
              'BackgroundColor',[1 1 1], 'Callback','batchEditExec(''batchafaire'')',...
              'Style','listbox', 'Position',[posx posy large haut], ...
              'String',hh.tach(1).Descr,'UIContextMenu', conmnu, 'Value',1);
    % D�finition des ContextMenus
    uimenu(conmnu,'Label', 'Ajouter', 'Callback','batchEditExec(''ajouterbatch'')');
    uimenu(conmnu,'Label', 'Supprimer', 'Callback', 'batchEditExec(''efface'')');
    uimenu(conmnu,'Label', 'Monter', 'Callback', 'batchEditExec(''monter'')');
    uimenu(conmnu,'Label', 'Descendre', 'Callback', 'batchEditExec(''descendre'')');
    posx =posx+large+intx;large =boutx;haut=bouty;posy =debuty-((debuty-finy-5*haut)/2)-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''ajouterbatch'')', ...
  	      'Position',[posx posy large haut], 'String','Ajouter');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''efface'')', ...
  	      'Position',[posx posy large haut], 'String','Supprimer');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''monter'')', ...
  	      'Position',[posx posy large haut], 'String','Monter');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''descendre'')', ...
              'Position',[posx posy large haut], 'String','Descendre');
    posy =posy-haut;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''batchpropriete'')', ...
              'Position',[posx posy large haut], 'String','Propri�t�');
  % ********AU TRAFFAILLE, voyons, c qui kia encowe pis mes dents... :-B
    posx =(1-large)/2; posy =bouty/2;
    uicontrol('Parent',fig, 'Callback','batchEditExec(''allez_du_nerf'')', ...
              'Position',[posx posy large haut], 'String','Au travail');
    guidata(fig,Ppa);

end
