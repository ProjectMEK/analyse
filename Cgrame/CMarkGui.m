%
% Classe  CMarkGui
%
% Gestion du GUI GuiMark, ici on va répondre à ces callback
%
% METHODS
%                activEss(obj, src, evnt)
%                afficheStatus(tO, mots)
%                canelli(obj,src,evnt)
%                changeCanDst(obj, src, evnt)
%                changeCanExtra(obj, src, evnt)
%                categos(obj,src,evnt)
%                fermer(obj,src,evnt)
%                initGui(tO, OT)
%                lircate(obj, OA)
%             v =lirVarOnglet(obj, fich)
%                lirVarPanelAmplitude(obj, s)
%                lirVarPanelBidon(obj, s)
%                lirVarPanelCUSUM(obj, s)
%                lirVarPanelExport(obj, s)
%                lirVarPanelMinMax(obj, s)
%                lirVarPanelMontee(obj, s)
%                lirVarPanelTemporel(obj, s)
%                lirVarPanelEmg(obj, s)
%                majGui(obj,OA)
%                prepareWmhVg(obj, vg)
%        sortie =quelpoint(obj)
%                reaffiche(obj,src,evnt)
%                listSetPoint(obj, OA)
%                showLesCat(obj, vg)
%                showPanel(tO, src, event)
%                suppression(obj,src,evnt)
%                testAGLR(tO,src,evnt)
%                testCUSUM(tO,src,evnt)
%                travail(obj,src,evnt)
%                valpardef(obj,src,evnt)
%                varGlobal(obj, s)
%
classdef CMarkGui < COngletUtil & CMLMark

  properties
    fig =[];                    % Interface du marquage auto
    Axe =[];                    % Axe de l'interface de marquage
    wmh =CParamMark();          % paramètres relatifs à la fenêtre de marquage
    hndGlob =[];                % handle à grouper (show/hide) pour onglets...
  end

  properties (Constant)
    % Si on ajoute ou enlève un onglet dans le GUI marquage, il faut modifier "TAGPANGLOB"
    TAGPANGLOB ={'PanelMinMax', 'PanelMontee', 'PanelTemporel', 'PanelAmplitude', 'PanelEmg', 'PanelCUSUM'};
  end  % properties (Constant)

  methods

    %-----------------------------------------------------
    % En entrée on aura une structure venant de CGuiMLMark
    % qui va servir à propager le texte dans la langue voulue
    % une fois le GUI fabriqué.
    %-----------------------
    function initGui(tO, OT)
      tO.initTexto(OT);
      OA =CAnalyse.getInstance();
      tO.lircate(OA);
    end

    %-------------------------------
    % gestion du changement de panel
    % Comme on a plusieurs panel qui utilise les même boutons de façon non
    % dépendante, plutôt que de créer un set de bouton identique par panel,
    % on change le "parent"...
    %---------------------------------
    function showPanel(tO, src, event)
      showPanel@COngletUtil(tO, src, event);
      switch tO.curPanTag
      case tO.TAGPANGLOB
        set(tO.hndGlob, 'Parent',tO.curPan);
      end
    end

    %-----------------------------------------------
    % Gestion de l'affichage dans la barre de status
    %-------------------------------
    function afficheStatus(tO, mots)
      if nargin < 2
        %_____________________________________________________
        % on lit la string contenant le texte à afficher selon
        % le choix de la langue
        %----------------------
        mots =tO.barstatus;
      end
      OA =CAnalyse.getInstance();
      OA.OFig.commentaire(mots);
    end

    %-----------------------------------
    % suite à un changement de canal Src
    %-----------------------------
    function canelli(obj,src,evnt)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      obj.wmh.setCanSrc(get(src, 'Value'));
      OA.OFig.cano.setValue(obj.wmh.canSrc);
      % on affiche les points disponibles pour ce canal
      obj.listSetPoint(OA);
      vg.can =obj.wmh.canSrc;
      OA.OFig.affiche();
    end

    %---------------------------------------
    % suite à un changement de canal "Extra"
    %--------------------------------------
    function changeCanExtra(obj, src, evnt)
      obj.wmh.setCanExtra(get(src, 'Value'));
    end

    %---------------------------------------------
    % suite à un changement de canal "Destination"
    %------------------------------------
    function changeCanDst(obj, src, evnt)
      obj.wmh.setCanDst(get(src, 'Value'));
    end

    %---------------------------------------
    % On veut choisir par essai ou catégorie
    %--------------------------------
    function activEss(obj, src, evnt)
      obj.wmh.setParEss(get(src, 'Value'));
      OA =CAnalyse.getInstance();
      obj.lircate(OA);
      obj.listSetPoint(OA);
    end

    %------------------------------
    % suite à un changement d'essai
    %-------------------------------
    function reaffiche(obj,src,evnt)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      chtri =get(src, 'Value');
      if obj.wmh.parEss
        obj.wmh.setAllTri(chtri);
      end
      obj.wmh.setTri(chtri);
      obj.wmh.setAffniv(0);
      OA.OFig.essai.setValue(chtri);
      vg.affniv =0;
      vg.tri =chtri;
      obj.listSetPoint(OA);
      OA.OFig.affiche();
    end

    %-----------------------------------
    % suite à un changement de catégorie
    %-----------------------------
    function categos(obj,src,evnt)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      vg.cat =get(src, 'Value');
      set(findobj('Type','uicontrol', 'tag', 'IpCatsLesnoms'), 'Value',vg.cat);
      obj.wmh.setAffniv(1);
      vg.affniv =1;
      if obj.wmh.parEss
        obj.lircate(OA);
      end
      obj.listSetPoint(OA);
      OA.OFig.affiche();
    end

    %--------------------------------------
    % Callback pour démarrer la suppression
    % des points sélectionnés
    %---------------------------------
    function suppression(obj,src,evnt)
      OA =CAnalyse.getInstance();
      obj.supppts(OA);
      obj.listSetPoint(OA);
      OA.OFig.affiche();
    end

    %----------------------------------------------
    % Callback pour remettre les valeurs par défaut
    % dans l'onglet marquage montée/descente
    %-------------------------------
    function valpardef(obj,src,evnt)
      set(findobj('Tag','SDeltaY'),'string','0');                % delta Y
      set(findobj('Tag','SDeltaX'),'string','0');                % delta X
      set(findobj('Tag','SDeltaT'),'string','0');                % delta T
      set(findobj('Tag','SMMMDIntDebut'),'string','p0');         % Début interv de travail
      set(findobj('Tag','SMMMDIntFin'),'string','pf');           % fin interv de travail
    end

    %-----------------------------------------------
    % Teste les valeurs entrées pour seuil et dérive
    % et affiche g+ et g-
    %------------------------------
    function testCUSUM(tO,src,evnt)
      try
        OA =CAnalyse.getInstance();
        OA.OFig.affiche();
        curFich =OA.findcurfich();
        s =tO.lirVarOnglet(curFich);
        % en temps normal, s.alltri fonctionne avec l'option de marquage par essai
        % ici on veut travailler sur le premier essai sélectionné
        s.alltri =curFich.Vg.tri(1);
        s.checkCUSUM(curFich);
        delete(s);
      catch lavie
        parleMoiDe(lavie);
        tO.afficheStatus(lavie.message);
      end
    end

    %---------------------------------------
    % Teste les valeurs entrées pour h, L, d
    % et affiche le résultat pour l'essai en cours
    %-----------------------------
    function testAGLR(tO,src,evnt)
      try
        OA =CAnalyse.getInstance();
        OA.OFig.affiche();
        curFich =OA.findcurfich();
        s =tO.lirVarOnglet(curFich);
        % en temps normal, s.alltri fonctionne avec l'option de marquage par essai
        % ici on veut travailler sur le premier essai sélectionné
        s.alltri =curFich.Vg.tri(1);
        s.checkAGLR(curFich);
        delete(s);
      catch lavie
        parleMoiDe(lavie);
        tO.afficheStatus(lavie.message);
      end
    end

    %-----------------------------
    function travail(obj,src,evnt)
      % Le travail c'est la job des parents (actuellement: CMark).
    end

    %-----------------------------------------------
    % En cliquant sur le "X" pour fermer la fenêtre,
    % on ne la ferme pas, on la cache.
    %----------------------------
    function fermer(obj,src,evnt)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;          
      OA.OFig.cacherMarquage();
      vg.setWmh(obj.wmh);
      vg.majVgWmh();
      OA.OFig.cano.setValue(vg.can);
      OA.OFig.essai.setValue(vg.tri);
      if vg.niveau
        set(findobj('Type','uicontrol', 'tag','IpCatsLesnoms'), 'Value',vg.cat);
      end
      vg.valeur =0;
      OA.OFig.commentaire(obj.potravfermer);
      OA.OFig.affiche();
    end

    %-------------------
    % Mise À Jour du GUI
    %----------------------
    function majGui(obj,OA)
      Ofich =OA.findcurfich();
      vg =Ofich.Vg;
      hdchnl =Ofich.Hdchnl;
      OA.OFig.montrerMarquage();
      obj.prepareWmhVg(vg);
      Ofich.lesess();
      Ofich.lescats();
      if vg.ess > 2;letopess =vg.ess;else letopess =vg.ess+1;end
      set(findobj('Tag','LBCanSrc'), 'Value',1, 'String',hdchnl.Listadname, 'Max',vg.nad, 'Value',obj.wmh.canSrc);
      set(findobj('Tag','LBQuelEss'), 'Value',1, 'String',vg.lesess,'Max',letopess,'Value',obj.wmh.tri);
      set(findobj('Tag','LBCanDst'), 'Value',1, 'String',hdchnl.Listadname,'Max',vg.nad,'Value',obj.wmh.canDst);
      set(findobj('Tag','LBCanalExtra'), 'Value',1, 'String',hdchnl.Listadname,'Max',vg.nad,'Value',1);
      set(findobj('Tag','CBessCat'), 'Value',obj.wmh.parEss);
      obj.showLesCat(vg);
      obj.lircate(OA);
      obj.listSetPoint(OA);
    end

    %----------------------------------
    % gestion du listbox des catégories
    %---------------------------
    function showLesCat(obj, vg)
      if vg.niveau & ~isempty(vg.lescats)
        sletop =length(vg.lescats);
        if sletop <= 2
          sletop =sletop+1;
        end
        set(findobj('Tag','LBQuelCat'), 'Value',1, 'String',vg.lescats,'Max',sletop,'Value',vg.cat, 'Enable','on');
      else
        set(findobj('Tag','LBQuelCat'), 'Enable','off');
      end
    end

    %-------------------------------------------------
    % Ajustement lors de l'entrée dans le GUI marquage
    % en fonction des paramètres actuels du GUI principal
    %-----------------------------
    function prepareWmhVg(obj, vg)
      vg.majWmhVg();
      obj.wmh =vg.getWmh;
      % correction canal source
      obj.wmh.setCanSrc(vg.can);
      % correction canal destination
      obj.wmh.setCanDst(1);
      % correction canal extra
      obj.wmh.setCanExtra(1);
      if isfield(vg, 'multiaff')
        vg.multiaff =[];
      end
    end

    %-------------------------------
    % Recherche les essais à marquer
    %------------------------
    function lircate(obj, OA)
      Ofich =OA.findcurfich();
      catego =Ofich.Catego;
      vg =Ofich.Vg;
      if obj.wmh.parEss    % on travail les essais un à un
        if vg.affniv  % on travaille sur une catégorie
          lalist =get(findobj('Type','uicontrol','tag', 'IpCatsLesnoms'),'Value');
          lamat =zeros(vg.niveau,vg.ess);
          a =zeros(vg.niveau);
          niv =1;
          tot =catego.Dato(1,1,1).ncat;
          for i =1:size(lalist,1)
            while lalist(i) > tot
              niv =niv+1;
              tot =tot+catego.Dato(1,niv,1).ncat;
            end
            a(niv) =a(niv)+1;
            lacat =lalist(i)-(tot-catego.Dato(1,niv,1).ncat);
            lamat(niv,:) =lamat(niv,:)+catego.Dato(2,niv,lacat).ess(:)'; %'
          end
          final =ones(vg.ess,1);
          for i =1:vg.niveau
            if a(i)
              for j =1:vg.ess
                final(j,1) =final(j,1) & lamat(i,j);
              end
            end
          end
          if max(final) > 0
            i =1;
            while ~final(i,1)
              i =i+1;
            end
            alltri(1) =i;
            k =2;
            for j =i+1:vg.ess
              if final(j)
                alltri(k,1) =j;
                k =k+1;
              end
            end
          else
            alltri =0;
          end
        else  % On travaille sur certains esais
          alltri =get(findobj('Tag','LBQuelEss'),'Value');
        end
      else  % on travaille sur tous les essais
        alltri =1:vg.ess;
      end
      obj.wmh.setAllTri(alltri);
    end

    %--------------------------------
    % LECTURE DES POINTS SÉLECTIONNÉS
    %------------------------------
    function sortie =quelpoint(obj)
      sortie =1;
      deltous =get(findobj('Tag','CBtodosPuntos'), 'Value');
      if deltous
        lemax =length(get(findobj('Tag','LBpts'),'String'));
        sortie =[1:lemax];
      else
        delpts =str2num(get(findobj('Tag','EnumPts'), 'String'));
        if ~isempty(delpts)
          sortie =delpts;
          s =find(sortie == 0);
          if ~isempty(s)
            sortie(s) =[];
          end
        else
          sortie =get(findobj('Tag','LBpts'),'value');
        end
      end
      if isempty(sortie)
        sortie =1;
      end
    end

    %-------------------
    % fonction générique
    % les onglets sont bâtis selon des règles précises
    % de manière à construire automatiquement des handle de fonction.
    % On va intéroger l'onglet choisi
    %----------------------------------
    function v =lirVarOnglet(obj, fich)
      try
        v =CMarkVarCalcul(fich);
        texto =obj.getCurPanTag;
        v.fonc =['fnc' texto];
        textoLeer =['lirVar' texto];
        obj.(textoLeer)(v);
        obj.varGlobal(v);
        v.initialise();
      catch e
        rethrow(e);
      end
    end

    %--------------------------------------------------------
    % Lecture des paramètres qui peuvent être utils pour tous
    % s, est un objet de la classe: CMarkVarCalcul
    %-------------------------
    function varGlobal(obj, s)
      s.alltri =obj.wmh.allTri;
      s.remplace =get(findobj('Tag','CBremplacePts'), 'Value');
      s.csrc =obj.wmh.canSrc;
      s.lpts =obj.quelpoint();  % points à copier
      s.leDebut =get(findobj('Tag','SMMMDIntDebut'), 'String');
      s.laFin =get(findobj('Tag','SMMMDIntFin'), 'String');
      s.canExtra =obj.wmh.canExtra;
      s.copieVers =get(findobj('Tag','LBCanalExportPt'), 'Value');
      s.EcraseVers =get(findobj('Tag','LBCanalExportRemplace'), 'Value');
      s.reptout =get(findobj('Parent',obj.curPan, 'Tag','CBToutInt'), 'value');
      s.occur =get(findobj('Parent',obj.curPan, 'Tag','SMarkTempRepet'),'String');
      if ~isempty(s.occur)
        if ~isempty(str2num(s.occur))
          foo =str2num(s.occur);
          s.occur =foo(1);
        else
          s.occur =1;
        end
      else
        s.occur =1;
      end
    end

    %------------------------------------------
    % Lecture des composants de l'onglet Export
    % s, est un objet de la classe: CMarkVarCalcul
    %---------------------------------
    function lirVarPanelExport(obj, s)
      s.p2p =get(findobj('Tag','CBCanSrcCanDSt'),'Value');
      s.cdst =obj.wmh.canDst;  % canaux de destination
    end

    %------------------------------------------
    % Lecture des composants de l'onglet MinMax
    % s, est un objet de la classe: CMarkVarCalcul
    %---------------------------------
    function lirVarPanelMinMax(obj, s)
      s.leMin =get(findobj('Tag','CBMin'), 'Value');
      s.leMax =get(findobj('Tag','CBMax'), 'Value');
    end

    %---------------------------------------------------
    % Lecture des composants de l'onglet Montée/Descente
    % s, est un objet de la classe: CMarkVarCalcul
    %---------------------------------
    function lirVarPanelMontee(obj, s)
      s.dbtmnt =get(findobj('Tag','CBMonteDebut'), 'value');       % début montée
      s.dbtdsc =get(findobj('Tag','CBDescenteDebut'), 'value');    % début desc.
      s.finmnt =get(findobj('Tag','CBMonteFin'), 'value');         % fin montée
      s.findsc =get(findobj('Tag','CBDescenteFin'), 'value');      % fin desc.
      s.deltaY =get(findobj('Tag','SDeltaY'),'string');            % Delta Y
      if ~isempty(s.deltaY)
        goo =strfind(s.deltaY, '%');                               % est-ce que l'on veut un pourcentage
        if ~isempty(goo)
          s.deltaY(goo) =[];
          s.deltaY =-abs(str2num(s.deltaY));                       % si oui on met deltaY < 0
        else
          s.deltaY =abs(str2num(s.deltaY));                        % si non on garde la valeur > 0
        end
      end
      if isempty(s.deltaY) | s.deltaY == 0
        s.deltaY =-50;
      end
      s.deltaX =abs(str2num(get(findobj('Tag','SDeltaX'),'string')));    % Delta X
      s.deltaT =abs(str2num(get(findobj('Tag','SDeltaT'),'string')));    % Delta T
    end

    %--------------------------------------------
    % Lecture des composants de l'onglet Temporel
    % s, est un objet de la classe: CMarkVarCalcul
    %-----------------------------------
    function lirVarPanelTemporel(obj, s)
      s.tmp =get(findobj('Tag','SMarkTemp'),'string');
      s.int =get(findobj('Tag','SMarkTempInt'),'String');
    end

    %---------------------------------------------
    % Lecture des composants de l'onglet Amplitude
    % s, est un objet de la classe: CMarkVarCalcul
    %------------------------------------
    function lirVarPanelAmplitude(obj, s)
      s.ampRef =strtrim(get(findobj('Tag','SAmplitRef'),'string'));
      pCent =str2num(get(findobj('Tag','SAmplitRefPc'),'string'));
      if pCent <= 0
        s.pCent =1;
      else
        s.pCent =pCent/100;
      end
      s.delai =str2num(get(findobj('Tag','SAmplitDelai'),'String'));
      direction =get(findobj('Tag','PuMDirection'),'value');
      s.direction =logical(abs(direction-2));
    end

    %---------------------------------------
    % Lecture des composants de l'onglet Emg
    % s, est un objet de la classe: CMarkVarCalcul
    %------------------------------
    function lirVarPanelEmg(obj, s)
      quien ={'h','l','d'};
      for U =1:length(quien)
        foo =str2num(get(findobj('Tag',['SEmgAGLR' quien{U}]),'string'));
        if isempty(foo) | ~isnumeric(foo) | foo <= 0
          me =MException('ANALYSE:CMarkGui:lirVarPanelEmg', ...
              'Le paramètre "%s" n''est pas valide.', quien{U});
          throw(me);
        else
          s.(['var' quien{U}]) =foo;
        end
      end
    end

    %-----------------------------------------------
    % Lecture des composants de l'onglet point Bidon
    % s, est un objet de la classe: CMarkVarCalcul
    %--------------------------------
    function lirVarPanelBidon(obj, s)
      foo =get(findobj('Tag','SPtBidon'),'String');
      if isempty(foo)
        s.ptbidon =get(findobj('Tag','LBPtBidon'),'Value');
      else
        k =str2num(foo);
        pat ='[^0-9]';
        if isempty(k) || ~isempty(regexp(foo, pat))
          me =MException('ANALYSE:CMarkGui:lirVarPanelBidon', ...
              'Expression du numéro de point: %s non valide', foo);
          throw(me);
        else
          s.ptbidon =k(1);
        end
      end
    end

    %----------------------------------------------------
    % Lecture des composants de l'onglet CUSUM changement
    % s, est un objet de la classe: CMarkVarCalcul
    %--------------------------------
    function lirVarPanelCUSUM(obj, s)
      s.seuil =abs(str2num(get(findobj('Tag','SSeuil'), 'string')));      % Seuil, threshold
      if isempty(s.seuil)
        s.seuil =1;
        set(findobj('Tag','SSeuil'), 'string','1');
      end
      s.derive =abs(str2num(get(findobj('Tag','SDeriveDrift'), 'string')));    % Dérive, drift
      if isempty(s.derive)
        s.derive =0;
        set(findobj('Tag','SDeriveDrift'), 'string','0');
      end
      s.gpls =get(findobj('Tag','CBMonteCUSUM'), 'value');
      s.gmns =get(findobj('Tag','CBDescenteCUSUM'), 'value');
    end

    %------------------------------------------------------------------------
    % Fabrication de la liste des points existants dans les différents canaux
    % et on les affichent dans la listbox des points à effacer et dans le PanelBidon
    %-----------------------------
    function listSetPoint(obj, OA)
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      catego =Ofich.Catego;
      vg =Ofich.Vg;
      % nb de point max à afficher pour un canal
      lotmax =max(hdchnl.npoints(:))+1;
      if obj.wmh.allTri
        npts =max(max(hdchnl.npoints(obj.wmh.canSrc,obj.wmh.allTri)));
        if npts
          for ii =1:npts
            laliste{ii} =int2str(ii);
          end
          if npts == 2; npts =3;end
        else
          laliste ={'...'};
          npts =1;
        end
        for ii =1:lotmax
          lotlist{ii} =int2str(ii);
        end
      else
        laliste ={'...'};
        npts =1;
        lotlist ='1';
      end
      letop =length(laliste);
      laval =get(findobj('Tag','LBpts'),'Value');
      if ~isempty(find(laval > letop))
        laval =letop;
      end
      set(findobj('Tag','LBpts'), 'Value',1, 'String',laliste, 'Max',npts, 'value',laval);
      laval =get(findobj('Tag','LBPtBidon'),'Value');
      if ~isempty(find(laval > lotmax))
        laval =lotmax;
      end
      set(findobj('Tag','LBPtBidon'),'Value',1,'String',lotlist, 'value',laval);
    end

  end  % methods
end % classdef
