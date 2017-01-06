%%
% Convertir un tableau de cellules qui contient des chiffres du format
% texte ou numérique vers une matrice numérique
%
function v =convCellArray2Mat(u)
  s =size(u);
  v =zeros(s);
  for a =1:s(1)
    for b =1:s(2)
      if isnumeric(u{a,b})
        v(a,b) =u{a,b};
      else
        v(a,b) =str2num(u{a,b});
      end
    end
  end
end
