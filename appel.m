%
% GESTIONNAIRE DES CALLBACK
%     des menus Analyse
%
% Cette fonction est appelée par le menu principale d'Analyse
% en fournissant comme premier argument, le nom d'une tâche à
% accomplir. Ce nom est traité dans un bloc "switch/case"
%
function appel(varargin)
  try

    % Instance principale d'Analyse
    OA =CAnalyse.getInstance();

    switch varargin{1}

    %_____________________________________________________________________________
    %------- MENU FICHIER *****
    case 'ouvrirfich'                     % ouverture de tous les type de fichiers
      letype =CEFich(varargin{2});
      mnouvre(letype, false);

    case 'ajoutfich'                      % Ajoute un fichier Analyse au fichier courant
      ajoutFichAnalyse();

    case 'editbatch'                      % Exécuter des jobs en batch
      % batchEditExec();
      oTmp =CBatchEditExec.getInstance();

    case 'fermerfich'                     % Fermer le fichier courant
      OA.fermerfich();

    case 'sauverfich'                     % Sauvegarder le fichier courant
      OA.sauverfich();

    case 'sauversousfich'                 % Sauvegarder-sous le fichier courant
      OA.sauversousfich();

    case 'exportdata'                     % Exporte les données ds un fichier texte
      exportacion();

    case 'resultats'                      % Écriture des résultats
      resultats();

    case 'impression'                     % impression copie/coller, jpeg, imprimer
      letype =varargin{2};
      impression(letype);

    case 'ouvfichrecent'                  % ouverture d'un fichier récemment ouvert
      letype =CEFich(varargin{2});
      lequel =varargin{3};
      mnouvre(letype, lequel);

    case 'lesPreferencias'                % Ouvrir le GUI des préférences
      foo =CPreference();

    case 'redemarrer'                     % on ferme et on ré-ouvre Analyse
      analyse('arcommence');

    case 'terminus'                       % on ferme Analyse
      analyse('terminus');

    %_____________________________________________________________________________
    %------- MENU EDIT *****

    case 'majcan'                         % MAJ de certains paramètres des canaux
      majCan();

    case 'editcan'                        % Édition de certains paramètres des canaux
      editCan();

    case 'copiecan'                       % Copie les canaux désirés
      cpCan();

    case 'EditCategorie'                  % Édition des niveaux/Catégories
      hEC =CEditCateg(true);

    case 'RebatirCategorie'               % Rebâtir/Reset les niveaux/Catégories
      hEC =CEditCateg(false);
      hEC.RebatirCategorie();
      delete(hEC);

    case 'EditEchelTps'                   % Édition des échelle de temps
      ITpchnl();

    %_____________________________________________________________________________
    %------- MENU MODIFIER *****

    case 'corrige'                        % Correction sur les datas
      Otmp =CCorrige();

    case 'couper'                         % Couper des datas début/fin canaux
      couperData();

    case 'decouper'                       % découper les canaux en plusieurs fichiers???
      OW =CDecoup();

    case 'decime'                         % décimation des datas
      decimage();

    case 'rebase'                         % rebase des datas
      rebase();

    case 'rotation'                       % rotation dans un plan
      rotationPlan();

    case 'syncess'                        % synchronisation des essais
      synchroEss();

    case 'synccan'                        % synchronisation des canaux
      synchroCan();

    %_____________________________________________________________________________
    %------- MENU MATH *****

    case 'filtre'                        % ButterWorth
      filtreBW();

    case 'sptoul'                        % Complément à SPTOOL
      fiFilt();

    case 'derive'                        % Le même DIFFER que dans DATAC.DOS
      % fncDiffer();
      foo =CDiffer();
      foo.guiDiffer();

    case 'moindre'                       % Menu Polynomial-Fit
      moindreCarre();                    % dérivé par la méthode des moindres carrés

    case 'integr'                        % Intégrale définie
      inteSuc(0,1);

    case 'intcum'                        % Intégrale Cumulative
      integCum();

    case 'normalise'                     % Normalisation
      normalise();

    case 'normaltemps'                   % Normalisation Temporelle
      normTemporel();

    case 'ellipse'                       % Ellipse de confiance
      ellipse();

    case 'moyectype'                     % Moyenne et Ecart-type par catégorie
      essmoy();

    case 'moypoint'                      % Moyenne autour des points marqués
      hMoy =CMoyAutourPt();

    case 'droiteregress'                 % Moyenne autour des points marqués
      hMoy =CPenteDroiteReg();

    case 'angulo'                        % Calcul d'angle
  	  angulo();

    case 'tretcanal'                     % Traitement de canal
  	  OW =CTretcan();

    %_____________________________________________________________________________
    %------- MENU EMG *****

    case 'Absolue'                     % --> Rectification
      ValAbs();

    case 'Lissage'                     % --> Lissage       
      EMGLissage();

    case 'Rootmeansquare'              % --> RMS
      EMGRms();

    case 'Emgmoyen'                    % --> MAV
      EMGMav();

    case 'Trio'                        % --> FM-FMoy-Max        
      EMGTrio();

    case 'Normalis'                    % --> Normalisation
      EMGNorm();

    case 'Intesucc'                    % --> Integrations successives
      integSuc(1,0);

    case 'ZerosCrossing'               % --> Changement de polarité
      EMGZero();

    case 'Distrib'                     % --> Distrib de prob d'amplit       OK
      EMGDistrib();

    %_____________________________________________________________________________
    %------- MENU FPLT *****
    % pour le call de CCalculCOP(type, manuel)
    %     type: vielle plateforme(0),  Optima(1)
    %   manuel: call le GUI(1),  call un fichier(0)

    case 'CentreDePressionManuel'      % Calcul la position du COP avec GUI
      hDP =CCalculCOP(true);

    case 'CentreDePressionFichier'     % Calcul la position du COP sans GUI
      hDP =CCalculCOP(false);

    case 'COPoptimaManuel'             % Calcul la position du COP avec GUI (Optima)
      hDP =CCalculCOPoptima(true);

    case 'COPoptimaFichier'            % Calcul la position du COP sans GUI (Optima)
      hDP =CCalculCOPoptima(false);

    case 'statPourCOP'                 % Calcul statistique à partir du COP
      hDP =CStat4COP();

    %_____________________________________________________________________________
    %------- MENU TRAJECTOIRE *****

    case 'ProjetGPS'                   % Calcul la distance parcourue
    	hDP =CProjetGPS();

    case 'ecef2lla'                    % (GPS)ECEF vers LLA
    	CGPSecef2lla.ouverture();

    case 'DistParcourueXYZ'            % Calcul la distance parcourue
    	hDP =CDistParcourXYZ();

    %_____________________________________________________________________________
    %------- MENU OUTILS *****

    case 'echeltmp'                    % Choix des échelles de temps
      OA =CAnalyse.getInstance();
      hF =OA.findcurfich();
      hF.Tpchnl.OnMenuClicked(0);
      OA.OFig.affiche();

    case 'importpt'                    % importer des points
      V =CImportPoint();

    case 'trierpt'                     % trier les points marqués
      V =CTrierPt();

    case 'marquage'                    % Interface pour marquer automatiquement
      OM =CMark.getInstance();

    case 'zoomonoff'                   % toggle le zoom on/off
      guiToul('zoomonoff');

    case 'affichecoord'                % affiche un curseurbar avec coordonnées
      guiToul('affichecoord');

    case 'colore_canal'                % Affiche les canaux avec différentes couleurs
      guiToul('colore_canal');

    case 'colore_essai'                % Affiche les essais avec différentes couleurs
      guiToul('colore_essai');

    case 'colore_categorie'            % Affiche les niveaux/catégories avec différentes couleurs
      guiToul('colore_categorie');

    case 'la_legende'                  % Affiche la légende et ses couleurs
      guiToul('la_legende');

    case 'ligne_type'                  % Affiche les échantillons
      guiToul('ligne_type');

    case 'outil_point'                 % Affiche point avec texte
      guiToul('outil_point');

    case 'AffichePointSansTexte'       % Affiche point sans texte
      guiToul('AffichePointSansTexte');

    case 'la_trich'                    % Affichage proportionnel
      guiToul('la_trich');

    case 'modexy'                      % Affichage CanalY vs CanalX
      guiToul('modexy');

    %_____________________________________________________________________________
    %------- MENU AIDE *****

    case  'leweb'                      % dirigé sur le wikigrame (etu)
      aideDoc('leweb');

    case  'histoire'                   % dirigé sur l'historique d'analyse
      aideDoc('histoire');

    case  'journalisation'             % Afficher le journal des actions
      Oj =CJournal.getInstance();
      Oj.afficher();

    case  'aidedoc'                    % dirigé "À propos d'Analyse"
      aideDoc();

    end % switch

  catch moo;
    parleMoiDe(moo);
  end

end
