function EMGLissage(varargin)
  %
  % LISSAGE
  %
  % Laboratoire GRAME
  % Mars 2000, octobre 2010
  %
  % Fonction qui permet de lisser la courbe: atténue les effets du bruits.
  %
  % L'algorithme utilise la "méthode des fenêtres": il part d'une fenêtre
  % qui fait la moyenne des points qu'elle contient, sauvegarde le résultat
  % dans une matrice, puis décalle la fenêtre d'un échantillon et fait de
  % même.
  % Les paramètres à choisir sont: le choix des canaux et la largeur de la 
  % fenêtre (attention: la largeur de la fenêtre doit être un nombre impair).
  %
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
  case 'ouverture'       %cas ou on appelle la fct
    if vg.nad > 2, letop =vg.nad; else, letop =vg.nad+1; end
    lapos =positionfen('G','C',300,450);
    fig =figure('Name', 'LISSAGE (Moyenne par fenêtre)', ...
                'Position',lapos, ...
                'CloseRequestFcn','EMGLissage(''fermer'')',...
                'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                'DefaultUIControlunits','pixels',...
                'DefaultUIControlFontSize',11,...
                'Resize', 'off');
    uicontrol('Parent',fig, 'Position',[25 410 250 25], ...
              'String','Choix du/des canal/aux à lisser', 'Style','text');
    uicontrol('Parent',fig, 'tag','NomCanaux', 'BackgroundColor',[1 1 1], 'Position',[50 180 200 225], ...
              'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Style','listbox', 'Value',1);
    uicontrol('Parent',fig, 'Position',[40 115 220 35], 'Style','text', ...
              'String','Largeur de la fenêtre (nbre impair):');
    uicontrol('Parent',fig, 'tag','LargeurFen', 'style', 'edit', ...
              'position', [125 80 50 25], 'string', '25');
    uicontrol('Parent',fig, 'Callback','EMGLissage(''travail'')', ...
              'Position',[100 25 100 25], 'String','Au travail');
    set(fig,'WindowStyle','modal');
  %-------------
  case 'travail'
    Wb =waitbar(0, 'Travail en cours...');
    canaux =get(findobj('tag','NomCanaux'),'Value')';				% 'canaux à lisser
    nombre =size(canaux,1);
    hdchnl.duplic(canaux);
    Dti =CDtchnl();
    Dtf =CDtchnl();
    window =str2num(get(findobj('tag','LargeurFen'),'String'));    % larg de la fenetre
    AvAp =floor(window/2);                                         % nb de datas avant et après
    ideb =AvAp+1;	                        % pt de depart
    for U =1:nombre
      vg.nad =vg.nad+1;
      Ofich.getcanal(Dti, canaux(U));
      Dtf.cloneThat(Dti);
      if max(hdchnl.nsmpls(vg.nad, :)) == min(hdchnl.nsmpls(vg.nad, :))
        ifin =hdchnl.nsmpls(vg.nad, 1)-AvAp;
        total =nombre*(ifin-ideb);
        tmp =(U-1)*(ifin-ideb);
        for smpl =ideb:ifin
          Dtf.Dato.(Dtf.Nom)(smpl, :)=mean(Dti.Dato.(Dti.Nom)(smpl-AvAp:smpl+AvAp, :));
          tmp =tmp+1;
          waitbar(tmp/total, Wb);
        end
        for V =1:vg.ess
          Dtf.Dato.(Dtf.Nom)(1:ideb, V) =Dti.Dato.(Dti.Nom)(ideb, V);
          Dtf.Dato.(Dtf.Nom)(ifin:ifin+AvAp, V)=Dti.Dato.(Dti.Nom)(ifin, V);
          hdchnl.comment{vg.nad, V} =['LISS//' hdchnl.comment{vg.nad, V}];
        end
        hdchnl.max(vg.nad, :) =max(Dtf.Dato.(Dtf.Nom)(1:ifin+AvAp, :));
        hdchnl.min(vg.nad, :) =min(Dtf.Dato.(Dtf.Nom)(1:ifin+AvAp, :));
      else
        total =nombre*vg.ess;
        tmp =(U-1)*vg.ess;
        for V =1:vg.ess
          ifin =hdchnl.nsmpls(vg.nad, V)-AvAp;
          for smpl =ideb:ifin
            Dtf.Dato.(Dtf.Nom)(smpl, V)=mean(Dti.Dato.(Dti.Nom)(smpl-AvAp:smpl+AvAp, V));
          end
          tmp =tmp+1;
          waitbar(tmp/total, Wb);
          Dtf.Dato.(Dtf.Nom)(1:ideb, V) =Dti.Dato.(Dti.Nom)(ideb, V);
          Dtf.Dato.(Dtf.Nom)(ifin:ifin+AvAp, V)=Dti.Dato.(Dti.Nom)(ifin, V);
          hdchnl.comment{vg.nad, V} =['LISS//' hdchnl.comment{vg.nad, V}];
          hdchnl.max(vg.nad, V) =max(Dtf.Dato.(Dtf.Nom)(1:ifin+AvAp, V));
          hdchnl.min(vg.nad, V) =min(Dtf.Dato.(Dtf.Nom)(1:ifin+AvAp, V));
        end
      end
      Ofich.setcanal(Dtf, vg.nad);
      hdchnl.adname{vg.nad} =['LIS(' hdchnl.adname{canaux(U)} ')'];
    end
    delete(Wb);
    delete(gcf);														%on enleve la fig menu
    vg.sauve =1;																%etat de sauvegarde du doc.
    gaglobal('editnom');
  %------------
  case 'fermer'																%cas ou on abandonne
    delete(gcf);
  %--
  end
end
