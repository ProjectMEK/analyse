function EMGTrio(varargin)
%
% FM-FMoy-Max 
% (Densité Spectrale de Puissance; Fréquences Médiane, Moyenne et Maximum)
%
% Laboratoire GRAME
% Avril 2000, juillet 2002, Novembre 2010
%
% Fonction qui donne la densité spectrale de puissance de la courbe choisie;
% elle permet de faire afficher sur cette courbe, la Fréquence Médiane,
% la fréquence moyenne, et/ou le Max.
%
% L'algorithme pour la fréquence médiane part de la fréquence la plus basse
% et calcule l'aire de la courbe de DSP entre 0 et cette fréquence. Puis il
% compare avec la moitié de l'aire totale: Si elle est inférieure, il refait 
% de même avec la fréquence suivante. Cette boucle s'arrête quand l'aire 
% calculée a dépassé la moitié de l'aire totale. Pour la fréquence moyenne
% et pour le max, rien à préciser.
%
% Les paramètres demandés sont: le choix des canaux, le marquage des fréquences
% médiane, moyenne et/ou du max, l'intervalle de calcul, le nombre d'échantillons
% pour le calcul de la transformée de Fourier et pour l'overlap (ces 2 derniers 
% paramètres étant utiles pour la fonction Matlab prédéfinie "psd").
%
% Attention
%
% La densité spectrale de puissance s'effectue sur un signal de préférence
% sans composante DC. Dans la litérature, on prend Y = X - mean(X) pour
% s'assurer qu'il n'y a plus de composante DC. On utilise donc le signal
% brut, tout au plus on passe un filtre [5 500]Hz, mais pas de rectification.
%
%_______________________________________________________________________________
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
    if vg.nad > 2; letop =vg.nad; else letop =vg.nad+1;end
    liste ={'128';'256';'512';'1024';'2048';'4096'};
    dep ={'temps en seconde'; 'Point marqué'};
    vg.valeur = 1;
    largeur=300; hauteur=530;
    lapos =positionfen('G','C',largeur, hauteur);
    fig = figure('Name', 'FREQ MED, MOY et MAX', 'Position',lapos, 'Resize', 'off', ...
            'CloseRequestFcn','EMGTrio(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',11);
    hbout =25; haut =hbout; posx =50; Lstd =200; large =Lstd; my =10; posy =hauteur-haut-my;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix des canaux');
    haut =90; posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixCanaux', 'Style','listbox', 'BackgroundColor',[1 1 1], 'Callback','EMGTrio(''Points'')', ...
              'Position',[posx posy large haut], 'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Value',1);
    haut =hbout; posy =posy-2*haut;
    uicontrol('Parent',fig, 'Style','text', 'BackgroundColor',[0.7922 0.7176 0.8157], ...
              'Position',[posx posy large haut], 'String','Choix de marquage');
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','MarkFreqMed', 'Style','checkbox', 'FontSize',10, ...
              'BackgroundColor',[0.7922 0.7176 0.8157], 'Position',[posx posy large haut], ...
              'String','marquage de la freq mediane', 'Value',0);
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','MarkFreqMoy', 'Style','checkbox', 'FontSize',10, ...
              'BackgroundColor',[0.7922 0.7176 0.8157], 'Position',[posx posy large haut], ...
              'String','marquage de la freq moyenne', 'Value',0);
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','MarkPuisMax', 'Style','checkbox', 'FontSize',10, ...
              'BackgroundColor',[0.7922 0.7176 0.8157], 'Position',[posx posy large haut], ...
              'String','marquage de la puiss spect max', 'Value',0);
    posy =posy-2*haut; large =round(largeur/2); posx =round((largeur-large)/2);
    uicontrol('Parent',fig, 'Position',[posx posy large haut-5], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix de Début/Fin');
    posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixDebutFin', 'Position',[posx posy large haut], ...
              'Style','popupmenu', 'String',dep, 'Callback','EMGTrio(''Points'')', 'Value',1);
    posy =round(posy-1.75*haut); large =round(largeur/6); posx =round(largeur/4);
    uicontrol('Parent',fig, 'tag','TempsDebut', 'style', 'edit', ...
              'Position', [posx posy large haut], 'string', '0');
    uicontrol('Parent',fig, 'tag','PointDebut', 'BackgroundColor',[1 1 1], 'visible','off', ...
              'Position',[posx posy large haut], 'Style','popupmenu', 'String','...', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Début', 'FontSize',10);
    posx =round(largeur*0.75)-large;
    uicontrol('Parent',fig, 'tag','TempsFin', 'style', 'edit', 'Position', [posx posy large haut], 'string', '10');
    uicontrol('Parent',fig, 'tag','PointFin', 'BackgroundColor',[1 1 1], 'Style','popupmenu', ...
              'Position',[posx posy large haut], 'String','...', 'visible','off', 'Value',1);
    uicontrol('Parent',fig, 'Position',[posx posy-haut large haut], 'Style','text', ...
              'String','Fin', 'FontSize',10);
    posy =posy-round(2.5*haut); posx =25; Lptit =70; large =largeur-2*posx-Lptit; corry =4;
    uicontrol('Parent',fig, 'Style','text', 'Position',[posx posy-corry large haut], 'FontSize',10, ...
              'String','Nb d''échantillons pour FFT: ', 'HorizontalAlignment','right');
    uicontrol('Parent',fig, 'Tag','NbEchantFft', 'Style','popupmenu', 'BackgroundColor',[1 1 1], ...
              'Position',[posx+large posy Lptit haut], 'String',liste, 'Value',1);
    posy =posy-haut;
    uicontrol('Parent',fig, 'Position',[posx posy-corry large haut], 'Style','text', 'FontSize',10, ...
              'String','Nb d''échantillons d''overlap: ', 'HorizontalAlignment','right');
    uicontrol('Parent',fig, 'Tag','NbOverlap', 'style', 'edit', 'position', [posx+large posy Lptit haut], 'string', '0');
    large =100; posx =round((largeur-large)/2); posy =posy-2*haut;
    uicontrol('Parent',fig, 'Callback','EMGTrio(''travail'')', 'Position',[posx posy large haut], 'String','Au travail');
    set(fig,'WindowStyle','modal');
  %------------
  case 'Points'
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    switch(pts)
    %-----
    case 1                                                  %cas valeur temporelle
      set(findobj('tag','PointDebut'),'visible','off');
      set(findobj('tag','PointFin'),'visible','off');
      set(findobj('tag','TempsDebut'),'visible','on');
      set(findobj('tag','TempsFin'),'visible','on');
    %-----
    case 2                                                  %cas pts déjà marqués	
      set(findobj('tag','TempsDebut'),'visible','off');
      set(findobj('tag','TempsFin'),'visible','off');
      set(findobj('tag','PointDebut'),'visible','on');
      set(findobj('tag','PointFin'),'visible','on');
      EMGTrio('initpts');
    end
  %-------------
  case 'initpts'
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    if pts == 2
      canal =get(findobj('tag','ChoixCanaux'),'Value')';  %'
      liste ={'...'};
      nptm =min(min(hdchnl.npoints(canal,:)));
      for l =1:nptm
        liste{end+1} =['n°' num2str(l)];
      end
      laval =get(findobj('tag','PointDebut'),'value');
      if laval > nptm+1
        laval =1;
      end
      set(findobj('tag','PointDebut'),'String',liste,'value',laval);
      laval =get(findobj('tag','PointFin'),'value');
      if laval > nptm+1
        laval =1;
      end
      set(findobj('tag','PointFin'),'String',liste,'value',laval);
    end
  %-------------
  case 'travail'
    canaux =get(findobj('tag','ChoixCanaux'),'Value');
    nombre =length(canaux);
    ptchnl =Ofich.Ptchnl;
    pop =get(findobj('Tag','NbEchantFft'),'Value');
    popstr =get(findobj('Tag','NbEchantFft'), 'String');
    noverlap =str2double(get(findobj('Tag','NbOverlap'),'String'));
    nfft =str2double(popstr{pop});
    pts =get(findobj('tag','ChoixDebutFin'),'Value');
    % Points à marquer après calcul
    fm =get(findobj('tag','MarkFreqMed'),'Value');
    fmoy =get(findobj('tag','MarkFreqMoy'),'Value');
    pmax =get(findobj('tag','MarkPuisMax'),'Value');
    %----------
    switch(pts)         %pts de debut et fin a choisir
    %-----
    case 1
      %------------------------
      % Ajout des canaux utiles
      hdchnl.duplic(canaux);
      Dt =CDtchnl();
      deb =str2double(get(findobj('tag','TempsDebut'),'String'));
      fin =str2double(get(findobj('tag','TempsFin'),'String'));
      for ncan =1:nombre
        % comme on produit un nouveau canal, on incrémente vg.nad au fur et à mesure
        vg.nad =vg.nad+1;
        % on lit les datas du canal demandé et on les met dans Dt
        Ofich.getcanal(Dt, canaux(ncan));
        for j =1:vg.ess
          fs =hdchnl.rate(vg.nad,j);
          tdeb =max(deb*fs, 1);
          tfin =min(fin*fs, hdchnl.nsmpls(vg.nad,j));
          emgt =Dt.Dato.(Dt.Nom)(tdeb:tfin,j);
          %------------------------------------------------------------------
          % Changement de fonction pour calculer la puissance spectrale
          % Matlab abandonne la fonction "psd"
          % Ils suggère la fonction "pwelch"
          % Attention, pwelch moyenne les datas en fonction du
          % nombre de fréquence, il faut alors remultiplier par fs/2
          % On remarquera que le premier et le dernier point sont la moitié
          % de ce qu'ils étaient avec la fonction psd.
          % Ancienne Fc:  [P,f] =psd(emgt,nfft,fs,hanning(nfft),noverlap,1);
          %------------------------------------------------------------------
          % test de spectrum
          %   Hspec =spectrum.welch('Hann', length(emgt), 0);
          %   Hpsd =psd(Hspec, emgt, 'Fs',fs, 'NFFT',nfft);
          %   P =Hpsd.Data*fs/2;
          %   f =Hpsd.Frequencies;
          %   P([1 end]) =P([1 end])*2;
          % fin de test de spectrum
          %
          % J'ai remis le hanning plutôt que window...  le 6 avril 2016
          %_____________________________________________________________________
          %[P,f] =pwelch(emgt,window(@hann,nfft),noverlap,nfft,fs,'onesided');
          [P,f] =pwelch(emgt,hanning(nfft),noverlap,nfft,fs,'onesided');
          P =P*fs/2;
          long =length(f);
          hdchnl.comment{vg.nad, j} =['DSP,nfft=' num2str(nfft) '//' hdchnl.comment{canaux(ncan), j}];
          hdchnl.rate(vg.nad,j) =(long-1)/(f(long)-f(1));
          hdchnl.frontcut(vg.nad,j) =f(1)-(1/hdchnl.rate(vg.nad,j));
          hdchnl.nsmpls(vg.nad,j) =long;
          Dt.Dato.(Dt.Nom)(1:long, j) =P(1:long);                % DSP ds le nveau canal
          hdchnl.max(vg.nad, j) =max(Dt.Dato.(Dt.Nom)(1:long, j));
          hdchnl.min(vg.nad, j) =min(Dt.Dato.(Dt.Nom)(1:long, j));
          if fm
            d =trapz(f,P);
            dmi =d/2;
            a =0;
            t =1;
            while a < dmi
              t =t+1;
              a =trapz(f(1:t),P(1:t));
            end
            ptchnl.marqettyp(vg.nad, j, 0, (t-1), 1);
          end
          if fmoy
            som1 =sum(f(1:long).*P(1:long));
            som2 =sum(P(1:long));
            MPF =som1/som2;
            indicef =((MPF-f(1))*hdchnl.rate(vg.nad,j)) +1;      % on met la freq moy en
            valent =floor(indicef);									             % nb de donnees
            ptchnl.marqettyp(vg.nad, j, 0, valent, 2);
          end
          if pmax
            [a,temp] =max(P);	  								%max de la DSP et son indice
            ptchnl.marqettyp(vg.nad, j, 0, temp, 3);
          end
        end			% end bcl sur les essais
        Ofich.setcanal(Dt, vg.nad);
        hdchnl.adname{vg.nad} =['DSP.(' deblank(hdchnl.adname{canaux(ncan)}) ')'];
      end				% end bcl sur les canaux
    %-----
    case 2				% pts dep et fin deja marques
      pd =get(findobj('tag','PointDebut'),'Value');					% num pt dep
      pf =get(findobj('tag','PointFin'), 'Value');					% num pt fin
      if pd == 1 || pf == 1 || pd == pf
        disp('Il faut choisir deux points différents...');
        return;
      else
        ttest =Ofich.assezpt(canaux,[pd-1 pf-1]);
        if ttest
          return;
        end
      end
      %------------------------
      % Ajout des canaux utiles
      hdchnl.duplic(canaux);
      Dt =CDtchnl();
      for ncan =1:nombre
      	vg.nad =vg.nad+1;
      	Ofich.getcanal(Dt, canaux(ncan));
        for j =1:vg.ess
          tdeb =ptchnl.Dato((pd-1),hdchnl.point(canaux(ncan),j),1);
          tfin =ptchnl.Dato((pf-1),hdchnl.point(canaux(ncan),j),1);
          fs =hdchnl.rate(vg.nad,j);
          emgt =Dt.Dato.(Dt.Nom)(tdeb:tfin,j);
          [P,f] =pwelch(emgt,window(@hann,nfft),noverlap,nfft,fs,'onesided');
          P =P*fs/2;
          long =length(f);
          hdchnl.comment{vg.nad, j} =['DSP,nfft=' num2str(nfft) '//' hdchnl.comment{canaux(ncan), j}];
          hdchnl.rate(vg.nad,j) =(long-1)/(f(long)-f(1));
          hdchnl.frontcut(vg.nad,j) =f(1)-(1/hdchnl.rate(vg.nad,j));
          hdchnl.nsmpls(vg.nad,j) =long;
          Dt.Dato.(Dt.Nom)(1:long, j) =P(1:long);                % DSP ds le nveau canal
          hdchnl.max(vg.nad, j) =max(Dt.Dato.(Dt.Nom)(1:long, j));
          hdchnl.min(vg.nad, j) =min(Dt.Dato.(Dt.Nom)(1:long, j));
          if fm
            d =trapz(f,P);
            dmi =d/2;
            a =0;
            t =1;
            while a < dmi
              t =t+1;
              a =trapz(f(1:t),P(1:t));
            end
            ptchnl.marqettyp(vg.nad, j, 0, (t-1), 1);
          end
          if fmoy
            som1 =sum(f(1:long).*P(1:long));
            som2 =sum(P(1:long));
            MPF =som1/som2;
            indicef =((MPF-f(1))*hdchnl.rate(vg.nad,j)) +1;      % on met la freq moy en
            valent =floor(indicef);									             % nb de donnees
            ptchnl.marqettyp(vg.nad, j, 0, valent, 2);
          end
          if pmax
            [a,temp] =max(P);	  								%max de la DSP et son indice
            ptchnl.marqettyp(vg.nad, j, 0, temp, 3);
          end
        end	 % end de la bcl sur les essais
        Ofich.setcanal(Dt, vg.nad);
        hdchnl.adname{vg.nad} =['DSP.(' deblank(hdchnl.adname{canaux(ncan)}) ')'];
      end    % fin boucle sur les canaux
    end					% end du switch sur les pts de dep et fin	
    vg.sauve = 1;															%etat de sauvegarde du doc.
    delete(Dt);
    delete(gcf);
    gaglobal('editnom');
  %------------
  case 'fermer'																%qd on abandonne
    delete(gcf);
  %--
  end
end
