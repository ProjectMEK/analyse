function canout =differDtchnl(varargin)
%
%        Utile pour Stat4COP
%
% DIFFER (Inspir� de la s�rie de logiciels d�velopp�s sous DOS)
% Fait la diff�rentiel de chaque colonne de la matrice en entr�e
% et effectue un lissage des donn�es.
%
% Trois param�tres d'entr�es sont "N�CESSAIRES"
% 
% EX: retour = differ(canaux,fen�tre,fr�quence);
% 
%     canaux    --> matrice de dimension 1,2 ou 3, qui contient les canaux
%                   � diff�rencier.
%     fen�tre   --> nombre de point sur lequel se fera le lissage
%     fr�quence --> fr�quence d'�chantillonage � laquelle l'acquisition a
%                   �t� effectu�e.
% DIFFER retournera une matrice de m�me dimension que la matrice "canaux"
%
% Laboratoire GRAME
% MEK - mars 1999
%
  if nargin == 3
    candif =varargin{1};      % canal � diff�rencier
    window =varargin{2};      % largeur de fen�tre pour le traitement
    rate   =varargin{3};      % fr�quence d'�chantillonage
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
