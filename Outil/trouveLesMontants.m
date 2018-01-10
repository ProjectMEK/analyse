%-----------------------------------------------------------
% fonction pour trouver les pentes montantes on doit fournir
%   dato    canal des vitesse instantann�es ([0; diff(can)])
%   vref    variation d'amplitude seuil
%   tsmpl   temps maximum pour que l'amplitude varie de vref
%           jouera le r�le d'une fen�tre "glissante"
%-----------------------------------------------
function V =trouveLesMontants(dato, vref, tsmpl)
  %
  % si on trouve un point qui r�pond aux crit�res detaY/deltaX, on va faire
  % une v�rification au cas ou ce serait seulement un pic de bruit. Puis,
  % on fait un saut de "inc" sample plus loin pour continuer la recherche.
  % Si tsmpl est petit, �a ne fera pas de diff�rence. Mais si il est grand,
  % on va acc�l�rer la recherche.
  %
  inc =max(floor(tsmpl/4), 1);
  gpls(tsmpl) =0;
  % VITESSE INSTANTANN�E DE R�F�RENCE
  vitinst =vref/tsmpl;
  %N SERA LA LIMITE SUP�RIEURE POUR LA BOUCLE WHILE
  N =length(dato)-tsmpl+1;
  %V SERA NOTRE TABLEAU POUR LES INDEX DES PENTES TROUV�ES
  V(round(N/3)) =0.0;
  Vind =1;
  U =2;
  while U <= N
    if tsmpl > 2
      gpls(:) =dato(U:U+tsmpl-1);
      %ON V�RIFIE AVEC LA VIT. INSTANT.
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

    %COMME NOTRE FEN�TRE A SEULEMENT UN SAMPLE DE LARGE
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
