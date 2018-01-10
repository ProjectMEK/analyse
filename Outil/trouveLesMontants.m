%-----------------------------------------------------------
% fonction pour trouver les pentes montantes on doit fournir
%   dato    canal des vitesse instantannées ([0; diff(can)])
%   vref    variation d'amplitude seuil
%   tsmpl   temps maximum pour que l'amplitude varie de vref
%           jouera le rôle d'une fenêtre "glissante"
%-----------------------------------------------
function V =trouveLesMontants(dato, vref, tsmpl)
  %
  % si on trouve un point qui répond aux critères detaY/deltaX, on va faire
  % une vérification au cas ou ce serait seulement un pic de bruit. Puis,
  % on fait un saut de "inc" sample plus loin pour continuer la recherche.
  % Si tsmpl est petit, ça ne fera pas de différence. Mais si il est grand,
  % on va accélérer la recherche.
  %
  inc =max(floor(tsmpl/4), 1);
  gpls(tsmpl) =0;
  % VITESSE INSTANTANNÉE DE RÉFÉRENCE
  vitinst =vref/tsmpl;
  %N SERA LA LIMITE SUPÉRIEURE POUR LA BOUCLE WHILE
  N =length(dato)-tsmpl+1;
  %V SERA NOTRE TABLEAU POUR LES INDEX DES PENTES TROUVÉES
  V(round(N/3)) =0.0;
  Vind =1;
  U =2;
  while U <= N
    if tsmpl > 2
      gpls(:) =dato(U:U+tsmpl-1);
      %ON VÉRIFIE AVEC LA VIT. INSTANT.
      leTest =find(gpls > vitinst, 1);
      if ~isempty(leTest)
        %ON S'ASSURE QUE CE N'EST PAS SEULEMENT UN PIC DE BRUIT
        vitmoy =cumsum(gpls);
        leTest =find(vitmoy > vref, 1);
        if ~isempty(leTest)
          V(Vind) =U+leTest-1;
          Vind =Vind+1;
          U =U+leTest+inc;
        end
      end

    %COMME NOTRE FENÊTRE A SEULEMENT UN SAMPLE DE LARGE
    %ON TRAVAILLE DIRECTEMENT AVEC LES VIT. INSTANT.
    elseif dato(U+1) > vref
      V(Vind) =U;
      Vind =Vind+1;
      U =U+1;
    end
    U =U+inc;
  end
  V(Vind:end) =[];
end
