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
        % a été retiré car on n'utilise plus les multi-axes.
        % si on le replace, il faudra vérifier l'intéraction avec le mode batch.
        % ganaxe(lescan);
        Ofich.Tpchnl.Delcan(lescan);
        gaglobal('editnom');
        OA.OFig.affiche();
      end
    end
  %------------- % Si on modifie les noms de canaux
  % Celui qui call cette fonction devra tenir compte que sous Octave il arrive que
  % la fenêtre active appelé par CDessine.affiche n'est pas la figure principale.
  % pour y pallier on peut appeler passer un deuxième paramètre
  %   hA =CAnalyse.getInstance();
  %   gaglobal('editnom',hA.OFig.fig);
  case 'editnom'
    hdchnl =Ofich.Hdchnl;
    hdchnl.ResetListAdname();
    lesnoms ={'Tous'};
    lesnoms(2:vg.nad+1) =hdchnl.Listadname;
    OA.OFig.canopts.setString(lesnoms);
    OA.OFig.cano.setString(hdchnl.Listadname);
    if nargin == 2
      OA.OFig.affiche(varargin{2});
    else
      OA.OFig.affiche();
    end
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