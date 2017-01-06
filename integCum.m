% 
% DialogBox pour demander les infos relatives à l'intégration
% Cumulative, puis on passe à l'action.
%
function integCum(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;

  switch(commande)
  %---------------
  case 'ouverture'
    vg.valeur =1;
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','H',300,470);
    fig =figure('Name','MENUINTÉGRALE-CUM', 'Tag','INTCUM', 'Position',lapos, ...
          'CloseRequestFcn','integCum(''fermer'')',...
          'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
          'defaultUIControlunits','pixels',...
          'defaultUIControlFontSize',12,...
          'Resize','off');
    uicontrol('Parent',fig, 'Position',[25 435 250 25], 'Style','text', ...
              'FontWeight','bold', 'String','Choix du/des canal/aux');
    uicontrol('Parent',fig, 'Tag','QUELCANAL', 'Style','listbox', ...
              'BackgroundColor',[1 1 1], 'Position',[50 200 200 160], ...
              'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Value',1);
    uicontrol('Parent',fig, 'Tag','CANALRESULTAT', 'Position',[50 170 274 25], ...
              'FontSize',9, 'HorizontalAlignment','left',...
              'String','Placer le résultat dans le même canal',...
              'Style','checkbox', 'Value',0);
    uicontrol('Parent',fig, 'Callback','integCum(''travail'')', ...
              'Position',[100 15 100 20], 'String','Au travail');
    set(fig,'WindowStyle','modal');

  %-------------
  case 'travail'
    Vcan =get(findobj('Tag','QUELCANAL'), 'Value');
    nouveau =abs(get(findobj('Tag','CANALRESULTAT'),'Value')-1);     % on écrase le canal source
    nombre =length(Vcan);
    dtchnl =CDtchnl();
    if nouveau
      hdchnl.duplic(Vcan);
      Ncan =[1:nombre]+vg.nad;
    else
    	Ncan =Vcan;
    end
    for ii =1:nombre
      Ofich.getcanal(dtchnl, Vcan(ii));
      N =dtchnl.Nom;
      hdchnl.adname{Ncan(ii)} =['IC.' deblank(hdchnl.adname{Vcan(ii)})];
      for jj =1:vg.ess
        lesmpl =hdchnl.nsmpls(Ncan(ii),jj);
        fniq =1/hdchnl.rate(Ncan(ii),jj);
        dtchnl.Dato.(N)(1:lesmpl,jj) =cumtrapz(dtchnl.Dato.(N)(1:lesmpl,jj))*fniq;
        vc =[hdchnl.comment{Ncan(ii), jj} '(Int-Cum)//'];
        hdchnl.comment{Ncan(ii), jj} =vc;
        hdchnl.max(Ncan(ii),jj) =max(dtchnl.Dato.(N)(1:lesmpl,jj));
        hdchnl.min(Ncan(ii),jj) =min(dtchnl.Dato.(N)(1:lesmpl,jj));
      end
      Ofich.setcanal(dtchnl, Ncan(ii));
    end
    delete(findobj('Tag','INTCUM'));
    delete(dtchnl);
    vg.sauve =1;
    vg.valeur =0;
    if nouveau
      vg.nad =vg.nad+nombre;
      gaglobal('editnom');
    else
      OA.OFig.affiche();
    end
  %-------------
  case 'fermer'
    delete(findobj('Tag','INTCUM'));
    vg.valeur =0;
  end
end
