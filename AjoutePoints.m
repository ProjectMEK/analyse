%
% Fonction pour importer des points à partir
% d'un fichier .INI
%
% EN ENTRÉE on aura:  H --> un objet de la classe CImportPoint
%-----------------------
function AjoutePoints(H)
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  % VARIABLES D'ANALYSE
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  vg.sauve =1;
	ptchnl =Ofich.Ptchnl;
	% création d'une barre de défilement pour montrer la progression du travail fait
	Wbar =laWaitbar(0.001, 'Ajout de points en cours...', 'C', 'C');
	% CANAUX UTILES
  hCx =CDtchnl();
  Ofich.getcanal(hCx, H.cX);
  Nx =hCx.Nom;
  hCy =CDtchnl();
  Ofich.getcanal(hCy, H.cY);
  Ny =hCy.Nom;
  M =CDataVide();
  Wtot =H.nbPts*vg.ess;
  Wcur =1;
  for E =1:vg.ess
    H.Tmax =4*hdchnl.rate(H.cX, E);
    smpl =min(hdchnl.nsmpls([H.cX H.cY], E));
    M.D =zeros(smpl, 1, 'double');
    for V =1:H.nbPts
      waitbar(Wcur/Wtot, Wbar);
      Wcur =Wcur+1;
      M.D(:) =sqrt((hCx.Dato.(Nx)(1:smpl, E)-H.Mat(V, 1)).^2+(hCy.Dato.(Ny)(1:smpl, E)-H.Mat(V, 2)).^2);
      P =TrouvePoints(H, M);
      if isempty(P)
        continue;
      end
      for U =1:length(P)
        ptchnl.marquage(H.cPt, E, false, P(U));
      end
    end
    if H.OnTrie
      ptchnl.OnTrie(H.cPt, E);
    end
  end
  delete(Wbar);
end

%--------------------------------------------------------------
% EN ENTRÉE on aura:  tO --> un objet de la classe CImportPoint
%                      V --> un objet de la classe CDataVide
%------------------------------
function Z =TrouvePoints(tO, V)
  Z =[];
  % C contiendra l'index de ceux qui nous intéresse dans V.D
  C =find(V.D <= tO.Rmax);
  if isempty(C)
    return;
  elseif length(C) == 1
    Z =C;
    return;
  end
  Onsort =false;
  cur =0;
  K =[];
  N =length(C);
  while cur < N
    % K contiendra l'index des suites dans C
    K =[];
    cur =cur+1;
    while cur < N
      K(end+1) =cur;
      if C(cur+1)-C(cur) > tO.Tmax
        break;
      end
      cur =cur+1;
    end
    if cur == N
      K(end+1) =cur;
    end
    if ~isempty(K)
      % foo contiendra l'index par rapport à K
      [Q, foo] =min(V.D(C(K)));
      Z(end+1) =C(K(foo));
    end
  end
end
