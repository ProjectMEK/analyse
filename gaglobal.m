%
% gaglobal --> gestion des actions global, qui ont une influence g�n�rale
%
% par ex, si on a cr�� ou modifier un nom de canal, c'est ici que l'on va
% reg�n�rer les listes de nom de canaux etc...
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
        % a �t� retir� car on n'utilise plus les multi-axes.
        % si on le replace, il faudra v�rifier l'int�raction avec le mode batch.
        % ganaxe(lescan);
        Ofich.Tpchnl.Delcan(lescan);
        gaglobal('editnom');
        OA.OFig.affiche();
      end
    end
  %------------- % Si on modifie les noms de canaux
  % Celui qui call cette fonction devra tenir compte que sous Octave il arrive que
  % la fen�tre active appel� par CDessine.affiche n'est pas la figure principale.
  % pour y pallier on peut appeler passer un deuxi�me param�tre
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
  case 'affiche_canaux'    % On raffra�chit l'affichage
    OA.OFig.affiche();
  end
end