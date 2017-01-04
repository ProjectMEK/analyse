function canout =differDtchnl(varargin)
%
%        Utile pour Stat4COP
%
% DIFFER (Inspiré de la série de logiciels développés sous DOS)
% Fait la différentiel de chaque colonne de la matrice en entrée
% et effectue un lissage des données.
%
% Trois paramètres d'entrées sont "NÉCESSAIRES"
% 
% EX: retour = differ(canaux,fenêtre,fréquence);
% 
%     canaux    --> matrice de dimension 1,2 ou 3, qui contient les canaux
%                   à différencier.
%     fenêtre   --> nombre de point sur lequel se fera le lissage
%     fréquence --> fréquence d'échantillonage à laquelle l'acquisition a
%                   été effectuée.
% DIFFER retournera une matrice de même dimension que la matrice "canaux"
%
% Laboratoire GRAME
% MEK - mars 1999
%
  if nargin == 3
    candif =varargin{1};      % canal à différencier
    window =varargin{2};      % largeur de fenêtre pour le traitement
    rate   =varargin{3};      % fréquence d'échantillonage
  else
    return
  end
  %
  % on s'assure que la valeur de window est impair
  %
  if mod(window,2) == 1
    radius =(window-1)/2;
  else
    radius =window/2;
    window =window+1;
  end
  rnorm =rate/(2*sum((1:radius).^2));
  vecteur =ones(window,size(candif,2),size(candif,3));
  for  i=1:size(candif,2),for j =1:size(candif,3)
    vecteur(:,i,j) =vecteur(:,i,j).*(-radius:radius)';
  end,end;
  ifirst =radius+1;
  ilast =size(candif,1)-radius;
  canout =zeros(size(candif));
  for i =ifirst:ilast
    canout(i,:,:) =rnorm*(sum(vecteur.*candif(i-radius:i+radius,:,:)));
  end
  for i =1:radius
    canout(i,:,:) =canout(1+radius,:,:);
    canout(ilast+i,:,:) =canout(ilast,:,:);
  end
end
