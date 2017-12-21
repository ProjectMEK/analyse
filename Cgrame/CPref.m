%
% Classe CPref                      Explication des pr�f en dessous
%                                   de la classe.
% Gestion des pr�f�rences
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
    %  Les "properties" de cette classe seront sauvegard�es en tant que
    %  pr�f�rences d'une session � l'autre (dans le fichier grame.mat).
    %
    %  Si on ajoute ou enl�ve des properties, il faut modifier en
    %  cons�quence la properties: listProp
    %  (car les access sont protected)
    %-------------------------------------------------------------------

    conserver =CEOnOff(0);      % Conserver les pr�f�rences d'une session � l'autre
    langue ='fr.mat';           % fichier pour la langue de travail (dans le dossier "doc")
    maxfr =6;                   % nb max de fichier dans le menu "fichiers r�cents"
    dispError =1;               % affichage des messages d'erreurs

    %____________________________________________________
    %   La variable *Fix d�termine si vous voulez
    %   imposer une valeur au d�marrage. Si coch�, la
    %   variable associ� * gardera la valeur. Si non
    %   coch�, la valeur lors de la derni�re fermeture
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
    ligne =CEOnOff(0);          % Afficher les �chantillons
    colcanFix =CEOnOff(1);      %
    colcan =CEOnOff(1);         % Afficher couleur pour les diff�rents canaux
    colessFix =CEOnOff(1);      %
    coless =CEOnOff(1);         % Afficher couleur pour les diff�rents essais
    colcatFix =CEOnOff(1);      %
    colcat =CEOnOff(0);         % Afficher couleur pour les diff�rentes cat�gories
    legendeFix =CEOnOff(1);     %
    legende =CEOnOff(1);        % Afficher la l�gende
    trichFix =CEOnOff(1);       %
    trich =CEOnOff(0);          % Affichage proportionnel
  end  % properties (SetAccess = protected)

  properties (Constant, Access = protected)
    %
    % Liste de toutes les propri�t�s
    listProp ={'conserver', 'langue', 'maxfr', 'dispError', 'xyFix','xy', 'ptFix', ...
               'pt', 'zoomonoffFix', 'zoomonoff', 'affcoordFix', 'affcoord', ...
               'ligneFix', 'ligne', 'colcanFix', 'colcan', 'colessFix', 'coless', ...
               'colcatFix', 'colcat', 'legendeFix', 'legende', 'trichFix', 'trich'};

    %___________________________________________________________________________
    % Liste des propri�t�s affich� dans un uicontrol
    % et accessible avec get(obj, "Value")
    %---------------------------------------------------------------------------
    lstPropV ={'conserver', 'dispError', 'xyFix','xy', 'ptFix', 'pt', ...
               'zoomonoffFix', 'zoomonoff', 'affcoordFix', 'affcoord', ...                       %
               'ligneFix', 'ligne', 'colcanFix', 'colcan', 'colessFix', 'coless', ...
               'colcatFix', 'colcat', 'legendeFix', 'legende', 'trichFix', 'trich'};

    %___________________________________________________________________________
    % Liste des propri�t�s utiles dans Vg
    %---------------------------------------------------------------------------
    listPropVg ={'xy', 'pt', 'zoomonoff', 'affcoord', 'ligne', 'colcan', 'coless', 'colcat', 'legende', 'trich'};

    %___________________________________________________________________________
    % Liste des propri�t�s affich� dans une bo�te
    % texte et qui ont une valeur num�rique
    %---------------------------------------------------------------------------
    lstPropN ={'maxfr'};

    %___________________________________________________________________________
    % Liste des propri�t�s affich� dans une bo�te
    % texte et qui sont une cha�ne de caract�res
    %---------------------------------------------------------------------------
    lstPropT ={'langue'};

  end  % properties (Constant, Access = protected)

  methods

    %---------------------------------------------
    % Mise � jour des propri�t�s � partir de "a"
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
    % V�rification des propri�t�s qui ont des valeurs "�tendues"
    %-------------------
    function verifie(tO)
      tO.verifieMoi('dispError');
      tO.verifieMoi('pt');
    end

    %----------------------------------------------------------
    % V�rification d'une propri�t� qui a des valeurs "�tendues"
    % laquelle  --> nom de la propri�t� � v�rifier.
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
    % on assigne les valeurs globales � Vg
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
    % on assigne les valeurs globales par d�faut � Vg
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
    % De cette fa�on, � l'ouverture on aura qu'� mixer avec *Fix
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
      if vg.zoomonoff; cur =bitset(cur, 4, 1);  end     % (d�-)activer le zoom
      if vg.ligne;     cur =bitset(cur, 5, 1);  end     % affichage des �chantillons
      if vg.colcan;    cur =bitset(cur, 6, 1);  end     % affichage des couleurs pour canaux
      if vg.coless;    cur =bitset(cur, 7, 1);  end     % affichage des couleurs pour essais
      if vg.colcat;    cur =bitset(cur, 8, 1);  end     % affichage des couleurs pour cat�go
      if vg.legende;   cur =bitset(cur, 9, 1);  end     % affichage de la l�gende
      if vg.trich;     cur =bitset(cur, 10, 1); end     % affichage de la l�gende
      if vg.affcoord;  cur =bitset(cur, 11, 1); end     % (d�-)activer l'affichage des coord
    end

    %----------------------------------------
    % on mixe la variable vg.affiche avec les
    % propri�t�s *.Fix
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
    % avec les propri�t�s de "tO"
    %---------------------------
    function val =getObjData(tO)
      val =CPref();
      for U =1:length(tO.listProp)
        val.(tO.listProp{U}) =tO.(tO.listProp{U});
      end
    end  %getObjData

    %---------------------------------------
    % Retourne une structure dont les champs
    % sont les propri�t�s de "tO"
    %------------------------
    function val =getData(tO)
      for U =1:length(tO.listProp)
        val.(tO.listProp{U}) =tO.(tO.listProp{U});
      end
    end  %getData

    %---------------------------------
    % SETTER pour certaines propri�t�s
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
    % on ajoute/modifi les propri�t�s de tO
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
    % on ajoute/modifi les propri�t�s de tO
    % avec les propri�t�s de l'objet CPref "v"
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
%  Fonctionnement/gestion des pr�f�rences
%  
%  --------------
%  � l'ouverture
%  --------------
%    -  On load les pr�f  (A1)
%    -  On les applique � l'ouverture des fichiers  (A2)
%  
%         -------------
%    (A1) Lors du load
%         -------------
%         - Si grame.mat n'existe pas           \
%         - Si grame.mat n'est pas compatible    |--> On applique les pr�f par d�faut
%         - Si CPref.conserver = false          /       (Vg.affiche = 790 --> bin(1100010110) )
%         
%         - Si grame.mat est r�gulier            |--> On applique les CPref.*
%         - Si CPref.conserver =true             |--> On fait suivre dans Vg.affiche
%         
%         -----------------------
%    (A2) Ouverture des fichiers
%         -----------------------
%         - On applique Vg.affiche sur vg
%
%  ---------------
%  � la fermeture
%  ---------------
%    - Si CPref.conserver = false  --> delete(grame.mat)
%    
%    - Else on sauvegarde Vg.affiche avec les valeurs courantes
%           et les CPref.*
%
%