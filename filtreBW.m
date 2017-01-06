% 
% DialogBox pour demander les infos relatives au Butterworth
% puis on passe à l'action.
%
% Les choix sont : passe-bas
%                  passe-haut
%                  passe-bande
%                  coupe-bande (fiter-notch)
%
% en fonction du choix, on demandera des infos qui pourront différées.
%
function filtreBW(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    fh =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  switch(commande)
  %---------------
  case 'ouverture'
    vg.valeur=1;
    letype ={'Passe-Bas (défaut)','Passe-Haut','Passe bande','Coupe bande (Notch Filter)'};
    if vg.nad > 2;letop =vg.nad;else letop =vg.nad+1;end
    lapos =positionfen('G','H',300,470);
    fh.fig(1) =figure('Name','MENUFILTRAGE', 'Position',lapos, ...
            'CloseRequestFcn','filtreBW(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',12, 'Resize','off');
    %________________________
    % Choix du filtre à faire
    fh.titre(1) =uicontrol('Parent',fh.fig(1), ...
            'Position',[25 435 250 25], ...
            'FontWeight','bold',...
            'Style','text',...
            'String','Choix du type de ButterWorth');
    fh.control(1) =uicontrol('Parent',fh.fig(1), ...
            'Position',[25 405 250 25], ...
            'String',letype, ...
            'Callback','filtreBW(''choix'')', ...
            'Style','popupmenu', ...
            'Value',1);
    %___________________________
    % Choix des canaux à filtrer
    fh.titre(2) =uicontrol('Parent',fh.fig(1), ...
            'FontWeight','bold',...
            'Position',[25 365 250 25], ...
            'String','Choix du/des canal/aux', ...
            'Style','text');
    fh.control(2) =uicontrol('Parent',fh.fig(1), ...
            'BackgroundColor',[1 1 1], ...
            'Position',[50 200 200 160], ...
            'String',hdchnl.Listadname, ...
            'Min',1,...
            'Max',letop,...
            'Style','listbox',...
            'Value',1);
    %___________________________
    % Choix de l'ordre du filtre
    fh.text(1) =uicontrol('Parent',fh.fig(1), ...
            'Position',[35 125 165 20], ...
            'Style','text',...
            'String','     ordre du filtre:');
    fh.ed(1) =uicontrol('Parent',fh.fig(1), ...
            'Position',[200 125 50 20], ...
            'Style','edit', ...
            'String','4');
    %___________________________________
    % Choix de la fréquence de coupure 1
    fh.text(2) =uicontrol('Parent',fh.fig(1), ...
            'Position',[35 70 165 20], ...
            'Style','text',...
            'String','Fréquence de coupure:');
    fh.ed(2) =uicontrol('Parent',fh.fig(1), ...
            'Position',[200 70 50 20], ...
            'Style','edit', ...
            'String','10');
    %___________________________________
    % Choix de la fréquence de coupure 2
    fh.text(3) = uicontrol('Parent',fh.fig(1), 'Position',[50 85 200 20], 'Style','text', ...
              'String','Min                         Max', 'visible','off');
    fh.ed(3) = uicontrol('Parent',fh.fig(1), 'Position',[175 60 50 20], ...
              'Style','edit', 'String','20', 'visible','off');
    %______________________________________
    % Placer le résultat dans le même canal
    fh.control(4) =uicontrol('Parent',fh.fig(1), ...
            'Position',[50 170 274 25], ...
            'FontSize',9,...
            'HorizontalAlignment','left',...
            'String','Placer le résultat dans le même canal',...
            'Style','checkbox', ...
            'Value',0);
    %___________
    % Au travail
    fh.control(3) =uicontrol('Parent',fh.fig(1), ...
            'Callback','filtreBW(''travail'')', ...
            'Position',[100 15 100 20], ...
            'String','Au travail');
    set(fh.fig(1),'WindowStyle','modal');
    guidata(gcf,fh);
  %-----------
  case 'choix'
    bouton =get(fh.control(1),'Value');
    switch(bouton)
    case {1, 2}
      effacer(fh, 'off');
      set(fh.text(1), 'Position',[35 125 165 20]);
      set(fh.ed(1),'Position',[200 125 50 20]);
      set(fh.text(2), 'Position',[35 70 165 20]);
      set(fh.ed(2), 'Position',[200 70 50 20]);
    case {3, 4}
      set(fh.text(1), 'Position',[35 140 165 20]);
      set(fh.ed(1), 'Position',[180 140 50 20]);
      set(fh.text(2), 'Position',[50 105 200 20]);
      set(fh.ed(2), 'Position',[75 60 50 20]);
      effacer(fh, 'on');
    end
    vg.valeur =bouton;
    guidata(gcf,fh);
  %-------------
  case 'travail'
    % création d'un canal temporaire de travail
    dtchnl =CDtchnl();
    % lecture de l'interface
    afaire =get(fh.control(1),'Value');
    lescan =get(fh.control(2),'Value');
    nouveau =abs(get(fh.control(4),'Value')-1);     % on écrase le canal source
    lehndl =findobj('type','figure','tag','IpTraitement');
    ord =get(fh.ed(1),'String');
    frc1 =get(fh.ed(2),'String');
    frc2 =get(fh.ed(3),'String');
    % variable pour les calculs
    nombre =length(lescan);                         % Nb de canal à filtrer
    ordre =str2double(ord);                         % ordre du ButterW
    frcut1 =str2double(frc1);                       % fréq de coupure bas
    frcut2 =str2double(frc2);                       % fréq de coupure haut
    prenom ={'BUT.bas', 'BUT.haut', 'BUT.band', 'BUT.coupe'};       % modification du nom de canal
    if nouveau
      % si on écrase pas, on place les nouveaux à la fin
      Ncan =vg.nad+1:vg.nad+nombre;
      hdchnl.duplic(lescan);
    else
      Ncan =lescan;
    end
    % on travaille sur chacun des canaux séparément
    for i =1:nombre
    	Ofich.getcanal(dtchnl, lescan(i));
    	N =dtchnl.Nom;
      hdchnl.adname{Ncan(i)} =[prenom{afaire} deblank(hdchnl.adname{Ncan(i)})];
      %_____________________________________________
      % on a tous le même nombres d'échantillons
      %---------------------------------------------
      if min(hdchnl.nsmpls(Ncan(i),:)) == max(hdchnl.nsmpls(Ncan(i),:))
      disp('Même nb de smpls')
        try
          verifFreq(hdchnl, afaire, lescan(i), 1, frcut1, frcut2);
          lemoins =hdchnl.nsmpls(Ncan(i),1);
          fniq =double(hdchnl.rate(Ncan(i),1))/2;
          cuchillo1 =max(0.0001, min(0.9999, frcut1/fniq));
          cuchillo2 =max(0.0001, min(0.9999, frcut2/fniq));
          if afaire == 1
            [b,a] =butter(ordre,cuchillo1);
            for j =1:vg.ess
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',Ord=',ord,', Freq=',frc1,'//'];
              hdchnl.comment{Ncan(i), j} =vc;
            end
          elseif afaire == 2
            [b,a] =butter(ordre,cuchillo1,'high');
            for j =1:vg.ess
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',Ord=',ord,', Freq=',frc1,'//'];
              hdchnl.comment{Ncan(i), j} =vc;
            end
          elseif afaire == 3
            [b,a] =butter(ordre,[cuchillo1 cuchillo2]);
            for j =1:vg.ess
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',F1= ' frc1 ',F2= ' frc2 '//'];
              hdchnl.comment{Ncan(i), j} =vc;
            end
          else
            [b,a] =butter(ordre,[cuchillo1 cuchillo2],'stop');
            for j =1:vg.ess
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',F1= ' frc1 ',F2= ' frc2 '//'];
              hdchnl.comment{Ncan(i), j} =vc;
            end
          end
          dtchnl.Dato.(N)(1:lemoins,:) =filtfilt(b,a,double(dtchnl.Dato.(N)(1:lemoins,:)));
          for j =1:vg.ess
            hdchnl.max(Ncan(i), j) =max(dtchnl.Dato.(N)(1:lemoins,j));
            hdchnl.min(Ncan(i), j) =min(dtchnl.Dato.(N)(1:lemoins,j));
          end
        catch me
          disp(me.message);
        end
      else
        for j =1:vg.ess
          try
            verifFreq(hdchnl, afaire, Ncan(i), j, frcut1, frcut2);
          catch me
            disp(me.message);
            continue;
          end
          lemoins =hdchnl.nsmpls(Ncan(i),j);
          fniq =double(hdchnl.rate(Ncan(i),j))/2;
          cuchillo1 =max(0.001, min(0.999, frcut1/fniq));
          cuchillo2 =max(0.001, min(0.999, frcut2/fniq));
          if afaire == 1
            [b,a] =butter(ordre,cuchillo1);
            vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',Ord=',ord,', Freq=',frc1,'//'];
            hdchnl.comment{Ncan(i), j} =vc;
          elseif afaire == 2
            [b,a] =butter(ordre,cuchillo1,'high');
            vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',Ord=',ord,', Freq=',frc1,'//'];
            hdchnl.comment{Ncan(i), j} =vc;
          elseif afaire == 3
            [b,a] =butter(ordre,[cuchillo1 cuchillo2]);
            vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',F1=' frc1 ', F2=' frc2 '//'];
            hdchnl.comment{Ncan(i), j} =vc;
          else
            [b,a] =butter(ordre,[cuchillo1 cuchillo2],'stop');
            vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{afaire} ',F1=' frc1 ', F2=' frc2 '//'];
            hdchnl.comment{Ncan(i), j} =vc;
          end
          try
            dtchnl.Dato.(N)(1:lemoins,j) =filtfilt(b,a,double(dtchnl.Dato.(N)(1:lemoins,j)));
            hdchnl.max(Ncan(i), j) =max(dtchnl.Dato.(N)(1:lemoins,j));
            hdchnl.min(Ncan(i), j) =min(dtchnl.Dato.(N)(1:lemoins,j));
          catch auvol
            disp(['Erreur, canal: ' num2str(lescan(i)) ' essai: ' num2str(j)]);
            disp(auvol.message);
          end
        end
      end
      Ofich.setcanal(dtchnl, Ncan(i));
    end  % for i =1:nombre
    delete(fh.fig(1));
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
    delete(fh.fig(1));
    vg.valeur =0;
  end
end

function verifFreq(hdchnl, afaire, can, ess, f1, f2)
    % on vérifie que la fréq de coupure respecte la fonction butter de matlab
    if afaire < 3  % Butterworth Passe-Bas/Haut
      if 2*f1 > hdchnl.rate(can,ess)
        mots =sprintf(['La fréquence de coupure doit être inférieure à la moitié ', ...
              'de la fréquence d''aquisition: can(%i) ess(%i)'], can, ess);
        e =MException('MFILTRE:VERIFFREQ',mots);
        throw(e);
      end
    else  % passe bande et coupe bande
      if 2*f1 > hdchnl.rate(can,ess) || 2*f2 > hdchnl.rate(can,ess) || f1 <= 0 || f1 >= f2
        mots =sprintf(['Les fréquences de coupure doivent être non-nulles et inférieures à la moitié ', ...
              'de la fréquence d''aquisition: can(%i) ess(%i)'], can, ess);
        e =MException('MFILTRE:VERIFFREQ',mots);
        throw(e);
      end
    end
end

function effacer(fh, v)
  %
  % gestion des Objets à afficher ou enlever
  %
  set(fh.text(3), 'visible',v);
  set(fh.ed(3), 'visible',v);
end
