%
% Classe CDessine
%
% Gestion de l'affichage dans l'axe.
% La nomenclature du handle de l'instance de cette classe, et de plusieurs vieilles
% classes, a changé au fil du temps. Au début c'était "obj", puis "thisObj" pour en
% venir de façon systématique à "tO" qui est le diminutif de "this Object".
%
% METHODS
%              obj =CDessine()     % CONSTRUCTOR
%                   delete(obj)     % DESTRUCTOR
%
%                   affiche(obj)
%                   afflistener(obj,src,evnt)
%                   cacherMarquage(tO)
%   [lestri, test] =canalessai(obj, gr, vg, categ, mfen)
%                   chfichpref(obj, Ofich)
%                   choffmenu(obj)
%                   choffpan(obj)
%                   chonmenu(obj, Ofich)
%                   chonpan(obj)
%                   commentaire(tO, TEXTE)
%                   deleteDataCursorBar(tO)
%                   detruitpt(tO)
%                   fabrikgr(obj,gr,vg,cc)
%                   finaliseAxe(tO, lafig, labar)
%                   montrerMarquage(tO)
%                   renommer(tO, Ofich)
%                   resetAxes(tO, elgca)
%                   toggleActiveBtous(tO, leBoss, STATUS)
%
% METHODS (Access =protected)
%                   ecriinfo(obj, Ofich)
%                   finition(obj, Ofich)
%                   forgelegend(obj, Ofich, ligne, V)
%                   onaffiche(obj, Ofich, ligne, V)
%
classdef CDessine < handle

  properties
    fig =[];                   % figure principale
    mkfig =[];                 % figure du marquage de point
    curstatusbar =[];          % handle de la barre de status
    Bcano =zeros(1,5);         % block de handle des boutons affichage canaux
    Bess =zeros(1,5);          % block de handle des boutons affichage essais
    Bcato =zeros(1,2);         % block de handle des boutons affichage catégories
    Btous =[];                 % block contenant tous les éléments à "disabled" pour affichage
    cano =[];                  % handle d'un objet CListBox1 pour l'affichage du nom des canaux
    essai =[];                 % handle d'un objet CListBox1 pour l'affichage du nom des essais
    nivo =[];                  % handle d'un objet CListBox1 pour l'affichage du nom des catégories/niveaux
    canopts =[];               % handle d'un objet CListBox2 pour afficher les canaux pour le marquage manuel
    Lepan =[];                 % handle sur un panel pour l'ensemble de la fenêtre moins la barre de status
    statusaff =[];             % handle du bouton pour indiquer le status de l'affichage
    Lax =[];                   % handle de l'axes courant pour l'affichage
    exLax =[];                 % avant-dernier handle de l'axes pour l'affichage
    haffcoord =[];             % handle de l'objet DataCursorBar
    matlab =true;              % true si on travaille avec Matlab.
  end
  %
  methods

    %------------
    % CONSTRUCTOR
    %-----------------------
    function obj =CDessine()
      try

        
        foo =CParamGlobal.getInstance();
        obj.matlab =foo.matlab;
        GUIAnalyse(obj);
        IpMenu(obj);
        set(obj.fig, 'visible','on')
        obj.cacherMarquage();

      catch bb;
        parleMoiDe(bb);
      end
    end

    %-----------
    % DESTRUCTOR
    %-------------------
    function delete(obj)
      if ishandle(obj.mkfig)
        delete(obj.mkfig);
      end
      if ishandle(obj.fig)
        delete(obj.fig);
      end
    end

    %---------------------------------------------------------------
    % L'affichage va se faire maintenant dans la fenêtre principale.
    % On va mettre la fenêtre de marquage invisible.
    % Il faut aussi changer le "statusbar" courant et les axes.
    %--------------------------
    function cacherMarquage(tO)
      % On ajuste la position du marquage en fonction de la position de l'autre fen
      lapos =get(tO.mkfig, 'position');
      if ~isempty(lapos)
        lapos =lapos.*[1 1 1 0.97];
        set(tO.fig,'position',lapos);
      end
      % on rend la fen principale visible et active
      set(tO.fig, 'Visible','on');
      figure(tO.fig);
      % on "ferme" la fen du marquage
      if ~isempty(lapos)
        set(tO.mkfig, 'Visible','off');
      end
      tO.finaliseAxe(tO.fig, 'IpStatus');
    end

    %----------------------------------------------------------------------------
    % L'afficahge va se faire maintenant dans la fenêtre de marquage automatique.
    % On va mettre la fenêtre principale invisible.
    % Il faut aussi changer le "statusbar" courant et les axes.
    %---------------------------
    function montrerMarquage(tO)
      % On ajuste la position du marquage en fonction de la position de l'autre fen
      lapos =get(tO.fig, 'position').*[1 1 1 1.03];
      set(tO.mkfig,'position',lapos);
      % on rend le marquage visible et actif
      set(tO.mkfig, 'Visible','on');
      figure(tO.mkfig);
      % on "ferme" la fen principale
      set(tO.fig, 'Visible','off');
      tO.finaliseAxe(tO.mkfig, 'MarkStatus');
    end

    %---------------------------------------
    % IL FAUT SAVOIR DANS QUEL AXES AFFICHER
    % on reset les "pointeurs" pour l'axe courant
    %    lafig  --> handle de la figure pour l'affichage
    %    labar  --> tag du uicontrol de la barre de status active
    %-------------------------------------
    function finaliseAxe(tO, lafig, labar)
      tO.exLax =tO.Lax;
      tO.Lax =get(lafig, 'CurrentAxes');
      if isempty(tO.Lax)
        tO.Lax =gca;
      end
      % Et aussi dans quelle statusbar mettre les commentaires
      tO.curstatusbar =findobj('Tag', labar);
    end

    %----------------------------------------------------
    % Rend le panel, qui contient tous les controls de la
    % fenêtre principale, visible.
    %--------------------
    function chonpan(obj)
      set(obj.Lepan,'visible','on');
    end

    %----------------------------------------------------
    % Rend le panel, qui contient tous les controls de la
    % fenêtre principale, invisible.
    %--------------------
    function choffpan(obj)
      try
        % on reset le nom de la fenêtre
        set(findobj('tag', 'IpTraitement'),'Name','En attente de traitement');
        % on reset aussi la barre de status
        obj.commentaire();
        set(obj.Lepan,'visible','off');
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %-----------------------------------------------------
    % On renomme la fenêtre après un changement de fichier
    % EN ENTRÉE on a Ofich un objet de la classe CFichierAnalyse
    %---------------------------
    function renommer(tO, Ofich)
      vg =Ofich.Vg;
      set(tO.fig, 'Name', ['Analyse: ' Ofich.Info.finame ' [V' num2str(vg.otype) ']']);
    end

    %-----------------------------------------------------
    % Après un changement de fichier, on ré-initialise les
    % menu et préférences en fonction du nouveau fichier.
    % EN ENTRÉE on a Ofich un objet de la classe CFichierAnalyse
    %------------------------------
    function chfichpref(obj, Ofich)
      vg =Ofich.Vg;
      obj.renommer(Ofich);
      if vg.xy
        set(findobj('tag', 'IpmnuXy'),'checked','on')
      else
        set(findobj('tag', 'IpmnuXy'),'checked','off')
      end
    	switch vg.pt
    	case {0,3}
        set(findobj('tag','IpmnuPoint'),'checked','off');
        set(findobj('tag','IpmnuPointSansTexte'),'checked','off');
    	case 1
        set(findobj('tag','IpmnuPoint'),'checked','on');
        set(findobj('tag','IpmnuPointSansTexte'),'checked','off');
      case 2
        set(findobj('tag','IpmnuPoint'),'checked','off');
        set(findobj('tag','IpmnuPointSansTexte'),'checked','on');
      end
      if vg.ligne
        set(findobj('tag','IpmnuSmpl'),'checked','on');
      else
        set(findobj('tag','IpmnuSmpl'),'checked','off');
      end
      if vg.colcan
        set(findobj('tag','IpmnuColcan'),'checked','on');
      else
        set(findobj('tag','IpmnuColcan'),'checked','off');
      end
      if vg.coless
        set(findobj('tag','IpmnuColess'),'checked','on');
      else
        set(findobj('tag','IpmnuColess'),'checked','off');
      end
      if vg.colcat
        set(findobj('tag','IpmnuColcat'),'checked','on');
      else
        set(findobj('tag','IpmnuColcat'),'checked','off');
      end
      if vg.legende
        set(findobj('tag','IpmnuLegende'),'checked','on');
      else
        set(findobj('tag','IpmnuLegende'),'checked','off');
      end
      if vg.trich
        set(findobj('tag','Ipmnutrich'),'checked','on');
      else
        set(findobj('tag','Ipmnutrich'),'checked','off');
      end
      if vg.loq
      	set(findobj('tag','IpFrameLock'),'value',vg.loq)
      end
      Otp =Ofich.Tpchnl;
      if Otp.nbech == 0 | vg.letemps > Otp.nbech
        vg.letemps =0;
      end
      Otp.CacherMenu();
      Otp.AfficherMenu();
      lesnoms ={'Tous'};
      lesnoms(2:vg.nad+1) =Ofich.Hdchnl.Listadname;
      obj.canopts.updateprop({'String';lesnoms});
      obj.cano.updateprop({'value';1;'String';Ofich.Hdchnl.Listadname;'max';vg.nad;'value';vg.can});
      set(findobj('tag','IpCanTous'),'value',vg.toucan);
      obj.essai.updateprop({'value';1});
      obj.essai.setString(vg.lesess);
      obj.essai.updateprop({'value';vg.tri});
      set(findobj('tag','IpEssTous'),'value',vg.toutri);
    	set(findobj('tag','IpTextCats'),'visible','off');
  	  obj.nivo.updateprop({'visible';'off'});
      set(findobj('tag','IpCatsPermute'),'visible','off');
      if vg.niveau & ~isempty(vg.lescats)
    	  obj.nivo.setValue(1);
    	  obj.nivo.setString(vg.lescats);
    	  if ~isempty(find(vg.cat >length(vg.lescats)))
    	  	vg.cat =1;
    	  end
    	  obj.nivo.setValue(vg.cat);
        set(findobj('tag','IpCatsPermute'),'String',int2str(vg.permute));
      	set(findobj('tag','IpTextCats'),'visible','on');
    	  obj.nivo.updateprop({'visible';'on'});
        set(findobj('tag','IpCatsPermute'),'visible','on');
      end
    end

    %----------------------
    % Active tous les menus
    % Lors de l'ouverture d'un premier fichier
    %---------------------
    function chonmenu(obj)
      set(findobj('Type','uimenu','tag', 'IpmnuSave'), 'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuSaveas'), 'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuFermer'), 'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuAjouter'), 'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuModifier'), 'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuOutils'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuMath'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuFPlt'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuEdit'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuEmg'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuEcritureResultats'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuExportation'),'Enable','on');
      set(findobj('Type','uimenu','tag', 'IpmnuTrajectoire'),'Enable','on');
      obj.commentaire(' ');  % est-ce vraiment dans la description de tâche de cette fonction?  :-)
    end

    %-------------------------
    % Désactive tous les menus
    % Lors de la fermeture de tous les fichiers
    % et à l'ouverture de l'application
    %----------------------
    function choffmenu(obj)
      set(findobj('Type','uimenu','tag', 'IpmnuSave'), 'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuSaveas'), 'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuFermer'), 'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuAjouter'), 'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuModifier'), 'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuOutils'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuMath'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuFPlt'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuEdit'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuEmg'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuEcritureResultats'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuExportation'),'Enable','off');
      set(findobj('Type','uimenu','tag', 'IpmnuTrajectoire'),'Enable','off');
    end

    %_________________________________________________
    % affichage du texte TEXTE dans la barre de status
    %-------------------------------------------------
    function commentaire(tO, TEXTE)
      try
        if nargin < 2
          TEXTE ='Vous devez ouvrir un fichier pour commencer.';
        elseif isempty(TEXTE)
          TEXTE =' ';
        end
        set(tO.curstatusbar, 'string',TEXTE);
        % on s'assure que le display se fera à la suite
        pause(0.005);
      catch moo;
        disp(moo);
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %--------------------------------------------
    % fonction pour gérer l'affichage des courbes
    % (Dans une autre vie c'était woutil.m)
    %--------------------
    function affiche(obj)
      try

        fendebut =gcf;
        OA =CAnalyse.getInstance();
  
        if OA.Vg.peinture;
          % On arrête tout de go car on est déjà entrain d'afficher
          return
  
        else
          %___________________________________________________________________
          % On désactive les boîtes de sélection pour ne pas que l'utilisateur
          % clique sans arrêt et que l'ordi ne soit pas en mesure de répondre adéquatement
          %-------------------------------------------------------------------------------
          obj.toggleActiveBtous(OA, false);
  
        end

        %___________________________________________________
        % On s'assure de travailler avec le fichier en cours
        %---------------------------------------------------
        Ofich =OA.findcurfich();
        vg =Ofich.Vg;

        %_______________________________________________
        % Si on est en mode XY, il faut avoir défini des
        % canaux au préalable.
        %-----------------------------------------------
        if vg.xy && (isempty(Ofich.ModeXY.YY) || isempty(vg.y))
          obj.toggleActiveBtous(OA, true);
          return;
        end

        % on prépare les variables pour garder les traces de l'affichage
        gr =Ofich.Gr;
        cc =Ofich.Catego;
        obj.fabrikgr(gr,vg,cc);
        nbtotfen =length(vg.multiaff)+1;

        for mfen =1:nbtotfen
          [lestri, cfini] =obj.canalessai(gr, vg, cc, mfen-1);
          if cfini
          	continue;
          elseif mfen == 1
            Ofich.Lestri =lestri;
          end
          obj.detruitpt();
          obj.finition(Ofich);
        end

        figure(fendebut);
        pause(.2)
        obj.toggleActiveBtous(OA, true);

      catch moo;
        CQueEsEsteError.dispOct(moo);
        obj.commentaire('L''affichage s''est terminée anormalement')
      end

    end

    %_______________________________________________________________________
    % On dés/ré-active les boîtes de sélection pour ne pas que l'utilisateur
    % clique sans arrêt et que l'ordi ne soit pas en mesure de répondre adéquatement
    % De plus, un bouton a été ajouté en février 2017 pour que visuellement on
    % puisse savoir si l'affichage est en cours de travail (rouge) ou non (vert).
    % les couleurs fonctionnent comme ceci: ex.
    % ..., 'BackgroundColor',[R G B], ... ou R, G et B sont compris entre 0 et 1.
    % donc, noir=[0 0 0], blanc=[1 1 1], rouge=[1 0 0] etc...
    %----------------------------------------------------------------------------
    function toggleActiveBtous(tO, leBoss, S)
      try
        ss =CEOnOff(S);
      	set(tO.Btous, 'enable',char(ss));
      	set(tO.statusaff, 'BackgroundColor',[~S S 0 ])
        leBoss.Vg.peinture =~ss;
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %----------------------------------------
    % Si une "cursorbar" existe, on la delete
    %-------------------------------
    function deleteDataCursorBar(tO)
      if isa(tO.haffcoord, 'CAfficheCoord')
        delete(tO.haffcoord);
        tO.haffcoord =[];
      end
    end

    %------------------------------
    % Fabrication de la variable Gr
    % lors d'affichage par catégowi
    %------------------------------
    function fabrikgr(obj,gr,vg,cc)
      try
        if gr.status
          gr.reset();
          if vg.affniv
            %______________________________________________________________________
            %  gr.lescats =zeros(1,2)      contiendra les niveaux et cat à afficher
            a =zeros(vg.niveau);  % utilisé pour voir si on a des essais dans ce niveaux
            niv =1;
            indniv =1;
            tot =cc.Dato(1,1,1).ncat;  % pour vérifier si on est à l'intérieur de ce niveau
            oldtot =0;
            for i =1:length(vg.cat)
              categowi =vg.cat(i)-oldtot;
              while vg.cat(i) > tot
                % si oui, on ajoute le prochain niveau et on reboucle
                categowi =categowi-cc.Dato(1,niv,1).ncat;
                niv =niv+1;
                oldtot =tot;
                tot =tot+cc.Dato(1,niv,1).ncat;
              end
              a(niv) =a(niv)+1;
              if gr.lescats(1,1) == 0
                gr.lescats(1,1) =niv;  % on conserve une trace du niv et cat à afficher
                gr.lescats(1,2) =1;
                gr.lescats(1,3) =categowi;
              elseif a(niv) == 1
                indniv =indniv+1;
                gr.lescats(indniv,1) =niv;
                gr.lescats(indniv,2) =1;
                gr.lescats(indniv,3) =categowi;
              else
                gr.lescats(indniv,1) =niv;
                gr.lescats(indniv,2) =gr.lescats(indniv,2)+1;
                gr.lescats(indniv,(3+gr.lescats(indniv,2)-1)) =categowi;
              end
            end
            % On les met en ordre décroissant
            gr.nbniv =size(gr.lescats,1);
            if gr.nbniv > 1
              [foo, bb] =sort(gr.lescats(:,1), 'descend');
              tmpcat =gr.lescats;
              for j =1:gr.nbniv
                gr.lescats(j,:) =tmpcat(bb(j), :);
              end
              if vg.permute
                gr.lescats(gr.nbniv+1:gr.nbniv+vg.permute,:) =gr.lescats(1:vg.permute,:);
                gr.lescats(1:vg.permute,:) =[];
              end
            end
          end
        end

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %------------------------------------------------------------
    function [lestri, test] =canalessai(obj, gr, vg, categ, mfen)
      try
        %_________________________________________________________
        % On commence par déterminer quels canaux il faut afficher
        %---------------------------------------------------------
        test =false;
        if mfen
          %___________
          % (Nouv-Axe)
          %-----------
          elmodo =getappdata(vg.multiaff(mfen),'LEMODE');
          if elmodo(1) == 0
            test =true;
            lestri =0;
            return;
          end
          lescan =getappdata(vg.multiaff(mfen),'LESCAN');
          gr.xy =0;
          figure(vg.multiaff(mfen));
        else
          %______________
          % Axe Principal
          %--------------
          if  vg.xy
            lescan =vg.y;
          elseif vg.toucan
            lescan =[1:vg.nad];
          else
            lescan =vg.can;
          end
          gr.xy =vg.xy;
          %__________________________________________________
          % On fait un reset de l'axes afin de ne pas traîner
          % des objets incohérents dans l'affichage
          %----------------------------------------
          obj.resetAxes(obj.Lax);
        end
        %____________________
        % Choix par catégorie
        %--------------------
        lestri =[];
        if vg.affniv
          qessai =zeros(vg.ess,1);    % essai et couleur
          qessaitmp =ones(vg.ess,1);  % essai et couleur
          qessaitmp2 =zeros(vg.ess,5);
          colo =0;
          % SI ON A PLUSIEURS NIVEAUX
          for k =2:gr.nbniv
            for i =1:gr.lescats(k,2)
              %____________________
              % Sous un même niveau
              % UNION des cats
              %---------------
              qessai(:,1) =qessai(:,1)+categ.Dato(2,gr.lescats(k,1),gr.lescats(k,i+2)).ess(:);
            end
            %______________________
            % INTERSECTION des nivs
            %----------------------
            qessaitmp(:,1) =qessaitmp(:,1) & qessai(:,1);
            qessai(:,:) =zeros(size(qessai));
          end
          lacolle =0;
          %______________________________________________
          % TRAITEMENT DU NIVEAU "MAIN" POUR LES COULEURS
          %----------------------------------------------
          for i =1:gr.lescats(1,2)
            qessai(:,1) =qessaitmp(:,1) & categ.Dato(2,gr.lescats(1,1),gr.lescats(1,i+2)).ess(:);
            qessaitmp2(:,5) =qessaitmp2(:,5)+(gr.lescats(1,i+2)*(qessaitmp(:,1) & categ.Dato(2,gr.lescats(1,1),gr.lescats(1,i+2)).ess(:)));
            qessaitmp2(:,1) =qessaitmp2(:,1) + qessai(:,1);
            if vg.colcat
              %______________________________________________________________
              % IL FAUT DISCRÉMINER LES DIFFÉRENTES POSSIBILITÉS DE COLORIAGE
              %--------------------------------------------------------------
              if gr.lescats(1,2) > 1
                if lacolle == 14; lacolle =1; else; lacolle =lacolle+1; end
                qessaitmp2(:,2) =qessaitmp2(:,2)+( lacolle * qessai(:,1));  % On peinture
                j =1;  % On s'assure qu'il y a des essais à afficher
                while (j <= vg.ess) & ~qessai(j,1); j =j+1; end
                if j <= vg.ess
                  qessaitmp2(j,3) =1;  % Légende
                end
              elseif vg.coless  % UNE SEULE CAT -> ON COLORE PAR ESSAI
                for m =1:vg.ess
                  if qessai(m,1)
                    if colo == 14; colo =1; else; colo =colo+1; end
                    qessaitmp2(m,2) =colo;
                    qessaitmp2(m,3) =1;
                  end
                end
              else  % UNE SEULE CAT, ET ON NE COLORE PAS LES ESSAIS
                aaa =1;
                for m =1:vg.ess
                  if qessai(m,1)
                    qessaitmp2(m,2) =1;
                    if aaa; qessaitmp2(m,3) =1; end
                    aaa =0;
                  end
                end
              end  %  if gr.lescats(1,2)>1
            else   %  if vg.colcat
              qessaitmp2(:,2) =qessaitmp2(:,2) + qessai(:,1);
            end
          end  %  for
          j =1;
          if gr.xy
            lestri =zeros(vg.ess,11);
          else
            lestri =zeros(vg.ess,8);
          end
          for i =1:vg.ess
            if qessaitmp2(i,1)
              lestri(j,1) =i;                   % no de l'essai
              lestri(j,2) =qessaitmp2(i,2);     % et sa couleur
              lestri(j,3) =qessaitmp2(i,3);     % passe à la légende
              lestri(j,4) =gr.lescats(1,1);     % niveau
              lestri(j,5) =qessaitmp2(i,5);     % cat
              lestri(j,6) =lescan(1);           % canal
              if gr.xy
                lestri(j,7) =vg.x(1);
              end
              j =j+1;
            end
          end
          nombre =length(lescan);
          nbess =j-1;
          if nbess < vg.ess; lestri(nbess+1:end,:) =[]; end
          if nbess
            maxcol =max(lestri(:,2));
            if (nombre > 1)
              lestri(nbess*nombre,6) =0;
              for i =1:nombre-1
                lestri((i*nbess)+1:(i+1)*nbess,:) =lestri(1:nbess,:);
                lestri((i*nbess)+1:(i+1)*nbess,6) =lescan(i+1);
                if gr.xy
                  lestri((i*nbess)+1:(i+1)*nbess,7) =vg.x(i+1);
                end
                if vg.colcan
                  lestri((i*nbess)+1:(i+1)*nbess,2) =lestri((i*nbess)+1:(i+1)*nbess,2)+(i*maxcol);
                  for j =(i*nbess)+1:(i+1)*nbess
                    while lestri(j,2)>14
                      lestri(j,2) =lestri(j,2)-14;
                    end
                  end
                else
                  lestri((i*nbess)+1:(i+1)*nbess,3) =0;   % on ne passe pas à la légende
                end
              end
            end
          else
            lestri =[];
            disp(['La selection demandee est vide']);
            disp(['Les courbes affichees seront celles selectionnees dans la fenetre ESSAI']);
            vg.affniv =0;
          end
        end
        %______________________________________________
        % Choix par essai ou résultat de catégorie Vide
        %----------------------------------------------
        if isempty(lestri)
          if vg.toutri
            lestri =[1:vg.ess]'; %'
          else
            lestri(1:length(vg.tri),1) =vg.tri;
            if isempty(lestri)
              obj.essai.setValue(1);  % on a pas choisi d'essai
              lestri =1;
            end
          end
          if gr.xy
            lestri(:,2:11) =0;
          else
            lestri(:,2:8) =0;
          end
          %_____________________________________________________
          % fonction pour assigner la cat par défaut (vg.defniv)
          %-----------------------------------------------------
          if vg.niveau
            if categ.Dato(1,vg.defniv,1).ncat
              for i =1:size(lestri,1)
                lecat =0;
                for j =1:categ.Dato(1,vg.defniv,1).ncat
                  if categ.Dato(2,vg.defniv,j).ess(lestri(i,1))
                    lecat =j;
                    break;
                  end
                end
                if lecat
                  lestri(i,4) =vg.defniv;
                  lestri(i,5) =j;
                end
              end
            end
          end
          colo =0;
          if vg.coless
            for i =1:size(lestri,1)
              if colo == 14; colo =1; else; colo =colo+1; end
              lestri(i,2) =colo;
              lestri(i,3) =1;
            end
          else
            if vg.colcan; lestri(1,3) =1; end
            lestri(:,2) =1;
          end
          lestri(:,6) =lescan(1);
          if gr.xy
            lestri(:,7) =vg.x(1);
          end
          nombre =length(lescan);
          nbess =size(lestri,1);
          maxcol =max(lestri(:,2));
          if nombre > 1
            lestri(nbess*nombre,6) =0;
            for i =1:nombre-1
              lestri((i*nbess)+1:(i+1)*nbess,:) =lestri(1:nbess,:);
              lestri((i*nbess)+1:(i+1)*nbess,6) =lescan(i+1);
              if gr.xy
                lestri((i*nbess)+1:(i+1)*nbess,7) =vg.x(i+1);
              end
              if vg.colcan
                lestri((i*nbess)+1:(i+1)*nbess,2) =lestri((i*nbess)+1:(i+1)*nbess,2)+(i*maxcol);
                for j =(i*nbess)+1:(i+1)*nbess
                  while lestri(j,2) > 14
                    lestri(j,2) =lestri(j,2)-14;
                  end
                end
              else
                lestri((i*nbess)+1:(i+1)*nbess,3) =0;   % on ne passe pas à la légende
              end
            end
          end
        end

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %____________________________________________________
    % Avant de faire un reset de l'axes il faut conserver
    % le tag car on l'utilise ailleur.
    %----------------------------
    function resetAxes(tO, elgca)
      try
        letag =get(elgca,'tag');
        cla(elgca, 'reset');
        set(elgca,'tag',letag);
        % On flush le DataCursorBar s'il existe
        tO.deleteDataCursorBar();

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %-------------------------------------------------
    % On détruit les objects de la mémoire pour ne pas
    % encrasser à long terme
    %---------------------
    function detruitpt(tO)
      try
        if isempty(tO.exLax)
          tO.exLax =gca;
        end
        ElPunto =getappdata(tO.exLax,'ElPunto');
        for U =1:length(ElPunto)
        	delete(ElPunto{U});
        end
        setappdata(tO.exLax,'ElPunto',[]);

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %---------------------------
    % Listenner pour l'affichage
    % est-il encore util???
    %---------------------------------
    function afflistener(obj,src,evnt)
      obj.affiche();
    end

  end  %methods

  methods (Access =protected)

    %----------------------------
    function finition(obj, Ofich)
      try

        lestri =Ofich.Lestri;
        gr =Ofich.Gr;
        vg =Ofich.Vg;
        hdchnl =Ofich.Hdchnl;
        if vg.xlim; xlim(obj.Lax, vg.xval); end
        if vg.ylim; ylim(obj.Lax, vg.yval); end
        nbcourb =size(lestri,1);
        hold(obj.Lax,'on');

        %____________________________________
        % et si on trichait un peu (vg.trich)
        %------------------------------------
        gr.max2 =hdchnl.max(lestri(1,6),lestri(1,1));
        gr.min2 =hdchnl.min(lestri(1,6),lestri(1,1));
        if gr.xy
          gr.max2x =hdchnl.max(lestri(1,7),lestri(1,1));
          gr.min2x =hdchnl.min(lestri(1,7),lestri(1,1));
          gr.filtmp =vg.filtp;
          if gr.filtmp
            gr.lesdim =[vg.filtpmin vg.filtpmax];
          end
        end

        j =1;
        for i =1:nbcourb
          if hdchnl.nsmpls(lestri(i,6),lestri(i,1)) == 0
            disp(['Essai(' num2str(lestri(i,1)) ') canal(' num2str(lestri(i,6)) '): vide']);
            continue;
          end
          gr.max1 =hdchnl.max(lestri(i,6),lestri(i,1));
          gr.min1 =hdchnl.min(lestri(i,6),lestri(i,1));

          if gr.xy
            gr.max1x =hdchnl.max(lestri(i,7),lestri(i,1));
            gr.min1x =hdchnl.min(lestri(i,7),lestri(i,1));
          end

          obj.onaffiche(Ofich, i, j);

          if lestri(i,3)
            obj.forgelegend(Ofich, i, j);
            j =j+1;
          end

        end
        if max(lestri(:,3))
          if lestri(end,3) == 0
            gr.leshdls(end)=[];
          end
          a =[];
          if ~isempty(gr.leshdls)
            [a,b,c,d] =legend(obj.Lax, gr.leshdls, gr.lalegend);
            % Octave n'affichait pas la légende tel quel, j'ai dû ajouter
            if ~obj.matlab
              set(a, 'parent',obj.Lax);
            end

            if  vg.legende
              set(a,'box','on','visible','on','box','off');
            else
            	set(a,'box','on','visible','off');
            end

          end
        end

        obj.ecriinfo(Ofich);
        guiToul('zoomonoff');
        guiToul('affichecoord');

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %-----------------------------
    % fait un refresh du graphique
    % Ofich  --> handle d'un objet CFichierAnalyse
    % ligne  --> numéro de la courbe à afficher, en fonction de la var tO.Lestri
    % V      --> numéro de la courbe réellement affichée.
    %---------------------------------------
    function onaffiche(obj, Ofich, ligne, V)
      try
        vg =Ofich.Vg;
        gr =Ofich.Gr;
        hdchnl =Ofich.Hdchnl;
        ptchnl =Ofich.Ptchnl;
        tpchnl =Ofich.Tpchnl;
        lestri =Ofich.Lestri;
        gr.tri =lestri(ligne,1);
        gr.y =lestri(ligne,6);
        couleur =Ofich.couleur;
        lix =CDtchnl();
        ligrec =CDtchnl();
        Ofich.getcaness(ligrec, gr.tri, gr.y);
        lerate =hdchnl.rate(gr.y,gr.tri);

        if gr.xy
          gr.x =lestri(ligne,7);
          ledebut =max([hdchnl.frontcut(gr.x,gr.tri) hdchnl.frontcut(gr.y,gr.tri)]); % en sec
          leboutte =min([(hdchnl.nsmpls(gr.x,gr.tri)/lerate+hdchnl.frontcut(gr.x,gr.tri))...
                         (hdchnl.nsmpls(gr.y,gr.tri)/lerate+hdchnl.frontcut(gr.y,gr.tri))]);
          if gr.filtmp
            ledebut =max([ledebut gr.lesdim(1)]);
            leboutte =min([leboutte gr.lesdim(2)]);
          end
          Ofich.getcaness(lix, gr.tri, gr.x);
          ledebutx =max([1 floor((ledebut-hdchnl.frontcut(gr.x,gr.tri))*lerate)]);
          ledebuty =max([1 floor((ledebut-hdchnl.frontcut(gr.y,gr.tri))*lerate)]);
          leboutte =floor((leboutte-ledebut)*lerate);  % nb de sample à considérer
          if vg.trich
            if (gr.max2-gr.min2) == 0; gam1 =0.00000001;
            else; gam1 =gr.max2-gr.min2;
            end
            if (gr.max1-gr.min1) == 0; gam2 =0.00000001;
            else; gam2 =gr.max1-gr.min1;
            end
            gam =gam1/gam2;
            delt =(gam*gr.min1)-gr.min2;
            ligrec.Dato.(ligrec.Nom) =(gam*ligrec.Dato.(ligrec.Nom))-delt;
            if (gr.max2x-gr.min2x) == 0; gam1 =0.00000001;
            else; gam1=gr.max2x-gr.min2x;
            end
            if (gr.max1x-gr.min1x) == 0; gam2 =0.00000001;
            else; gam2=gr.max1x-gr.min1x;
            end
            gam =gam1/gam2;
            delt =(gam*gr.min1x)-gr.min2x;
            lix.Dato.(lix.Nom) =(gam*lix.Dato.(lix.Nom))-delt;
          end
          if leboutte > 0
            Ofich.Lestri(ligne, 9) =leboutte;
            Ofich.Lestri(ligne, 10) =ledebutx;
            Ofich.Lestri(ligne, 11) =ledebuty;
            gr.leshdls(V) =plot(obj.Lax,lix.Dato.(lix.Nom)(ledebutx:ledebutx+leboutte-1),...
                                ligrec.Dato.(ligrec.Nom)(ledebuty:ledebuty+leboutte-1),couleur(lestri(ligne,2),:));
            Ofich.Lestri(ligne, 8) =gr.leshdls(V);
          end
        else
          gr.x =lestri(ligne,6);
          fs =hdchnl.rate(gr.y,gr.tri);
          lix.Nom ='temps';
          lix.Dato.(lix.Nom) =(hdchnl.frontcut(gr.y,gr.tri) +1/fs):(1/fs)...
                :hdchnl.frontcut(gr.y,gr.tri)+(single(hdchnl.nsmpls(gr.y,gr.tri))/fs);

          if vg.letemps > 0
            fs1 =hdchnl.rate(tpchnl.Dato{vg.letemps}.canal,gr.tri);
            if ptchnl.Dato(tpchnl.Dato{vg.letemps}.point,hdchnl.point(tpchnl.Dato{vg.letemps}.canal,gr.tri),2) == -1
              lepp =0.0;
            else
              lepp =ptchnl.Dato(tpchnl.Dato{vg.letemps}.point,hdchnl.point(tpchnl.Dato{vg.letemps}.canal,gr.tri),1);
              lepp =single(lepp)/fs1;
            end
            lix.Dato.(lix.Nom) = lix.Dato.(lix.Nom) - (lepp+hdchnl.frontcut(tpchnl.Dato{vg.letemps}.canal,gr.tri));
          end
          leboutte =hdchnl.nsmpls(gr.y,gr.tri);

          if vg.trich
            if (gr.max2-gr.min2) == 0; gam1 =0.00000001;
            else; gam1=gr.max2-gr.min2;
            end
            if (gr.max1-gr.min1) == 0; gam2 =0.00000001;
            else; gam2=gr.max1-gr.min1;
            end
            gam =gam1/gam2;
            delt =(gam*gr.min1)-gr.min2;
            ligrec.Dato.(ligrec.Nom) =(gam*ligrec.Dato.(ligrec.Nom))-delt;
          end

          if leboutte > 0
            gr.leshdls(V) =plot(obj.Lax,lix.Dato.(lix.Nom)(1:leboutte),ligrec.Dato.(ligrec.Nom)(1:leboutte),couleur(lestri(ligne,2),:));
            Ofich.Lestri(ligne, 8) =gr.leshdls(V);
          end

        end

        lalist='...';
        set(findobj('Type','uicontrol','tag', 'IpFrameEnleverpt'),'String','...');
        %
        % On fait le marquage des points
        %
        if (vg.pt == 1 | vg.pt == 2)
        	montrer ='on';
          ElPunto =getappdata(obj.Lax,'ElPunto');
          if gr.xy
            if hdchnl.npoints(gr.x,gr.tri)
              for i =1:hdchnl.npoints(gr.x,gr.tri)
                lept =ptchnl.Dato(i ,hdchnl.point(gr.x,gr.tri) ,1);
                if (ptchnl.Dato(i ,hdchnl.point(gr.x,gr.tri) ,2) == -1) | (lept < ledebutx) | (lept > ledebutx+leboutte)
                  continue;  % Y a personne...
                end
                p =CPointxy(gr.leshdls(V),Ofich,gr.tri,gr.x,i,ledebutx-1,true);
                ElPunto{end+1} =p;
                Lindex =double(lept)-double(ledebutx)+1;
                p.initial(Lindex,montrer);
              end  % for
            end
            if hdchnl.npoints(gr.y,gr.tri)
              for i =1:hdchnl.npoints(gr.y,gr.tri)
                lept=ptchnl.Dato(i ,hdchnl.point(gr.y,gr.tri) ,1);
                if (ptchnl.Dato(i ,hdchnl.point(gr.y,gr.tri) ,2) == -1) | (lept < ledebuty) | (lept > ledebuty+leboutte)
                  continue   % Y a personne...
                end
                p =CPointxy(gr.leshdls(V),Ofich,gr.tri,gr.y,i,ledebuty-1,false);
                ElPunto{end+1} =p;
                Lindex =double(lept)-double(ledebuty)+1;
                p.initial(Lindex,montrer);
              end
            end
          else
            if hdchnl.npoints(gr.y,gr.tri)
              for i =1:hdchnl.npoints(gr.y,gr.tri)
                lept =ptchnl.Dato(i ,hdchnl.point(gr.y,gr.tri) ,1);
                if (ptchnl.Dato(i ,hdchnl.point(gr.y,gr.tri) ,2) == -1) | (lept <= 0)
                  % Le point a été invalivé --> point bidon
                  lalist=[lalist '|#' num2str(i) '- Vide...'];
                  continue;
                end
                p =CPoints(gr.leshdls(V),Ofich,gr.tri,gr.y,i);
                ElPunto{end+1} =p;
                p.initial(lept, montrer);
                addlistener(p,'RAffiche',@obj.afflistener);
                pos =p.lapos();
                lalist =[lalist '|' num2str(i) ' [' num2str(pos(1)) ' ] [ ' num2str(pos(2)) ']'];
              end
            end
            if size(lestri,1) == 1
              set(findobj('Type','uicontrol','tag', 'IpFrameEnleverpt'),'String',lalist);
            else
              set(findobj('Type','uicontrol','tag', 'IpFrameEnleverpt'),'String','...');
            end
          end
          setappdata(obj.Lax,'ElPunto',ElPunto);
        end
        delete(lix);
        delete(ligrec);

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %-------------------------------------------------------
    % élaboration du texte qui va s'afficher dans la légende
    % Ofich  --> handle d'un objet CFichierAnalyse
    % ligne  --> numéro de la courbe à afficher, en fonction de la var tO.Lestri
    % V      --> numéro de la courbe réellement affichée.
    %-----------------------------------------
    function forgelegend(obj, Ofich, ligne, V)
      try
        gr =Ofich.Gr;
        vg =Ofich.Vg;
        hdchnl =Ofich.Hdchnl;
        catego =Ofich.Catego.Dato;
        can =Ofich.Lestri(ligne,6);
        canx =Ofich.Lestri(ligne,7)*logical(gr.xy);
        gr.lalegend{V} =' ';
        long_champ =48;
        pouett =' ';
        if vg.affniv        % ESSAIS SÉLECTIONNÉES PAR CAT
          Leniv =strtrim(catego(1,Ofich.Lestri(ligne,4),1).nom);
          lacat =[catego(2,Ofich.Lestri(ligne,4),Ofich.Lestri(ligne,5)).nom '    '];
          if gr.lescats(1,2) > 1 % PLUSIEURS CAT
          	leniv =Leniv(1:min(length(Leniv), 5));
            if and(vg.colcan, gr.xy)
              pouett =['(' leniv '-' strtrim(lacat) ') ' hdchnl.adname{can} ' Vs ' hdchnl.adname{canx}];
            elseif vg.colcan
              pouett =['(' leniv '-' strtrim(lacat) ') ' hdchnl.adname{can}];
            else
              pouett =[leniv '-' strtrim(lacat)];
            end
          elseif vg.coless  % UNE CAT, COLORE ESSAIS
          	leniv =Leniv(1:min(length(Leniv), 8));
            if and(vg.colcan, gr.xy)
              pouett =['(' leniv ') T' num2str(Ofich.Lestri(ligne,1)) '-' hdchnl.adname{can} ' Vs ' hdchnl.adname{canx}];
            elseif vg.colcan
              pouett =['(' leniv ') T' num2str(Ofich.Lestri(ligne,1)) '-' hdchnl.adname{can}];
            else
              pouett =['(' leniv ') T' num2str(Ofich.Lestri(ligne,1))];
            end
          else              % UNE CAT, NE COLORE PAS ESSAIS
          	leniv =Leniv(1:min(length(Leniv), 12));
            if and(vg.colcan, gr.xy)
              pouett =['(' leniv ') ' hdchnl.adname{can} ' Vs ' hdchnl.adname{canx}];
            elseif vg.colcan
              pouett =['(' leniv ') ' hdchnl.adname{can}];
            else
              pouett =[Leniv(1:min(length(Leniv), 5)); '-'];
            end
          end
        elseif vg.coless    % ESSAIS SÉLECTIONNÉES PAR CAT
          lessai =vg.lesess{Ofich.Lestri(ligne,1)};
          if and(vg.colcan, gr.xy)
            pouett =[lessai ':' hdchnl.adname{can} ' Vs ' hdchnl.adname{canx}];
          elseif vg.colcan
            pouett =strcat(lessai,':',hdchnl.adname{can});
          else
            pouett =strtrim(lessai);
          end
        elseif vg.colcan
          if gr.xy
            pouett =[hdchnl.adname{can} ' Vs ' hdchnl.adname{canx}];
          else
            pouett =hdchnl.adname{can};
          end
        end
        curlc =length(pouett);
        if curlc > long_champ
          pouett =pouett(1:long_champ);
        end
        gr.lalegend{V} =pouett;

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end

    %---------------------------------------
    % Fonction pour afficher une ligne titre
    % et une ligne de status.
    %----------------------------
    function ecriinfo(obj, Ofich)
      try
        gr =Ofich.Gr;
        vg =Ofich.Vg;
        hdchnl =Ofich.Hdchnl;
        test1 =hdchnl.rate(Ofich.Lestri(1,6),Ofich.Lestri(1,1));
        test2 =Ofich.Lestri(1,6);
        if gr.xy
          test3 =hdchnl.rate(Ofich.Lestri(1,7),Ofich.Lestri(1,1));
          test4 =Ofich.Lestri(1,7);
          if not(test1 == test3)
            test1 =0;
          end
        end
        for i =2:size(Ofich.Lestri,1)
          if test1 ~= hdchnl.rate(Ofich.Lestri(i,6),Ofich.Lestri(i,1))
            test1 =0;
          end
          if test2 ~= Ofich.Lestri(i,6)
            test2 =0;
          end
          if gr.xy
            if test3 ~= hdchnl.rate(Ofich.Lestri(i,7),Ofich.Lestri(i,1))
              test1 =0;
            end
            if test3 ~= Ofich.Lestri(i,7)
              test2 =0;
            end
          end
        end
        if gr.xy
          texte =['Canaux Y Vs Canaux X'];
          if test2
            texte =[hdchnl.adname{Ofich.Lestri(1,6)} ' Vs ' hdchnl.adname{Ofich.Lestri(1,7)}];
          end
        else
          texte =['Canaux Vs le temps'];
          if test2
            texte =[hdchnl.adname{Ofich.Lestri(1,6)} ' Vs le temps'];
          end
        end
        if test1 % même fréquence d'échantillonage
          texte =[texte, ' (', num2str(hdchnl.rate(Ofich.Lestri(1,6),Ofich.Lestri(1,1))), ' Hz)'];
        end
        title(obj.Lax, texte);
        if vg.affniv
        	if vg.toucan
            gr.comment =strcat(gr.comment, '/Tous les canaux');
          elseif size(Ofich.Lestri,1) == 1
            onvaou =(Ofich.Lestri(1,1)-1)*vg.nad +Ofich.Lestri(1,6);
            gr.comment =hdchnl.comment{onvaou};
          else
          	gr.comment =strcat(gr.comment, '/', Ofich.Info.prenom);
          end
          if vg.letemps
            gr.comment =[gr.comment '/[(' Ofich.Tpchnl.Dato{vg.letemps}.nom ')]'];
          end
        else
          gr.comment=' ';
          if vg.toutri
            if vg.toucan
              gr.comment =strcat('Tous les canaux et tous les essais /', gr.comment);
            else
              gr.comment =strcat('Tous les essais /', gr.comment);
            end
          elseif vg.toucan
            gr.comment =strcat('Tous les canaux /', gr.comment);
          elseif size(Ofich.Lestri,1) == 1
            onvaou =(Ofich.Lestri(1,1)-1)*vg.nad +Ofich.Lestri(1,6);
            gr.comment =hdchnl.comment{onvaou};
          else
            gr.comment =Ofich.Info.prenom;
          end
          if vg.letemps
            gr.comment =[ '[(',Ofich.Tpchnl.Dato{vg.letemps}.nom,')]',gr.comment ];
          end
        end
        obj.commentaire(gr.comment);

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end

    end
    %
  end
end

%
%  STRUCTURE LESTRI(1, N)
%
%      1      2       3      4        5        6      7     8
%    essai couleur légende niveau catégorie canalY canalX handle
%
%
%  STRUCTURE GR.LESCATS
%  niveau NbDeCAtChoisi Numérocat1 Numérocat2 ... NumérocatNbDeCAtChoisi
%
%
%  Si on colore les can: vg.colcan = 1
%  Si on colore les ess: vg.coless = 1
%  Si on colore les cat: vg.colcat = 1
%
%
