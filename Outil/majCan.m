%
% Fonction pour faire une mise à jour des paramètres qui pourraient
% avoir été négligé par certaines vieilles fonctions.
%   Pour chacun des canaux sélectionnés
%   - On refait le calcul des min et max.
%
function majCan(varargin)
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  vg =Ofich.Vg;
  Ofich.majMinMax(vg.can);
end