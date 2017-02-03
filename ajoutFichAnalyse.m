%
% Ajout d'un fichier Analyse dans un fichier déjà ouvert
% Comme cette fonction est appellée par le menu, on va lui
% assigner la variable varargin en entrée pour éviter les
% messages d'errewur de compatibilité du nombre d'argument.
%
function ajoutFichAnalyse(varargin)
  % on lit la structure contenant le texte à afficher selon le choix de la langue
  tt =CMLWilly();

  [fnom, pnom, choix] =uigetfile(tt.ajfichtyp, tt.ajfichtyptit, 'MultiSelect', 'on');
  if isempty(pnom) | pnom == 0
    return;
  elseif iscell(fnom)
  	fnom =sort(fnom);
  	lestep =1/(length(fnom)*6);
  else
  	fnom ={fnom};
  	lestep =1/6;
  end
	lesaut =0;
  hwb = waitbar(0,[tt.genlecfich ' ' fnom{1} ', ' tt.genveuillezpat]);
  hA =CAnalyse.getInstance();
  hFi =hA.findcurfich();
  for U =1:length(fnom)
  	lesaut =lesaut+lestep;
    waitbar(lesaut, hwb, [tt.genlecfich ' ' fnom{U} ', ' tt.genveuillezpat]);
    F =CLiranalyse(CFichEnum.analyse);
    entrada =fullfile(pnom, fnom{U});
    bonformat =F.SondeFichier(entrada);
  	lesaut =lesaut+lestep;
    waitbar(lesaut, hwb);
    K0 =[];
    if hA.isfichopen(entrada)
      K1 ='ajmt_zzzcc';
      K2 =0;
      vaya =false;
      while ~vaya
        K0 =fullfile(pnom, [K1 num2str(K2) '.mat']);
        vaya =isempty(dir(K0));
        K2 =K2+1;
      end
      copyfile(entrada, K0, 'f');
      entrada =K0;
    end
    if isempty(bonformat)
      delete(F);
      delete(hwb);
      if ~isempty(K0)
        delete(K0);
      end
      return;
    elseif ~bonformat
      salida =fullfile(pnom, 'jmt_zicstt00.mat');
      F.TransformCanaux(entrada, salida, hwb);
      entrada =salida;
    end
    [F.Info.prenom, b, c] =fileparts(entrada);
    F.Info.finame =[b c];
    F.Vg.valeur =1;
  	lesaut =lesaut+lestep;
    waitbar(lesaut, hwb);
    test =F.lire(1);
  	lesaut =lesaut+lestep;
    waitbar(lesaut, hwb);
    if test
    	copyfile(F.Info.finame, F.Info.fitmp, 'f');
    	lesaut =lesaut+lestep;
      waitbar(lesaut, hwb);
      [s1 F.autre.lenom s2] =fileparts(fnom{U});
    	hFi.ajoutanalyse(F, choix-1);
    	lesaut =lesaut+lestep;
      waitbar(lesaut, hwb);
    else
    	lesaut =lesaut+2*lestep;
      waitbar(lesaut, hwb);
    end
    delete(F);
    if ~bonformat
    	delete(entrada);
    end
    if ~isempty(K0) & ~isempty(dir(K0))
      delete(K0);
    end
  end
  hFi.Vg.sauve=1;
  hFi.Vg.valeur=0;
  delete(hwb);
  gaglobal('editessnom');
end
