%
% calculGPS(V)  en entrée on aura un objet CProjetGPS
% 
% Fonction pour faire tous les calculs à partir
% de la longitude-latitude
%
% 20 janv 2012, MEK
%
function calculGPS(hO)
  hO.LbCanVit =get(findobj('Tag','CanVitesse'), 'Value')-1;
  if (hO.cLON == hO.cLAT) & (hO.LbCanVit == 0)
    me =MException('ANALYSE:calculGPS','Les canaux doivent être différents');
    throw(me);
  end
  if ~hO.Distance && ~hO.Vgauche && ~hO.Vdroite
    me =MException('ANALYSE:calculGPS','Il faut choisir au moins une tâche!!!');
    throw(me);
  end
  OA =CAnalyse.getInstance();
  OF =OA.findcurfich();
  hH =OF.Hdchnl;
  Vg =OF.Vg;
  %----------------------------
  % Sur quel essai on travaille
  %--------
  if hO.Ess
    hO.lesess =[1:Vg.ess];
  else
    hO.lesess =get(hO.LbEss, 'Value');
  end
  %----------------------------------
  % Ajout des canaux pour les calculs
  % On effacera les canaux non voulus après
  %----------------------
  ajoutCanaux(hO, hH, Vg);
  %--------------------------------
  % Calcul de la distance parcourue
  %-----------
  if hO.Interv
    laFonction =@Tout2D;
    hO.PI ='Pi';
    hO.PF ='Pf';
  else
  	laFonction =@parPoint2D;
    hO.PI =get(hO.LbPti, 'String');
    hO.PF =get(hO.LbPtf, 'String');
  end
  hD =laFonction(hO, OF, hH, Vg);
  lec =hO.CdistP;
  OF.setcanal(hD, lec);
  N =hD.Nom;
  for U =1:Vg.ess
    hH.max(lec, U) =max(hD.Dato.(N)(1:hH.nsmpls(lec,U), U));
    hH.min(lec, U) =min(hD.Dato.(N)(1:hH.nsmpls(lec,U), U));
  end
  %---------------------------------------
  % Marquage des virage à droite et gauche
  %-------------------------
  if hO.Vgauche | hO.Vdroite
    CalculVir(hO, hD, OF, hH, Vg)
  end
  limpiar(hO, OF, hH, Vg);            % on nettoie les canaux inutiles
  Vg.sauve =1;
  Vg.valeur =0;
  delete(hD);
end

%-----------------------------------------------------
% On ajoute les canaux pour les besoins de la fonction
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     hdchnl --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%-----------------------------------
function ajoutCanaux(tO, hdchnl, vg)
  %------------------------------------
  % Un canal pour la distance parcourue
  %------------------------------------
  hdchnl.duplic(tO.cLON);
  vg.nad =vg.nad+1;
  tO.CdistP =vg.nad;
  hdchnl.adname{tO.CdistP} =['DistAbs(LL)' strtrim(hdchnl.adname{tO.cLON}) '/' strtrim(hdchnl.adname{tO.cLAT})];
  %-----------------------------------
  % Un canal pour les virages à gauche
  %-----------------------------------
  hdchnl.duplic(tO.cLON);
  vg.nad =vg.nad+1;
  tO.CviraG =vg.nad;
  hdchnl.adname{tO.CviraG} =['VirG Lon(' strtrim(hdchnl.adname{tO.cLON}) '/' strtrim(hdchnl.adname{tO.cLAT}) ')'];
  %-----------------------------------
  % Un canal pour les virages à droite
  %-----------------------------------
  hdchnl.duplic(tO.cLAT);
  vg.nad =vg.nad+1;
  tO.CviraD =vg.nad;
  hdchnl.adname{tO.CviraD} =['VirD Lat(' strtrim(hdchnl.adname{tO.cLON}) '/' strtrim(hdchnl.adname{tO.cLAT}) ')'];
end

%-------------------------------------
% On fait le ménage des canaux inutils
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     hF     --> un objet de la classe CFichierAnalyse
%                     hdchnl --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%-----------------------------------
function limpiar(tO, hF, hdchnl, vg)
  Ca =[];
  Cb =false;
  if ~tO.Distance
    Ca =tO.CdistP;
    Cb =tO.CdistP;
  end
  if ~tO.Vgauche
    Ca(end+1) =tO.CviraG;
  end
  if ~tO.Vdroite
    Ca(end+1) =tO.CviraD;
  end
  if Cb
    hF.delcan(Cb);
  end
  if ~isempty(Ca)
    hdchnl.SuppCan(Ca);
  end
  vg.nad =vg.nad-length(Ca);
end

%--------------------------------------------------------
% CALCUL DE LA DISTANCE PARCOURUE EN 2D SUR TOUT LE CANAL
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     Ofich  --> un objet de la classe CFichierAnalyse
%                     hdchnl --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%------------------------------------------
function hCx =Tout2D(tO, Ofich, hdchnl, vg)
	hW =waitbar(0, 'Calcul en cours');
  nbEss =max(tO.lesess)+1;
  hCx =CDtchnl();                % Lon
  hCy =CDtchnl();                % Lat
  Ofich.getcanal(hCx, tO.cLON);
  Nx =hCx.Nom;
  Ofich.getcanal(hCy, tO.cLAT);
  Ny =hCy.Nom;
  waitbar(1/nbEss);
  % on prend en considération le canal de vitesse
  if tO.LbCanVit
    D =AnalyseVitesse(tO, Ofich, hdchnl, vg);
  else
  	D =zeros(size(hCx.Dato.(Nx)));
    smpl =max(hdchnl.nsmpls(tO.cLON, :));
    Vit =ones(smpl, vg.ess);
  	% constantes utiles pour le calcul
  	ff =1-(1/298.257223563);
    Radi =1;
    if tO.Unit
      Radi =pi/180;
    end
    Aa =6378137.0;      % en mètres
    % à partir d'un croquis perso (Sans Altitude)
    for U =tO.lesess
  	  waitbar((U+1)/nbEss);
      hdchnl.comment{tO.CdistP, U} =['Dist-Parcourue vs temps/' hdchnl.comment{tO.cLON, U}];
   		letop =min([hdchnl.nsmpls(tO.cLON, U), hdchnl.nsmpls(tO.cLAT, U)]);
   		lat1 =hCy.Dato.(Ny)(1:letop-1, U)*Radi;
   		lat2 =hCy.Dato.(Ny)(2:letop, U)*Radi;
   		lon1 =hCx.Dato.(Nx)(1:letop-1, U)*Radi;
   		lon2 =hCx.Dato.(Nx)(2:letop, U)*Radi;
      R =Aa*cos(lat1);
      S =R.*(lon1-lon2);
      M =Aa*(lat1-lat2);
      t5 =sqrt(S.*S+M.*M);
      for V = 1:letop-1
        if Vit(V+1, U)
          D(V+1, U) =D(V, U)+t5(V);
        else
          D(V+1, U) =D(V, U);
        end
      end
  	end
	end
	delete(hCy);
	close (hW);
  hCx.Dato.(Nx) =D;
end

%--------------------------------------------------------
% CALCUL DE LA DISTANCE PARCOURUE EN 2D ENTRE DEUX POINTS
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     Ofich  --> un objet de la classe CFichierAnalyse
%                     hdchnl --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%----------------------------------------------
function hCx =parPoint2D(tO, Ofich, hdchnl, vg)
	hW =waitbar(0, 'Calcul en cours');
  nbEss =max(tO.lesess)+1;
  ptchnl =Ofich.Ptchnl;
  lec =tO.CdistP;
  hCx =CDtchnl();
  hCy =CDtchnl();
  Ofich.getcanal(hCx, tO.cLON);
  Nx =hCx.Nom;
  Ofich.getcanal(hCy, tO.cLAT);
  Ny =hCy.Nom;
	D =zeros(size(hCx.Dato.(Nx)));
	canP =tO.GetCanPoint();
  waitbar(1/nbEss);
  % on prend en considération le canal de vitesse
  Vit =AnalyseVitesse(tO, Ofich, hdchnl, vg);
	% constantes utiles pour le calcul (reciprocal flattening of the earth = 298.257223563)
	ff =1-(1/298.257223563);
  Radi =1;
  if tO.Unit
    Radi =pi/180;
  end
  % semimajor axis (semiminor: 6356752.3142 mètres)
  Aa =6378137.0;      % en mètres
	for U =tO.lesess
	  waitbar((U+1)/nbEss);
	  comment =hdchnl.comment{tO.cLON, U};
    hdchnl.comment{lec, U} =['Dist-Parcourue/point invalide/' comment];
    P1 =ptchnl.valeurDePoint(tO.PI, canP, U);
    P2 =ptchnl.valeurDePoint(tO.PF, canP, U);
 		if isempty(P1) || isempty(P2) ||P1 == 0 || P2 == 0
 			% rien à faire
 		elseif P2 == P1
 			% rien à faire
		else
		  if P2 < P1
  			A =P2;
  			P2 =P1;
  			P1 =A;
  		end
   		p1txt =num2str(round(P1/hdchnl.rate(lec, U)*1000)*0.001);
   		p2txt =num2str(round((P2-1)/hdchnl.rate(lec, U)*1000)*0.001);
      hdchnl.comment{lec, U} =['Dist-Parcourue/entre ' p1txt ' et ' p2txt '/' comment];
   		lat1 =hCy.Dato.(Ny)(1:P2-1, U)*Radi;
   		lat2 =hCy.Dato.(Ny)(2:P2, U)*Radi;
   		lon1 =hCx.Dato.(Nx)(1:P2-1, U)*Radi;
   		lon2 =hCx.Dato.(Nx)(2:P2, U)*Radi;
      R =Aa*cos(lat1);
      S =R.*(lon1-lon2);
      M =Aa*(lat1-lat2);
      t5 =sqrt(S.*S+M.*M);
  	  for V = P1:P2-1
        if Vit(V+1, U)
          D(V+1, U) =D(V, U)+t5(V);
        else
          D(V+1, U) =D(V, U);
        end
      end
      hdchnl.nsmpls(lec, U) =P2;
    end
	end
	S =max(hdchnl.nsmpls(lec, :));
  hCx.Dato.(Nx) =D(1:S,:);
	delete(hCy);
	close (hW);
end

%--------------------------------------------------------------------------
% On tient compte des moments ou la vitesse est presque Nulle, soit < 1.5Km
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     hF     --> un objet de la classe CFichierAnalyse
%                     hD     --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%-----------------------------------------
function V =AnalyseVitesse(tO, hF, hD, Vg)
  hVit =CDtchnl();
  hF.getcanal(hVit, tO.LbCanVit);
  V =zeros(size(hVit.Dato.(hVit.Nom)));
  can =hVit.Dato.(hVit.Nom)(:,tO.lesess);
  foo =single(can > 1.5);
  foo(:) =(can.*foo)/3.6;  % vit en m/s
  cur =1;
  for U =tO.lesess
    V(:,U) =cumsum(foo(:,cur)/hD.rate(tO.LbCanVit,U));
    cur =cur+1;
  end
  delete(hVit);
end

%----------------------
% Détection des virages
% EN ENTRÉE on aura:  tO     --> un objet de la classe CProjetGPS
%                     hCDist --> un objet de la classe CDtchnl
%                     Ofich  --> un objet de la classe CFichierAnalyse
%                     hdchnl --> un objet de la classe CHdchnl
%                     vg     --> un objet de la classe CVgAnalyse
%------------------------------------------------
function CalculVir(tO, hCDist, Ofich, hdchnl, vg)
	hW =waitbar(0, 'Recherche des virages en cours');
	ptchnl =Ofich.Ptchnl;
  nbEss =max(tO.lesess)+1;
  hCx =CDtchnl();                % Lon
  hCy =CDtchnl();                % Lat
  Ofich.getcanal(hCx, tO.cLON);
  Nx =hCx.Nom;
  Ofich.getcanal(hCy, tO.cLAT);
  Ny =hCy.Nom;
  Nd =hCDist.Nom;
  waitbar(1/nbEss);
  %-------------------
  % segment de travail
  %---------
	V1P1 =[1:4];               % [1:5]          % [1:5]  % mean(V1P1)       premier pt du premier vecteur
  saut2 =7;                % 4              % 4      % mean(V1P1+saut2) deuxième pt du premier vecteur
  saut3 =saut2+5;          % saut2+4        % 10     % mean(V1P1+saut3) premier pt du deuxième vecteur
  saut4 =saut3+saut2;      % saut3+saut2+1  % 16     % mean(V1P1+saut4) deuxième pt du deuxième vecteur
	segtrav =V1P1(end)+saut4;
  foo =2;                  % step après une première détection
	S2 =V1P1(end)+saut2;     % on marque où
  Aref =40;          % angle de ref
  Amin =5;
  for U =tO.lesess
    Nsmp =hdchnl.nsmpls(tO.CdistP, U);
   	D =zeros(Nsmp, 1);
	  waitbar((U+1)/nbEss);
    hdchnl.comment{tO.CviraG, U} =['Virage Gauche/' hdchnl.comment{tO.cLON, U}];
    hdchnl.comment{tO.CviraD, U} =['Virage Droite/' hdchnl.comment{tO.cLON, U}];
    hdchnl.max(tO.CviraG, U) =hdchnl.max(tO.cLON, U);
    hdchnl.min(tO.CviraG, U) =hdchnl.min(tO.cLON, U);
    hdchnl.max(tO.CviraD, U) =hdchnl.max(tO.cLAT, U);
    hdchnl.min(tO.CviraD, U) =hdchnl.min(tO.cLAT, U);
    %------------------------------------------------------
    % On recherche les samples séparés d'au moins un mètres
    %-------------------------------
 		letop =hdchnl.max(tO.CdistP, U);
 		laref =0;
 		Ecur =1;    % Écriture courante
 		Lcur =1;    % Lecture courante
 		while Lcur < Nsmp
 		  if (hCDist.Dato.(Nd)(Lcur, U)-laref) >= 1.0 %1.5
 		    laref =hCDist.Dato.(Nd)(Lcur, U);
 		    D(Ecur) =Lcur;
 		    Ecur =Ecur+1;
 		  end
 		  Lcur =Lcur+1;
 		end
 		D(Ecur:end) =[];
 		nbVrai =length(D);
 		LaDiff =floor((hdchnl.frontcut(tO.CdistP, U)-hdchnl.frontcut(tO.cLON, U))*hdchnl.rate(tO.CdistP, U));
 		Dp =D+LaDiff;
 		hdchnl.frontcut(tO.cLON, U) =hdchnl.frontcut(tO.CdistP, U);
 		hdchnl.frontcut(tO.cLAT, U) =hdchnl.frontcut(tO.CdistP, U);
 		%-------------------------------------
 		% On commence la recherche des virages
 		%------------------
 		if nbVrai > segtrav
 		  X =hCx.Dato.(Nx)(Dp, U);
 		  Y =hCy.Dato.(Ny)(Dp, U);
 		  vG =0;
 		  vD =0;
 		  laLim =0;   % nb de fois avant qu'on accepte que c un tournant
 		  Si =V1P1;
 		  Su =nbVrai-segtrav;
 		  while Si(end) < Su
   	  	LON =[mean(X(Si)) mean(X(Si+saut2)) mean(X(Si+saut3)) mean(X(Si+saut4))];
   	  	LAT =[mean(Y(Si)) mean(Y(Si+saut2)) mean(Y(Si+saut3)) mean(Y(Si+saut4))];
     		V1 =[LON(2)-LON(1) LAT(2)-LAT(1) 0];
     		V2 =[LON(4)-LON(3) LAT(4)-LAT(3) 0];
     		Teta =atan2(cross(V1, V2), dot(V1, V2))*180/pi;
     		if Teta(3) > Aref
     		  vD =0;
     		  if vG == laLim
       		  ptchnl.Onmark(tO.CviraG, U ,false , D(Si(1)+S2));
       		  Si =Si+saut3;        % Si+segtrav;
       		  vG =0;
       		else
     		    vG =vG+1;
         		Si =Si+foo;
     		  end
     		elseif Teta(3) < -Aref
     		  vG =0;
     		  if vD == laLim
       		  ptchnl.Onmark(tO.CviraD, U ,false , D(Si(1)+S2));
       		  Si =Si+saut3;
       		  vD =0;
       		else
       		  vD =vD+1;
         		Si =Si+foo;
       		end
     		elseif abs(Teta(3)) < Amin
     		  Si =Si+S2;
     		end
     		Si =Si+1;
   		end
    end
	end
	if tO.Vgauche
	  Ofich.setcanal(hCx, tO.CviraG);
	end
	if tO.Vdroite
	  Ofich.setcanal(hCy, tO.CviraD);
	end
	delete(hCx);
	delete(hCy);
	close (hW);
end

%
%  première tentative, 3 segments, 2 vecteur vect(1er pt, dernier pt) de S1 et S3
%       Si =S1(1);
% 		  while Si < Su
%   	  	LON =X([Si Si+saut2 Si+saut3 Si+saut4]);
%   	  	LAT =Y([Si Si+saut2 Si+saut3 Si+saut4]);
%     		V1 =[LON(2)-LON(1) LAT(2)-LAT(1) 0];
%     		V2 =[LON(4)-LON(3) LAT(4)-LAT(3) 0];
%     		Teta =atan2(cross(V1, V2), dot(V1, V2))*180/pi;
%     		if Teta > Aref
%     		  ptchnl.Onmark(tO.CviraG, U ,false , D(Si+saut2));
%     		  Si =Si+segtrav;
%     		elseif Teta < -Aref
%     		  ptchnl.Onmark(tO.CviraD, U ,false , D(Si+saut2));
%     		  Si =Si+segtrav;
%     		end
%     		Si =Si+1;
%   		end
%
%  Seconde tentative avec le calcul des polynomes
%       Si =S1(1);
% 		  while Si < Su
%   	  	LON =X([Si:Si+saut2]);
%   	  	LAT =Y([Si:Si+saut2]);
%   	  	Pp =polyfit(LON, LAT, 1);
%   	  	L([1 2]) =polyval(Pp, LON([1 end]));
%     		V1 =[LON(end)-LON(1) L(2)-L(1) 0];
%   	  	LON =X([Si+saut3:Si+saut4]);
%   	  	LAT =Y([Si+saut3:Si+saut4]);
%   	  	Pp =polyfit(LON, LAT, 1);
%   	  	L([1 2]) =polyval(Pp, LON([1 end]));
%     		V2 =[LON(end)-LON(1) L(2)-L(1) 0];
%     		Teta =atan2(cross(V1, V2), dot(V1, V2))*180/pi;
%     		if Teta > Aref
%     		  ptchnl.Onmark(tO.CviraG, U ,false , Si+saut2);
%     		  Si =Si+segtrav;
%     		elseif Teta < -Aref
%     		  ptchnl.Onmark(tO.CviraD, U ,false , Si+saut2);
%     		  Si =Si+segtrav;
%     		end
%     		Si =Si+1;
%   		end
%   		hCx.Dato.(Nx)(1:length(X), U) =X;
%   		hCy.Dato.(Ny)(1:length(Y), U) =Y;
%