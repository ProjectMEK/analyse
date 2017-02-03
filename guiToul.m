%
% fonction pour gérer les outils
% zoom, marquage et affichage
%
function guiToul(varargin)
    if nargin == 0
      return;
    else
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      commande = varargin{1};
    end
  switch(commande)

  %-------------------------
  % Toggle la valeur du zoom
  %---------------
  case 'zoomonoff'
    vg.zoomonoff =CEOnOff(~vg.zoomonoff);
    afficheZoom(vg.zoomonoff);
  %________________________________
  % Affichage des points avec texte
  % vg.pt = 0   pas d'affichage
  %         1   avec texte
  %         2   sans texte
  %         3   pas d'afficahge mais on crée les pts, en réflexion pour le faire disparaître
  %-----------------
  case 'outil_point'
    hndltxt =findobj('tag', 'IpmnuPointSansTexte');
    set(hndltxt,'checked','off');
    hndl =findobj('tag', 'IpmnuPoint');
    switch vg.pt
    case 0
      vg.pt =1;
      set(hndl,'checked','on');
      OA.OFig.affiche();
    case 1
      vg.pt =0;
      set(hndl,'checked','off');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        ElPunto{U}.dttip.Visible ='off';
      end
    case 2
      vg.pt =1;
      set(hndl,'checked','on');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        K =ElPunto{U};
        K.dttip.StringFcn =@K.Eltexto;
      end
    case 3
      vg.pt =1;
      set(hndl,'checked','on');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        K =ElPunto{U};
        K.dttip.Visible ='on';
        K.dttip.StringFcn =@K.Eltexto;
      end
    end
  %________________________________
  % Affichage des points sans texte
  % vg.pt = 0   pas d'affichage
  %         1   avec texte
  %         2   sans texte
  %         3   pas d'afficahge mais on crée les pts, en réflexion pour le faire disparaître
  %---------------------------
  case 'AffichePointSansTexte'
    hndl =findobj('tag', 'IpmnuPoint');
    set(hndl,'checked','off');
    hndltxt =findobj('tag', 'IpmnuPointSansTexte');
    switch vg.pt
    case 0
      vg.pt =2;
      set(hndltxt,'checked','on');
      OA.OFig.affiche();
    case 1
      vg.pt =2;
      set(hndltxt,'checked','on');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        K =ElPunto{U};
        K.dttip.StringFcn =@K.EltextoVide;
      end
    case 2
      vg.pt =0;
      set(hndltxt,'checked','off');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        ElPunto{U}.dttip.Visible ='off';
      end
    case 3
      vg.pt =2;
      set(hndltxt,'checked','on');
      ElPunto =getappdata(gca,'ElPunto');
      for U =1:length(ElPunto)
        K =ElPunto{U};
        K.dttip.Visible ='on';
        K.dttip.StringFcn =@K.EltextoVide;
      end
    end
  %------------
  case 'modexy'
    bidon =get(findobj('tag', 'IpmnuXy'),'checked');
    if vg.xy
      Ofich.ModeXY.cacher();
    else
      Ofich.ModeXY.montrer();
    end
  %------------------
  case 'colore_canal'
    hndl =findobj('tag','IpmnuColcan');
    bidon =get(hndl,'checked');
    if strcmpi(bidon, 'on')
      vg.colcan =0;
      set(hndl,'checked','off');
    else
      vg.colcan =1;
      set(hndl,'checked','on');
    end
    OA.OFig.affiche();
  %------------------
  case 'colore_essai'
    hndl =findobj('tag','IpmnuColess');
    bidon =get(hndl,'checked');
    if strcmpi(bidon, 'on')
      vg.coless =0;
      set(hndl,'checked','off');
    else
      vg.coless =1;
      set(hndl,'checked','on');
    end
    OA.OFig.affiche();
  %----------------------
  case 'colore_categorie'
    hndl =findobj('tag','IpmnuColcat');
    bidon =get(hndl,'checked');
    if strcmpi(bidon, 'on')
      vg.colcat =0;
      set(hndl,'checked','off');
    else
      vg.colcat =1;
      set(hndl,'checked','on');
    end
    OA.OFig.affiche();
  %----------------
  case 'la_legende'
    hndl =findobj('tag','IpmnuLegende');
    bidon =get(hndl,'checked');
    [a,b,c,d] =legend;
    if strcmpi(bidon, 'on')
      vg.legende =0;
      set(hndl,'checked','off');
      set(a,'box','on','visible','off');
    else
      vg.legende =1;
      set(hndl,'checked','on');
      set(a,'box','on','visible','on','box','off');
    end
  %--------------
  case 'la_trich'
    hndl =findobj('tag','Ipmnutrich');
    bidon =get(hndl,'checked');
    if strcmpi(bidon, 'on')
      vg.trich =0;
      set(hndl,'checked','off');
    else
      vg.trich =1;
      set(hndl,'checked','on');
    end
    OA.OFig.affiche();
  %-----------
  case 'loque'
    hdchnl =Ofich.Hdchnl;
    vg.loq =get(findobj('Type','uicontrol','tag', 'IpFrameLock'),'Value');
    switch vg.loq
    case 1    % auto
      vg.xlim =0; vg.ylim =0;
      OA.OFig.affiche();
      set(findobj('Type','uicontrol','tag', 'IpAxeSlider'),'Visible','Off');
      set(findobj('Type','uicontrol','tag', 'IpAxeSliderY'),'Visible','Off');
    case 2    % barré
      vg.xlim =1; vg.ylim =1;
      vg.xval =get(gca,'Xlim');
      vg.yval =get(gca,'Ylim');
      OA.OFig.affiche();
      leminy =min(hdchnl.min(:));
      lemaxy =max(hdchnl.max(:));
      if vg.xy
        lemin =leminy;
        lemax =lemaxy;
      else
        lemin =min(hdchnl.frontcut(:));
        lemax =max(hdchnl.sweeptime(:));
      end
      lemin =min([lemin vg.xval(1)]);
      lemax =max([lemax vg.xval(2)]);
      Tou =vg.xval(1)+abs(vg.xval(1)*0.001);
      set(findobj('Type','uicontrol', 'tag','IpAxeSlider'), 'Min',lemin, 'Max',lemax, ...
                  'SliderStep',vg.deroul, 'Value',Tou, 'Visible','On');
      lemin =min([leminy vg.yval(1)]);
      lemax =max([lemaxy vg.yval(2)]);
      Tou =vg.yval(1)+abs(vg.yval(1)*0.001);
      set(findobj('Type','uicontrol', 'tag','IpAxeSliderY'), 'Max',lemax, 'Min',lemin,...
                  'Value',Tou, 'Visible','On', 'SliderStep',vg.deroul);
    case 3    % manuel
      lokAxe;
    end
  %-------------------
  case 'essai_suivant'
  	if ~get(findobj('Type','uicontrol','tag', 'IpEssTous'),'Value')
      OA.OFig.essai.suivant();
      guiToul('choix_essai');
    end
  %---------------------
  case 'essai_precedent'
  	if ~get(findobj('Type','uicontrol','tag', 'IpEssTous'),'Value')
      OA.OFig.essai.precedent();
      guiToul('choix_essai');
    end
  %-----------------
  case 'choix_essai'
    set(findobj('Type','uicontrol','tag', 'IpEssTous'),'Value',0);
    lestri =OA.OFig.essai.getValue();
    if isempty(lestri)
      lestri =1;
      OA.OFig.essai.setValue(lestri);
    end
  	vg.tri =lestri;
    vg.affniv =0;
    vg.toutri =false;
    OA.OFig.affiche();
  %----------------
  case 'tout_essai'
  	vg.affniv =0;
  	vg.toutri =~vg.toutri;
    OA.OFig.affiche();
  %-------------------
  case 'canal_suivant'
  	if ~get(findobj('Type','uicontrol','tag', 'IpCanTous'),'Value') &...
    		strncmpi(get(findobj('tag', 'IpmnuXy'),'checked'),'of',2)
      if vg.x == vg.nad; vg.x =1; else vg.x =vg.x+1; end
      OA.OFig.cano.suivant();
      guiToul('choix_canaux');
    end
  %---------------------
  case 'canal_precedent'
  	if ~get(findobj('Type','uicontrol','tag', 'IpCanTous'),'Value') &...
  		  strncmpi(get(findobj('tag', 'IpmnuXy'),'checked'),'of',2)
      if vg.x == 1; vg.x =vg.nad; else; vg.x =vg.x-1; end
      OA.OFig.cano.precedent();
      guiToul('choix_canaux');
    end
  %------------------
  case 'choix_canaux'
    if strncmpi(get(findobj('tag', 'IpmnuXy'),'checked'),'of',2)
    	 set(findobj('Type','uicontrol','tag', 'IpCanTous'),'Value',0)
      lescan =OA.OFig.cano.getValue();
      if isempty(lescan)
        lescan =1;
        OA.OFig.cano.setValue(1);
      end
      vg.can =lescan;
      vg.toucan =false;
      OA.OFig.affiche();
    end
  %-----------------
  case 'tout_canaux'
    % on vérifie si on est en mode XY
    if strncmpi(get(findobj('tag', 'IpmnuXy'),'checked'),'of',2)
      vg.toucan =~vg.toucan;
      OA.OFig.affiche();
    end
  %------------------
  case 'essai_enleve'
	  cuales =OA.OFig.essai.getValue();
    Ofich.suppess(cuales);
  %------------------
  case 'canal_enleve'
	  elcan =OA.OFig.cano.getValue();
    Ofich.suppcan(elcan);
  %-------------------
  case 'enleve_marque'
    marc =get(findobj('Type','uicontrol','tag', 'IpFrameEnleverpt'),'Value')-1;
    if marc
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      tri =Ofich.Lestri(1,1);
      can =Ofich.Lestri(1,6);
      ptchnl.EnlevePointetLien(tri, can, marc);
      set(findobj('Type','uicontrol','tag', 'IpFrameEnleverpt'),'Value',1);
      vg.sauve =1;
      OA.OFig.affiche();
    end
  %------------------
  case 'outil_marque'

    % Si on est en mode marquage manuel on empêche de "reboucler" dans cette fonction
    fifu =CEOnOff( get(findobj('tag','IpFrameMarquerpt'),'enable') );
    if fifu
      ffu =findobj('parent',findobj('tag','IpFrame'));
      set(ffu,'enable','off');
    else
      return;
    end

    %
    % Tant que l'on clique dans l'AXE graphique, on peut marquer.
    % On peut changer de canal/essai pendant que l'on marque.
    % E (Essai) puis les flèches haut et bas
    % C (Canal) puis les flèches haut et bas
    % N (Niveau) puis les flèches haut et bas
    % Enter ou Esc pour arrêter
    %
    hD =OA.OFig;
    tpchnl =Ofich.Tpchnl;     % handle sur les échelle de temps
    hdchnl =Ofich.Hdchnl;     % handle sur le "header" du fichier courant
    ptchnl =Ofich.Ptchnl;     % handle sur les points marqués
    dtX =CDtchnl();           % création d'un objet pour manipuler les datas des canaux
    dtY =CDtchnl();
    lalet =OA.Vg.nextkey;     % lecture du mode {C,E,N} --> {Canal, Essai, Niveau}
    losbtn=0;

    vas_y =true;
    while vas_y
      [losx,losy,losbtn] =ginput(1);    % la valeur retournée est en seconde
      if (losbtn > 0) & (losbtn < 4)
        enx =get(findobj('Type','axes','tag', 'IpAxe'),'xlim');
        eny =get(findobj('Type','axes','tag', 'IpAxe'),'ylim');
        quelcanal =get(findobj('tag','IpFrameChoixCan'),'value') - 1;
        %************************************************************%
        % on vérifie si on a cliqué dans la fenêtre graphique
        %
        % Lestri --> Matrice d'information sur les courbes affichées
        %            Lestri(1:ess, :)       premier canal
        %            Lestri((1:ess)+ess, :)   deuxième canal
        %            etc...
        %************************************************************%
        if (losx >= enx(1)) & (losx <= enx(2)) & (losy <= eny(2)) & (losy >= eny(1))
          if vg.xy
            %******************%
            % AFFICHAGE X vs Y
            %******************%
            xMin =losy-vg.xymarkxecart;
            xMax =losy+vg.xymarkxecart;
            yMin =losx-vg.xymarkyecart;
            yMax =losx+vg.xymarkyecart;
            N =size(Ofich.Lestri,1);
            cOk =0;
            yena =find(Ofich.Lestri(:, [6 7]) == quelcanal);
            if quelcanal & isempty(yena) & N == 1
              cOk =1;
            elseif quelcanal & isempty(yena)
              % on veut afficher dans un canal qui n'est pas affiché
              % on cherche combien d'essai à afficher
              ref =find(Ofich.Lestri(1, 1) == Ofich.Lestri(2:N, 1));
              if isempty(ref)                   % un seul canal XY
                cOk =N;
              else                              % plusieurs canaux XY
                cOk =ref(1);
              end
            end
            for i =1:N                          % on passe toutes les courbes
              tri =Ofich.Lestri(i,1);
              canx =Ofich.Lestri(i,7);
              cany =Ofich.Lestri(i,6);
              NbS =min(hdchnl.nsmpls(canx,tri), hdchnl.nsmpls(cany,tri));
              Ofich.getcaness(dtX, tri, canx);
              Nx =dtX.Nom;
              Ofich.getcaness(dtY, tri, cany);
              Ny =dtY.Nom;
              if vg.xymarkx
                Dat =dtX.Dato.(Nx)(1:NbS)-losx;
              else
                Dat =dtY.Dato.(Ny)(1:NbS)-losy;
              end
              quien =sign(Dat(1:end-1).*Dat(2:end));
              t2 =find(Dat == 0);
              if ~isempty(t2)
                quien(t2) =-1;
              end
              temps =find(quien == -1);
              if isempty(temps)
                continue;
              elseif length(temps) > 1
                TesT =find(temps(2:end)-temps(1:end-1) == 1);
                while ~isempty(TesT)
                  temps(TesT(end)+1) =[];
                  if length(temps) > 1
                    TesT =find(temps(2:end)-temps(1:end-1) == 1);
                  else
                    TesT =[];
                  end
                end
              end
              for V =1:length(temps)
                if temps(V) < length(Dat) & (abs(Dat(temps(V))) > abs(Dat(temps(V)+1)))
                  temps(V) =temps(V)+1;
                end
                if vg.xymarkx
                  if (dtY.Dato.(Ny)(temps(V)) < xMin) | (dtY.Dato.(Ny)(temps(V)) > xMax)
                    continue;
                  end
                else
                  if (dtX.Dato.(Nx)(temps(V)) < yMin) | (dtX.Dato.(Nx)(temps(V)) > yMax)
                    continue;
                  end
                end
                % on passe au marquage
                if quelcanal
                  if quelcanal == canx
                    %COORDONNÉEE X SEULEMENT
                    U =ptchnl.Onmark(canx,tri,0,temps(V));
                    rajoutPtsXY(Ofich, vg, canx, i, U, true);
                    vg.sauve =1;
                  elseif quelcanal == cany
                    %COORDONNÉEE Y SEULEMENT
                    U =ptchnl.Onmark(cany,tri,0,temps(V));
                    rajoutPtsXY(Ofich, vg, cany, i, U, false);
                    vg.sauve =1;
                  elseif i <= cOk
                    ptchnl.marquage(quelcanal,tri,0,temps(V));
                    vg.sauve =1;
                  end
                else
                  %COORDONNÉEE X
                  U =ptchnl.Onmark(canx,tri,0,temps(V));
                  rajoutPtsXY(Ofich, vg, canx, i, U, true);
                  %COORDONNÉEE Y
                  U =ptchnl.Onmark(cany,tri,0,temps(V));
                  rajoutPtsXY(Ofich, vg, cany, i, U, false);
                  vg.sauve =1;
                end
              end
            end
          else     % if vg.xy
            if quelcanal
              can =quelcanal;
              CoK =~isempty(find(Ofich.Lestri(:,6) == can));
              tri =Ofich.Lestri(1,1);
              for i =1:size(Ofich.Lestri,1)
                if CoK
                  if can ~= Ofich.Lestri(i,6)
                    continue;
                  end
                else
                  if (i > 1) & (tri >= Ofich.Lestri(i,1))
                    continue;
                  end
                end
                tri =Ofich.Lestri(i,1);
                if vg.letemps == 0
                  lepp =0;
                else
                  fs1 =hdchnl.rate(tpchnl.Dato{vg.letemps}.canal,tri);
                  lepp =ptchnl.Dato(tpchnl.Dato{vg.letemps}.point,hdchnl.point(tpchnl.Dato{vg.letemps}.canal,tri),1);
                  lepp =lepp/fs1;
                end
                temps =(losx+lepp-hdchnl.frontcut(can,tri))*hdchnl.rate(can,tri);
                temps =round(temps);
                if isempty(find(Ofich.Lestri(:,6) == can))
                  ptchnl.marquage(can,tri,0,temps);
                else
                  U =ptchnl.Onmark(can,tri,0,temps);
                  rajoutPts(Ofich, vg, can, i, U);
                end
                vg.sauve=1;
              end
            else     % if quelcanal
              for i =1:size(Ofich.Lestri,1)
                tri =Ofich.Lestri(i,1);
                can =Ofich.Lestri(i,6);
                if vg.letemps == 0
                  lepp =0;
                else
                  fs1 =hdchnl.rate(tpchnl.Dato{vg.letemps}.canal,tri);
                  lepp =ptchnl.Dato(tpchnl.Dato{vg.letemps}.point, hdchnl.point(tpchnl.Dato{vg.letemps}.canal, tri), 1);
                  lepp =lepp/fs1;
                end
                temps =(losx+lepp-hdchnl.frontcut(can,tri))*hdchnl.rate(can,tri);
                temps =round(temps);
                U =ptchnl.Onmark(can,tri,0,temps);
                rajoutPts(Ofich, vg, can, i, U);
                vg.sauve =1;
              end
            end     % if quelcanal
          end
        else
          vas_y =false;
          OA.Vg.nextkey =lalet;
          ffu =findobj('parent',findobj('tag','IpFrame'));
          set(ffu,'enable','on');
        end
      elseif losbtn == 27          % Esc
        vas_y =false;
        OA.Vg.nextkey =lalet;
        ffu =findobj('parent',findobj('tag','IpFrame'));
        set(ffu,'enable','on');
      elseif (losbtn == 67) | (losbtn == 99)         % Canal
        lalet =0;
      elseif (losbtn == 69) | (losbtn == 101)        % Essai
        lalet =1;
        if vg.affniv
          vg.affniv =0;
          hD.affiche();
        end
      elseif (losbtn == 78) | (losbtn == 110)        % Niveau
        lalet =2;
        if ~vg.affniv
          vg.affniv =1;
          hD.affiche();
        end
      elseif (losbtn == 30) | (losbtn == 45)         % flèche haut ou "-"
        if lalet==0
          guiToul('canal_precedent');
        elseif lalet == 1
          guiToul('essai_precedent');
        elseif lalet == 2
          lalist =hD.nivo.getValue();
          letop =length(hD.nivo.getString());
          if isempty(lalist)
            lalist =2;
          end
          lalist =lalist-1;
          if lalist(1) < 1
            lalist(1) =letop;
            lalist =sort(lalist);
          end
          hD.nivo.setValue(lalist);
          vg.cat =lalist;
          hD.affiche();
        end
      elseif (losbtn == 31) | (losbtn == 43)        % flèches bas ou "+"
        if lalet==0
          guiToul('canal_suivant');
        elseif lalet==1
          guiToul('essai_suivant');
        elseif lalet==2
          lalist =hD.nivo.getValue();
          letop =length(hD.nivo.getString());
          if isempty(lalist)
            lalist =0;
          end
          lalist =lalist+1;
          if lalist(end) > letop
            lalist(end)=1;
            lalist =sort(lalist);
          end
          hD.nivo.setValue(lalist);
          vg.cat =lalist;
          hD.affiche();
        end
      end
    end
    delete(dtX);
    delete(dtY);
    afficheZoom(vg.zoomonoff);
    OA.OFig.affiche();
  %----------------------------
  % Affiche un "cursorbar" pour
  % voir les coordonnées X-Y
  %------------------
  case 'affichecoord'
    vg.affcoord =CEOnOff(~vg.affcoord);
    afficheCoord(OA, vg.affcoord);
  %-----------------
  case 'permutation'
    gr =Ofich.Gr;
    lescats =gr.lescats;
    if vg.affniv
      grand =size(lescats,1);
      if grand > 1
        vg.permute =vg.permute+1;
        if vg.permute == grand
          vg.permute =0;
        else
          lescats(grand+1:grand+vg.permute,:) =lescats(1:vg.permute,:);
          lescats(1:vg.permute,:) =[];
          gr.lescats =lescats;
          gr.nbniv =size(gr.lescats,1);
          gr.status =false;
        end
        OA.OFig.affiche();
      	gr.status =true;
      else
        vg.permute =0;
      end
      set(findobj('Type','uicontrol','tag', 'IpCatsPermute'),'String',int2str(vg.permute));
    end
  %-------------
  case 'deroull'
    tasse =get(findobj('Type','uicontrol','tag', 'IpAxeSlider'),'value');
    vg.xval= [tasse, vg.xval(2)-vg.xval(1)+tasse];
    OA.OFig.affiche();  
  %--------------
  case 'deroully'
    tasse = get(findobj('Type','uicontrol','tag', 'IpAxeSliderY'),'value');
    vg.yval =[tasse, vg.yval(2)-vg.yval(1)+tasse];
    OA.OFig.affiche();  
  %----------------
  case 'ligne_type'
    gr =Ofich.Gr;
    hndl =findobj('tag','IpmnuSmpl');
    bidon =CEOnOff.(get(hndl,'checked'));
    vg.ligne =CEOnOff(abs(bidon-1));
    set(hndl,'checked',char(vg.ligne));
    if vg.ligne
      letyp ='+';
    else
      letyp ='none';
    end
    Ofich.couleur =OA.couleur{vg.ligne+1};
    % On agit directement sur le handle des courbes déjà affichées
    set(Ofich.Lestri(:,8), 'Marker',letyp);
  %-------------------------------------------
  % On a sélectionné une catégorie, on affiche
  % en fonction de ces nouvelles options.
  %------------
  case 'niveau'
    vg.affniv =1;
    vg.cat =OA.OFig.nivo.getValue();
    OA.OFig.affiche();
  end
end

function rajoutPts(Ofich, vg, can, lig, pt)
  hdchnl =Ofich.Hdchnl;
  ptchnl =Ofich.Ptchnl;
  lestri =Ofich.Lestri(lig, :);
  montrer =CEOnOff(vg.pt == 1 | vg.pt == 2);
  ElPunto =getappdata(gca,'ElPunto');
  tri =lestri(1);
  %
  % On fait le marquage du point
  %
  if ptchnl.Dato(pt ,hdchnl.point(can, tri) ,2) ~= -1
    lept =ptchnl.Dato(pt ,hdchnl.point(can, tri) ,1);
    p =CPoints(lestri(8), Ofich, tri, can, pt);
    ElPunto{end+1} =p;
    p.initial(lept, montrer);
    setappdata(gca,'ElPunto',ElPunto);
  end
end

%
% Applique la valeur "valZoom" à la propriété zoom de la fenêtre courante.
%
function afficheZoom(valZoom)
    pp =CEOnOff(valZoom);
    ss =zoom(gcf);
    set(ss,'enable',char(pp));
    set(findobj('tag','IpmnuZoom'),'checked',char(pp));
end

%
% Affiche un "cursorbar" pour voir les coordonnées X-Y
%
function afficheCoord(hDess, V)
  f =hDess.OFig.haffcoord;
  pp =CEOnOff(V);
  set(findobj('tag','IpmnuCoord'),'checked',char(V));
  % si le cursorbar existe ou n'a pas été détruit
  % CDessine le supprimera. En attendant on le cache.
  if isa(f, 'CAfficheCoord')
    f.cache();
  end
  if V 
    if isa(f, 'CAfficheCoord')
      if f.montre()
        hDess.OFig.haffcoord =CAfficheCoord();
      end
    else
      hDess.OFig.haffcoord =CAfficheCoord();
    end
  end
end

function rajoutPtsXY(Ofich, vg, can, lig, pt, XouY)
  hdchnl =Ofich.Hdchnl;
  ptchnl =Ofich.Ptchnl;
  lestri =Ofich.Lestri(lig,:);
  tri =lestri(1);
  debut =11-XouY;
  montrer =CEOnOff(vg.pt == 1 | vg.pt == 2);
  %
  % On fait le marquage du point
  %
  ElPunto =getappdata(gca, 'ElPunto');
  lept =ptchnl.Dato(pt ,hdchnl.point(can,tri) ,1);
  if (lept < lestri(debut)) | (lept > lestri(debut)+lestri(9))
    return;  % Y a personne...
  end
  p =CPointxy(lestri(8),Ofich,tri,can,pt,lestri(debut)-1,XouY);
  ElPunto{end+1} =p;
  Lindex =double(lept)-double(lestri(debut))+1;
  p.initial(Lindex,montrer);
  setappdata(gca,'ElPunto',ElPunto);
end