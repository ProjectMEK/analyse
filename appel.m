%
% GESTIONNAIRE DES CALLBACK
%     des menus Analyse
%
% Cette fonction est appel�e par le menu principale d'Analyse
% en fournissant comme premier argument, le nom d'une t�che �
% accomplir. Ce nom est trait� dans un bloc "switch/case"
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

  case 'lesPreferencias'                % Ouvrir le GUI des pr�f�rences
    foo =CPreference();

  %_____________________________________________________________________________
  %------- MENU EDIT *****

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
