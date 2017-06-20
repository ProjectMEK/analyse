%
% Classe CAnalyse       (Sealed)
%
% CAnalyse est le squelette d'Analyse.
%
% Une classe SINGLETON,
%   donc une seule instance possible. Pour r�cup�rer le handle
%   de l'objet existant (ou en cr�er un premier) :
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
    couleur =[];          % cellule contenant l'ordre des couleurs pour l'affichage de courbes
    Fic =[];              % handle sur un objet CFic()
    Vg =[];               % handle sur un objet CVgBase()
    laPosXY =[];
    Hautaxe =[];          % hauteur initial de l'axe
    OFig =[];             % Handle de l'object CDessine
    OPG =[];              % handle sur l'objet CParamGlobal()
  end  %properties

  methods (Access =private)

    %------------
    % CONSTRUCTOR
    %--------------------
    function tO =CAnalyse
      try
        tO.OPG =CParamGlobal.getInstance();
        tO.Fic =CFic();
        tO.Fic.pref =CPref();
        tO.Vg =CVgBase();
        tO.couleur{1} =['b-';'k-';'r-';'g-';'c-';'m-';'y-';'b:';'k:';'c:';'r:';'g:';'m:';'y:'];
        tO.couleur{2} =['+b-';'+k-';'+r-';'+g-';'+c-';'+m-';'+y-';'+b:';'+k:';'+c:';'+r:';'+g:';'+m:';'+y:'];
      catch K;
        CQueEsEsteError.dispOct(K);
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
      delete(tO.OPG);
      tO.OPG =[];
      delete(tO.Fic);
      tO.Fic =[];
      delete(tO.Vg);
      tO.Vg =[];
      if ~isempty(tO.OFig)
        delete(tO.OFig);
      end
    end

    %------------------------------------------------
    % Pour supprimer un objet qui controle une figure
    % quand on clique sur le X en haut � droite
    %---------------------------------
    function DelCurObj(tO, src, event)
      V =get(src, 'UserData');     % peut �tre le handle d'un objet
      if ~isempty(V)
        delete(V);
        delete(src);
      end
    end

    %________________________________________________
    % Pour supprimer un objet qui controle une figure
    % il doit avoir une propri�t�: thatObj.fig
    %--------------------------------------
    function delFigTravailFini(tO, thatObj)
      if ~isempty(thatObj)
        set(tO.OFig.fig, 'WindowButtonMotionFcn',{@CValet.GarbageCollector, thatObj});
        set(thatObj.fig, 'WindowStyle','normal', 'Visible','off');
      end
    end

    %____________________________
    % Application des pr�f�rences
    %----------------------------------
    function initLesPreferencias(tO, p)
      try

        if ~isempty(p)
          % Le fichier "grame.mat" avait du contenu
          if isfield(p, 'pref')
            % il contient les info CPref
            if isfield(p.pref, 'conserver') && p.pref.conserver
              % on avait coch� "garder les pref"
              % On met � jour les prop rattach� � Analyse
          	  tO.Fic.pref.maj(p.pref);
          	  tO.finInitLesPreferencias(p);
              tO.Vg.affiche =tO.Fic.pref.initVarAffiche(tO.Vg);
              tO.initLesPreferenciasGlobal();
            end
            % else on n'avait pas coch� "garder les pref"
              %_____________________________________
              % On garde les valeurs par d�faut pour
              % toutes les pr�f�rences.
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
          % Le fichier "grame.mat" n'existait pas ou n'�tait pas lisible.
          % On garde les valeurs par d�faut pour toutes les pr�f�rences.
          %----------------------------------------------------------------
        end

      catch Me
        rethrow(Me);
      end

    end

    %_______________________________________
    % Ici on met � jour les fichiers r�cents
    % et aussi les param�tres d'affichages graphiques
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
    % Application des pr�f�rences globales
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
    % Mise � jour du fichier courant
    % EN ENTR�E on a  OFi --> un objet de la classe CLiranalyse
    %--------------------------
    function majcurfich(tO,OFi)
      try
        % Mise � jour de curfich
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

      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %--------------------------------------
    % retourne le Handle du fichier courant
    %--------------------------
    function F =findcurfich(tO)
      F =tO.Fic.hfich{tO.Fic.curfich};
    end

    %_______________________________________________
    % � la fin du processus d'ouverture d'un fichier
    % on passe par cette fonction peu importe le type
    % de fichier � ouvrir
    % EN ENTR�E on a  OFi --> un objet de la classe CLiranalyse
    %-----------------------------
    function finaliseLect(tO, OFi)
      try
        tO.Vg.mazero();
        tO.Fic.nf =tO.Fic.nf+1;
        tO.Fic.curfich =tO.Fic.nf;
        tO.Fic.hfich{tO.Fic.nf} =OFi;
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %___________________________________
    % � l'ouverture d'un nouveau fichier
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
    % on affiche un autre fichier parmi la s�lection
    % des fichiers ouverts, on doit mettre en veille
    % (background) le fichier qui �tait actif.
    %---------------------
    function AuSuivant(tO)
      % hvF --> handle vieux fichier
      hvF =tO.Fic.hfich{tO.Fic.lastfich};
      hvF.AuSuivant();
    end

    %-------------------------------------------
    % Suite � l'ouverture d'un fichier, On met �
    % jour la liste des derniers fichiers ouverts
    %----------------------
    function fichrecent(tO)
      tO.Fic.majFichRecent();
    end

    %--------------------------------------
    % lors des sauvegarder-sous, v�rifie si
    % le nom de fichier est d�j� ouvert
    % Retourne true si le fichier est d�j� ouvert
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
    % Ex�cute "sauvegarder-sous" pour
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
      try
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
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %--------------------------
    % Fermer le fichier courant
    % Appel� par un Callback
    %--------------------------------
    function fermerfich(tO,src,event)
      tO.fermecur();
    end

    %-------------------------------
    % sauvegarder le fichier courant
    % Appel� par un Callback
    %--------------------------------
    function sauverfich(tO,src,event)
      tO.sauvecur();
    end

    %------------------------------------
    % sauvegarder-sous le fichier courant
    % Appel� par un Callback
    %--------------------------------
    function sauversousfich(tO,src,event)
      tO.sauvecursous();
    end

  end  % methods
end % classdef
