%
% gaglobal --> gestion des actions global, qui ont une influence générale
%
% par ex, si on a créé ou modifier un nom de canal, c'est ici que l'on va
% regénérer les listes de nom de canaux etc...
%
function gaglobal(varargin)
  if nargin
    commande =varargin{1};
    OA =CAnalyse.getInstance();
    Ofich =OA.findcurfich();
    vg =Ofich.Vg;
  else
    return;
  end
  switch commande
  %------------ % Si on efface des canaux
  case 'delcan'
    if nargin > 1
      lescan =varargin{2};
      if length(lescan)
        ganaxe(lescan);
        Ofich.Tpchnl.Delcan(lescan);
        gaglobal('editnom');
        OA.OFig.affiche();
      end
    end
  %------------- % Si on modifie les noms de canaux
  case 'editnom'
    letop =max(2,vg.nad);
    hdchnl =Ofich.Hdchnl;
    hdchnl.ResetListAdname();
    lesnoms ={'Tous'};
    lesnoms(2:vg.nad+1) =hdchnl.Listadname;
    OA.OFig.canopts.setString(lesnoms);
    OA.OFig.cano.setString(hdchnl.Listadname);
  %---------------- % Si on modifie les noms de canaux et les essais
  case 'editessnom'
  	Ofich.editcats();
  	Ofich.editess();
    gaglobal('editnom');
  %--------------------
  case 'affiche_canaux'    % On raffraîchit l'affichage
    OA.OFig.affiche();
  end
end