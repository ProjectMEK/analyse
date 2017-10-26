%
% GESTIONNAIRE DES CALLBACK
%     des menus Analyse
%
% Cette fonction est appel�e par le menu principale d'Analyse
% en fournissant comme premier argument, le nom d'une t�che �
% accomplir. Ce nom est trait� dans un bloc "switch/case"
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

    case 'editbatch'                      % Ex�cuter des jobs en batch
      % batchEditExec();
      oTmp =CBatchEditExec.getInstance();

    case 'fermerfich'                     % Fermer le fichier courant
      OA.fermerfich();

    case 'sauverfich'                     % Sauvegarder le fichier courant
      OA.sauverfich();

    case 'sauversousfich'                 % Sauvegarder-sous le fichier courant
      OA.sauversousfich();

    case 'exportdata'                     % Exporte les donn�es ds un fichier texte
      exportacion();

    case 'resultats'                      % �criture des r�sultats
      resultats();

    case 'impression'                     % impression copie/coller, jpeg, imprimer
      letype =varargin{2};
      impression(letype);

    case 'ouvfichrecent'                  % ouverture d'un fichier r�cemment ouvert
      letype =CEFich(varargin{2});
      lequel =varargin{3};
      mnouvre(letype, lequel);

    case 'lesPreferencias'                % Ouvrir le GUI des pr�f�rences
      foo =CPreference();

    case 'redemarrer'                     % on ferme et on r�-ouvre Analyse
      analyse('arcommence');

    case 'terminus'                       % on ferme Analyse
      analyse('terminus');

    %_____________________________________________________________________________
    %------- MENU EDIT *****

    case 'majcan'                         % MAJ de certains param�tres des canaux
      majCan();

    case 'editcan'                        % �dition de certains param�tres des canaux
      editCan();

    case 'copiecan'                       % Copie les canaux d�sir�s
      cpCan();

    case 'EditCategorie'                  % �dition des niveaux/Cat�gories
      hEC =CEditCateg(true);

    case 'RebatirCategorie'               % Reb�tir/Reset les niveaux/Cat�gories
      hEC =CEditCateg(false);
      hEC.RebatirCategorie();
      delete(hEC);

    case 'EditEchelTps'                   % �dition des �chelle de temps
      ITpchnl();

    %_____________________________________________________________________________
    %------- MENU MODIFIER *****

    case 'corrige'                        % Correction sur les datas
      Otmp =CCorrige();

    case 'couper'                         % Couper des datas d�but/fin canaux
      couperData();

    case 'decouper'                       % d�couper les canaux en plusieurs fichiers???
      OW =CDecoup();

    case 'decime'                         % d�cimation des datas
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

    case 'sptoul'                        % Compl�ment � SPTOOL
      fiFilt();

    case 'derive'                        % Le m�me DIFFER que dans DATAC.DOS
      % fncDiffer();
      foo =CDiffer();
      foo.guiDiffer();

    case 'moindre'                       % Menu Polynomial-Fit
      moindreCarre();                    % d�riv� par la m�thode des moindres carr�s

    case 'integr'                        % Int�grale d�finie
      inteSuc(0,1);

    case 'intcum'                        % Int�grale Cumulative
      integCum();

    case 'normalise'                     % Normalisation
      normalise();

    case 'normaltemps'                   % Normalisation Temporelle
      normTemporel();

    case 'ellipse'                       % Ellipse de confiance
      ellipse();

    case 'moyectype'                     % Moyenne et Ecart-type par cat�gorie
      essmoy();

    case 'moypoint'                      % Moyenne autour des points marqu�s
      hMoy =CMoyAutourPt();

    case 'droiteregress'                 % Moyenne autour des points marqu�s
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

    case 'ZerosCrossing'               % --> Changement de polarit�
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

    case 'statPourCOP'                 % Calcul statistique � partir du COP
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

    case 'echeltmp'                    % Choix des �chelles de temps
      OA =CAnalyse.getInstance();
      hF =OA.findcurfich();
      hF.Tpchnl.OnMenuClicked(0);
      OA.OFig.affiche();

    case 'importpt'                    % importer des points
      V =CImportPoint();

    case 'trierpt'                     % trier les points marqu�s
      V =CTrierPt();

    case 'marquage'                    % Interface pour marquer automatiquement
      OM =CMark.getInstance();

    case 'zoomonoff'                   % toggle le zoom on/off
      guiToul('zoomonoff');

    case 'affichecoord'                % affiche un curseurbar avec coordonn�es
      guiToul('affichecoord');

    case 'colore_canal'                % Affiche les canaux avec diff�rentes couleurs
      guiToul('colore_canal');

    case 'colore_essai'                % Affiche les essais avec diff�rentes couleurs
      guiToul('colore_essai');

    case 'colore_categorie'            % Affiche les niveaux/cat�gories avec diff�rentes couleurs
      guiToul('colore_categorie');

    case 'la_legende'                  % Affiche la l�gende et ses couleurs
      guiToul('la_legende');

    case 'ligne_type'                  % Affiche les �chantillons
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

    case  'leweb'                      % dirig� sur le wikigrame (etu)
      aideDoc('leweb');

    case  'histoire'                   % dirig� sur l'historique d'analyse
      aideDoc('histoire');

    case  'journalisation'             % Afficher le journal des actions
      Oj =CJournal.getInstance();
      Oj.afficher();

    case  'aidedoc'                    % dirig� "� propos d'Analyse"
      aideDoc();

    end % switch

  catch moo;
    parleMoiDe(moo);
  end

end
