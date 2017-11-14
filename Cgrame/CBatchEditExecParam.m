%
% classdef CBatchEditExecParam < handle
%
% METHODS
%                 V = prepareInfoBatch(tO)
%                     ecraseInfoBatch(tO, V)
%                     onVide(tO)
%         varargout = creerNouvelAction(tO,nom)
%                 L = genereListAction(tO)
%                     effaceTouteAction(tO)
%                     effaceAction(tO,N)
%                     remonte(tO,N)
%                     redescend(tO,N)
%               cOk = isActionsPretes(tO)
%                 K = verifieListFichierIn(tO)
%                     fabricListFichierIn(tO,FIN)     à être défini par le parent
%               cOK = isActionAvantPret(tO,A)
%                     mazPret(tO,A)
%            retour = setTmpFichVirt(tO, V)
%                     tournezLaManivelle(tO,hJ)
%            reussi = ouvrirFichier(tO,N)
%
classdef CBatchEditExecParam < handle

  properties
      % utile à long terme
      ver =1.01;
      % nombre d'espace à ajouter dans le journal "pour faire beau"
      S =0;
      % Info sur les fichiers à traiter
      Nfich =0;
      listFichIN ={'aucun fichier à traiter'};
      % Info sur les fichiers de sortie
      listFichOUT =[];
      % Path du fichier de sortie
      pathOUT =[];
      % Info sur les actions
      % Liste des actions possibles
      listChoixActions =[];
      % liste des handles des CAction sélectionnées
      listAction =[];
      % nombre d'actions sélectionnées
      Naction =0;
      % liste de fichier virtuel (il doit y en avoir autant qu'il y a d'action)
      listFichVirt =[];
      % fichier virtuel de travail
      tmpFichVirt =CFichierVirtuel();
      % fichier en traitement
      curFich =[];
      %
  end % properties

  methods

    %-------------------------------------------------------------
    % On prépare les infos afin de les sauvegarder dans le but de
    % pouvoir les ré-utiliser lors d'une autre session de travail.
    % Il faut faire attention avec les handle de figure...
    %-------------------------------------------------------------
    function V = prepareInfoBatch(tO)
      % liste des propriétés à sauvegarder
      pp ={'ver','Nfich','listFichIN','listFichOUT','pathOUT','listAction','Naction','listFichVirt'};
      % sauvegarde dans la structure V
      for U =1:length(pp)
        V.(pp{U}) =tO.(pp{U});
      end
    end

    %------------------------------------------------------------------------------
    % On écrase les infos avec celles récupérer lors d'une sauvegarde
    % ultérieure. On doit au préalable vider le présent objet des vieilles valeurs.
    %------------------------------------------------------------------------------
    function ecraseInfoBatch(tO, V)
      % liste des propriétés à sauvegarder
      pp ={'ver','Nfich','listFichIN','listFichOUT','pathOUT','listAction','Naction','listFichVirt'};
      % on vide les propriétés actuelles (mise à zéro des possibles objets)
      tO.onVide();
      % On écrase les propriétés à partir de la structure V
      for U =1:length(pp)
        if isfield(V, pp{U})
          tO.(pp{U}) =V.(pp{U});
        end
      end
    end

    % Remise à zéro de toutes les propriétés
    function onVide(tO)
      % nombre d'espace à ajouter dans le journal "pour faire beau"
      tO.S =0;
      % Info sur les fichiers à traiter
      tO.Nfich =0;
      tO.listFichIN ={'aucun fichier à traiter'};
      tO.listFichOUT =[];
      tO.pathOUT =[];
      % Liste des actions possibles
      tO.effaceTouteAction();
    end

    %-------------------------------------------------
    % Création d'un nouvel objet CAction et ajout de son handle dans la liste tO.listAction.
    % Aussi, création d'un fichier virtuel et ajout dans la liste tO.listFichVirt
    % En ENtrée: on veut le nom de l'action
    % En Sortie: on retourne le handle de l'objet créé
    %-------------------------------------------------
    function varargout = creerNouvelAction(tO,nom)
      % vérification si le nom existe et quelle classe lui est associée
      [nAct,cAct] =infoActions(nom);
      if ~isempty(nAct)
        % le nom existe alors on crée un objet CAction en lui passant le nom et la classe
        tO.listAction{end+1} =CAction(nAct,cAct);
        % on met à jour la propriété Naction
        tO.Naction =length(tO.listAction);
        % création d'un fichier virtuel et ajout dans la liste
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

    % Généré la liste des actions sélectionnées
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
    % Delete une action par son numéro dans la liste
    %-----------------------------------------------
    function effaceAction(tO,N)
      if length(tO.listAction) >= N
        % on efface l'objet correspondant à l'action N
        delete(tO.listAction{N});
        % on vide la liste en conséquence
        tO.listAction(N) =[];
        % on ré-ajuste le nombre d'action dans la liste
        tO.Naction =length(tO.listAction);
        % on efface le fichier virtuel correspondant
        delete(tO.listFichVirt{N});
        % on vide la liste en conséquence
        tO.listFichVirt(N) =[];
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en remontant la Nième
    % dans la listbox (si elle était 3, elle devient 2)
    %--------------------------------------------------
    function remonte(tO,N)
      if N > 1
        foo =tO.listAction{N-1};
        tO.listAction{N-1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------
    % Change l'ordre des actions en descendant la Nième
    % dans la listbox (si elle était 2, elle devient 3)
    %--------------------------------------------------
    function redescend(tO,N)
      if N < tO.Naction
        foo =tO.listAction{N+1};
        tO.listAction{N+1} =tO.listAction{N};
        tO.listAction{N} =foo;
      end
    end

    %--------------------------------------------------------
    % Vérification si toutes les actions ont été configurées.
    % En sortie  cOk --> true o false
    %--------------------------------------------------------
    function cOk = isActionsPretes(tO)
      cOk =true;
      for U =1:tO.Naction
        cOk =(cOk && tO.listAction{U}.pret);
      end
    end

    %------------------------------------------------
    % On vérifie la liste des fichiers à traiter
    % Si elle n'existe pas, on la crée
    % En sortie K  --> 0 si elle ne peut être créé
    %                  1 si il y a au moins 1 fichier
    %------------------------------------------------
    function K = verifieListFichierIn(tO)
      if tO.Nfich == 0
        tO.fabricListFichierIn();
      end
      K =(tO.Nfich > 0);
    end

    %-----------------------------------------------
    % On fabrique la liste des fichiers à traiter
    % Devrait être "overloadé" par une classe Parent
    %-----------------------------------------------
    function fabricListFichierIn(tO,FIN)
      % on laisse les parents s'en occuper...
    end

    %----------------------------------------------------------------------
    % On vérifie si les actions antérieures à A sont toutes prêtes.
    % En entrée   A  --> le numéro de l'action à vérifier
    % En sortie cOK  --> true si les actions antérieures sont toutes prêtes
    %----------------------------------------------------------------------
    function cOK = isActionAvantPret(tO,A)
      cOK =true;
      for U =1:A-1
        cOK =(cOK && tO.listAction{U}.pret);
      end
    end

    %---------------------------------------------------------------------
    % Mise À Zéro(false) de la valeur de la propriété "pret" pour toutes
    % les actions suivantes incluant la courante.
    % En entrée   A  --> le numéro de l'action à modifier (par défaut = 1)
    %---------------------------------------------------------------------
    function mazPret(tO,A)
      % si A n'est pas défini, il sera égal à 1
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
    % on retourne le fichier virtuel de référence et celui de sortie
    % En entrée       V  --> numéro de l'action sélectionnée
    % En sortie  retour  --> true si il n'y a pas d'erreur
    %---------------------------------------------------------------
    function retour = setTmpFichVirt(tO, V)
      % initialisation des variables de sortie
      retour =false;
      % on vérifie si la liste des fichiers existe
      if tO.verifieListFichierIn()
      	% laref va contenir le fichier temporaire de travail
      	laref =tO.tmpFichVirt;
      	if V == 1
      	  % si on traite la 1ère action, on relie le fichier analyse
      	  laref.lire(tO.listFichIN{1});
        else
          % autrement, laref sera une copie du fichier virtuel précédent
          prec =tO.listFichVirt{V-1};
          prec.reClone(laref);
        end
        retour =true;
      end

    end

    %-----------------------------------------------------
    % C'est ici que l'on gère les travaux en batch
    % En entrée  hJ  --> handle du journal de bord
    %
    % - Une boucle pour passer chacun des fichiers à faire
    % - Puis une pour chacune des actions
    %-----------------------------------------------------
    function tournezLaManivelle(tO,hJ)
      hA =CAnalyse.getInstance();
      hJ.ajouter('Tout semble conforme, début du travail sur les fichiers.',tO.S);
      tO.S =tO.S+2;

      % boucle pour les fichiers
      %-------------------------
      for U =1:tO.Nfich

        % ouverture du fichier U
        %-----------------------
        if tO.ouvrirFichier(U);
          hJ.ajouter(['Ouverture de:  ' tO.listFichIN{U}],tO.S);
          tO.S =tO.S+2;

          % boucle pour les actions
          %------------------------
          for A =1:tO.Naction
            % quel est le handle de l'action à effectuer
            H =tO.listAction{A};
            % on inscrit dans le journal la description de la fonction à effectuer
            desc =H.description;
            hJ.ajouter(['Fonction:  ' desc],tO.S);
            tO.S =tO.S+2;

            % on exécute le travail
            %----------------------
            H.enRoute(tO.curFich);
            hJ.ajouter(['...' desc ' réussie...'],tO.S);
            tO.S =tO.S-2;
          end

          % sauvegarde du fichier
          %-----------------------
          tt =tO.curFich.sauver();
          tO.S =tO.S-2;
          hJ.ajouter(['Sauvegarde de:  ' tO.listFichOUT{U}],tO.S);
          % fermeture du fichier
          %---------------------
          hA.fermecur();
        else
        	hJ.ajouter(['Erreur de lecture: ' tO.listFichIN{U}],tO.S);
        end
      end

      % Travail en lot terminé
      %-----------------------
      tO.S =tO.S-2;
      hJ.ajouter(['Fin du travail en batch, ' datestr(now)],tO.S);
      % on va sauvegarder le log dans le répertoire du haut des fichier de sortie
      fnom =datestr(now);
      % on remplace les espaces et retire les ':'
      fnom(find(isspace(fnom))) ='_';
      fnom(findstr(fnom,':'))=[];
      complet =fullfile(tO.pathOUT,[fnom '.log']);
      hJ.ajouter(['Sauvegarde du journal dans: ' complet],tO.S);
      hJ.sauvegarde(complet);

    end

    %----------------------------------------------------------------
    % Ouverture d'un fichier Analyse pour le travail en batch
    % On va négliger tout les aspect affichage dans le GUI principale
    % En entrée  N  --> numéro du fichier dans la liste
    %----------------------------------------------------------------
    function reussi = ouvrirFichier(tO,N)
      % On vérifie si les fichiers d'entrées et sortie sont identique
      if ~strcmpi(tO.listFichIN{N},tO.listFichOUT{N})
        % si non, on s'assure que le path de sortie existe
        [a,b,c] =fileparts(tO.listFichOUT{N});
        if ~isdir(a)
          % création du path de sortie
          mkdir(a);
        end
        % on va copier le fichier source dans le fichier destination pour le travail
        copyfile(tO.listFichIN{N},tO.listFichOUT{N},'f');
      end
      % maintenant on ouvre le "fichier de sortie"
      tO.curFich =ouvreFichBatch(tO.listFichOUT{N});
      if isempty(tO.curFich)
      	reussi =false;
      else
      	reussi =true;
      end
    end

  end  % methods

end
