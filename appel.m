%
% GESTIONNAIRE DES CALLBACK
%     des menus Analyse
%
% Cette fonction est appelée par le menu principale d'Analyse
% en fournissant comme premier argument, le nom d'une tâche à
% accomplir. Ce nom est traité dans un bloc "switch/case"
%
function appel(varargin)

  % Instance principale d'Analyse
  OA =CAnalyse.getInstance();

  switch varargin{1}

  %_____________________________________________________________________________
  %------- MENU FICHIER *****
  case 'fermerfich'                     % Fermer le fichier courant
    OA.fermerfich();

  case 'sauverfich'                     % Sauvegarder le fichier courant
    OA.sauverfich();

  case 'sauversousfich'                 % Sauvegarder-sous le fichier courant
    OA.sauversousfich();

  case 'lesPreferencias'                % Ouvrir le GUI des préférences
    foo =CPreference();

  %_____________________________________________________________________________
  %------- MENU EDIT *****

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

  case 'integral'
  	wintsucc(0,1);
  case 'tretcanal'
  	OW =CTretcan();
  case 'Intesucc'
  	wintsucc(1,0);
  case 'CentreDePressionManuel'
  	hDP =CCalculCOP(true);
  case 'CentreDePressionFichier'
  	hDP =CCalculCOP(false);
  case 'COPoptimaManuel'
  	hDP =CCalculCOPoptima(true);
  case 'COPoptimaFichier'
  	hDP =CCalculCOPoptima(false);
  case 'statPourCOP'
  	hDP =CStat4COP();
  %_____________________________________________________________________________
  %------- MENU TRAJECTOIRE *****
  case 'ProjetGPS'
  	hDP =CProjetGPS();
  case 'ecef2lla'
  	CGPSecef2lla.ouverture();
  case 'DistParcourueXYZ'
  	hDP =CDistParcourXYZ();
  %_____________________________________________________________________________
  %------- MENU OUTILS *****
  case 'echeltmp'
    hF =thisObj.hA.findcurfich();
    hF.Tpchnl.OnMenuClicked(0);
    thisObj.hA.OFig.affiche();
  case 'importpt'
    V =CImportPoint();
  case 'marquage'                       % Interface pour marquer automatiquement
    OM =CMark.getInstance();
  end
