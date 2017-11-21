%
% fonction pour gérer les options du menu "Aide"
% 
function varargout = aideDoc(varargin)
  OA =CAnalyse.getInstance();
  if (OA.Fic.nf > 0)
  	hF =OA.findcurfich();
  	vg =hF.Vg;
  end
  if nargin == 0
    commande = 'ouverture';
  else
    commande = varargin{1};
  end

  switch(commande)

  %---------
  % À propos
  %---------------
  case 'ouverture'
    lesmots{1} ={'Programme Analyse', 3, 12};
    lesmots{end+1} ={['Version ' OA.Fic.vermot '**'], 1, 0};
    if (OA.Fic.nf > 0) & (vg.laver ~= OA.Fic.laver)
      vermot =quelver(vg.laver);
      lesmots{end+1} ={['(Dernière sauvegarde: Version ' vermot ')'], 1, 7};
    end
    if OA.OPG.getMatlab()
      lesmots{end+1} ={'Testé avec Matlab R2013b', 1, 0};
    else
      lesmots{end+1} ={'Testé avec Octave 4.2.1', 1, 0};
    end
    lesmots{end+1} ={[char(169) ' 1998-2017'], 2, 8};
    lesmots{end+1} ={'** Prenez note que Analyse ne sera', 2, 8};
    lesmots{end+1} ={'jamais une version finale. Pour les', 0, 8};
    lesmots{end+1} ={['puristes, la version est: ' OA.Fic.vermot 'b'], 0, 8};
    % après avoir "fabriqué" la variable lesmots on appel
    % une fonction du dossier "communs"
    GUI_aPropos(lesmots, 0);
    set(findobj('Tag','APROPOS'),'WindowStyle','modal');

  %-----------------------------------------------
  % Affiche l'historique d'Analyse dans le browser
  %--------------
  case 'histoire'
  	% -a doc/dernier.html
    % -a doc/...
  	lurl =fullfile(OA.Fic.basedir, 'doc/dernier.html');
    system(lurl);

  %---------------------------------
  % Connecte avec le site wiki de la
  % documentation du laboratoire GRAME
  %-----------
  case 'leweb'
    lurl=['http://www.mouvement.kin.ulaval.ca/kinetu/index.php/Analyse'];
    web(lurl);
  end
end

function vercar =quelver(laver)
  if laver < 7
    vercar ='6';
    return;
  end
  vcar =num2str(laver, '%2.4f');
  vercar =[vcar(1:end-2) '.' vcar(end-1:end)];
end