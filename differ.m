%
% DIFFER (Inspir� de la s�rie de logiciels d�velopp�s sous DOS)
% Fait la diff�rentiel de chaque colonne de la matrice en entr�e
% et effectue un lissage des donn�es.
%
% cinq param�tres d'entr�es sont "N�CESSAIRES"
%
% EX:  differ(hDtchnl, nsmpls, essai, window, rate);
% 
%     hDtchnl   --> objet de la classe CHdchnl
%     nsmpls    --> nombre d'�chantillons � diff
%     essai     --> num�ro de l'essai � diff
%     fen�tre   --> nombre de point sur lequel se fera le lissage
%     rate      --> fr�quence d'�chantillonage � laquelle l'acquisition a
%                   �t� effectu�e.
% DIFFER retournera un canal de m�me dimension que celui d'entr�e.
%
% Laboratoire GRAME
% MEK - mars 1999
%
function canout =differ(varargin)
  % Attribution des param�tres d'entr�es de la fonction
  % aux variables utilis�es dans les calculs
  if nargin == 5
    hndt =varargin{1};      % handle du canal � diff�rencier
    smpls =varargin{2};
    ess =varargin{3};
    window =varargin{4};      % largeur de fen�tre pour le traitement
    rate   =varargin{5};      % fr�quence d'�chantillonage
  else
    errordlg('Cinq param�tres d''entr�es sont n�cessaires.','ERREUR DE SYNTAXE!!!');
    return
  end
  % on s'assure que la valeur de window est impair
  if mod(window,2) == 1
    radius =(window-1)/2;
  else
    radius =window/2;
    window =window+1;
  end
  % calcul du param�tre pour la normalisation (lors du lissage)
  rnorm =rate/(2*sum((1:radius).^2));
  % fabrication du "vecteur de normalisation" pour le lissage
  vecteur =ones(window,length(ess));
  % fabrication du "vecteur de d�riv�"
  vtmp =(-radius:radius)';
  for i =1:length(ess)
    vecteur(:,i) =vtmp;
  end
  % calcul des bornes de d�but et fin
  ifirst =radius+1;
  ilast =smpls-radius;
  % initialisation de la matrice de sortie
  canout =zeros(size(hndt.Dato.(hndt.Nom)(1:smpls,ess)));
  % LISSAGE
  for i =ifirst:ilast
    canout(i,:)= rnorm*(sum(vecteur.*hndt.Dato.(hndt.Nom)(i-radius:i+radius,ess)));
  end
  % Il reste � s'occuper des points perdus au d�but et � la fin.
  for i =1:radius
    canout(i,:)=canout(1+radius,:);
    canout(ilast+i,:)=canout(ilast,:);
  end
  hndt.Dato.(hndt.Nom)(1:smpls,ess) =canout;
end