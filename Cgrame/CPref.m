%
% Classe CPref                      Explication des préf en dessous
%                                   de la classe.
% Gestion des préférences
%
% METHODS
%            assignePrefaVg(tO, vg)
%      val = getData(tO)
%      val = getObjData(tO)
%            imposePrefaVg(tO, vg)
%      cur = initVarAffiche(tO, vg)
%            maj(tO, a)
%      cur = prepareVarAffiche(tO, vg)
%            setConserver(tO, val)
%            setDispError(tO, val)
%            setMaxfr(tO, val)
%            setPt(tO, val)
%            verifie(tO)
%            verifieMoi(tO, laquelle)
%
% METHODS (Access = private)
%            appendCPref(tO, v)
%            appendStruct(tO, v)
%
classdef CPref < handle

  properties (SetAccess = protected)
    %-------------------------------------------------------------------
    %  Les "properties" de cette classe seront sauvegardées en tant que
    %  préférences d'une session à l'autre (dans le fichier grame.mat).
    %
    %  Si on ajoute ou enlève des properties, il faut modifier en
    %  conséquence la properties: listProp
    %  (car les access sont protected)
    %-------------------------------------------------------------------

    conserver =CEOnOff(0);      % Conserver les préférences d'une session à l'autre
    langue ='fr.mat';           % fichier pour la langue de travail (dans le dossier "doc")
    maxfr =6;                   % nb max de fichier dans le menu "fichiers récents"
    dispError =1;               % affichage des messages d'erreurs

    %____________________________________________________
    %   La variable *Fix détermine si vous voulez
    %   imposer une valeur au démarrage. Si coché, la
    %   variable associé * gardera la valeur. Si non
    %   coché, la valeur lors de la dernière fermeture
    %   est prise en compte.
    %----------------------------------------------------

    xyFix =CEOnOff(1);          %
    xy =int8(0);                % Afficher le Mode XY
    ptFix =CEOnOff(1);          %
    pt =int8(2);                % Affichage des points
    zoomonoffFix =CEOnOff(1);   %
    zoomonoff =CEOnOff(1);      % Zoom actif/inactif
    affcoordFix =CEOnOff(1);    %
    affcoord =CEOnOff(0);       % Afficher Coord actif/inactif
    ligneFix =CEOnOff(1);       %
    ligne =CEOnOff(0);          % Afficher les échantillons
    colcanFix =CEOnOff(1);      %
    colcan =CEOnOff(1);         % Afficher couleur pour les différents canaux
    colessFix =CEOnOff(1);      %
    coless =CEOnOff(1);         % Afficher couleur pour les différents essais
    colcatFix =CEOnOff(1);      %
    colcat =CEOnOff(0);         % Afficher couleur pour les différentes catégories
    legendeFix =CEOnOff(1);     %
    legende =CEOnOff(1);        % Afficher la légende
    trichFix =CEOnOff(1);       %
    trich =CEOnOff(0);          % Affichage proportionnel
  end  % properties (SetAccess = protected)

  properties (Constant, Access = protected)
    %
    % Liste de toutes les propriétés
    listProp ={'conserver', 'langue', 'maxfr', 'dispError', 'xyFix','xy', 'ptFix', ...
               'pt', 'zoomonoffFix', 'zoomonoff', 'affcoordFix', 'affcoord', ...
               'ligneFix', 'ligne', 'colcanFix', 'colcan', 'colessFix', 'coless', ...
               'colcatFix', 'colcat', 'legendeFix', 'legende', 'trichFix', 'trich'};

    %___________________________________________________________________________
    % Liste des propriétés affiché dans un uicontrol
    % et accessible avec get(obj, "Value")
    %---------------------------------------------------------------------------
    lstPropV ={'conserver', 'dispError', 'xyFix','xy', 'ptFix', 'pt', ...
               'zoomonoffFix', 'zoomonoff', 'affcoordFix', 'affcoord', ...                       %
               'ligneFix', 'ligne', 'colcanFix', 'colcan', 'colessFix', 'coless', ...
               'colcatFix', 'colcat', 'legendeFix', 'legende', 'trichFix', 'trich'};

    %___________________________________________________________________________
    % Liste des propriétés utiles dans Vg
    %---------------------------------------------------------------------------
    listPropVg ={'xy', 'pt', 'zoomonoff', 'affcoord', 'ligne', 'colcan', 'coless', 'colcat', 'legende', 'trich'};

    %___________________________________________________________________________
    % Liste des propriétés affiché dans une boîte
    % texte et qui ont une valeur numérique
    %---------------------------------------------------------------------------
    lstPropN ={'maxfr'};

    %___________________________________________________________________________
    % Liste des propriétés affiché dans une boîte
    % texte et qui sont une chaîne de caractères
    %---------------------------------------------------------------------------
    lstPropT ={'langue'};

  end  % properties (Constant, Access = protected)

  methods

    %---------------------------------------------
    % Mise à jour des propriétés à partir de "a"
    % a  --> structure ou objet de la classe CPref
    %---------------------------------------------
    function maj(tO, a)
      if isa(a,'struct')
        tO.appendStruct(a);
      elseif isa(a,'CPref')
        tO.appendCPref(a);
      else
        error('GRAME:CPref:maj','Erreur de Type, on attend une Struct ou une CPref');
      end
      tO.verifie();
    end

    %-----------------------------------------------------------
    % Vérification des propriétés qui ont des valeurs "étendues"
    %-------------------
    function verifie(tO)
      tO.verifieMoi('dispError');
      tO.verifieMoi('pt');
    end

    %----------------------------------------------------------
    % Vérification d'une propriété qui a des valeurs "étendues"
    % laquelle  --> nom de la propriété à vérifier.
    %--------------------------------
    function verifieMoi(tO, laquelle)
      switch laquelle
      case 'dispError'
        if tO.dispError < 0 || tO.dispError > 3
          tO.dispError =2;
        end
      case 'pt'
        if tO.pt < 0 || tO.pt > 2
          tO.pt =0;
        end
      end
    end

    %--------------------------------------
    % Lorsque l'on ouvre un nouveau fichier
    % et que tO.conserver == true
    % on assigne les valeurs globales à Vg
    % ou vg --> handle CVgFichier
    %------------------------------
    function assignePrefaVg(tO, vg)
      N =length(tO.listPropVg);
      for U =1:N
        if tO.([tO.listPropVg{U} 'Fix'])
          vg.(tO.listPropVg{U}) =tO.(tO.listPropVg{U});
        end
      end
    end

    %--------------------------------------
    % Lorsque l'on ouvre un nouveau fichier
    % et que tO.conserver == false
    % on assigne les valeurs globales par défaut à Vg
    % ou vg --> handle CVgFichier
    %-----------------------------
    function imposePrefaVg(tO, vg)
      N =length(tO.listPropVg);
      foo =CPref();
      for U =1:N
        vg.(tO.listPropVg{U}) =foo.(tO.listPropVg{U});
      end
      delete(foo);
    end

    %------------------------------------------------
    % On retourne les valeurs active avant de fermer.
    % De cette façon, à l'ouverture on aura qu'à mixer avec *Fix
    %--------------------------------------
    function cur =prepareVarAffiche(tO, vg)
      cur =uint16(0);
      if vg.xy
        cur =bitset(cur, 1, 1);
      end
    	switch vg.pt
    	case 1
        cur =bitset(cur, 2, 1);
      case 2
        cur =bitset(cur, 3, 1);
      end
      %-------------------------
      if vg.zoomonoff; cur =bitset(cur, 4, 1);  end     % (dé-)activer le zoom
      if vg.ligne;     cur =bitset(cur, 5, 1);  end     % affichage des échantillons
      if vg.colcan;    cur =bitset(cur, 6, 1);  end     % affichage des couleurs pour canaux
      if vg.coless;    cur =bitset(cur, 7, 1);  end     % affichage des couleurs pour essais
      if vg.colcat;    cur =bitset(cur, 8, 1);  end     % affichage des couleurs pour catégo
      if vg.legende;   cur =bitset(cur, 9, 1);  end     % affichage de la légende
      if vg.trich;     cur =bitset(cur, 10, 1); end     % affichage de la légende
      if vg.affcoord;  cur =bitset(cur, 11, 1); end     % (dé-)activer l'affichage des coord
    end

    %----------------------------------------
    % on mixe la variable vg.affiche avec les
    % propriétés *.Fix
    %-----------------------------------
    function cur =initVarAffiche(tO, vg)
      cur =uint16(vg.affiche);
      if tO.xyFix
        cur =bitset(cur, 1, tO.xy);
      end
      if tO.ptFix
        cur =bitset(cur, 2, 0);
        cur =bitset(cur, 3, 0);
    	  switch tO.pt
      	case 1
          cur =bitset(cur, 2, 1);
        case 2
          cur =bitset(cur, 3, 1);
        end
      end
      if tO.zoomonoffFix
        cur =bitset(cur, 4, tO.zoomonoff);
      end
      if tO.ligneFix
        cur =bitset(cur, 5, tO.ligne);
      end
      if tO.colcanFix
        cur =bitset(cur, 6, tO.colcan);
      end
      if tO.colessFix
        cur =bitset(cur, 7, tO.coless);
      end
      if tO.colcatFix
        cur =bitset(cur, 8, tO.colcat);
      end
      if tO.legendeFix
        cur =bitset(cur, 9, tO.legende);
      end
      if tO.trichFix
        cur =bitset(cur, 10, tO.trich);
      end
      if tO.affcoordFix
        cur =bitset(cur, 11, tO.affcoord);
      end
    end

    %-------------------------------
    % Retourne un nouvel objet CPref
    % avec les propriétés de "tO"
    %---------------------------
    function val =getObjData(tO)
      val =CPref();
      for U =1:length(tO.listProp)
        val.(tO.listProp{U}) =tO.(tO.listProp{U});
      end
    end  %getObjData

    %---------------------------------------
    % Retourne une structure dont les champs
    % sont les propriétés de "tO"
    %------------------------
    function val =getData(tO)
      for U =1:length(tO.listProp)
        val.(tO.listProp{U}) =tO.(tO.listProp{U});
      end
    end  %getData

    %---------------------------------
    % SETTER pour certaines propriétés
    %-----------------------------
    function setConserver(tO, val)
      tO.conserver =val;
    end

    %-------------------------
    function setMaxfr(tO, val)
      tO.maxfr =val;
    end

    %-----------------------------
    function setDispError(tO, val)
      tO.dispError =val;
      tO.verifieMoi('dispError');
    end

    %----------------------
    function setPt(tO, val)
      tO.pt =val;
      tO.verifieMoi('pt');
    end

  end % methods

  methods (Access = private)

    %--------------------------------------
    % on ajoute/modifi les propriétés de tO
    % avec les champs de la structure "v"
    %---------------------------
    function appendStruct(tO, v)
      for U =1:length(tO.listProp)
        if isfield(v, tO.listProp{U})
          tO.(tO.listProp{U}) =v.(tO.listProp{U});
        end
      end
    end

    %-----------------------------------------
    % on ajoute/modifi les propriétés de tO
    % avec les propriétés de l'objet CPref "v"
    %-----------------------------------------
    function appendCPref(tO, v)
      champ =fieldnames(v);
      for U =1:length(tO.listProp)
        if ismember(tO.listProp{U},champ)
          tO.(tO.listProp{U}) =v.(tO.listProp{U});
        end
      end
    end

  end  % methods (Access = private)
end

%
%  Fonctionnement/gestion des préférences
%  
%  --------------
%  À l'ouverture
%  --------------
%    -  On load les préf  (A1)
%    -  On les applique à l'ouverture des fichiers  (A2)
%  
%         -------------
%    (A1) Lors du load
%         -------------
%         - Si grame.mat n'existe pas           \
%         - Si grame.mat n'est pas compatible    |--> On applique les préf par défaut
%         - Si CPref.conserver = false          /       (Vg.affiche = 790 --> bin(1100010110) )
%         
%         - Si grame.mat est régulier            |--> On applique les CPref.*
%         - Si CPref.conserver =true             |--> On fait suivre dans Vg.affiche
%         
%         -----------------------
%    (A2) Ouverture des fichiers
%         -----------------------
%         - On applique Vg.affiche sur vg
%
%  ---------------
%  À la fermeture
%  ---------------
%    - Si CPref.conserver = false  --> delete(grame.mat)
%    
%    - Else on sauvegarde Vg.affiche avec les valeurs courantes
%           et les CPref.*
%
%