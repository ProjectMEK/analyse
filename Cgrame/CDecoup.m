%
% Classe CDecoup
%
% L'idée est de garder du temps avant et après un point marqué
% Il faut donc avoir des points marqués pour tous les essais
% dans un canal donné.
% Puis on va sauvegarder les datas dans un nouveau fichier.
%
% Jadis, plusieurs choix étaient offert ici. On a divisé les tâches
% avec la fonction "couper"
%
% MEK - juillet 2009
%
classdef CDecoup < CBasePourFigureAnalyse

  properties
    status =false;  % sera "true" lorsque le travail commence afin
                    % de ne pas cliquer à répétition pendant les calculs.
  end

  methods

    %------------
    % CONSTRUCTOR
    %----------------------
    function obj =CDecoup()
      GUIDecoup(obj);
    end

    %-----------------------------
    % Callback lorsque l'on clique
    % le bouton "Au travail"
    %------------------------------
    function travail(obj,src,event)
      if obj.status
        return;
      end
      obj.status =true;
      afaire =get(findobj('tag','DecoupeQueFaire'),'Value');
      cc =get(findobj('tag','DecoupeCanaux'),'Value')'; % '
      ff =get(findobj('tag','DecoupeFrontcut'),'Value');
      switch(afaire)
     	case 1
      	obj.parpoint(cc,ff);
   		case 2
   		case 3
   		end
   	end

   	%-------------------------------------------
   	% On découpe en fonction du choix d'un point
   	%------------------------------------
   	function parpoint(obj,Can,garderfcut)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      ptchnl =Ofich.Ptchnl;
      catego =Ofich.Catego;
      nombre =length(Can);
      Zst =uint8(1);                % step de base pour le waitbar
      Zmax =uint8(127);
      Z =Zst;
      Foo =double(Z)/double(Zmax);
      elWb =laWaitbar(Foo, 'Comptabilisation des nouveaux essais', 'C', 'B', gcf);
      %
      % Comptabilisation des nouveaux essais
     	canref =get(findobj('tag','DecoupeCanalRef'),'value');
     	% numéro du pt à considérer
     	quelpts =get(findobj('tag','DecoupeLesPoints'),'value');
     	Avant =str2double(get(findobj('tag','DecoupeAvant'),'String'));
     	Apres =str2double(get(findobj('tag','DecoupeApres'),'String'));
     	nbPtsRef =length(quelpts);
     	totess =0;
     	pbms ='';
     	pbmstot ={' '};
     	CellPts =cell(vg.ess, 1);
     	nblespts(vg.ess) =0;
     	problema =false;
     	probess =1;
     	for U =1:vg.ess
     	  waitbar(Foo, elWb);
        Z =bitand(Z+Zst, Zmax);
        Foo =double(Z)/double(Zmax);
   		  pbms =['E' num2str(U) ' P:'];
     		combien =hdchnl.npoints(canref,U);
     		if combien
   				pppts =quelpts;
   				for V =nbPtsRef:-1:1
   				  if pppts(V) > combien
   				    % Comme on affiche le max(points) alors quelpts peut être > que nb de point d'un canal donné
   				    pbms =[pbms num2str(pppts(V)) '-'];
   				    pppts(V) =[];
   				    problema =true;
   				  elseif ptchnl.Dato(pppts(V),hdchnl.point(canref,U),2) == -1
   				    % On enlève les points bidons
              pbms =[pbms num2str(pppts(V)) '-'];
              pppts(V) =[];
              problema =true;
   				  elseif ptchnl.Dato(pppts(V),hdchnl.point(canref,U),1) < 1
   				    % On enlève les points nulle
              pbms =[pbms num2str(pppts(V)) '-'];
              pppts(V) =[];
              problema =true;
   				  end
   				end
   		    CellPts{U} =pppts;
   				nblespts(U) =length(pppts);
     		else
     			pbms =[pbms num2str(quelpts) '*'];
     			problema =true;
     		end  % if combien
     		if problema
     		  pbmstot{probess} =pbms;
     		  probess =probess+1;
     		  problema =false;
     		end
     	end  % for U =1:vg.ess
      totess =sum(nblespts(:));
     	if length(pbmstot{1}) > 1
     		warndlg(['Les essais suivants ont des points manquant ' pbmstot], 'Nombre de point inégaux');
     	end
     	VvsN(vg.ess) =0;
     	yen_ati =(nblespts ~= 0);
     	waitbar(Foo, elWb, 'Ré-organisation des variables et catégories');
      if totess
        % Création d'un objet VgFichier pour garder une copie lors des travaux
        Vvg =vg.copie();
        % "au début" On ajoute les canaux utiles à la fin puis,
        % on enlèvera ceux du début rendu inutiles "à la fin"      :-0
        hdchnl.duplic(Can);
        vg.nad =vg.nad+nombre;
        hdchnl.ajoutess(totess-vg.ess);
        vg.ess =totess;
        % Initialisation d'un canal "vide" avec le bon nombre d'essai
        Yy =CDtchnl();
        Yy.Nom ='Motte';
        Yy.Dato.(Yy.Nom)(100,vg.ess) =0;
        % Création d'un nouveau NIVEAU et ses catégories
        nouvcat ='decoup-Canal: ';
        vg.niveau =vg.niveau+1;
        catego.Dato(1,vg.niveau,1).nom =nouvcat;
        liste0 =zeros(vg.ess,1);
        catego.Dato(1,vg.niveau,1).ess =liste0;
        catego.Dato(1,vg.niveau,1).ncat =0;
        catego.Dato(1,vg.niveau,1).ness =0;
        eee =1;
        dpt =1;
        aa(vg.ess) =0;
        for T =1:Vvg.ess
       	  waitbar(Foo, elWb);
          Z =bitand(Z+Zst, Zmax);
          Foo =double(Z)/double(Zmax);
          if yen_ati(T)
            catego.Dato(1,vg.niveau,1).ncat =catego.Dato(1,vg.niveau,1).ncat+1;
            catego.Dato(2,vg.niveau,eee).nom =['Essai-' num2str(T)];
            catego.Dato(2,vg.niveau,eee).ess =liste0;
            catego.Dato(2,vg.niveau,eee).ess(dpt:dpt+nblespts(T)-1) =1;
            catego.Dato(2,vg.niveau,eee).ncat =nblespts(T);
            aa(dpt:dpt+nblespts(T)-1) =T;
            dpt =dpt+nblespts(T);
            eee =eee+1;
          end
          VvsN(T) =sum(yen_ati(1:T));
        end
      else
        delete(elWb);
      	obj.terminus();
        return;
      end
      waitbar(Foo, elWb, 'Découpage, veuillez patienter...');
      Xx =CDtchnl();
      for ii =1:nombre
        Ncan =Vvg.nad+ii;  % Nouveau canal
        Vcan =Can(ii);     % Vieux canal
        curess =1;
        lenom =['Dec-' deblank(hdchnl.adname{Vcan})];
        hdchnl.adname{Ncan} =lenom;
        Ofich.getcanal(Xx, Vcan);
        for jj =1:Vvg.ess
          if yen_ati(jj)
            Rv =hdchnl.rate(Vcan,jj);
            pavant =round(Avant*Rv);
            papres =round(Apres*Rv-1);
          	smpl =pavant+papres;
            dernier =hdchnl.nsmpls(Vcan,jj);
            pp =ptchnl.Dato(CellPts{jj},hdchnl.point(canref, jj), 1);
            % Si on a pas la même fréquence que le canal ref
            Rref =hdchnl.rate(canref,jj);
            if ~(Rref == Rv)
              pp =round((Rv/Rref)*(pp+Rref*(hdchnl.frontcut(canref,jj)-hdchnl.frontcut(Vcan,jj))));
            end
            elpp =[(pp-pavant)+1 (pp+papres)];
            for kk =1:length(pp)
     	        waitbar(Foo, elWb);
              Z =bitand(Z+Zst, Zmax);
              Foo =double(Z)/double(Zmax);
              if (elpp(kk,1) > dernier)
              	Yy.Dato.(Yy.Nom)(1:smpl,curess) =Xx.Dato.(Xx.Nom)(dernier,jj);
              elseif (elpp(kk,2) < 1)
              	Yy.Dato.(Yy.Nom)(1:smpl,curess) =Xx.Dato.(Xx.Nom)(1,jj);
              elseif (elpp(kk,1) < 1) & elpp(kk,2) > dernier
                manque =abs(elpp(kk,1)-1)+1;
                Yy.Dato.(Yy.Nom)(1:manque,curess) =Xx.Dato.(Xx.Nom)(1,jj);
                arret =elpp(kk,2)-dernier;
              	Yy.Dato.(Yy.Nom)(manque:smpl-arret,curess) =Xx.Dato.(Xx.Nom)(1:dernier,jj);
              	Yy.Dato.(Yy.Nom)(smpl-arret+1:smpl,curess) =Xx.Dato.(Xx.Nom)(dernier,jj);
              elseif (elpp(kk,1) < 1)
                manque =abs(elpp(kk,1)-1)+1;
                Yy.Dato.(Yy.Nom)(1:manque,curess) =Xx.Dato.(Xx.Nom)(1,jj);
                Yy.Dato.(Yy.Nom)(manque:smpl,curess) =Xx.Dato.(Xx.Nom)(1:elpp(kk,2),jj);
              elseif elpp(kk,2) > dernier
                arret =elpp(kk,2)-dernier;
              	Yy.Dato.(Yy.Nom)(1:smpl-arret,curess) =Xx.Dato.(Xx.Nom)(elpp(kk,1):dernier,jj);
              	Yy.Dato.(Yy.Nom)(smpl-arret+1:smpl,curess) =Xx.Dato.(Xx.Nom)(dernier,jj);
              else
                Yy.Dato.(Yy.Nom)(1:smpl,curess) =Xx.Dato.(Xx.Nom)(elpp(kk,1):elpp(kk,2),jj);
              end
              hdchnl.nsmpls(Ncan,curess) =smpl;
              hdchnl.rate(Ncan,curess) =Rv;
              hdchnl.sweeptime(Ncan,curess) =smpl/hdchnl.rate(Ncan,curess);
              hdchnl.max(Ncan,curess) =max(Yy.Dato.(Yy.Nom)(1:smpl,curess));
              hdchnl.min(Ncan,curess) =min(Yy.Dato.(Yy.Nom)(1:smpl,curess));
              if hdchnl.npoints(Vcan,jj)
              	tmp =(ptchnl.Dato(1:hdchnl.npoints(Vcan,jj),hdchnl.point(Vcan,jj),1) >= elpp(kk,1)) &...
              	     (ptchnl.Dato(1:hdchnl.npoints(Vcan,jj),hdchnl.point(Vcan,jj),1) <= elpp(kk,2));
              	NPt =1;
              	for U =1:length(tmp)
              		if tmp(U)
              			temps =ptchnl.Dato(U,hdchnl.point(Vcan,jj),1)-elpp(kk,1)+1;
              			ttyp =ptchnl.Dato(U,hdchnl.point(Vcan,jj),2);
              			Ofich.marqettyp(Ncan,curess,NPt,temps,ttyp);
              			NPt =NPt+1;
              		end
              	end
              end
              if garderfcut
              	hdchnl.frontcut(Ncan,curess) =(pp(kk)/Rv)+hdchnl.frontcut(Vcan,jj)-Avant;
              else
              	hdchnl.frontcut(Ncan,curess) =0;
              end
              curess =curess+1;
            end
          end  % if yen_ati(jj)
        end  % for jj =1:Vvg.ess
        if size(Yy.Dato.(Yy.Nom),2) > vg.ess
          Yy.Dato.(Yy.Nom)(:,vg.ess+1:end) =[];
        end
        Ofich.setcanal(Yy, Ncan);
     	  waitbar(Foo, elWb);
        Z =bitand(Z+Zst, Zmax);
        Foo =double(Z)/double(Zmax);
      end
      if size(hdchnl.rate,2) > vg.ess
        hdchnl.sweeptime(:,vg.ess+1:end) =[];
        hdchnl.rate(:,vg.ess+1:end) =[];
        hdchnl.nsmpls(:,vg.ess+1:end) =[];
        hdchnl.max(:,vg.ess+1:end) =[];
        hdchnl.min(:,vg.ess+1:end) =[];
        hdchnl.npoints(:,vg.ess+1:end) =[];
        hdchnl.point(:,vg.ess+1:end) =[];
        hdchnl.frontcut(:,vg.ess+1:end) =[];
        hdchnl.comment(:,vg.ess+1:end) =[];
      end
      if length(hdchnl.numstim) > vg.ess
        hdchnl.numstim(vg.ess:end) =[];
      end
      % COMMENTAIRES
      waitbar(Foo, elWb, 'Modification des commentaires...');
      for ii =1:nombre
     	  waitbar(Foo, elWb);
        Z =bitand(Z+Zst, Zmax);
        Foo =double(Z)/double(Zmax);
        CualEs =0;
        for jj =1:vg.ess
          CualEs =CualEs+1;
          elPunto =CellPts{aa(jj)};
          vc =['Déc. (E' num2str(aa(jj)) ' Pt' num2str(elPunto(CualEs)) ') '  deblank(hdchnl.adname{Can(ii)}) '//'];
          if CualEs == length(elPunto)
            CualEs =0;
          end
          hdchnl.comment{Vvg.nad+ii, jj} =vc;
        end
      end
      % MISE À JOUR DES CATÉGORIES
      waitbar(Foo, elWb, 'Modification des catégories...');
      for U =1:vg.niveau-1
     	  waitbar(Foo, elWb);
        Z =bitand(Z+Zst, Zmax);
        Foo =double(Z)/double(Zmax);
      	quien =zeros(vg.ess,1);
      	for V =1:catego.Dato(1,U,1).ncat
      		qq =find(catego.Dato(2,U,V).ess);
      		oeuf =zeros(vg.ess,1);
      		while ~isempty(qq)
      			ss =find(aa == qq(1));
      			if ~isempty(ss)
      				oeuf(ss) =1;
      			end
      			qq(1) =[];
      		end
      		quien =(quien | oeuf);
      		catego.Dato(2,U,V).ess =oeuf;
          catego.Dato(2,U,V).ncat =sum(oeuf);
        end
        catego.Dato(1,U,1).ess =~quien;
        catego.Dato(1,U,1).ness =sum(~quien);
      end
    	quien =zeros(vg.ess,1);
    	for U =1:catego.Dato(1,vg.niveau,1).ncat
     	  waitbar(Foo, elWb);
        Z =bitand(Z+uint8(5)*Zst, Zmax);
        Foo =double(Z)/double(Zmax);
        quien =(quien | catego.Dato(2,vg.niveau,U).ess);
        catego.Dato(2,vg.niveau,U).ncat =sum(catego.Dato(2,vg.niveau,U).ess);
      end
      catego.Dato(1,vg.niveau,1).ess =~quien;
      catego.Dato(1,vg.niveau,1).ness =sum(~quien);
      vg.sauve=1;
      vg.valeur=0;
      Z =bitand(Z+uint8(5)*Zst, Zmax);
      Foo =double(Z)/double(Zmax);
   	  waitbar(Foo, elWb);
   	  Ofich.suppcan(1:Vvg.nad);
     	delete(elWb);
      delete(Vvg);
      Ofich.sauversous();
      lafig=findobj('tag','DecoupeLafig');
      delete(lafig);
      gaglobal('editessnom');
    end

    %--------------------------------------------
    % callback pour le choix du canal qui donnera
    % les points de référence.
    %------------------------------
    function quelcan(obj,src,event)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      canref =get(findobj('tag','DecoupeCanalRef'),'value');
      p ={'1'};
      maxpoint =max(hdchnl.npoints(canref,:));
      for U =2:maxpoint
        p{end+1} =num2str(U);
      end
      set(findobj('tag','DecoupeLesPoints'), 'string',p, 'value',1);
      obj.eltoupts();
    end

    %------------------------------------------------
    % Callback pour gérer le bouton "Tous" les canaux
    %-----------------------------
    function toucan(obj,src,event)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      ss =get(findobj('tag','DecoupeTouCan'),'value');
  	  if ss
  		  set(findobj('tag','DecoupeCanaux'),'value',1:vg.nad,'enable','off');
  	  else
  		  set(findobj('tag','DecoupeCanaux'),'enable','on');
  	  end
    end

    %------------------------------------------------
    % Callback pour gérer le bouton "Tous" les points
    %-----------------------------
    function toupts(obj,src,event)
      obj.eltoupts();
    end

    %--------------------------------------------
    % Callback pour choisir le type de découpage.
    % Pour l'instant, un seul type, alors pas de choix.
    %----------------------------
    function choix(obj,src,event)
      obj.cacher();
      bouton =get(findobj('tag','DecoupeQueFaire'),'Value');
      switch(bouton)
      case 1
     	  set(findobj('tag','DecoupeTextCanalRef'),'visible','on');
    	  set(findobj('tag','DecoupeCanalRef'),'visible','on');
      	set(findobj('tag','DecoupeTousPoints'),'visible','on');
      	set(findobj('tag','DecoupeLesPoints'),'visible','on');
        set(findobj('tag','DecoupeTextTemps'),'visible','on');
        set(findobj('tag','DecoupeTextAvant'),'visible','on');
        set(findobj('tag','DecoupeTextApres'),'visible','on');
        set(findobj('tag','DecoupeAvant'),'visible','on');
        set(findobj('tag','DecoupeApres'),'visible','on');
      case 2
      	set(findobj('tag','DecoupeTextInterUtil'),'visible','on');
        set(findobj('tag','DecoupeTextDebut'),'visible','on');
        set(findobj('tag','DecoupeDebut'),'visible','on');
        set(findobj('tag','DecoupeTextFin'),'visible','on');
        set(findobj('tag','DecoupeFin'),'visible','on');
        set(findobj('tag','DecoupeTextPrecise2'),'visible','on');
        set(findobj('tag','DecoupePrecise3'),'visible','on');
        set(findobj('tag','DecoupeTextTemps'),'visible','on');
        set(findobj('tag','DecoupeTextAvant'),'visible','on');
        set(findobj('tag','DecoupeTextApres'),'visible','on');
        set(findobj('tag','DecoupeAvant'),'visible','on');
        set(findobj('tag','DecoupeApres'),'visible','on');
      case 3
      	set(findobj('tag','DecoupeTextInterUtil'),'visible','on');
        set(findobj('tag','DecoupeTextDebut'),'visible','on');
        set(findobj('tag','DecoupeDebut'),'visible','on');
        set(findobj('tag','DecoupeTextFin'),'visible','on');
        set(findobj('tag','DecoupeFin'),'visible','on');
        set(findobj('tag','DecoupeTextPrecise3'),'visible','on');
        set(findobj('tag','DecoupePrecise4'),'visible','on');
      end
    end

  end  % methods

  methods (Static)

    %-----------------------------------------
    % toggle le radiobutton pour utiliser tous
    % les points ou seulement ceux sélectionnés
    %------------------
    function eltoupts()
      ss =get(findobj('tag','DecoupeTousPoints'),'value');
  	  if ss
  	  	pp =get(findobj('tag','DecoupeLesPoints'),'string');
  		  set(findobj('tag','DecoupeLesPoints'),'value',1:length(pp),'enable','off');
  	  else
  		  set(findobj('tag','DecoupeLesPoints'),'enable','on');
  	  end
    end

    %--------------------------------------------------------
    % Lors d'un changement de sélection de type de découpage,
    % on masque tout avec cette fonction, puis on "démasque"
    % les composante utiles en fonction du choix.
    %----------------
    function cacher()
    	set(findobj('tag','DecoupeTextCanalRef'),'visible','off');
    	set(findobj('tag','DecoupeCanalRef'),'visible','off');
    	set(findobj('tag','DecoupeTousPoints'),'visible','off');
    	set(findobj('tag','DecoupeLesPoints'),'visible','off');
    	set(findobj('tag','DecoupeTextInterUtil'),'visible','off');
      set(findobj('tag','DecoupeTextDebut'),'visible','off');
      set(findobj('tag','DecoupeDebut'),'visible','off');
      set(findobj('tag','DecoupeTextFin'),'visible','off');
      set(findobj('tag','DecoupeFin'),'visible','off');
      set(findobj('tag','DecoupeTextPrecise2'),'visible','off');
      set(findobj('tag','DecoupeTextPrecise3'),'visible','off');
      set(findobj('tag','DecoupePrecise2'),'visible','off');
      set(findobj('tag','DecoupePrecise3'),'visible','off');
      set(findobj('tag','DecoupeTextTemps'),'visible','off');
      set(findobj('tag','DecoupeTextAvant'),'visible','off');
      set(findobj('tag','DecoupeTextApres'),'visible','off');
      set(findobj('tag','DecoupeAvant'),'visible','off');
      set(findobj('tag','DecoupeApres'),'visible','off');
    end

    %-------------------------------
    % N'est plus utilisé, 5 oct 2009
    %---------------
    function autre()
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      ptchnl =Ofich.Ptchnl;
      catego =Ofich.Catego;
      nombre =length(Can);
      espass =[];
      % Comptabilisation des essais
      switch afaire
      case 1  % points marqués
      	canref =get(findobj('tag','DecoupeCanalRef'),'value');
      	totess =0;
      	pbms ={' '};
      	for U =1:vg.ess
      		if hdchnl.npoints(canref,U) > 1
      			totess =totess+hdchnl.npoints(canref,U)-1;
      		else
      			pbms{1} =[pbms{1} ' ' num2str(U)];
      		end
      	end
      	if length(pbms{1}) > 1
      		warndlg(['Les essais suivants n''ont pas assez de points:' pbms],'Découpage par points');
        	return;
      	end
      case 2 % intervale de temps
      	tiempo =str2double(get(findobj('tag','DecoupePrecise2'),'string'));
      	totess =0;
      	for U =1:vg.ess
      		if hdchnl.sweeptime(1,U) >= tiempo
      			totess =totess+floor(hdchnl.sweeptime(1,U)/tiempo);
      		else
      			totess =totess+1;
      		end
      	end
      case 3 % nombre d'intervale
      	nbi =str2double(get(findobj('tag','DecoupePrecise3'),'string'));
      	totess =nbi*vg.ess;
      end
      % Création d'un objet VgFichier pour garder une copie lors des travaux
      Vvg =vg.copie();
      hdchnl.duplic(Can);
      vg.nad =vg.nad+length(Can);
      vg.ess =totess;
      Xx =CDtchnl();
      for ii =1:nombre
        nouvcat =['decoup-Canal: ' hdchnl.adname{Can(ii)}];
        vg.niveau =vg.niveau+1;
        catego(1,vg.niveau,1).nom =nouvcat;
        liste0(1:vg.ess) =0;
        catego(1,vg.niveau,1).ess =liste0;
        catego(1,vg.niveau,1).ncat =0;
        catego(1,vg.niveau,1).ness =0;
        curess =1;
        Ofich.getcanal(Can(ii),Xx);
        for jj=1:Vvg.ess
          debIntTexte =get(findobj('tag','DecoupeDebut'),'String');
          debinterv =ptchnl.valeurDePoint(debIntTexte, Can(ii), jj);
          switch(afaire)
          %-----
          case 1     % DÉCOUPAGE PAR POINTS MARQUÉS
            fininterv =hdchnl.nsmpls(Can(ii),jj);
            avant =str2num(get(findobj('tag','DecoupeAvant'),'String'));
            avant =round(avant*hdchnl.rate(Can(ii),jj));
            apres =str2num(get(findobj('tag','DecoupeApres'),'String'));
            apres =round(apres*hdchnl.rate(Can(ii),jj));
            lespts =ptchnl(1:hdchnl.npoints(Can(ii),jj),hdchnl.point(Can(ii),jj),1);
            lespts =sort(lespts);
          %-----
          case 2     % DÉCOUPAGE PAR INTERVALLES DE TEMPS
            finIntTexte =get(findobj('tag','DecoupeFin'),'String');
            fininterv =ptchnl.valeurDePoint(finIntTexte, Can(ii), jj);
            if fininterv < debinterv
              aaa =debinterv;
              debinterv =fininterv;
              fininterv =aaa;
            end
            avant =str2num(get(findobj('tag','DecoupeAvant'),'String'));
            avant =round(avant*hdchnl.rate(Can(ii),jj));
            apres =str2num(get(findobj('tag','DecoupeApres'),'String'));
            apres =round(apres*hdchnl.rate(Can(ii),jj));
            lespts =str2num(get(findobj('tag','DecoupePrecise2'),'String'));
            lespts=lespts*hdchnl.rate(Can(ii),jj);
            lespts=[debinterv+lespts:lespts:fininterv];
          case 3     % DÉCOUPAGE INTERVALLES FIXES
            finIntTexte =get(findobj('tag','DecoupeFin'),'String');
            fininterv =ptchnl.valeurDePoint(finIntTexte, Can(ii), jj);
            if fininterv<debinterv
              aaa=debinterv;
              debinterv=fininterv;
              fininterv=aaa;
            end
            nbpts=str2num(get(findobj('tag','DecoupePrecise3'),'String'));
            lespts=floor((fininterv-debinterv+1)/nbpts);
            avant=floor((fininterv-debinterv+1)/nbpts/2);
            apres=avant;
            lespts=[debinterv+avant-1:lespts:fininterv];
          end
          catego(1,vg.niveau,1).ncat=catego(1,vg.niveau,1).ncat+1;
          catego(2,vg.niveau,jj).nom=['Essai-' num2str(jj)];
          catego(2,vg.niveau,jj).ess=liste0;
          catego(2,vg.niveau,jj).ncat=0;
          dernier=hdchnl.nsmpls(Can(ii),jj);
          smpl=avant+apres;
          lenom=['Dec-' deblank(hdchnl.adname{vg.nad})];
          hdchnl.adname{vg.nad} =lenom;
          for kk=1:length(lespts)
            if (lespts(kk)<debinterv) || (lespts(kk)>fininterv)
              continue;
            end
            if (lespts(kk)-avant)<0
              manque=avant-lespts(kk);
              Yy(1:manque,ii,curess)=Xx.Dato(1,ii,jj);
              Yy(manque+1:smpl,ii,curess)=Xx.Dato(1:smpl-manque,ii,jj);
            elseif (lespts(kk)+apres)>dernier
              manque=lespts(kk)+apres-dernier;
              Yy(smpl-manque+1:smpl,ii,curess)=Xx.Dato(dernier,ii,jj);
              deou=lespts(kk)-avant;
              Yy(1:smpl-manque,ii,curess)=Xx.Dato(deou+1:deou+smpl-manque,ii,jj);
            else
              deou=lespts(kk)-avant;
              Yy(1:smpl,ii,curess)=Xx.Dato(deou+1:deou+smpl,ii,jj);
            end
            hdchnl.nsmpls(vg.nad,curess)=smpl;
            hdchnl.rate(vg.nad,curess)=hdchnl.rate(vg.nad,1);
            hdchnl.sweeptime(vg.nad,curess)=smpl/hdchnl.rate(vg.nad,1);
            catego(2,vg.niveau,jj).ess(curess)=1;
            catego(2,vg.niveau,jj).ncat=catego(2,vg.niveau,jj).ncat+1;
            curess=curess+1;
          end
        end
        if (ii == 1) && (curess-1 < size(hdchnl.nsmpls,2))
          if curess-1>Vvg.ess
            hdchnl.nsmpls(:,curess:end)=[];
            hdchnl.rate(:,curess:end)=[];
            hdchnl.sweeptime(:,curess:end)=[];
          else
            hdchnl.nsmpls(:,Vvg.ess+1:end)=[];
            hdchnl.rate(:,Vvg.ess+1:end)=[];
            hdchnl.sweeptime(:,Vvg.ess+1:end)=[];
          end
        end
      end
      vg.ess=size(hdchnl.nsmpls,2);
      dimY=size(Yy);
      % CANAUX VIDES PAR L'AJOUT D'ESSAIS
      hdchnl.nomstim(1:Vvg.nad,Vvg.ess+1:vg.ess) ={espass};
      hdchnl.nomstim(Vvg.nad+1:size(hdchnl.rate,1),1:vg.ess) ={espass};
      hdchnl.sweeptime(1:Vvg.nad,Vvg.ess+1:end)=1;
      hdchnl.rate(1:Vvg.nad,Vvg.ess+1:end)=1;
      hdchnl.nsmpls(1:Vvg.nad,Vvg.ess+1:end)=1;
      % ON FINALISE LES NOUVEAUX CANAUX
      hdchnl.npoints(Vvg.nad+1:end,1:vg.ess)=0;
      hdchnl.point(Vvg.nad+1:end,1:vg.ess)=0;
      hdchnl.numero(Vvg.nad+1:end,1:vg.ess)=0;
      hdchnl.spcode(Vvg.nad+1:end,1:vg.ess)=0;
      hdchnl.usercode(Vvg.nad+1:end,1:vg.ess)=0;
      hdchnl.frontcut(Vvg.nad+1:end,1:vg.ess)=0;
      if size(hdchnl.npoints,2)>vg.ess
        hdchnl.npoints(:,vg.ess+1:end)=[];
        hdchnl.point(:,vg.ess+1:end)=[];
        hdchnl.nomstim =hdchnl.nomstim(:,1:vg.ess);
        hdchnl.numero(:,vg.ess+1:end)=[];
        hdchnl.spcode(:,vg.ess+1:end)=[];
        hdchnl.usercode(:,vg.ess+1:end)=[];
        hdchnl.frontcut(:,vg.ess+1:end)=[];
      end
      % GESTION DES COMMENTAIRES
      for ii =1:Vvg.nad
        nc = ['Vide.' deblank(hdchnl.adname{ii})];
        vc = [deblank(hdchnl.adname{ii}) '-Vide'];
        hdchnl.adname{ii} =vc;
        for jj = Vvg.ess+1:vg.ess
          hdchnl.comment{ii, jj} =nc;
        end
      end
  
        dtchnl(1:dimY(1),Vvg.nad+1:Vvg.nad+dimY(2),1:dimY(3))=Yy;
        % COMMENTAIRES
        for ii=1:nombre
          vc = ['Découp.' deblank(hdchnl.adname{Vvg.nad+ii}) '//'];
          for jj=1:vg.ess
            hdchnl.comment{Vvg.nad+ii, jj} =vc;
          end
        end
  
      % MISE À JOUR DES CATÉGORIES
      nouvess=vg.ess-Vvg.ess;
      totcat=size(catego,2);
      for ii=1:totcat
        if ii <= totcat-nombre
          catego(1,ii,1).ess(end+1:end+nouvess)=1;
          catego(1,ii,1).ness=catego(1,ii,1).ness+nouvess;
          for jj=1:catego(1,ii,1).ncat
            catego(2,ii,jj).ess(end+1:end+nouvess)=0;
          end
        else
          if length(catego(1,ii,1).ess)<vg.ess
            catego(1,ii,1).ess(end+1:vg.ess)=0;
          else
            catego(1,ii,1).ess(vg.ess+1:end)=[];
          end
          lesess=0;
          for jj=1:catego(1,ii,1).ncat
            if length(catego(2,ii,jj).ess)<vg.ess
              catego(2,ii,jj).ess(end+1:vg.ess)=0;
            else
              catego(2,ii,jj).ess(vg.ess+1:end)=[];
            end
            lesess=lesess+sum(catego(2,ii,jj).ess(:));
          end
          catego(1,ii,1).ness=vg.ess-lesess;
        end
      end
      vg.sauve=1;
      vg.valeur=0;
     	Ofich.suppcan(1:Vvg.nad);
      delete(Vvg);
      Ofich.sauversous();
      lafig=findobj('tag','DecoupeLafig');
      delete(lafig);
      gaglobal('editessnom');
    end

  end  % methods (Static)
end  % classdef
