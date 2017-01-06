% 
% DialogBox pour demander les infos relatives à la rotation puis on passe à l'action.
%
% La rotation pourra se faire autour du centre de son choix.
% - Manuel, valeur au choix
% - (Max+Min)/2 Le milieu entre le min et le max
% - Moyenne du canal
% - L'amplitude maximum du canal
% - L'amplitude minimum di canal
%
function rotationPlan(varargin)
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
    rh = guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %
  switch(commande)
  %---------------
  case 'ouverture'
    lapos =positionfen('G','H',400,550);
    rh.fig(1) = figure('Name','MENUROTATION', ...
            'Position',lapos, ...
            'CloseRequestFcn','rotationPlan(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','normalized',...
            'defaultUIControlFontSize',10,...
            'Resize','off');
    marge=0.03;hcase=0.065;lcase=1-2*marge;lcase1=(lcase-marge)/2;
    posx=marge;posy=1-2*marge-hcase;haut=hcase;large=lcase;
    titre = uicontrol('Parent',rh.fig(1), ...
            'FontSize',14,...
            'HorizontalAlignment','center',...
            'Position',[posx posy large haut], ...
            'String','Choix des canaux pour la rotation', ...
            'Style','text');
    large=lcase1;posy=posy-marge-haut;
    titre = uicontrol('Parent',rh.fig(1), ...
            'HorizontalAlignment','center',...
            'Position',[posx posy large haut], ...
            'Style','text',...
            'String','Abcisse (X)');
    posx=posx+large+marge;
    titre = uicontrol('Parent',rh.fig(1), ...
            'HorizontalAlignment','center',...
            'Position',[posx posy large haut], ...
            'Style','text',...
            'String','Ordonnée (Y)');
    posx=marge;posy=posy-haut;
    rh.control(1) = uicontrol('Parent',rh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String',hdchnl.adname, ...
            'Style','popupmenu', ...
            'Value',1);
    posx=posx+large+marge;
    rh.control(2) = uicontrol('Parent',rh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String',hdchnl.adname, ...
            'Style','popupmenu', ...
            'Value',1);
    posx=marge;posy=posy-haut-3*marge;large=lcase;
    titre = uicontrol('Parent',rh.fig(1), ...
            'HorizontalAlignment','center',...
            'Position',[posx posy large haut], ...
            'Style','text',...
            'String','Coordonnée du centre de rotation');
    leschoix=['Manuel|(Max+Min)/2|Moyenne|Le maximum|Le Minimum'];
    posx=marge+0.3*lcase1;large=0.7*lcase1;posy=posy-haut;
    rh.control(7) = uicontrol('Parent',rh.fig(1), ...
            'Position',[posx posy large haut], ...
            'ToolTipString','Abcisse du centre de rotation',...
            'Style','popupmenu', ...
            'String',leschoix,...
            'Value',1);
    posx=posx+large+marge;
    rh.control(9) = uicontrol('Parent',rh.fig(1), ...
            'Position',[posx posy large haut], ...
            'ToolTipString','Ordonnée du centre de rotation',...
            'Style','popupmenu', ...
            'String',leschoix,...
            'Value',1);
    posx=marge+0.3*lcase1;large=0.7*lcase1;posy=posy-haut;
    rh.control(5) = uicontrol('Parent',rh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String','0.0', ...
            'Style','edit');
    posx=posx+large+marge;
    rh.control(6) = uicontrol('Parent',rh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String','0.0', ...
            'Style','edit');
    posx=marge+0.3*lcase1;posy=posy-2*marge-haut;large=lcase/3;
    titre = uicontrol('Parent',rh.fig(1), ...
            'Position',[posx posy large haut], ...
            'Style','text',...
            'String','Angle (degré)');
    posx=posx+large;large=large/2;
    rh.ed(1) = uicontrol('Parent',rh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'Style','edit');
    posx=posx+large;large=large*2;
    rh.control(3) = uicontrol('Parent',rh.fig(1), ...
            'Position',[posx posy large haut], ...
            'String','Radian', ...
            'Style','checkbox', ...
            'Value',0);
    large=lcase1;posx=(1-large)/2;posy=posy-haut-2.5*marge;
    rh.control(4) = uicontrol('Parent',rh.fig(1), ...
            'Callback','rotationPlan(''travail'')', ...
            'Position',[posx posy large haut], ...
            'String','Au travail');
    posx=marge;large=lcase*0.8;posy=marge;
    rh.control(8) = uicontrol('Parent',rh.fig(1), ...
            'Position',[posx posy large haut*0.6], ...
            'String','Placez le résultat dans les mêmes canaux', ...
            'Style','checkbox', ...
            'Value',0);
    set(rh.fig(1),'WindowStyle','modal');
    guidata(gcf,rh);
  %-------------
  case 'travail'
    canx =get(rh.control(1),'Value')';      % canal X
    cany =get(rh.control(2),'Value')';      % canal Y
    ecrase =get(rh.control(8),'Value')';
    if canx == cany & ecrase
      return;
    end
    typcentx =get(rh.control(7),'Value')';
    typcenty =get(rh.control(9),'Value')';
    ang =get(rh.ed(1),'String');  % angle de rotation
    angle =str2num(ang);  % angle de rotation
    radian =get(rh.control(3),'Value')';
    if radian == 0
      angle =angle*pi/180;
    end
    if abs(angle) >= pi
      if angle > 0
        angle =angle-(2*pi);
      else
        angle =angle+(2*pi);
      end
    end
    mrot(1,1) =cos(angle);
    mrot(1,2) =-sin(angle);
    mrot(2,1) =sin(angle);
    mrot(2,2) =cos(angle);
    if typcentx == 1
      centrx =str2num(get(rh.control(5),'String'));
      if length(centrx) == 0
        centrx =0;
      end
    end
    if typcenty == 1
      centry =str2num(get(rh.control(6),'String'));
      if length(centry) == 0
        centry =0;
      end
    end
    if ecrase
      Ncanx =canx;
      Ncany =cany;
    else
      hdchnl.duplic([canx cany]);
      Ncanx =vg.nad+1;
      Ncany =vg.nad+2;
      hdchnl.adname{Ncanx} =['Rot-' hdchnl.adname{canx}];
      hdchnl.adname{Ncany} =['Rot-' hdchnl.adname{cany}];
      vg.nad =vg.nad+2;
    end
    lesX =CDtchnl();
    Ofich.getcanal(lesX, canx);
    Nx =lesX.Nom;
    lesY =CDtchnl();
    Ofich.getcanal(lesY, cany);
    Ny =lesY.Nom;
    for i =1:vg.ess
      ns  =min([hdchnl.nsmpls(canx,i) hdchnl.nsmpls(cany,i)]);
      if typcentx > 1
        centrx =lecentre(typcentx, lesX, i, ns);
      end
      if typcenty > 1
        centry =lecentre(typcenty, lesY, i, ns);
      end
      data(1:ns,1:2) =[lesX.Dato.(Nx)(1:ns,i)-centrx lesY.Dato.(Ny)(1:ns,i)-centry];
      modi =strcat('Rot:X(',hdchnl.adname{canx},'),Y(',hdchnl.adname{cany},'),ang=',ang,'//');
      vc =[modi '//' hdchnl.comment{canx, i}];
      hdchnl.comment{Ncanx, i} =vc;
      vc=[modi '//' hdchnl.comment{cany, i}];
      hdchnl.comment{Ncany, i} =vc;
      for j=1:ns
        data(j,:)=(mrot*data(j,:)')';
      end
      lesX.Dato.(Nx)(1:ns,i) =data(1:ns,1)+centrx;
      lesY.Dato.(Ny)(1:ns,i) =data(1:ns,2)+centry;
      hdchnl.max(Ncanx,i) =max(lesX.Dato.(Nx)(1:hdchnl.nsmpls(Ncanx,i),i));
      hdchnl.min(Ncanx,i) =min(lesX.Dato.(Nx)(1:hdchnl.nsmpls(Ncanx,i),i));
      hdchnl.max(Ncany,i) =max(lesY.Dato.(Ny)(1:hdchnl.nsmpls(Ncany,i),i));
      hdchnl.min(Ncany,i) =min(lesY.Dato.(Ny)(1:hdchnl.nsmpls(Ncany,i),i));
    end
    Ofich.setcanal(lesX, Ncanx);
    Ofich.setcanal(lesY, Ncany);
    delete(lesX);
    delete(lesY);
    delete(rh.fig(1));
    vg.sauve =1;
    if ecrase
      OA.OFig.affiche();
    else
      gaglobal('editnom');
    end
  %------------
  case 'fermer'
    delete(rh.fig(1));
  end
end

%
% on détermine le point de rotation    max min
%
function milieu =lecentre(dequec,HDt,ess,nsmpl)
  switch dequec
  case 2  % max+min / 2
    milieu =(max(HDt.Dato.(HDt.Nom)(1:nsmpl,ess))+min(HDt.Dato.(HDt.Nom)(1:nsmpl,ess)))/2;
  case 3  % La moyenne
    milieu =mean(HDt.Dato.(HDt.Nom)(1:nsmpl,ess));
  case 4  % Le Maximum
    milieu =max(HDt.Dato.(HDt.Nom)(1:nsmpl,ess));
  case 5  % Le Minimum
    milieu =min(HDt.Dato.(HDt.Nom)(1:nsmpl,ess));
  end
end