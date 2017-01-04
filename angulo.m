%
% calcula el ángulo (entre dos vectores)
%
% Laboratoire GRAME
% Janvier 2007
%
% Fonction qui calcule à chaque instant l'angle entre
% deux vecteurs: l'un des vecteurs pourra être la verticale
% l'horizontale ou un vecteur déterminé par deux points.
%
function angulo(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)
  %---------------   
  case 'ouverture'
    vg.valeur =1;
    choixv1 ={'Vecteur 1';'Horizontal (Axe X) (+)';'Horizontal (-)';...
              'Vertical (Axe Y) (+)';'Vertical (-)';'Axe Z (+)';'Axe Z (-)'};
    choixv2 ={'Vecteur 2';'Horizontal (Axe X) (+)';'Horizontal (-)';...
              'Vertical (Axe Y) (+)';'Vertical (-)';'Axe Z (+)';'Axe Z (-)'};
    Znoms =hdchnl.Listadname;
    Znoms(end+1) ={'0'};
    Zval =length(Znoms);
    col1=180;col2=480;largfen=col1+col2;hautfen=400;
    lapos =positionfen('G','C',largfen,hautfen);
    lafig =figure('Name', 'MENU ANGLE','tag','IAngulo', ...							
            'Position',lapos, 'CloseRequestFcn','angulo(''terminus'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');
    margx =20;hautlig =25;
    posx =margx; large =col1-2*margx; haut =hautlig; posy =hautfen-2*haut;
    uicontrol('Parent',lafig,'tag','checkess', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',[posx posy large haut], ...
            'String','Tous les essais', ...
            'Style','checkbox', ...
            'Value',1);
    haut =round(0.6*hautfen);posy =posy-haut;
    uicontrol('Parent',lafig, 'tag','listess', 'BackgroundColor',[1 1 1], ...
              'Position',[posx posy large haut], 'String',vg.lesess, ...
              'Min',1, 'Max',vg.ess, 'Style','listbox', 'Value',1);
    cc2div4 =round((col2-2*margx)/4); cc2 =round(cc2div4 * 1.5);
    posx =col1+margx;
    haut =hautlig; posy =hautfen-2*haut; large =cc2; posxchoix =col1+round(cc2div4/2);
    uicontrol('Parent',lafig,'tag','popvect1', 'Position',[posxchoix posy large haut], ...
              'callback',@WAvecteur1, 'String',choixv1, 'Style','popupmenu', 'Value',1);
    large =cc2div4; posy =posy-2*haut;
    uicontrol('Parent',lafig, ...
            'FontWeight','bold',...
            'Position',[posx+large posy large haut], ...
            'horizontalalignment','center',...
            'String','Canal en X', ...
            'Style','text');
    uicontrol('Parent',lafig, ...
            'FontWeight','bold',...
            'Position',[posx+2*large posy large haut], ...
            'horizontalalignment','center',...
            'String','Canal en Y', ...
            'Style','text');
    uicontrol('Parent',lafig, ...
            'FontWeight','bold',...
            'Position',[posx+3*large posy large haut], ...
            'horizontalalignment','center',...
            'String','Canal en Z', ...
            'Style','text');
    posy=posy-haut;
    uicontrol('Parent',lafig, ...
            'Position',[posx posy large haut], ...
            'horizontalalignment','center',...
            'String','Pt. Origine', ...
            'Style','text');
    uicontrol('Parent',lafig,'tag','popvect1orix', ...
            'Position',[posx+large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    uicontrol('Parent',lafig,'tag','popvect1oriy', ...
            'Position',[posx+2*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    uicontrol('Parent',lafig,'tag','popvect1oriz', ...
            'Position',[posx+3*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    posy=posy-haut;
    uicontrol('Parent',lafig, ...
            'Position',[posx posy large haut], ...
            'horizontalalignment','center',...
            'String','2ième Point', ...
            'Style','text');
    uicontrol('Parent',lafig,'tag','popvect1p2x', ...
            'Position',[posx+large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',1);
    uicontrol('Parent',lafig,'tag','popvect1p2y', ...
            'Position',[posx+2*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',1);
    uicontrol('Parent',lafig,'tag','popvect1p2z', ...
            'Position',[posx+3*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    posy =posy-2*haut; large =cc2;
    uicontrol('Parent',lafig,'tag','popvect2', 'Position',[posxchoix posy large haut], ...
              'callback',@WAvecteur2, 'String',choixv2, ...
              'Style','popupmenu', 'Value',1);
    large =cc2div4; posy =posy-2*haut;
    uicontrol('Parent',lafig, ...
            'Position',[posx posy large haut], ...
            'horizontalalignment','center',...
            'String','Pt. Origine', ...
            'Style','text');
    uicontrol('Parent',lafig,'tag','popvect2orix', ...
            'Position',[posx+large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    uicontrol('Parent',lafig,'tag','popvect2oriy', ...
            'Position',[posx+2*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    uicontrol('Parent',lafig,'tag','popvect2oriz', ...
            'Position',[posx+3*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    posy =posy-haut;
    uicontrol('Parent',lafig, ...
            'Position',[posx posy large haut], ...
            'horizontalalignment','center',...
            'String','2ième Point', ...
            'Style','text');
    uicontrol('Parent',lafig,'tag','popvect2p2x', ...
            'Position',[posx+large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',1);
    uicontrol('Parent',lafig,'tag','popvect2p2y', ...
            'Position',[posx+2*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',1);
    uicontrol('Parent',lafig,'tag','popvect2p2z', ...
            'Position',[posx+3*large posy large haut], ...
            'String',Znoms, ...
            'Style','popupmenu', ...
            'Value',Zval);
    posy =posy-3*haut;
    uicontrol('Parent',lafig, ...
            'Callback','angulo(''travail'')', ...
            'Position',[posxchoix posy large haut], ...
            'String','au travail');
    uicontrol('Parent',lafig,'tag','statustext', ...
            'FontSize',9,...
            'backgroundcolor',[0.7 0.7 0.7],...
            'Position',[0 0 largfen haut], ...
            'String','Calcule  l''angle entre les deux vecteurs', ...
            'Style','text');
    set(lafig,'WindowStyle','modal');
  %-------------
  case 'travail'
    ss =get(findobj('tag','checkess'),'value');
    if ss
      lesess =[1:vg.ess];
    else
      lesess =get(findobj('tag','listess'),'value');
    end
    % on va créer un canal à zéro, il sera utilisé dans les calculs
    % si on choisit 0 pour un canal
    hdchnl.duplic(1);
    vg.nad = vg.nad+1;
    hdchnl.nsmpls(vg.nad, :) =max(hdchnl.nsmpls(:,:));
    %--------------------------------------
    % Lecture des paramètres de l'interface
    %--------------------------------------
    v1 =get(findobj('tag','popvect1'),'value');
    V1p1x =get(findobj('tag','popvect1orix'),'value');
    V1p1y =get(findobj('tag','popvect1oriy'),'value');
    V1p1z =get(findobj('tag','popvect1oriz'),'value');
    V1p2x =get(findobj('tag','popvect1p2x'),'value');
    V1p2y =get(findobj('tag','popvect1p2y'),'value');
    V1p2z =get(findobj('tag','popvect1p2z'),'value');
    Vprimo =[V1p1x V1p1y V1p1z V1p2x V1p2y V1p2z];
    v2 =get(findobj('tag','popvect2'),'value');
    V2p1x =get(findobj('tag','popvect2orix'),'value');
    V2p1y =get(findobj('tag','popvect2oriy'),'value');
    V2p1z =get(findobj('tag','popvect2oriz'),'value');
    V2p2x =get(findobj('tag','popvect2p2x'),'value');
    V2p2y =get(findobj('tag','popvect2p2y'),'value');
    V2p2z =get(findobj('tag','popvect2p2z'),'value');
    Vsegundo =[V2p1x V2p1y V2p1z V2p2x V2p2y V2p2z];
    V =[Vprimo Vsegundo];
    if length(lesess) > 1
      Smpl =min(max(hdchnl.nsmpls(V, lesess), [], 2));
    else
      Smpl =min(hdchnl.nsmpls(V, lesess));
    end
    R =1:Smpl;           
    V1 =zeros(Smpl, length(lesess), 3);
    V2 =V1;
    %------------------------------------------
    % On emplie de zéro le canal supplémentaire
    dtchnl =CDtchnl();
    dtchnl.Dato.V =zeros(Smpl, vg.ess);
    Ofich.setcanal(dtchnl, vg.nad);
    dtc1 =CDtchnl();
    dtc2 =CDtchnl();
    canalx =[];
    %--------
    switch v1
    %----- VECTEUR SELON POINTS
    case 1
      Ofich.getcanal(dtc1, V1p1z);
      Ofich.getcanal(dtc2, V1p2z);
      V1(:,:,3) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      Ofich.getcanal(dtc1, V1p1x);
      Ofich.getcanal(dtc2, V1p2x);
      V1(:,:,1) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      Ofich.getcanal(dtc1, V1p1y);
      Ofich.getcanal(dtc2, V1p2y);
      V1(:,:,2) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      ss =find(Vprimo == (vg.nad));
      if ~isempty(ss)
      	Vprimo(ss) =0;
      end
      [a,b,canalx] =find(Vprimo,1);
      nomv1 ='Vecteur 1';
    %----- HORIZONTALE +
    case 2
      V1(:,:,1) =1;
      nomv1 ='Horizon pos.';
    %----- HORIZONTALE -
    case 3
      V1(:,:,1) =-1;
      nomv1 ='Horizon neg.';
    %----- VERTICALE +
    case 4
      V1(:,:,2) =1;
      nomv1 ='Vertical pos.';
    %----- VERTICALE -
    case 5
      V1(:,:,2) =-1;
      nomv1 ='Vertical neg.';
    %----- AXE Z +
    case 6
      V1(:,:,3) =1;
      nomv1 ='Selon Z pos.';
    %----- AXE Z -
    case 7
      V1(:,:,3) =-1;
      nomv1 ='Selon Z neg.';
    end
    %--------
    switch v2
    %----- VECTEUR SELON POINTS
    case 1
      Ofich.getcanal(dtc1, V2p1z);
      Ofich.getcanal(dtc2, V2p2z);
      V2(:,:,3) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      Ofich.getcanal(dtc1, V2p1x);
      Ofich.getcanal(dtc2, V2p2x);
      V2(:,:,1) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      Ofich.getcanal(dtc1, V2p1y);
      Ofich.getcanal(dtc2, V2p2y);
      V2(:,:,2) =dtc2.Dato.(dtc2.Nom)(R,lesess)-dtc1.Dato.(dtc1.Nom)(R,lesess);
      if isempty(canalx) || canalx == 0
        ss =find(Vsegundo == (vg.nad));
        if ~isempty(ss)
        	Vsegundo(ss) =0;
        end
        [a,b,canalx] =find(Vsegundo,1);
      end
      nomv2 ='Vecteur 2';
    %----- HORIZONTALE +
    case 2
      V2(:,:,1) =1;
      nomv2 ='Horizon pos.';
    %----- HORIZONTALE -
    case 3
      V2(:,:,1)=-1;
      nomv2 ='Horizon neg.';
    %----- VERTICALE +
    case 4
      V2(:,:,2)=1;
      nomv2 ='Vertical pos.';
    %----- VERTICALE -
    case 5
      V2(:,:,2)=-1;
      nomv2 ='Vertical neg.';
    %----- AXE Z +
    case 6
      V2(:,:,3) =1;
      nomv2 ='Selon Z pos.';
    %----- AXE Z -
    case 7
      V2(:,:,3) =-1;
      nomv2 ='Selon Z neg.';
    end
    if isempty(canalx) || canalx == 0
    	canalx =1;
    end
    delete(dtc1);
    delete(dtc2);
    %---------------------------------------------------------------
    % La démarche à suivre sera de ramener le plan des vecteur V1_V2
    % parallèle au plan X_Y. Pour y arriver, on va coucher le vecteur V1
    % sur l'axe X+ (bien entendu V2 subira les mêmes transformation afin
    % de préserver l'angle), puis avec une rotation autour de l'axe X
    % les deux vecteurs seront dans le plan X-Y.
    %------------------------------
    T1 =zeros(size(V1));
    T2 =T1;
    % ROTATION AUTOUR DE L'AXE Z pour amener V1 dans le plan Z_X         ... Vu comme ça c'est simple rare :-D
    [T1(:,:,1),T1(:,:,2),T1(:,:,3)] =cart2sph(V1(:,:,1),V1(:,:,2),V1(:,:,3));
    [T2(:,:,1),T2(:,:,2),T2(:,:,3)] =cart2sph(V2(:,:,1),V2(:,:,2),V2(:,:,3));
    T2(:,:,1) =T2(:,:,1)-T1(:,:,1);
    T1(:,:,1) =0;
    [V1(:,:,1),V1(:,:,2),V1(:,:,3)] =sph2cart(T1(:,:,1),T1(:,:,2),T1(:,:,3));
    [V2(:,:,1),V2(:,:,2),V2(:,:,3)] =sph2cart(T2(:,:,1),T2(:,:,2),T2(:,:,3));
    % Ici, le vecteur V1 est dans le plan Z_X
    % ROTATION AUTOUR DE L'AXE Y pour coucher V1 sur l'axe X+
    % Attention à l'ordre car ici on rotationne en sens inverse
    [T1(:,:,1),T1(:,:,2),T1(:,:,3)] =cart2sph(V1(:,:,1),V1(:,:,3),V1(:,:,2));
    [T2(:,:,1),T2(:,:,2),T2(:,:,3)] =cart2sph(V2(:,:,1),V2(:,:,3),V2(:,:,2));
    T2(:,:,1) =T2(:,:,1)-T1(:,:,1);
    T1(:,:,1) =0;
    [V1(:,:,1),V1(:,:,3),V1(:,:,2)] =sph2cart(T1(:,:,1),T1(:,:,2),T1(:,:,3));
    [V2(:,:,1),V2(:,:,3),V2(:,:,2)] =sph2cart(T2(:,:,1),T2(:,:,2),T2(:,:,3));
    % Ici, le vecteur V1 est couché sur l'axe X+
    % ROTATION AUTOUR DE L'AXE X pour amené V2 dans le plan X_Y
    [T1(:,:,1),T1(:,:,2),T1(:,:,3)] =cart2sph(V1(:,:,2),V1(:,:,3),V1(:,:,1));
    [T2(:,:,1),T2(:,:,2),T2(:,:,3)] =cart2sph(V2(:,:,2),V2(:,:,3),V2(:,:,1));
    T2(:,:,1) =T2(:,:,1)-T1(:,:,1);
    [V2(:,:,2),V2(:,:,3),V2(:,:,1)] =sph2cart(T2(:,:,1),T2(:,:,2),T2(:,:,3));
    [T2(:,:,1),T2(:,:,2),T2(:,:,3)] =cart2sph(V2(:,:,1),V2(:,:,2),V2(:,:,3));
    dtchnl.Dato.(dtchnl.Nom)(1:Smpl, lesess) =T2(:,:,1)/pi*180;
    %------------------------
    Smpl =min(hdchnl.nsmpls(V, :));
    nc =[nomv1 '/' nomv2];
    vc =['Angle entre ' nomv1 '/' nomv2];
    hdchnl.adname{vg.nad} =nc;
    for K =1:vg.ess
      hdchnl.frontcut(vg.nad, K) =0;
      hdchnl.nsmpls(vg.nad, K) =Smpl(K);
      hdchnl.rate(vg.nad,K) =hdchnl.rate(canalx, K);
      hdchnl.sweeptime(vg.nad, K) =hdchnl.nsmpls(vg.nad, K)./hdchnl.rate(vg.nad, K);
      hdchnl.comment{vg.nad, K} =vc;
      hdchnl.max(vg.nad, K) =max(dtchnl.Dato.(dtchnl.Nom)(1:Smpl(K), K));
      hdchnl.min(vg.nad, K) =min(dtchnl.Dato.(dtchnl.Nom)(1:Smpl(K), K));
    end
    Ofich.setcanal(dtchnl);
    lafig =findobj('tag','IAngulo');
    delete(lafig);
    delete(dtchnl);
    vg.sauve =1;
    gaglobal('editnom');
  %--------------
  case 'terminus'
    lafig =findobj('tag','IAngulo');
    delete(lafig);
  %--
  end
end

%-------
function WAvecteur1(src, event)
  ss =get(src, 'value');
  if ss == 1
    set(findobj('tag','popvect1orix'),'enable','on');
    set(findobj('tag','popvect1oriy'),'enable','on');
    set(findobj('tag','popvect1oriz'),'enable','on');
    set(findobj('tag','popvect1p2x'),'enable','on');
    set(findobj('tag','popvect1p2y'),'enable','on');
    set(findobj('tag','popvect1p2z'),'enable','on');
  else
    set(findobj('tag','popvect1orix'),'enable','off');
    set(findobj('tag','popvect1oriy'),'enable','off');
    set(findobj('tag','popvect1oriz'),'enable','off');
    set(findobj('tag','popvect1p2x'),'enable','off');
    set(findobj('tag','popvect1p2y'),'enable','off');
    set(findobj('tag','popvect1p2z'),'enable','off');
  end
end
%-------
function WAvecteur2(src, event)
  ss =get(src, 'value');
  if ss == 1
    set(findobj('tag','popvect2orix'),'enable','on');
    set(findobj('tag','popvect2oriy'),'enable','on');
    set(findobj('tag','popvect2oriz'),'enable','on');
    set(findobj('tag','popvect2p2x'),'enable','on');
    set(findobj('tag','popvect2p2y'),'enable','on');
    set(findobj('tag','popvect2p2z'),'enable','on');
  else
    set(findobj('tag','popvect2orix'),'enable','off');
    set(findobj('tag','popvect2oriy'),'enable','off');
    set(findobj('tag','popvect2oriz'),'enable','off');
    set(findobj('tag','popvect2p2x'),'enable','off');
    set(findobj('tag','popvect2p2y'),'enable','off');
    set(findobj('tag','popvect2p2z'),'enable','off');
  end
end
