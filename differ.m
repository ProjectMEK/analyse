%
% DIFFER (Inspiré de la série de logiciels développés sous DOS)
% Fait la différentiel de chaque colonne de la matrice en entrée
% et effectue un lissage des données.
%
% cinq paramètres d'entrées sont "NÉCESSAIRES"
%
% EX:  differ(hDtchnl, nsmpls, essai, window, rate);
% 
%     hDtchnl   --> objet de la classe CHdchnl
%     nsmpls    --> nombre d'échantillons à diff
%     essai     --> numéro de l'essai à diff
%     fenêtre   --> nombre de point sur lequel se fera le lissage
%     rate      --> fréquence d'échantillonage à laquelle l'acquisition a
%                   été effectuée.
% DIFFER retournera un canal de même dimension que celui d'entrée.
%
% Laboratoire GRAME
% MEK - mars 1999
%
function canout =differ(varargin)
  % Attribution des paramètres d'entrées de la fonction
  % aux variables utilisées dans les calculs
  if nargin == 5
    hndt =varargin{1};      % handle du canal à différencier
    smpls =varargin{2};
    ess =varargin{3};
    window =varargin{4};      % largeur de fenêtre pour le traitement
    rate   =varargin{5};      % fréquence d'échantillonage
  else
    errordlg('Cinq paramètres d''entrées sont nécessaires.','ERREUR DE SYNTAXE!!!');
    return
  end
  % on s'assure que la valeur de window est impair
  if mod(window,2) == 1
    radius =(window-1)/2;
  else
    radius =window/2;
    window =window+1;
  end
  % calcul du paramètre pour la normalisation (lors du lissage)
  rnorm =rate/(2*sum((1:radius).^2));
  % fabrication du "vecteur de normalisation" pour le lissage
  vecteur =ones(window,length(ess));
  % fabrication du "vecteur de dérivé"
  vtmp =(-radius:radius)';
  for i =1:length(ess)
    vecteur(:,i) =vtmp;
  end
  % calcul des bornes de début et fin
  ifirst =radius+1;
  ilast =smpls-radius;
  % initialisation de la matrice de sortie
  canout =zeros(size(hndt.Dato.(hndt.Nom)(1:smpls,ess)));
  % LISSAGE
  for i =ifirst:ilast
    canout(i,:)= rnorm*(sum(vecteur.*hndt.Dato.(hndt.Nom)(i-radius:i+radius,ess)));
  end
  % Il reste à s'occuper des points perdus au début et à la fin.
  for i =1:radius
    canout(i,:)=canout(1+radius,:);
    canout(ilast+i,:)=canout(ilast,:);
  end
  hndt.Dato.(hndt.Nom)(1:smpls,ess) =canout;
end