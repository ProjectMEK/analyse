%
% fonction pour gérer les callback du GUI affichage mode-XY
%
function appelXY(varargin)

  % Instance principale d'Analyse
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hXY =Ofich.ModeXY;
  commande = varargin{1};

  switch(commande)

  case 'mnucacher'
    % en cliquant sur le X pour fermer le GUI, on le cache plutôt que de l'effacer
    hXY.mnucacher();

  case 'mnuvoircan'
    % afficher les canaux XY sélectionné
    hXY.mnuvoircan();

  case 'togglefiltmp'
    % En mode XY, ajout d'un axe du temps qui va monitorer les points à afficher
    hXY.togglefiltmp();

  case 'deroultemps'
    % Que fait-on si on clique dans le slider du GUI
    hXY.deroultemps();

  case 'effacer'
    % Enlève/delete une paire de canaux(X,Y)
    hXY.effacer();

  case 'effaceles'
    % Enlève/delete toutes les paires de canaux(X,Y)
    hXY.effaceles();

  case 'editcan'
    % Édition des canaux Abcisse/Ordonnée
    hXY.editcan();

  case 'edittemps'
    % Min et Max de l'échelle de temps
    hXY.edittemps();

  case 'marklesx'
    % Choix du type de marquage manuel en X +/-Y
    hXY.marklesx();

  case 'marklesy'
    % Choix du type de marquage manuel en Y +/-X
    hXY.marklesy();

  case 'marklesecart'
    % callback pour modifier la tolérance lors du marquage manuelle
    hXY.marklesecart();

  end

end
