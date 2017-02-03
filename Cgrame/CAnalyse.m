%
% Classe CAnalyse       (Sealed)
%
% CAnalyse est le squelette d'Analyse.
%
% Une classe SINGLETON,
%   donc une seule instance possible. Pour récupérer le handle
%   de l'objet existant (ou en créer un premier) :
%
%   foo = CAnalyse.getInstance()
%
%__________________________
% METHODS (Access =private)
%   tO =CAnalyse     % CONSTRUCTOR
%
% METHODS (Static)
%   sObj =getInstance
%
% METHODS
%        ArretPartiel(tO,src,evnt)
%        AuSuivant(tO)
%        copycan(tO, hF)
%        DelCurObj(tO, src, event)
%        delete(tO)     % DESTRUCTOR
%   Cok =fermecur(tO)
%        fermerfich(tO,src,event)
%        fichrecent(tO)
%     F =findcurfich(tO)
%        finlect(tO, OFi)
%        initial(tO, vernum, vermot, Aqui)
%        initLesPreferencias(tO)
%        initLesPreferenciasGlobal(tO)
%   COk =isfichopen(tO,lenom)
%        majcurfich(tO,OFi)
%        recuperer(tO,src,evnt)
%        sauvecur(tO)
%        sauvecursous(tO)
%        sauverfich(tO,src,event)
%        sauversousfich(tO,src,event)
%
classdef (Sealed) CAnalyse < handle

  properties
    couleur =[];
    Fic =[];
    Vg =[];
    laPosXY =[];
    Hautaxe =[];          % hauteur initial de l'axe
    OFig =[];             % Handle de l'object CDessine
    Gmenu =[];            % Gestionnaire des requêtes du menu
  end  %properties

  methods (Access =private)

    %------------
    % CONSTRUCTOR
    %--------------------
    function tO =CAnalyse
      try
        tO.Fic =CFic();
        tO.Fic.pref =CPref();
        tO.Vg =CVgBase();
        tO.Gmenu =CGmenu(tO);
        tO.couleur{1} =['b-';'k-';'r-';'g-';'c-';'m-';'y-';'b:';'k:';'c:';'r:';'g:';'m:';'y:'];
        tO.couleur{2} =['+b-';'+k-';'+r-';'+g-';'+c-';'+m-';'+y-';'+b:';'+k:';'+c:';'+r:';'+g:';'+m:';'+y:'];
      catch K
        rethrow(K);
      end
    end

  end  % methods (Access =private)

  methods (Static)

    %--------------------------------------------
    % Fonction accessible de partout et par tous.
    % Si aucun objet CAnalyse existe, il appelle le constructeur
    % autrement il retourne le handle sur l'objet existant.
    %-------------------------
    function sObj =getInstance
      persistent localObj;
      if isempty(localObj) || ~isa(localObj, 'CAnalyse')
        localObj =CAnalyse();
      end
      sObj =localObj;
    end

  end  % methods (Static)

  methods

    %-----------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      delete(tO.Fic);
      delete(tO.Vg);
      if ~isempty(tO.Gmenu)
        delete(tO.Gmenu);
      end
      if ~isempty(tO.OFig)
        delete(tO.OFig);
      end
    end

    %------------------------------------------------
    % Pour supprimer un objet qui controle une figure
    % quand on clique sur le X en haut à droite
    %---------------------------------
    function DelCurObj(tO, src, event)
      V =get(src, 'UserData');     % peut être le handle d'un objet
      if ~isempty(V)
        delete(V);
        delete(src);
      end
    end

    %________________________________________________
    % Pour supprimer un objet qui controle une figure
    % il doit avoir une propriété: thatObj.fig
    %--------------------------------------
    function delFigTravailFini(tO, thatObj)
      if ~isempty(thatObj)
        set(tO.OFig.fig, 'WindowButtonMotionFcn',{@CValet.GarbageCollector, thatObj});
        set(thatObj.fig, 'WindowStyle','normal', 'Visible','off');
      end
    end

    %____________________________
    % Application des préférences
    %----------------------------------
    function initLesPreferencias(tO, p)
      try

        if ~isempty(p)
          % Le fichier "grame.mat" avait du contenu
          if isfield(p, 'pref')
            % il contient les info CPref
            if isfield(p.pref, 'conserver') && p.pref.conserver
              % on avait coché "garder les pref"
              % On met à jour les prop rattaché à Analyse
          	  tO.Fic.pref.maj(p.pref);
          	  tO.finInitLesPreferencias(p);
              tO.Vg.affiche =tO.Fic.pref.initVarAffiche(tO.Vg);
              tO.initLesPreferenciasGlobal();
            end
            % else on n'avait pas coché "garder les pref"
              %_____________________________________
              % On garde les valeurs par défaut pour
              % toutes les préférences.
              %-------------------------------------
          else
            %________________________________________
            % Il doit s'agir d'une vieille version du
            % fichier "grame.mat"
            %----------------------------------------
            tO.Fic.pref.setConserver(true);
            tO.finInitLesPreferencias(p);
          end
        % else   if ~isempty(p)
          %________________________________________________________________
          % Le fichier "grame.mat" n'existait pas ou n'était pas lisible.
          % On garde les valeurs par défaut pour toutes les préférences.
          %----------------------------------------------------------------
        end

      catch Me
        rethrow(Me);
      end

    end

    %_______________________________________
    % Ici on met à jour les fichiers récents
    % et aussi les paramètres d'affichages graphiques
    %--------------------------------------------------
    function finInitLesPreferencias(tO, V)
      try
        if isfield(V, 'recent')
          tO.Fic.initFichRecent(V.recent);
        end
        if isfield(V, 'lepath') & isdir(V.lepath)
          tO.Fic.ddir =V.lepath;
        end
        if isfield(V, 'param')
          leparam =V.param;
          tO.Vg.affiche =uint16(leparam(1,1));
          if length(leparam) > 4
            tO.Vg.la_pos =leparam(2:5,1);
          end
        end
      catch Me
        rethrow(Me);
      end
    end

    %_____________________________________
    % Application des préférences globales
    %-------------------------------------
    function initLesPreferenciasGlobal(tO)
      try
        CP =CParamGlobal.getInstance();
        CP.setDispError(tO.Fic.pref.dispError);
      catch Me
        rethrow(Me);
      end
    end

    %---------------------------------------
    % Initialisation de la version d'Analyse
    %-----------------------------------
    function initial(tO, vernum, vermot)
      tO.Fic.laver =vernum;
      tO.Fic.vermot =vermot;
    end

    %-------------------------------
    % Mise à jour du fichier courant
    % EN ENTRÉE on a  OFi --> un objet de la classe CLiranalyse
    %--------------------------
    function majcurfich(tO,OFi)
      % Mise à jour de curfich
      test =0;
      for U =1:tO.Fic.nf
      	if find(tO.Fic.hfich{U}, OFi)
      		test =U;
      		break;
      	end
      end
      if test
        tO.Fic.curfich =test;
      else
      	tO.Fic.nf =tO.Fic.nf+1;
        tO.Fic.curfich =tO.Fic.nf;
        tO.Fic.hfich{tO.Fic.curfich} =OFi;
      end
    end

    %--------------------------------------
    % retourne le Handle du fichier courant
    %--------------------------
    function F =findcurfich(tO)
      F =tO.Fic.hfich{tO.Fic.curfich};
    end

    %_______________________________________________
    % À la fin du processus d'ouverture d'un fichier
    % on passe par cette fonction peu importe le type
    % de fichier à ouvrir
    % EN ENTRÉE on a  OFi --> un objet de la classe CLiranalyse
    %------------------------
    function finlect(tO, OFi)
      vg =OFi.Vg;
      if vg.itype == CFichEnum.analyse
        if vg.laver < tO.Fic.laver
          vg.sauve =true;
        end
      else
        %_______________________________________
        % Pour tous les autres types de fichiers
        % on met la variable vg.sauve à true
        % afin de demander de sauvegarder à la
        % fermeture du fichier.
        %---------------------------------------
        vg.sauve =true;
      end
      tO.copycan(OFi);
      tO.CompVgPref(vg);
      OFi.majchamp();
      tO.Vg.mazero();
      tO.Fic.nf =tO.Fic.nf+1;
      tO.Fic.curfich =tO.Fic.nf;
      tO.Fic.hfich{tO.Fic.nf} =OFi;
      OFi.MnuFid =CMnuFichier(OFi);
    end

    %___________________________________
    % À l'ouverture d'un nouveau fichier
    % on "adjuste" vg en fonction des pref
    %--------------------------
    function CompVgPref(tO, vg)
      if tO.Fic.pref.conserver
        tO.Fic.pref.assignePrefaVg(vg);
      else
        tO.Fic.pref.imposePrefaVg(vg)
      end
    end

    %________________________________________________
    % Lorsque l'on ouvre un nouveau fichier ou encore
    % on affiche un autre fichier parmi la sélection
    % des fichiers ouverts, on doit mettre en veille
    % (background) le fichier qui était actif.
    %---------------------
    function AuSuivant(tO)
      hvF =tO.Fic.hfich{tO.Fic.lastfich};
      hvF.AuSuivant();
    end

    %-------------------------------
    % On copie les canaux du fichier
    % vers un fichier temporaire
    % EN ENTRÉE on a  hF --> un objet de la classe CLiranalyse
    %-----------------------
    function copycan(tO, hF)
      % on vérifie si une waitbar est active
      hwb =findobj('tag','WaitBarLecture');
      TextLocal ='Création du fichier temporaire de travail';
      delwb =false;
      if isempty(hwb)
        delwb =true;
        hwb =waitbar(0.001, TextLocal);
      else
        waitbar(0.001, hwb, TextLocal);
      end

      % Fichier source, vrai fichier
      Fsrc =fullfile(hF.Info.prenom, hF.Info.finame);
      % Fichier destination, fichier temporaire de travail
      Fdst =hF.Info.fitmp;

      ncan =hF.Vg.nad;
      hdchnl =hF.Hdchnl;
      laver ='-V7.3';

    	% nom de la variable du premier canal
    	lenom =hdchnl.cindx{1};
    	% on load le premier canal
    	A =load(Fsrc, lenom);
    	% on le sauve dans le fichier temporaire
    	save(Fdst, '-Struct', 'A', laver);

      % puis on fait la même chose pour les autres canaux
      for U =2:ncan
      	waitbar(0.95*single(U)/single(ncan), hwb);
      	A =[];
      	lenom =hdchnl.cindx{U};
      	A =load(Fsrc, lenom);
      	save(Fdst, '-Struct', 'A', lenom, '-APPEND');
      end

      % Si on a créé un waitbar, on le delete
      if delwb
        delete(hwb);
      end

    end

    %-------------------------------------------
    % Suite à l'ouverture d'un fichier, On met à
    % jour la liste des derniers fichiers ouverts
    %----------------------
    function fichrecent(tO)
      tO.Fic.majFichRecent();
    end

    %--------------------------------------
    % lors des sauvegarder-sous, vérifie si
    % le nom de fichier est déjà ouvert
    % Retourne true si le fichier est déjà ouvert
    %---------------------------------
    function COk =isfichopen(tO,lenom)
      COk =false;
      for U =1:tO.Fic.nf
        if strcmpi(tO.Fic.hfich{U}.Info.foname,lenom)
          COk =true;
          break;
        end
      end
    end

    %------------------------------
    % Sauvegarde le fichier courant
    %--------------------
    function sauvecur(tO)
      set(tO.OFig.fig,'Pointer','custom');
      Ofich =tO.findcurfich();
      test =Ofich.sauver();
      set(tO.OFig.fig,'Pointer','arrow');
    end

    %--------------------------------
    % Exécute "sauvegarder-sous" pour
    % le fichier courant
    %------------------------
    function sauvecursous(tO)
      set(tO.OFig.fig,'Pointer','custom')
      Ofich =tO.findcurfich();
      test =Ofich.sauversous();
      set(tO.OFig.fig,'Pointer','arrow');
    end

    %--------------------------
    % Fermer le fichier courant
    %-------------------------
    function Cok =fermecur(tO)
      Cok =false;
    	fid =tO.findcurfich();
    	vg =fid.Vg;
      a =fid.fermer();
      if ~ a
        return;
      end
      if tO.Fic.nf == 1
        tO.Vg.affiche =tO.Fic.pref.prepareVarAffiche(fid.Vg);
      end
      tO.OFig.choffpan();
      delete(fid);
      tO.Fic.hfich(tO.Fic.curfich) =[];
      tO.Fic.nf =tO.Fic.nf-1;
      tO.Fic.curfich =min(tO.Fic.nf, tO.Fic.curfich);
      if tO.Fic.nf
      	F =tO.Fic.hfich{tO.Fic.curfich};
        tO.OFig.chfichpref(F);
        tO.OFig.chonpan();
        tO.OFig.affiche();
      else
      	tO.OFig.choffmenu();
      end
      Cok =true;
    end

    %--------------------------
    % Fermer le fichier courant
    % Appelé par un Callback
    %--------------------------------
    function fermerfich(tO,src,event)
      tO.fermecur();
    end

    %-------------------------------
    % sauvegarder le fichier courant
    % Appelé par un Callback
    %--------------------------------
    function sauverfich(tO,src,event)
      tO.sauvecur();
    end

    %------------------------------------
    % sauvegarder-sous le fichier courant
    % Appelé par un Callback
    %--------------------------------
    function sauversousfich(tO,src,event)
      tO.sauvecursous();
    end

  end  % methods
end % classdef
