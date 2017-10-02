function fncDiffer(varargin)
%
% DialogBox pour demander les infos relatives � la diff�renciation
% puis on passe � l'action. On suit la d�marche retrouv� dans le
% programme differ.pas d�velopp� pour l'environnement DOS.
% Tous les calculs se font avec la fonction DIFFER.M
%
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    th =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  switch(commande)
  %---------------
  case 'ouverture'
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','C',300,450);
    th.fig(1) =figure('Name','MENUDIFFER', ...
            'Position',lapos, ...
            'CloseRequestFcn','fncDiffer(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',10,...
            'Resize','off');
    th.titre(1) =uicontrol('Parent',th.fig(1), ...
            'FontSize',12,...
            'Position',[25 400 250 25], ...
            'String','Choix des canal/aux � diff�rencier', ...
            'Style','text');
    th.control(1) =uicontrol('Parent',th.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[50 175 200 225], ...
            'String',hdchnl.Listadname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox', ...
            'Value',1);
    th.control(2) =uicontrol('Parent',th.fig(1), ...
            'Position',[25 140 250 25], ...
            'HorizontalAlignment','left',...
            'String','Placer le r�sultat dans le m�me canal',...
            'Style','checkbox', ...
            'Value',0);
    uicontrol('Parent',th.fig(1), 'Position',[25 80 225 40], 'Style','text',...
            'String','Nombre de points pour le lissage (Largeur de fen�tre)');
    uicontrol('Parent',th.fig(1), 'Style','edit', 'Tag','LargeurFenLissage', ...
              'BackgroundColor',[1 1 1], 'Position',[250 100 35 20], ...
              'Style','edit', 'String','11', ...
              'TooltipString','Si laiss� � 0 ou 1, d�riv� brute: (Xi+1)-(Xi)');
    th.control(3) =uicontrol('Parent',th.fig(1), ...
            'Callback','fncDiffer(''travail'')', ...
            'Position',[45 25 100 25], ...
            'String','Au travail!');
    set(th.fig(1),'WindowStyle','modal');
    guidata(gcf,th);
  %-------------
  case 'travail'
    dtchnl =CDtchnl();
    Vcan =get(th.control(1),'Value')';                        % 'canaux � diff�rencier
    nouveau =abs(get(th.control(2),'Value')-1);               % on �crase le canal source
    fen =get(findobj('Tag','LargeurFenLissage'),'String');    % Nb de point pour le lissage en char
    window =str2double(fen);                                  % Nb de point pour le lissage en chiffre
    auTravail =str2func('differ');
    if window < 2
      auTravail =str2func('rawDiffer');
    end
    nombre =length(Vcan);
    if nouveau
      hdchnl.duplic(Vcan);
      Ncan =vg.nad+1:vg.nad+nombre;
    else
    	Ncan =Vcan;
    end
    hwb =waitbar(0.001, 'Travail en cours...');
    aubout =nombre*vg.ess;
    for U =1:nombre
   	  % on v�rifie la grosseur en m�moire pour un canal complet
     	% on permet 300 Mo max
     	comodato =vg.ess*max(hdchnl.nsmpls(Vcan(U),:))*4/1024/1024;
   	  if comodato > 300
   	    disp(['Le canal ' num2str(U) ' d�passe 300 Mo en m�moire']);
   	  	continue;
   	  end
      Ofich.getcanal(dtchnl, Vcan(U));
      if (min(hdchnl.nsmpls(Vcan(U),:)) ~= max(hdchnl.nsmpls(Vcan(U),:)) ||...
          min(hdchnl.rate(Vcan(U),:)) ~= max(hdchnl.rate(Vcan(U),:)))
        hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Ncan(U)})];
        for V =1:vg.ess
        	waitbar(((U-1)*nombre+V)/aubout,hwb);
        	try
            lemoins =hdchnl.nsmpls(Vcan(U),V);
            auTravail(dtchnl, lemoins, V, window, hdchnl.rate(Vcan(U) ,V));
            hdchnl.comment{Ncan(U), V} =[hdchnl.comment{Ncan(U), V} ' Differ,Fen=' fen '//'];
            hdchnl.max(Ncan(U),V) =max(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
            hdchnl.min(Ncan(U),V) =min(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
          catch auvol
            disp(['Erreur, canal: ' num2str(Vcan(U)) ' essai: ' num2str(V)]);
            disp(auvol.message);
          end
        end
      else
        lemoins =hdchnl.nsmpls(Vcan(U),1);
        auTravail(dtchnl, lemoins, [1:vg.ess], window, hdchnl.rate(Vcan(U), 1));
        hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Vcan(U)})];
        for V =1:vg.ess
        	waitbar(((U-1)*nombre+V)/aubout,hwb);
          hdchnl.comment{Ncan(U), V} =[hdchnl.comment{Ncan(U), V} ' Differ,Fen=',fen,'//'];
          hdchnl.max(Ncan(U),V) =max(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
          hdchnl.min(Ncan(U),V) =min(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
        end
      end
      Ofich.setcanal(dtchnl, Ncan(U));
    end
    delete(dtchnl);
    delete(hwb);
    delete(th.fig(1));
    vg.sauve =1;
    if nouveau
      vg.nad =vg.nad+nombre;
      gaglobal('editnom');
    else
      OA.OFig.affiche();
    end
  %------------
  case 'fermer'
    delete(th.fig(1));
  %--
  end
end

function rawDiffer(hndt, smpls, ess, fen, rate)
  hndt.Dato.(hndt.Nom)(1:smpls-1, ess) =hndt.Dato.(hndt.Nom)(2:smpls, ess)-hndt.Dato.(hndt.Nom)(1:smpls-1, ess);
  hndt.Dato.(hndt.Nom)(smpls, ess) =hndt.Dato.(hndt.Nom)(smpls-1, ess);
  hndt.Dato.(hndt.Nom)(:, ess) =hndt.Dato.(hndt.Nom)(:, ess)*rate;
end