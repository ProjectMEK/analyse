%
% RECTIFICATION
%
% Laboratoire GRAME
% Mars 2000 - Juillet 2002
%
% Fonction qui prend la valeur absolue du/des canal/canaux choisis.
%
% Le calcul se fait grâce à la fonction Matlab prédéfinie "abs".
%
function ValAbs(varargin)
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)
  %---------------
  case 'ouverture'
    if vg.nad > 2; letop = vg.nad;else; letop =vg.nad + 1;end
    lapos =positionfen('G','C',300,450);
    fig =figure('Name', 'MENU RECTIFICATION', 'Position',lapos, ...
                'CloseRequestFcn','ValAbs(''fermer'')',...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','pixels',...
                'DefaultUIControlFontSize',11, 'Resize', 'off');
    uicontrol('Parent',fig, 'Position',[25 400 250 25], 'String','Choix du/des canal/aux à rectifier', 'Style','text');
    uicontrol('Parent',fig, 'tag','NomCanaux', 'BackgroundColor',[1 1 1], 'Position',[50 175 200 225], ...
              'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    uicontrol('Parent',fig, 'Callback','ValAbs(''travail'')', 'Position',[100 100 100 25], 'String','Au travail');
    set(fig,'WindowStyle','modal');
  %-------------
  case 'travail'                   %cas ou on a lance le trait.
    fig =gcf;
    lescan = get(findobj('tag','NomCanaux'), 'Value')';			%' num des canaux choisis
    nombre = size(lescan,1);											          %  nb de canaux choisis
    hdchnl.duplic(lescan);
    Dt =CDtchnl();
    for U =1:nombre
      vg.nad =vg.nad+1;
      Ofich.getcanal(Dt, lescan(U));
      Dt.Dato.(Dt.Nom)(:) =abs(Dt.Dato.(Dt.Nom)(:));
      Ofich.setcanal(Dt, vg.nad);
      hdchnl.adname{vg.nad} =['Abs(' hdchnl.adname{lescan(U)} ')'];
      for V =1:vg.ess
        smpl =hdchnl.nsmpls(vg.nad, V);
        hdchnl.comment{vg.nad, V} =['ABS//' hdchnl.comment{vg.nad, V}];
        hdchnl.max(vg.nad, V) =max(Dt.Dato.(Dt.Nom)(1:smpl, V));
        hdchnl.min(vg.nad, V) =min(Dt.Dato.(Dt.Nom)(1:smpl, V));
      end
    end
    delete(Dt);
    vg.sauve =1;
    delete(fig);														%on efface la fig menu
    gaglobal('editnom');
  %--------------
  case 'fermer'																%cas ou on abandonne
    delete(gcf);														%
  %--
  end
return
