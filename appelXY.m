%
% fonction pour g�rer les callback du GUI affichage mode-XY
%
function appelXY(varargin)

  % Instance principale d'Analyse
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hXY =Ofich.ModeXY;
  commande = varargin{1};

  switch(commande)

  case 'mnucacher'
    % en cliquant sur le X pour fermer le GUI, on le cache plut�t que de l'effacer
    hXY.mnucacher();

  case 'mnuvoircan'
    % afficher les canaux XY s�lectionn�
    hXY.mnuvoircan();

  case 'togglefiltmp'
    % En mode XY, ajout d'un axe du temps qui va monitorer les points � afficher
    hXY.togglefiltmp();

  case 'deroultemps'
    % Que fait-on si on clique dans le slider du GUI
    hXY.deroultemps();

  case 'effacer'
    % Enl�ve/delete une paire de canaux(X,Y)
    hXY.effacer();

  case 'effaceles'
    % Enl�ve/delete toutes les paires de canaux(X,Y)
    hXY.effaceles();

  case 'editcan'
    % �dition des canaux Abcisse/Ordonn�e
    hXY.editcan();

  case 'edittemps'
    % Min et Max de l'�chelle de temps
    hXY.edittemps();

  case 'marklesx'
    % Choix du type de marquage manuel en X +/-Y
    hXY.marklesx();

  case 'marklesy'
    % Choix du type de marquage manuel en Y +/-X
    hXY.marklesy();

  case 'marklesecart'
    % callback pour modifier la tol�rance lors du marquage manuelle
    hXY.marklesecart();

  end

end
