function varargout =suppcan(varargin)
  if nargin == 0
    return;
  else
    elmando = varargin{1};
  end
  if nargout
    for ii=1:nargout
      varargout{ii}=0;
    end
  end
  switch elmando
  %-------------------
  case 'untoutnouveau'
    ss =varargin{2};
    ss.tot =ss.tot+1;
    ccc =ss.tot;
    ss.elno =ss.elno+1;
    ss.tach =initparam('suppcan',ss.tach,ss.elno,ss.tot);
%    lesnoms =fieldnames(ttmp);
%    for ii =1:length(lesnoms)
%      ss.tach(ccc).(lesnoms{ii}) =ttmp.(lesnoms{ii});
%    end
    varargout{1} =ss;
  %-------------
  case 'edition'
    hh =guidata(findobj('Tag','IpBatch'));
    % ***INTERFACE GESTION DES PARAMÈTRES***
    latache = hh.status;
    largeur =450;hauteur =500;
    Locat =get(0,'PointerLocation');
    Posit =get(0,'MonitorPositions');
    if Locat(1)+largeur+25 > Posit(3) 
      posx =Posit(3)-largeur-25;
    else
      posx =Locat(1);
    end
    if Locat(2)-hauteur-25 < 1
      posy =25;
    else
      posy =Locat(2)-hauteur-25;
    end
    fig =figure('Name',hh.tach(latache).descr,'tag', 'IpProp',...
                'Units','pixel', 'UserData',latache,...
                'Position', [posx posy largeur hauteur], ...
                'CloseRequestFcn','wbatch(''terminus'')',...
                'defaultuicontrolunits','pixel',...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'defaultUIControlFontSize',9);
    %********FICHIERS D'ENTRÉES
    posy =choixfichier('BGuiFichEntree',fig,hh,[0 hauteur largeur]);
    %********ENLEVER CANAUX
    intx =15; bouty =25; boutx =75; winx =325;
    posx =intx; large =winx; haut =bouty; posy =posy-2*haut;
    uicontrol('parent',fig, 'position',[posx posy large haut],...
              'HorizontalAlignment','center',...
              'style','text', 'string','Liste des canaux à enlever');
    posy =posy-haut;
    uicontrol('parent',fig,'position',[posx posy large haut],...
              'BackgroundColor',[1 1 1],'style','edit',...
              'string',hh.tach(latache).listcan,'tag','BSuppCanaux');
    %********FICHIERS DE SORTIES
    posy =choixfichier('BGuiFichSortie',fig,hh, [0 posy largeur]);
    %******** Appliquer
    large =2*boutx;posx=round((largeur-large)/2); haut =bouty; posy=haut;
    uicontrol('parent',fig, 'callback','suppcan(''Applique'')',...
              'Position',[posx posy large haut], 'String','Appliquer');
    guidata(fig,hh);
    set(fig,'WindowStyle','modal');
  %--------------
  case 'Applique'
    hh =guidata(gcf); % findobj('tag','IpProp')
    sss =get(gcf, 'Userdata');
    hh.tach(sss).listcan =get(findobj('tag','BSuppCanaux'),'string');
    delete(gcf);
    hh.tach(sss).descr =[hh.tach(sss).intro deblank(hh.tach(sss).listcan) ')'];
    guidata(findobj('tag','IpBatch'),hh);
    wbatch('disptach');
  end
return


-	sc.exe config lanmanworkstation depend= bowser/mrxsmb10/nsi 
-	sc.exe config mrxsmb20 start= disabled
