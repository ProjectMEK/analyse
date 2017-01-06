%
% Classe pour gérer la conversion de ECEF vers LLA
%
classdef CGPSecef2lla

  %--------------------------------
  % Définition des Méthodes Statics

  methods (Static)

    function ouverture()
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      vg.valeur =1;																%
      largeur =450; hauteur =300;
      lapos =positionfen('G','C',largeur, hauteur);
      fig =figure('Name','Convertion de ECEF vers LLA', 'Position',lapos, ...
                  'CloseRequestFcn',@CGPSecef2lla.Fermer, ...
                  'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
                  'DefaultUIControlunits','pixels',...
                  'DefaultUIControlFontSize',11, 'Resize', 'off');
      marge =25; haut =25; posx =marge; large =largeur-2*marge; posy =hauteur-2*haut; corry =4;
      uicontrol('Parent',fig, 'Position',[posx posy large haut], 'HorizontalAlignment','center', ...
                'Style','text', 'String','Choix des canaux (GPS)');
      posy =posy-2*haut; largtit =30; largcan =large-largtit;
      uicontrol('Parent',fig, 'Position',[posx posy-corry largtit haut], 'HorizontalAlignment','right', ...
                'Style','text', 'String','X:  ');
      uicontrol('Parent',fig, 'tag','ChoixCanX', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
                'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1, 'Callback',@CGPSecef2lla.xyzChoix);
      posy =posy-haut-corry;
      uicontrol('Parent',fig, 'Position',[posx posy-corry largtit haut], 'HorizontalAlignment','right', ...
                'Style','text', 'String','Y:  ');
      uicontrol('Parent',fig, 'tag','ChoixCanY', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
                'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
      posy =posy-haut-corry;
      uicontrol('Parent',fig, 'Position',[posx posy-corry largtit haut], 'HorizontalAlignment','right', ...
                'Style','text', 'String','Z:  ');
      uicontrol('Parent',fig, 'tag','ChoixCanZ', 'BackgroundColor',[1 1 1], 'Position',[posx+largtit posy largcan haut], ...
                'Style','popupmenu', 'String',hdchnl.Listadname, 'Value',1);
      posx =marge+largtit; posy =posy-2*haut; large =round(large*0.7);
      A =uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','radiobutton', 'Tag','Ucm', ...
                'String','Les canaux sont en centimètres', 'Value',1, 'Callback',@CGPSecef2lla.Unites);
      posy =posy-haut;
      B =uicontrol('Parent',fig, 'Position',[posx posy large haut], 'Style','radiobutton',  'Tag','Um', 'Userdata', A,...
                'String','Les canaux sont en mètres', 'Value',0, 'Callback',@CGPSecef2lla.Unites);
      set(A, 'Userdata',B);
      large =100; posx =round((largeur-large)/2); posy =25;
      uicontrol('Parent',fig, 'Callback',@CGPSecef2lla.Travail, ...
                'Position',[posx posy large haut], 'String','Convertion');
      set(fig, 'WindowStyle','modal');
    end

    %--------------------------
    function Unites(src, event)
      V =get(src, 'Userdata');
      S =get(V, 'Value');
      if S
        set(V, 'Value',0);
        set(src, 'Value',1);
      else
        set(src, 'Value',1);
      end
    end

    %--------------------------
    function xyzChoix(src, evt)
      lesAD =get(src, 'String');
      leX =get(src, 'Value');
      if length(lesAD)-leX > 1
        set(findobj('tag','ChoixCanY'), 'Value',leX+1);
        set(findobj('tag','ChoixCanZ'), 'Value',leX+2);
      end
    end

    %---------------------------
    function Travail(src, event)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      Cx =get(findobj('tag','ChoixCanX'),'Value');
      Cy =get(findobj('tag','ChoixCanY'),'Value');
      Cz =get(findobj('tag','ChoixCanZ'),'Value');
      UU =get(findobj('Tag','Ucm'), 'Value');
      %________________________
      % Ajout des canaux utiles
      %
      hdchnl.duplic([Cx Cy Cz]);
      Dtx =CDtchnl();
      Dty =CDtchnl();
      Dtz =CDtchnl();
      Ofich.getcanal(Dtx, Cx);
      Ofich.getcanal(Dty, Cy);
      Ofich.getcanal(Dtz, Cz);
      %_____________________________________
      % correction pour les unités (cm ou m)
      %
      if UU
        Dtx.Dato.(Dtx.Nom) =Dtx.Dato.(Dtx.Nom)/100;
        Dty.Dato.(Dty.Nom) =Dty.Dato.(Dty.Nom)/100;
        Dtz.Dato.(Dtz.Nom) =Dtz.Dato.(Dtz.Nom)/100;
      end
      %___________________________
      % WGS84 ellipsoid constants:
      %
      a =6378137;
      e =8.1819190842622e-2;
      %______________________
      % On passe aux calculs:
      %
      b =sqrt(a^2*(1-e^2));
      ep =sqrt((a^2-b^2)/b^2);
      if max(max(hdchnl.nsmpls([Cx Cy Cz], :))) == min(min(hdchnl.nsmpls([Cx Cy Cz], :)))
        nsmpls =hdchnl.nsmpls(Cx, 1);
        p =sqrt(Dtx.Dato.(Dtx.Nom)(1:nsmpls,:).^2+Dty.Dato.(Dty.Nom)(1:nsmpls,:).^2);
        th =atan2(a*Dtz.Dato.(Dtz.Nom)(1:nsmpls,:), b*p);
        lon =atan2(Dty.Dato.(Dty.Nom)(1:nsmpls,:), Dtx.Dato.(Dtx.Nom)(1:nsmpls,:));
        lat =atan2((Dtz.Dato.(Dtz.Nom)(1:nsmpls,:)+ep^2.*b.*sin(th).^3), (p-e^2.*a.*cos(th).^3));
        N =a./sqrt(1-e^2.*sin(lat).^2);
        alt =(p./cos(lat))-N;
        %modif TL
        lat =lat*180/pi;
        lon =lon*180/pi;
        [lon,lat,Rr] =cart2sph(Dtx.Dato.(Dtx.Nom)(1:nsmpls,:), Dty.Dato.(Dty.Nom)(1:nsmpls,:), Dtz.Dato.(Dtz.Nom)(1:nsmpls,:));
        Dtx.Dato.(Dtx.Nom) =lat;
        Dty.Dato.(Dty.Nom) =lon;
        Dtz.Dato.(Dtz.Nom) =alt;
        Ofich.setcanal(Dtx, vg.nad+1);
        hdchnl.adname{vg.nad+1} =['LAT.(' deblank(hdchnl.adname{Cx}) ')'];
        Ofich.setcanal(Dty, vg.nad+2);
        hdchnl.adname{vg.nad+2} =['LON.(' deblank(hdchnl.adname{Cy}) ')'];
        Ofich.setcanal(Dtz, vg.nad+3);
        hdchnl.adname{vg.nad+3} =['ALT.(' deblank(hdchnl.adname{Cz}) ')'];
        for j =1:vg.ess
          hdchnl.comment{vg.nad+1, j} =['ECEF2LLA, //' hdchnl.comment{Cx, j}];
          hdchnl.comment{vg.nad+2, j} =['ECEF2LLA, //' hdchnl.comment{Cy, j}];
          hdchnl.comment{vg.nad+3, j} =['ECEF2LLA, //' hdchnl.comment{Cz, j}];
          hdchnl.max(vg.nad+1, j) =max(Dtx.Dato.(Dtx.Nom)(:, j));
          hdchnl.min(vg.nad+1, j) =min(Dtx.Dato.(Dtx.Nom)(:, j));
          hdchnl.max(vg.nad+2, j) =max(Dty.Dato.(Dty.Nom)(:, j));
          hdchnl.min(vg.nad+2, j) =min(Dty.Dato.(Dty.Nom)(:, j));
          hdchnl.max(vg.nad+3, j) =max(Dtz.Dato.(Dtz.Nom)(:, j));
          hdchnl.min(vg.nad+3, j) =min(Dtz.Dato.(Dtz.Nom)(:, j));
        end
      else
        for j =1:vg.ess
          nsmpls =min(hdchnl.nsmpls([Cx Cy Cz], j));
          p =sqrt(Dtx.Dato.(Dtx.Nom)(1:nsmpls,j).^2+Dty.Dato.(Dty.Nom)(1:nsmpls,j).^2);
          th =atan2(a*Dtz.Dato.(Dtz.Nom)(1:nsmpls,j), b*p);
          % J'ai fait les tests pour voir si on pouvait utiliser les fonctions
          % de convertion shérique (cart2sph). La longitude c'est OK, mais la lattitude non.
          %
          % J'ai aussi fait des tests avec des calculs itératifs, après la deuxième
          % boucle, on tombe à une pinotte près de la valeur ci-bas.
          %
          lon =atan2(Dty.Dato.(Dty.Nom)(1:nsmpls,j), Dtx.Dato.(Dtx.Nom)(1:nsmpls,j));
          lat =atan2((Dtz.Dato.(Dtz.Nom)(1:nsmpls,j)+ep^2.*b.*sin(th).^3), (p-e^2.*a.*cos(th).^3));
          N =a./sqrt(1-e^2.*sin(lat).^2);
          alt =(p./cos(lat))-N;
          %modif TL
          lat =lat*180/pi;
          lon =lon*180/pi;
          Dtx.Dato.(Dtx.Nom)(1:nsmpls,j) =lat;
          Dty.Dato.(Dty.Nom)(1:nsmpls,j) =lon;
          Dtz.Dato.(Dtz.Nom)(1:nsmpls,j) =alt;
          hdchnl.comment{vg.nad+1, j} =['ECEF2LLA, //' hdchnl.comment{Cx, j}];
          hdchnl.comment{vg.nad+2, j} =['ECEF2LLA, //' hdchnl.comment{Cy, j}];
          hdchnl.comment{vg.nad+3, j} =['ECEF2LLA, //' hdchnl.comment{Cz, j}];
          hdchnl.nsmpls(vg.nad+1, j) =nsmpls;
          hdchnl.nsmpls(vg.nad+2, j) =nsmpls;
          hdchnl.nsmpls(vg.nad+3, j) =nsmpls;
          hdchnl.sweeptime(vg.nad+1, j) =nsmpls/hdchnl.rate(vg.nad+1, j);
          hdchnl.sweeptime(vg.nad+2, j) =nsmpls/hdchnl.rate(vg.nad+2, j);
          hdchnl.sweeptime(vg.nad+3, j) =nsmpls/hdchnl.rate(vg.nad+3, j);
          hdchnl.max(vg.nad+1, j) =max(Dtx.Dato.(Dtx.Nom)(1:nsmpls, j));
          hdchnl.min(vg.nad+1, j) =min(Dtx.Dato.(Dtx.Nom)(1:nsmpls, j));
          hdchnl.max(vg.nad+2, j) =max(Dty.Dato.(Dty.Nom)(1:nsmpls, j));
          hdchnl.min(vg.nad+2, j) =min(Dty.Dato.(Dty.Nom)(1:nsmpls, j));
          hdchnl.max(vg.nad+3, j) =max(Dtz.Dato.(Dtz.Nom)(1:nsmpls, j));
          hdchnl.min(vg.nad+3, j) =min(Dtz.Dato.(Dtz.Nom)(1:nsmpls, j));
        end
        Ofich.setcanal(Dtx, vg.nad+1);
        hdchnl.adname{vg.nad+1} =['LAT.(' deblank(hdchnl.adname{Cx}) ')'];
        Ofich.setcanal(Dty, vg.nad+2);
        hdchnl.adname{vg.nad+2} =['LON.(' deblank(hdchnl.adname{Cy}) ')'];
        Ofich.setcanal(Dtz, vg.nad+3);
        hdchnl.adname{vg.nad+3} =['ALT.(' deblank(hdchnl.adname{Cz}) ')'];
      end
      vg.nad =vg.nad+3;
      delete([Dtx Dty Dtz]);
    	delete(gcf);
      vg.sauve = 1;
      gaglobal('editnom');
    end

    %--------------------------
    function Fermer(src, event)
      delete(gcf);
    end

  end  % methods
end
