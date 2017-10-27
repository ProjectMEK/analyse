%
% classdef CBatchEditExecParam < handle
%
% METHODS
%         varargout = creerNouvelAction(tO)
%                 L = genereListAction(tO)
%                     effaceTouteAction(tO)
%                     effaceAction(tO,N)
%
classdef CBatchEditExecParam < handle

  properties
      % utile � long terme
      ver =1.01;
      % nombre d'espace � ajouter dans le journal "pour faire beau"
      S =0;
      % Info sur les fichiers � traiter
      Nfich =0;
      listFichIN ={'aucun fichier � traiter'};
      % Info sur les fichiers de sortie
      listFichOUT =[];
      % Info sur les actions
      % Liste des actions possibles
      listChoixActions =[];
      % liste des handles des CAction s�lectionn�es
      listAction =[];
      % nombre d'actions s�lectionn�es
      Naction =0;
      % liste de fichier virtuel (il doit y en avoir autant qu'il y a d'action)
      listFichVirt =[];
      % fichier virtuel de travail
      tmpFichVirt =CFichierVirtuel();
      % fichier en traitement
      curFich =[];

      %
      status =0;
      erreur =0;
      Path =pwd;
      ChoixEntree =1;
      ChoixSortie =4;
      isFichierIn =0;
      isFichierOut =0;
      exten ='.mat';
      tot =0;
      elno =0;
      tacfic =1;
      tach =[];
  end  %properties

  methods

    %-------------------------------------------------
    % Cr�ation d'un nouvel objet CAction et ajout de son handle dans la liste tO.listAction.
    % Aussi, cr�ation d'un fichier virtuel et ajout dans la liste tO.listFichVirt
    % En ENtr�e: on veut le nom de l'action
    % En Sortie: on retourne le handle de l'objet cr��
    %-------------------------------------------------
    function varargout = creerNouvelAction(tO,nom)
      % v�rification si le nom existe et quelle classe lui est associ�e
      [nAct,cAct] =infoActions(nom);
      if ~isempty(nAct)
        % le nom existe alors on cr�e un objet CAction en lui passant le nom et la classe
        tO.listAction{end+1} =CAction(nAct,cAct);
        % on met � jour la propri�t� Naction
        tO.Naction =length(tO.listAction);
        % cr�ation d'un fichier virtuel et ajout dans la liste
        tO.listFichVirt{end+1} =CFichierVirtuel();
        if nargout > 0
          varargout{1} =tO.listAction{end};
        end
      else
        for U =1:nargout
          varargout{U} =[];
        end
      end
    end

    % G�n�r� la liste des actions s�lectionn�es
    %------------------------------------------
    function L = genereListAction(tO)
      L ={' '};
      for U =1:length(tO.listAction)
        L{U} =tO.listAction{U}.description;
      end
    end

    %-----------------------------
    % Delete toutes les actions
    %-----------------------------
    function effaceTouteAction(tO)
      if ~isempty(tO.listAction)
        N =length(tO.listAction);
        for U =N:-1:1
          tO.effaceAction(U);
        end
      end
    end

    %-----------------------------------------------
    % Delete une action par son num�ro dans la liste
    %-----------------------------------------------
    function effaceAction(tO,N)
      if length(tO.listAction) >= N
        % on efface l'objet correspondant � l'action N
        delete(tO.listAction{N});
        % on vide la liste en cons�quence
        tO.listAction(N) =[];
        % on r�-ajuste le nombre d'action dans la liste
        tO.Naction =length(tO.listAction);
        % on efface le fichier virtuel correspondant
        delete(tO.listFichVirt{N});
        % on vide la liste en cons�quence
        tO.listFichVirt(N) =[];
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en remontant la Ni�me
    % dans la listbox (si elle �tait 3, elle devient 2)
    %--------------------------------------------------
    function remonte(tO,N)
      if N > 1
        foo =tO.listAction{N-1};
        tO.listAction{N-1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en descendant la Ni�me
    % dans la listbox (si elle �tait 2, elle devient 3)
    %--------------------------------------------------
    function redescend(tO,N)
      if N < tO.Naction
        foo =tO.listAction{N+1};
        tO.listAction{N+1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------------
    % V�rification si toutes les actions ont �t� configur�es.
    % En sortie  cOk --> true o false
    %--------------------------------------------------------
    function cOk = isActionsPretes(tO)
      cOk =true;
      for U =1:tO.Naction
        cOk =(cOk && tO.listAction{U}.pret);
      end
    end

    %------------------------------------------------
    % On v�rifie la liste des fichiers � traiter
    % Si elle n'existe pas, on la cr�e
    % En sortie K  --> 0 si elle ne peut �tre cr��
    %                  1 si il y a au moins 1 fichier
    %------------------------------------------------
    function K = verifieListFichierIn(tO)
      if tO.Nfich == 0
        tO.fabricListFichierIn();
      end
      K =(tO.Nfich > 0);
    end

    %-----------------------------------------------
    % On fabrique la liste des fichiers � traiter
    % Devrait �tre "overload�" par une classe Parent
    %-----------------------------------------------
    function fabricListFichierIn(tO,FIN)
      % on laisse les parents s'en occuper...
    end

    %----------------------------------------------------------------------
    % On v�rifie si les actions ant�rieures � A sont toutes pr�tes.
    % En entr�e   A  --> le num�ro de l'action � v�rifier
    % En sortie cOK  --> true si les actions ant�rieures sont toutes pr�tes
    %----------------------------------------------------------------------
    function cOK = isActionAvantPret(tO,A)
      cOK =true;
      for U =1:A-1
        cOK =(cOK && tO.listAction{U}.pret);
      end
    end

    %---------------------------------------------------------------------
    % Mise � Z�ro(false) de la valeur de la propri�t� "pret" pour toutes
    % les actions suivantes incluant la courante.
    % En entr�e   A  --> le num�ro de l'action � modifier (par d�faut = 1)
    %---------------------------------------------------------------------
    function mazPret(tO,A)
      % si A n'est pas d�fini, il sera �gal � 1
      if ~exist('A')
        A =1;
      elseif A == 0
        A =1;
      end
      for U =A:tO.Naction
        tO.listAction{U}.pret =false;
      end
    end

    %---------------------------------------------------------------
    % on retourne le fichier virtuel de r�f�rence et celui de sortie
    % En entr�e       V  --> num�ro de l'action s�lectionn�e
    % En sortie  retour  --> true si il n'y a pas d'erreur
    %---------------------------------------------------------------
    function retour = setTmpFichVirt(tO, V)
      % initialisation des variables de sortie
      retour =false;
      % on v�rifie si la liste des fichiers existe
      if tO.verifieListFichierIn()
      	% laref va contenir le fichier temporaire de travail
      	laref =tO.tmpFichVirt;
      	if V == 1
      	  % si on traite la 1�re action, on relie le fichier analyse
      	  laref.lire(tO.listFichIN{1});
        else
          % autrement, laref sera une copie du fichier virtuel pr�c�dent
          prec =tO.listFichVirt{V-1};
          prec.reClone(laref);
        end
        retour =true;
      end

    end

    %-----------------------------------------------------
    % C'est ici que l'on g�re les travaux en batch
    % En entr�e  hJ  --> handle du journal de bord
    %
    % - Une boucle pour passer chacun des fichiers � faire
    % - Puis une pour chacune des actions
    %-----------------------------------------------------
    function tournezLaManivelle(tO,hJ)
      J.ajouter('Tout semble conforme, d�but du travail sur les fichiers.',tO.S);
      tO.S =tO.S+2;
      % boucle pour les fichiers
      for U =1:tO.Nfich
        % ouverture du fichier U
        tO.ouvrirFichier(U);
      end
    end

    %----------------------------------------------------------------
    % Ouverture d'un fichier Analyse pour le travail en batch
    % On va n�gliger tout les aspect affichage dans le GUI principale
    % En entr�e  N  --> num�ro du fichier dans la liste
    %----------------------------------------------------------------
    function ouvrirFichier(tO,N)
      % On v�rifie si les fichiers d'entr�es et sortie sont identique
      if ~strcmpi(tO.listFichIN{N},tO.listFichOUT{N})
        % si non, on s'assure que le path de sortie existe
        [a,b,c] =fileparts(tO.listFichOUT{N});
        if ~isdir(a)
          % cr�ation du path de sortie
          mkdir(a);
        end
        % on va copier le fichier source dans le fichier destination pour le travail
        copyfile(tO.listFichIN{N},tO.listFichOUT{N},'f');
      end
      % maintenant on ouvre le "fichier de sortie"
      tO.curFich =ouvreFichBatch(tO.listFichOUT{N});
    end

  end  % methods

end
