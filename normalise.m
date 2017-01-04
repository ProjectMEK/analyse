% 
% DialogBox pour demander les infos relatives à la normalisation
% puis on passe à l'action.
%
% Ce sera une normalisation en fonction des bornes Min et Max entrés.
% - soit les bornes Bmin et Bmax
% - les max et min du canal sont Ymax et Ymin
% - la valeur de Y normalisé sera Ynorm
%
%
%          (Y - Ymin)*(Bmax-Bmin)
%  Ynorm = ----------------------  + Bmin
%                     (Ymax-Ymin)
%
function normalise(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    wn =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %
  switch(commande)
  %---------------
  case 'ouverture'
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','H',300,450);
    wn.fig(1) =figure('Name','MENUNORMAL', 'Position',lapos, ...
            'CloseRequestFcn','normalise(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',10, 'Resize','off');
    uicontrol('Parent',wn.fig(1), 'FontSize',12, 'Position',[25 400 250 25], ...
            'String','Choix des canal/aux à normaliser', 'Style','text');
    wn.control(1) =uicontrol('Parent',wn.fig(1), 'BackgroundColor',[1 1 1], ...
            'Position',[50 175 200 225], 'String',hdchnl.Listadname, ...
            'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    wn.control(2) =uicontrol('Parent',wn.fig(1), 'Position',[25 140 250 25], ...
            'HorizontalAlignment','left',...
            'String','Placer le résultat dans le même canal',...
            'Style','checkbox', 'Value',0);
    uicontrol('Parent',wn.fig(1), 'Position',[50 100 135 25], ...
            'Style','text', 'String','Valeur minimum:');
    wn.ed(1) =uicontrol('Parent',wn.fig(1), 'BackgroundColor',[1 1 1], ...
            'Position',[200 100 40 25], 'Style','edit', 'String','0');
    uicontrol('Parent',wn.fig(1), 'Position',[50 70 135 25], ...
            'Style','text', 'String','Valeur maximum:');
    wn.ed(2) =uicontrol('Parent',wn.fig(1), 'BackgroundColor',[1 1 1], ...
            'Position',[200 70 40 25], 'Style','edit', 'String','1');
    uicontrol('Parent',wn.fig(1), 'Callback','normalise(''travail'')', ...
            'Position',[40 25 100 25], 'String','Au travail');
    set(wn.fig(1),'WindowStyle','modal');
    guidata(gcf,wn);
  %-------------
  case 'travail'
    Vcan =get(wn.control(1),'Value');       % canaux à normaliser
    nouveau =get(wn.control(2),'Value')-1;    % on écrase le canal source
    vmin =get(wn.ed(1),'String');  % valeur min en char
    vmax =get(wn.ed(2),'String');  % valeur max en char
    valmin =str2double(vmin);         % valeur min en chiffre
    valmax =str2double(vmax);         % valeur max en chiffre
    nombre =length(Vcan);
    dtchnl =CDtchnl();
    if nouveau
      hdchnl.duplic(Vcan);
      Ncan =[1:nombre]+vg.nad;
    else
    	Ncan =Vcan;
    end
    for i =1:nombre
      hdchnl.adname{Ncan(i)} =['N.' deblank(hdchnl.adname{Ncan(i)})];
      Ofich.getcanal(dtchnl, Vcan(i));
      N =dtchnl.Nom;
      for j =1:vg.ess
      	ss =hdchnl.nsmpls(Vcan(i),j);
        vc =[hdchnl.comment{Ncan(i), j} ' Normal,Min=' vmin ', Max=' vmax '//'];
        hdchnl.comment{Ncan(i), j} =vc;
        emin =hdchnl.min(Vcan(i),j);
        deltae =(valmax-valmin)/(hdchnl.max(Vcan(i),j)-emin);
        dtchnl.Dato.(N)(1:ss,j) =(dtchnl.Dato.(N)(1:ss,j)-emin)*deltae+valmin;
        hdchnl.max(Ncan(i),j) =max(dtchnl.Dato.(N)(1:ss,j));
        hdchnl.min(Ncan(i),j) =min(dtchnl.Dato.(N)(1:ss,j));
      end
      Ofich.setcanal(dtchnl, Ncan(i));
    end
    delete(wn.fig(1));
    delete(dtchnl);
    vg.sauve =1;
    if nouveau
      vg.nad =vg.nad+nombre;
      gaglobal('editnom');
    else
      OA.OFig.affiche();
    end
  %-------------
  case 'fermer'
    delete(wn.fig(1));
  %--
  end
end
