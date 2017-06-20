%
% fonction pour retourner une valeur numérique relative au système de points
% marqués dans analyse.
%
% P = numeroPoint(Ptxt, PMAX)
%     Ptxt --> string contenant quelquechose comme: Pi ou P3 ou Pf ou end
%     PMAX --> numéro du dernier point marqué. Dans Analyse, ça se traduit pa la
%              valeur de hdchnl.npoints(can,ess) du canal(can) et de l'essai(ess).
%
% Ex.
% P0, Pi, ou P1    retournera P =  1
% Pf, Pend ou end  retournera P =  PMAX
% end-2            retournera P =  PMAX - 2
% en cas d'erreur  retournera P =  []
%
function P = numeroPoint(Ptxt,PMAX)
  P =[];
  % on élimine le cas ou on a pas de point marqué.
  if PMAX == 0
    return;
  end
  % la seule opération permise est la soustraction: '-'
  foo ={'+','/','*'};
  for U =1:length(foo)
    if ~isempty(strfind(Ptxt,foo{U}))
      return;
    end
  end
  ttmp =lower(strtrim(Ptxt));
  switch ttmp
  case {'p0','p1','pi'}
    % on traite les cas ou on réfère au premier point par un alias
    P =1;
  case {'end','pend','pf'}
    % on traite les cas ou on réfère au dernier point par un alias
    P =PMAX;
  otherwise
    % on enlève la lettre 'p' du début de la string
    if strncmp(ttmp,'p',1)
      ttmp(1) =[];
    end
    N =0;
    % si on a une composition du genre "end-3" ou "Pf-3"
    if strncmp(ttmp,'end',3)
      N =PMAX;
      ttmp(1:3) =[];
    elseif strncmp(ttmp,'f',1)
      N =PMAX;
      ttmp(1) =[];
    end
    V =str2num(ttmp);
    if ~isempty(V)
      N =N+V;
      if N > 0 & N <= PMAX
        P =N;
      end
    end
  end
end

%
% N = leRestant(T)
%     T  --> string devant contenir le signe ''
%
function N = leRestant(T)

end