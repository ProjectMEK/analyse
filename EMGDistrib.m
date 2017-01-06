function EMGDistrib(varargin)
%
% DISTRIBUTION DE PROBABILITE D'AMPLITUDE 
%
% Laboratoire GRAME
% Mai 2000, novembre 2010
%
% Fonction qui s'effectue à partir des courbes du signal RMS normalisées. Elle comptabilise 
% le nombre de données qui se retrouvent dans différents intervalles de pourcentage.
% ATTENTION: Les calculs sont relatifs au choix du "Canal/Essai" que vous avez utilisé
% comme référence (puissance Max) lors de la normalisation.
%
% Pour calculer ces intervalles, l'algorithme part de la valeur minimale de la
% courbe RMS, et va jusqu'à sa valeur maximale par pas d'incrémentation. Les  
% résultats se retrouvent sur une courbe dont les abscisses sont les valeurs RMS,
% et dont les ordonnées sont le nombre de données correspondant cumulatives (%).
% Les paramètres demandés sont: le choix des canaux, l'intervalle de calcul pour la 
% courbe initiale, et le pas d'incrémentation (en valeur RMS).
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
  case 'ouverture'
    vg.valeur =1;
    if vg.nad > 2; letop =vg.nad; else letop =vg.nad+1; end
    interv =['intervalle à déterminer|tout le signal'];
    largeur =300; hauteur =450; epais =25; mgreg =round(0.15*largeur);
    lapos =positionfen('G','C',largeur, hauteur);
    fig =figure('Name', 'DISTRIBUTION PROBABILITÉ AMPL. CUM.', 'Position',lapos, ...
             'CloseRequestFcn','EMGDistrib(''fermer'')',...
             'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
             'DefaultUIControlunits','pixels',...
             'DefaultUIControlFontSize',11, 'Resize', 'off');
    posx =mgreg; large =largeur-2*posx; haut =epais; posy =hauteur-round(1.5*epais);
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix des canaux');
    haut =round(0.2*hauteur); posy =posy-haut;
    uicontrol('Parent',fig, 'tag','ChoixCanaux', 'BackgroundColor',[1 1 1], 'Style','listbox', ...
              'Position',[posx posy large haut], 'String',hdchnl.Listadname, 'Min',1, 'Max',letop, 'Value',1);
    haut =epais; posy =posy-2*haut;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','Choix du pas d`incrémentation');
    posy =posy-haut; large =round(0.2*largeur); posx =round((largeur-large)/2);
    uicontrol('Parent',fig, 'Tag','PasIncrement', 'style', 'edit', ...
              'position', [posx posy large haut], 'string', '5');
    posx =posx+large;
    uicontrol('Parent',fig, 'Position',[posx posy-3 large haut], 'Style','text', ...
              'HorizontalAlignment','left', 'String',' (%)');
    posx =round(0.05*largeur); large =round(0.6*largeur)-2*posx; posy =posy-round(2.5*haut);
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','text', ...
              'HorizontalAlignment','right', 'String','Intervalle de calcul:  ');
    mx =largeur-large-2*posx; posx =posx+large; large =mx;
    uicontrol('Parent',fig, 'Tag','Interval', 'Position',[posx posy+4 large haut], 'Style','checkbox', ...
              'String','tout le signal', 'Callback','EMGDistrib(''intv'')', 'Value',1);
    posy =posy-round(1.25*haut); posx =round(0.05*largeur); large =largeur-2*posx;
    uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','text', ...
              'HorizontalAlignment','center', 'String','ou bien, entrez les valeurs temporelles');
    large =round(largeur/5); posx =round((largeur-2*large)/4); posy =posy-2*haut;
    uicontrol('Parent',fig, 'Tag','TempsDebut', 'style', 'edit', 'Enable','off', ...
              'position', [posx posy large haut], 'string', '1');
    posx =3*posx+large;
    uicontrol('Parent',fig, 'Tag','TempsFin', 'style', 'edit', 'Enable','off',...
              'position', [posx posy large haut], 'string', '4');
    large =round(largeur/3); posx =round((largeur-2*large)/4); posy =posy-haut;
    uicontrol('Parent',fig, 'Tag','TitreDebut', 'Style','text', 'Position',[posx posy large haut], ...
              'Enable','off', 'HorizontalAlignment','center', 'String','Début (sec)', 'FontSize',10);
    posx =3*posx+large;
    uicontrol('Parent',fig, 'Tag','TitreFin', 'Style','text', 'Position',[posx posy large haut], ...
              'Enable','off', 'HorizontalAlignment','center', 'String','Fin (sec)', 'FontSize',10);
    large =round(0.3*largeur); posx =round((largeur-large)/2); posy =posy-2*haut;
    uicontrol('Parent',fig, 'Callback','EMGDistrib(''travail'')', ...
              'Position',[posx posy large haut], 'String','au travail');
    set(fig,'WindowStyle','modal');
  %----------
  case 'intv'
    intval = get(findobj('Tag','Interval'),'Value');
    if intval
      set(findobj('Tag','TitreDebut'),'enable','off');
      set(findobj('Tag','TitreFin'),'enable','off');
      set(findobj('tag','TempsDebut'),'enable','off');
      set(findobj('tag','TempsFin'),'enable','off');
    else
      set(findobj('Tag','TitreDebut'),'enable','on');
      set(findobj('Tag','TitreFin'),'enable','on');
      set(findobj('tag','TempsDebut'),'enable','on');
      set(findobj('tag','TempsFin'),'enable','on');
    end
  %-------------
  case 'travail'
    canaux =get(findobj( 'tag','ChoixCanaux'),'Value')';  %'
    nombre =size(canaux,1);
    intval =get(findobj('Tag','Interval'),'Value');
    pas =str2num(get(findobj('Tag','PasIncrement'),'String'));
    nbpas =floor(100/pas);
    if intval
      tdeb =1;
      %------------------------
      % Ajout des canaux utiles
      hdchnl.duplic(canaux);
      Dt =CDtchnl();
      for ncan =1:nombre
      	vg.nad =vg.nad+1;
    	  Ofich.getcanal(Dt, canaux(ncan));
        for j =1:vg.ess
          fs =hdchnl.rate(canaux(ncan),j);
          fcut =hdchnl.frontcut(canaux(ncan),j);
          tfin =hdchnl.nsmpls(canaux(ncan),j);
          pcrms =pas;
          for k =1:nbpas
            conton =find(Dt.Dato.(Dt.Nom)(tdeb:tfin,j) < pcrms);
            Dt.Dato.(Dt.Nom)(k,j) =length(conton)/tfin*100;
            pcrms =pcrms+pas;
          end
          hdchnl.comment{vg.nad, j} =['FDPC-' num2str(pas) '%//' hdchnl.comment{canaux(ncan), j}];
          hdchnl.nsmpls(vg.nad,j) =nbpas;
          hdchnl.rate(vg.nad,j) =1/pas;
          hdchnl.sweeptime(vg.nad,j) =nbpas*pas;
          hdchnl.max(vg.nad, j) =max(Dt.Dato.(Dt.Nom)(1:nbpas, j));
          hdchnl.min(vg.nad, j) =min(Dt.Dato.(Dt.Nom)(1:nbpas, j));
        end
        Ofich.setcanal(Dt, vg.nad);
        hdchnl.adname{vg.nad} =['FDPC(' hdchnl.adname{canaux(ncan)} ')'];
      end
    else
      tdeb =str2num(get(findobj('tag','TempsDebut'),'String'));	%en s.
      tfin =str2num(get(findobj('tag','TempsFin'),'String'));
      pp =tdeb;
      tdeb =min(tdeb, tfin);
      tfin =max(tfin, pp);
      % ON COMMENCE PAR VÉRIFIER SI NOS DEUX BORNES SONT OK
      for ncan =1:nombre
        for j =1:vg.ess
          fs =hdchnl.rate(canaux(ncan),j);
          fcut =hdchnl.frontcut(canaux(ncan),j);
          smpl =hdchnl.nsmpls(canaux(ncan),j);
          deb =floor((tdeb-fcut)*fs);							%en nb de données
          if deb > smpl-1
            disp(['erreur borne inférieure:E' num2str(j) '/C' num2str(canaux(ncan))]);
            return;
          end
          fin =floor((tfin-fcut)*fs);
          if fin < max(deb+1, 1)
            disp(['erreur borne supérieure:E' num2str(j) '/C' num2str(canaux(ncan))]);
            return;
          end
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
          fs =hdchnl.rate(canaux(ncan),j);
          fcut =hdchnl.frontcut(canaux(ncan),j);
          smpl =hdchnl.nsmpls(canaux(ncan),j);
          deb =max(1, floor((tdeb-fcut)*fs));							%en nb de données
          fin =min(smpl, floor((tfin-fcut)*fs));
          pcrms =pas;
          for k =1:nbpas
            conton =find(Dt.Dato.(Dt.Nom)(deb:fin,j) < pcrms);
            Dt.Dato.(Dt.Nom)(k,j) =length(conton)/(fin-deb+1)*100;
            pcrms =pcrms+pas;
          end
          hdchnl.comment{vg.nad, j} =['FDPC-' num2str(pas) '%//' hdchnl.comment{canaux(ncan), j}];
          hdchnl.nsmpls(vg.nad,j) =nbpas;
          hdchnl.rate(vg.nad,j) =1/pas;
          hdchnl.sweeptime(vg.nad,j) =nbpas*pas;
          hdchnl.max(vg.nad, j) =max(Dt.Dato.(Dt.Nom)(1:nbpas, j));
          hdchnl.min(vg.nad, j) =min(Dt.Dato.(Dt.Nom)(1:nbpas, j));
        end
        Ofich.setcanal(Dt, vg.nad);
        hdchnl.adname{vg.nad} =['FDPC(' hdchnl.adname{canaux(ncan)} ')'];
      end
    end
    delete(Dt);
    delete(gcf);
    vg.sauve =1;
    gaglobal('editnom');
  %------------
  case 'fermer'
    delete(gcf);
  %--
  end
end
