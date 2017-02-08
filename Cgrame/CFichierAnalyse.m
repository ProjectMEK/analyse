%
% Classe CFichierAnalyse
%
% Gestion et description pour un fichier de format Analyse.
% Héritera de la classe communs\CFichier
%
% MEK - septembre 2009
%
classdef CFichierAnalyse < CFichier

  properties
    Tag ='';
    couleur =[];
    Lestri =[];
    Gr =[];
    Tpchnl =[];
    MnuFid =[];
    ModeXY =[];
  end

  methods

    %-------------
    %  CONSTRUCTOR
    %------------------------------------
    function obj =CFichierAnalyse(letype)
      obj =obj@CFichier();
      obj.Vg =CVgAnalyse();
      obj.Vg.itype =letype;
      obj.Tpchnl =CTpchnlAnalyse(obj);
      obj.Gr =CGrVar();
    end

    %-----------
    % DESTRUCTOR
    %-------------------
    function delete(obj)
      delete(obj.Tpchnl);
      obj.Tpchnl =[];
      delete(obj.Gr);
      obj.Gr =[];
      if ~isempty(obj.ModeXY)
        delete(obj.ModeXY);
        obj.ModeXY =[];
      end
      if ~isempty(obj.MnuFid)
      	delete(obj.MnuFid);
      	obj.MnuFid =[];
      end
    end

    %----------------------------------------
    % Ici on met en veille les objets propres
    % à ce fichier (avant d'afficher un autre fichier)
    %---------------------
    function AuSuivant(tO)
      if tO.Vg.xy
        tO.ModeXY.AuRepos();
      end
    end

    %------------------------------------------------
    % fonction pour faire une mise à jour de la liste
    % des essais à afficher avec une catégorie
    %-------------------
    function editess(tO)
      % on reconstruit la liste des essai avec nom de catégo
      tO.lesess();
      vg =tO.Vg;
      vg.tri =max(1, min(vg.tri, vg.ess));
      hA =CAnalyse.getInstance();
      % MAJ de la listbox
      hA.OFig.essai.setValue(1);
      hA.OFig.essai.setString(vg.lesess);
      hA.OFig.essai.setValue(vg.tri);
      hA.OFig.essai.updateprop({'Max' vg.ess+1});
      if vg.xy
        tO.ModeXY.voircan();
      else
        hA.OFig.affiche();
      end
    end

    %------------------------------------------------
    % fonction pour faire une mise à jour de la liste
    % des catégories à afficher.
    %---------------------
    function editcats(obj)
      hA =CAnalyse.getInstance();
      hD =hA.OFig;
      vg =obj.Vg;
  	  obj.lescats();
      if vg.niveau & ~isempty(vg.lescats)
        set(findobj('tag', 'IpTextCats'),'visible','On');
        hD.nivo.setValue(1);
        hD.nivo.setString(vg.lescats);
    	  if ~isempty(find(vg.cat > length(vg.lescats)))
    	  	vg.cat =1;
    	  end
    	  hD.nivo.setValue(vg.cat);
        hD.nivo.updateprop({'Visible' 'On' 'Max' length(vg.lescats)+1});
        set(findobj('tag', 'IpCatsPermute'),'Visible','On','String',num2str(vg.permute));
      else
        set(findobj('tag', 'IpTextCats'),'visible','Off');
        hD.nivo.updateprop({'Visible' 'Off'});
        set(findobj('tag', 'IpCatsPermute'),'Visible','Off');
      end
    end

    %------------------------------------------------
    % fonction pour faire une mise à jour de la liste
    % des canaux à afficher ainsi que la liste des canaux
    % pour le marquage manuel.
    %--------------------
    function editcan(obj)
      vg =obj.Vg;
      hdchnl =obj.Hdchnl;
      vg.can =max(1, min(vg.can, vg.nad));
      lesnoms ={'Tous'};
      lesnoms(2:vg.nad+1) =hdchnl.adname;
      hA =CAnalyse.getInstance();
      hD =hA.OFig;
      hD.canopts.setString(lesnoms);
      hD.cano.setValue(vg.can);
      hD.cano.setString(hdchnl.adname);
      elTexto ={'Max' vg.nad+1};
      hD.cano.updateprop(elTexto);
    end

    %------------------------------------
    % Enlever/effacer les canaux "lescan"
    %----------------------------
    function suppcan(obj, lescan)
      hA =CAnalyse.getInstance();
      hdchnl =obj.Hdchnl;
      vg =obj.Vg;
      tpchnl =obj.Tpchnl;
      set(hA.OFig.fig,'Pointer','custom');
      nbcan =length(lescan);
      if vg.nad > 1 && nbcan < vg.nad
    		obj.delcan(lescan);            % on vide les datas (dtchnl)
        hdchnl.SuppCan(lescan);        % on vide hdchnl
        vg.nad =vg.nad-nbcan;
        vg.can =lescan(1);
        vg.sauve =1;
        obj.editcan();
        if ~isempty(obj.ModeXY)
          obj.ModeXY.delcan(lescan);
        end
        gaglobal('delcan',lescan);
      end
      set(hA.OFig.fig,'Pointer','arrow');
    end

    %------------------------------------
    % Enlever/effacer les essais "lesess"
    %---------------------------
    function suppess(obj,lesess)
      hdchnl =obj.Hdchnl;
      catego =obj.Catego;
      vg =obj.Vg;
      set(findobj('Type','figure','tag', 'IpTraitement'),'Pointer','custom')
      nbtri =length(lesess);
      if vg.ess > 1 && nbtri < vg.ess
      	obj.deless(lesess);
        hdchnl.sweeptime(:,lesess)=[];
        hdchnl.rate(:,lesess)=[];
        hdchnl.nsmpls(:,lesess)=[];
        hdchnl.max(:,lesess) =[];
        hdchnl.min(:,lesess) =[];
        hdchnl.npoints(:,lesess)=[];
        hdchnl.point(:,lesess)=[];
        hdchnl.frontcut(:,lesess)=[];
        hdchnl.numstim(lesess) =[];
        tmp =[1:vg.ess];
        tmp(lesess) =[];
        hdchnl.comment =hdchnl.comment(:,tmp);
        catego.EnleveEssai(lesess);
        vg.ess =vg.ess-nbtri;
        if lesess(1) > vg.ess
          vg.tri =1;
        else
          vg.tri =lesess(1);
        end
        vg.sauve =1;
        obj.editess();
      end
      set(findobj('Type','figure','tag', 'IpTraitement'),'Pointer','arrow')
    end
 
    %-------------------
    % Passage au mode XY
    %-------------------
    function initxy(obj)
      if isempty(obj.ModeXY)
        obj.ModeXY =CModeXY(obj);
      end
      obj.ModeXY.YetiLa();
    end

    %-------------------------------------------------------------------------
    % lors d'ajout de fichier, il faut s'assurer de créer les champs approprié
    % si besoin est, on fait les modif ici lors de l'ouverture de fichier
    %---------------------
    function majchamp(obj)
      OA =CAnalyse.getInstance();
      vg =obj.Vg;
      hdchnl =obj.Hdchnl;
      hdchnl.VerifSize(vg.nad, vg.ess);
      obj.initpoint();
      vg.can =1;
      vg.tri =1;
      vg.valeur =0;
      obj.couleur =OA.couleur{vg.ligne+1};
      %___________________________________________
      % on s'assure que itype/otype sont valides
      %-------------------------------------------
      if isempty(vg.itype) | isempty(CEFich(vg.itype))
        vg.itype =CEFich('analyse');
      end
      if isempty(vg.otype) | vg.otype > 7.3
        vg.otype =7;
      end
      %_____________
      % Affichage XY
      %-------------
      if length(vg.x) > length(vg.y)+1
        vg.x(length(vg.y)+1:end) =[];
      end
      for ii =length(vg.y):-1:1
        if vg.y(ii) == 0 || vg.x(ii) == 0 || vg.y(ii) > vg.nad ||...
           vg.x(ii) > vg.nad || hdchnl.rate(vg.x(ii),1) < hdchnl.rate(vg.y(ii),1)
          vg.y(ii) =[];
          vg.x(ii) =[];
        end
      end
      enbas =min(hdchnl.frontcut(:));
      enhaut =max(hdchnl.sweeptime(:));
      if vg.filtpmin < enbas || vg.filtpmin > enhaut
        vg.filtpmin = enbas;
      end
      if vg.filtpmax < enbas || vg.filtpmax > enhaut
        vg.filtpmax = enhaut;
      end
      for i=length(vg.choixy):-1:1
        if vg.choixy(i)>length(vg.y); vg.choixy(i)=[];
        else ; break;
        end
      end
      if vg.deroul(1) > 0.99; vg.deroul(1) = 0.01;
      elseif vg.deroul(2) > 0.99; vg.deroul(2) = 0.1; end
      %-------------------------------------------%
      % Il faut que: SWEEPTIME = NBSAMPLES / RATE %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      lerate =max(hdchnl.rate(:));
      a =find(hdchnl.nsmpls(:) < 1);
      if length(a)
        hdchnl.nsmpls(a)=0;
      end
      b = find(hdchnl.rate(:) < 0.0001);
      if length(b)
        hdchnl.rate(b)=lerate;
      end
      %-------------------------------------------%
      % Depuis la version 7.04.16: HDCHNL.MAX/MIN %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if vg.laver ~= OA.Fic.laver
        obj.majMinMax();
      end
    end

    %------------------------------------
    % Mise à jour des champs .min et .max
    %----------------------------
    function majMinMax(obj, can)
      OA =CAnalyse.getInstance();
      vg =obj.Vg;
      hdchnl =obj.Hdchnl;
      dd =findobj('tag','WaitBarLecture');
      TextLocal ='Mise à jour de HDCHNL, veuillez patienter';
      delwb =false;
      t_ou =single(0.001);
      if isempty(dd)
        delwb =true;
        dd =laWaitbar(t_ou, TextLocal, 'C', 'C', gcf);
      else
        waitbar(t_ou, dd, TextLocal);
      end
      HDt =CDtchnl();
      if nargin == 1
        can =1:vg.nad;
      end
      for C =can
      	obj.getcanal(HDt, C);
      	for E =1:vg.ess
      	  t_ou(:) =(single(C-1)*single(vg.ess)+single(E))/(single(vg.nad)*single(vg.ess));
      		waitbar(t_ou, dd);
      		if hdchnl.nsmpls(C,E) > size(HDt.Dato.(HDt.Nom), 1)
      		  hdchnl.nsmpls(C,E) =size(HDt.Dato.(HDt.Nom), 1);
      		elseif hdchnl.nsmpls(C,E) == 0
      		  hdchnl.nsmpls(C,E) =1;
      		end
          hdchnl.max(C,E) = max(HDt.Dato.(HDt.Nom)(1:hdchnl.nsmpls(C,E), E));
          hdchnl.min(C,E) = min(HDt.Dato.(HDt.Nom)(1:hdchnl.nsmpls(C,E), E));
        end
      end
      if delwb
        delete(dd);
      end
      vg.sauve =true;
      delete(HDt);
    end

    %--------------------------------------------------
    % Sauvegarde les datas sous un autre PATH et/ou NOM
    %----------------------------
    function Cok =sauversous(obj)
      Cok =false;
      OA =CAnalyse.getInstance();
      vg =obj.Vg;
      fic =obj.Info;
      [fname,pname,fndx] = uiputfile({'*.mat','Sauvegarde sous MATLAB V7'});
      if fndx == 0
        return;
      end
      lenom =fullfile(pname, fname);
      if OA.isfichopen(lenom)
        warndlg('Ce fichier est déjà ouvert');
        return;
      end
      fic.foname =lenom;
      fic.finame =fname;
      fic.prenom =pname;
      vg.otype =8-fndx;
      OA.OFig.renommer(obj);
      Cok =obj.sauver();
      if Cok
        set(obj.MnuFid.HMnu, 'Label',fic.finame);
      end
    end

    %--------------------------------------------
    % sauvegarde les datas dans le fichier actuel
    %------------------------
    function Cok =sauver(obj)
    % On sauvegarde le fichier
      Cok =false;
      OA =CAnalyse.getInstance();
      vg =obj.Vg;
      fic =obj.Info;
      if isempty(fic.foname)
        [fname,pname,fndx] = uiputfile({'*.mat','Sauvegarde sous MATLAB V7'});
        if fndx == 0
          return;
        end
        fic.foname =fullfile(pname, fname);
        fic.finame =fname;
        fic.prenom =pname;
        vg.otype =8-fndx;
        OA.OFig.renommer(obj);
      end
      vg.laver =OA.Fic.laver;
      vg.sauve =false;
      vg.valeur =0;
      if ~isempty(obj.ModeXY)
      	obj.ModeXY.sauver();
      end
      obj.ecrigrame();
      OA.fichrecent;
      Cok =true;
    end

    %___________________________________________________________________________
    % Écriture des fichiers en format ANALYSE
    %---------------------------------------------------------------------------
    function ecrigrame(tO)
      % Création d'une WaitBar pour montrer la progression du travail
      hwb =laWaitbar(0.05, 'Conversion de format, soyez patient un ti peu', 'C', 'B', gcf);

      % Afin d'améliorer la vitesse d'écriture (Pour ceux qui travaillent sur des fichiers
      % situés sur les disques réseaux), nous allons sauvegarder local dans un fichier
      % temporaire, puis nous allons copier le fichier à son emplacement final.
      %
      % 3 septembre 2015
      %-------------------------------------------------------------------------
      fichierlocaltmp =fullfile(tempdir(), 'mamoutfumersecher.mat');
      if ~isempty(dir(fichierlocaltmp))
        delete(fichierlocaltmp);
      end

      % on load les variables d'entête
      hdchnl =tO.Hdchnl.databrut();
      vg =tO.Vg.databrut();
      ptchnl =tO.Ptchnl.Dato;
      catego =tO.Catego.Dato;
      tpchnl =tO.Tpchnl.getDato();
      autre =tO.autre;
      fic =tO.Info;

      % LA VERSION -V7 COMPRESSE LES DONNÉES
      % LA VERSION -V7.3 SAUVE EN FORMAT HDF5
      laver ='-V7';

      waitbar(0.15, hwb, 'Copie des entêtes, soyez patient');
      save(fichierlocaltmp, 'vg','hdchnl','ptchnl','tpchnl','catego','autre', laver);

      waitbar(0.35, hwb, 'Sauvegarde des datas, soyez encore patient');
      totcan =vg.nad;
      t_ou =single(0.1);
      for U =1:totcan
      	lenom =hdchnl.cindx{U};
      	A =load(fic.fitmp, lenom);
      	save(fichierlocaltmp, '-Struct', 'A', lenom, '-APPEND');
      	A =[];
      	t_ou(:) =0.35+(single(U)/single(totcan)/2.0);
        waitbar(t_ou, hwb);
      end

      [prenom, aaz, aza] =fileparts(fic.foname);
      BS =strfind(prenom, '\');
      if ~isempty(BS)
        % À cause de la fonction waitbar qui ne veut pas du caractère "\"
        prenom(BS) ='/';
      end
      letitt =sprintf(' Copie dans %s\n soyez patient', prenom);
      waitbar(0.9, hwb, letitt);
      copyfile(fichierlocaltmp, fic.foname, 'f');

      waitbar(0.97, hwb, 'C''est presque fini, j''efface mes traces...');
      delete(fichierlocaltmp);

      delete(hwb);
    end

    %--------------------
    % On ferme le fichier
    %-----------------------
    function Cok =fermer(tO)
      Cok =false;
      vg =tO.Vg;
      if vg.sauve
      	hhfig =findobj('type','figure','tag','IpTraitement');
     	  bouton =CValet.fen3bton('RSVP', {'Le fichier a été Modifié';'Est-ce que vous voulez sauvegarder?'},...
      	                   'Oui', 'Non',hhfig);
        if isempty(bouton)
          return;
        elseif bouton
        	etpuis =tO.sauver();
          if ~ etpuis
              return;
          end
        end
      end
      if ~isempty(vg.multiaff) && vg.multiaff > 0
        tout =vg.multiaff;
        delete(tout);
      end
      Cok =true;
    end

    %---------------------------------
    % retourne la propriété: "couleur"
    %---------------------------
    function ss =get.couleur(tO)
      ss =tO.couleur;
    end

  end  % methods
end  % classdef
