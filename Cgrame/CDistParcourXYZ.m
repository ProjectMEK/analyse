%
% Classe CDistParcourXYZ
%
% Calcul de la distance parcourue
%
% METHODS
%   tO =CDistParcourXYZ()     % CONSTRUCTOR
%   ChangeX(tO, src, event)
%   ChangeY(tO, src, event)
%   ChangeZ(tO, src, event)
%   ChangeInterv(tO, src, event)
%   ChangeCanPoint(tO, src, event)
%   CheckCanPoint(tO)
%   QuelFonction(tO)
%   AuTravail(tO, src, event)
%   hCx =Tout2D(tO)
%   hCx =Tout3D(tO)
%   hCx =parPoint2D(tO)
%   hCx =parPoint3D(tO)
%   V =GetCanPoint(tO)
%   Terminus(tO, src, event)
%
classdef CDistParcourXYZ < handle

  properties
    Fig;        % handle de la figure
    canX =1;
    canY =1;
    canZ =0;
    Interv =1;
    Fonction;  % handle de la fonction de travail
    Pan1;      % handle du panel 1
    Pan2;      % handle du panel 2
    Pt1;       % handle du choix du points de début
    Pt2;       % handle du choix du points de fin
    lecan =1;
  end

  methods

    %------------
    % CONSTRUCTOR
    %-----------------------------
    function tO =CDistParcourXYZ()
      tO.Fig =IDistParcourXYZ(tO);
      tO.CheckCanPoint();
      tO.QuelFonction();
    end

    %---------------------------------------------
    % Change la valeur du canal de la coordonnée X
    %-------------------------------
    function ChangeX(tO, src, event)
      tO.canX =get(src, 'value');
      if tO.lecan == 1
        tO.CheckCanPoint();
      end
    end

    %---------------------------------------------
    % Change la valeur du canal de la coordonnée Y
    %-------------------------------
    function ChangeY(tO, src, event)
      tO.canY =get(src, 'value');
      if tO.lecan == 2
        tO.CheckCanPoint();
      end
    end

    %---------------------------------------------
    % Change la valeur du canal de la coordonnée Z
    %-------------------------------
    function ChangeZ(tO, src, event)
      tO.canZ =get(src, 'value')-1;
      if tO.lecan == 3
        tO.CheckCanPoint();
      end
      tO.QuelFonction();
    end

    %----------------------
    % Intervalle de travail
    % -  tous les échantillons
    % -  à déterminer: [(point de début) (point de fin)]
    %------------------------------------
    function ChangeInterv(tO, src, event)
      tO.Interv =get(src, 'value');
      if tO.Interv-1
      	set(tO.Pan1, 'visible','off');
      	set(tO.Pan2, 'visible','on');
      else
      	set(tO.Pan2, 'visible','off');
      	set(tO.Pan1, 'visible','on');
      end
      tO.QuelFonction();
    end

    %-----------------------------------------
    % Change le canal pour le choix des points
    % de début et fin d'interval.
    %--------------------------------------
    function ChangeCanPoint(tO, src, event)
      tO.lecan =get(src, 'value');
      tO.CheckCanPoint();
    end

    %------------------------------------------------------------
    % on regarde si on a des points marqués dans le canal choisi.
    % si oui, on les énumère dans les deux listbox: début/fin.
    %-------------------------
    function CheckCanPoint(tO)
      C =tO.GetCanPoint();
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      ppp ={};
      if C
        for U =1:max(hdchnl.npoints(C,:))
          ppp{end+1} =num2str(U);
        end
      end
      if isempty(ppp)
        ppp ={'...'};
      end
      V =get(tO.Pt1, 'value');
      if V > length(ppp)
        V =length(ppp);
      end
      set(tO.Pt1, 'value',1, 'string',ppp, 'value',V);
      V =get(tO.Pt2, 'value');
      if V > length(ppp)
        V =length(ppp);
      end
      set(tO.Pt2, 'value',1, 'string',ppp, 'value',V);
    end

    %----------------------------------------------
    % changement du choix de la fonction de travail
    % en fonction du canal Z (2D ou 3D)
    %------------------------
    function QuelFonction(tO)
      tO.Fonction =@tO.Tout2D;
      if tO.Interv-1
      	if tO.canZ
      		tO.Fonction =@tO.parPoint3D;
      	else
      		tO.Fonction =@tO.parPoint2D;
      	end
      elseif tO.canZ
      	tO.Fonction =@tO.Tout3D;
      end
    end

    %---------------------------------
    function AuTravail(tO, src, event)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      vg =Ofich.Vg;
      % Ajout des canaux utiles
      hdchnl.duplic(tO.canX);
      vg.nad =vg.nad+1;
      lec =vg.nad;
      hdchnl.adname{lec} =['DistAbs(XY)' deblank(hdchnl.adname{tO.canX}) '/' deblank(hdchnl.adname{tO.canY})];
      hD =tO.Fonction();
      Ofich.setcanal(hD, lec);
      N =hD.Nom;
      for U =1:vg.ess
        hdchnl.max(lec, U) =max(hD.Dato.(N)(1:hdchnl.nsmpls(lec,U), U));
        hdchnl.min(lec, U) =min(hD.Dato.(N)(1:hdchnl.nsmpls(lec,U), U));
      end
      vg.sauve=1;
      vg.valeur=0;
      gaglobal('editnom');
      delete(hD);
      delete(tO.Fig);
    end

    %--------------------------------------
    % CAlcul de la distance parcourue en 2D
    % sur tout l'interval
    %-----------------------
    function hCx =Tout2D(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      hCx =CDtchnl();
      hCy =CDtchnl();
      Ofich.getcanal(hCx, tO.canX);
      Nx =hCx.Nom;
      Ofich.getcanal(hCy, tO.canY);
      Ny =hCy.Nom;
   		hW =waitbar(0, 'Calcul en cours');
   		D =zeros(size(hCx.Dato.(Nx)));
   		for U =1:vg.ess
   		  waitbar(U/vg.ess);
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/total/' hdchnl.comment{tO.canX, U}];
     		letop =min([hdchnl.nsmpls(tO.canX, U), hdchnl.nsmpls(tO.canY, U)]);
     		% calcul de la distance inter-échantillon
     		% Xx =hCx.Dato.(Nx)(2:letop, U)-hCx.Dato.(Nx)(1:letop-1, U);
     		% Yy =hCy.Dato.(Ny)(2:letop, U)-hCy.Dato.(Ny)(1:letop-1, U);
     		% DXY =sqrt(Xx.^2+Yy.^2);
     	  DXY =sqrt(diff(hCx.Dato.(Nx)(1:letop, U)).^2 + diff(hCy.Dato.(Ny)(1:letop, U)).^2);
   		  for V = 1:letop-1
          D(V+1, U) =D(V, U)+DXY(V);
        end
   		end
   		delete(hCy);
   		close (hW);
      hCx.Dato.(Nx) =D;
    end

    %--------------------------------------
    % CAlcul de la distance parcourue en 3D
    % sur tout l'interval
    %-----------------------
    function hCx =Tout3D(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      hCx =CDtchnl();
      hCy =CDtchnl();
      hCz =CDtchnl();
      Ofich.getcanal(hCx, tO.canX);
      Nx =hCx.Nom;
      Ofich.getcanal(hCy, tO.canY);
      Ny =hCy.Nom;
      Ofich.getcanal(hCz, tO.canZ);
      Nz =hCz.Nom;
   		hW =waitbar(0, 'Calcul en cours');
   		D =zeros(size(hCx.Dato.(Nx)));
   		for U =1:vg.ess
   		  waitbar(U/vg.ess);
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/total/' hdchnl.comment{tO.canX, U}];
     		letop =min([hdchnl.nsmpls(tO.canX, U), hdchnl.nsmpls(tO.canY, U), hdchnl.nsmpls(tO.canZ, U)]);
     		% calcul de la distance inter-échantillon
     		% Xx =hCx.Dato.(Nx)(2:letop, U)-hCx.Dato.(Nx)(1:letop-1, U);
     		% Yy =hCy.Dato.(Ny)(2:letop, U)-hCy.Dato.(Ny)(1:letop-1, U);
     		% Zz =hCz.Dato.(Nz)(2:letop, U)-hCz.Dato.(Nz)(1:letop-1, U);
     	  DXY =sqrt(diff(hCx.Dato.(Nx)(1:letop, U)).^2 + diff(hCy.Dato.(Ny)(1:letop, U)).^2 + diff(hCz.Dato.(Nz)(1:letop, U)).^2);
   		  for V = 1:letop-1
          D(V+1, U) =D(V, U)+DXYZ(V);
        end
   		end
   		lenom =hdchnl.adname{vg.nad};
      hdchnl.adname{vg.nad} =[lenom '/' deblank(hdchnl.adname{tO.canZ})];
   		delete(hCy);
   		delete(hCz);
   		close (hW);
      hCx.Dato.(Nx) =D;
    end

    %--------------------------------------
    % CAlcul de la distance parcourue en 2D
    % sur l'interval choisi
    %-----------------------
    function hCx =parPoint2D(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      vg =Ofich.Vg;
      hCx =CDtchnl();
      hCy =CDtchnl();
      Ofich.getcanal(hCx, tO.canX);
      Nx =hCx.Nom;
      Ofich.getcanal(hCy, tO.canY);
      Ny =hCy.Nom;
   		hW =waitbar(0, 'Calcul en cours');
   		D =zeros(size(hCx.Dato.(Nx)));
   		canP =tO.GetCanPoint();
   		for U =1:vg.ess
   		  waitbar(U/vg.ess);
   		  comment =hdchnl.comment{tO.canX, U};
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/point invalide/' comment];
     		if hdchnl.npoints(canP, U) == 0
     			continue;
     		else
     			P =get(tO.Pt1, 'value');
     			if P > hdchnl.npoints(canP, U)             % pas assez de pt ds ce canal
     				continue;
     			elseif ptchnl.Dato(P, hdchnl.point(canP, U), 2) == -1    % pt bidon
     				continue;
     			else
     				P1 =double(ptchnl.Dato(P, hdchnl.point(canP, U), 1))/hdchnl.rate(canP, U);
     				if P1 > hdchnl.sweeptime(canP, U)
     				  continue;
     				end
     				P1 =max(1, round(P1*hdchnl.rate(vg.nad, U)));
     			end
     			P =get(tO.Pt2, 'value');
     			if P > hdchnl.npoints(canP, U)
     				continue;
     			elseif ptchnl.Dato(P, hdchnl.point(canP, U), 2) == -1
     				continue;
     			else
     				P2 =double(ptchnl.Dato(P, hdchnl.point(canP, U), 1))/hdchnl.rate(canP, U);
     				if P2 > hdchnl.sweeptime(canP, U)
     				  continue;
     				end
     				P2 =max(1, round(P2*hdchnl.rate(vg.nad, U)));
     			end
     			if P2 == P1
     				continue;
     			elseif P2 < P1
     				A =P2;
     				P2 =P1;
     				P1 =A;
     			end
     		end  % if hdchnl.npoints(canP, U) == 0
     		p1txt =num2str(round(P1/hdchnl.rate(vg.nad, U)*1000)*0.001);
     		p2txt =num2str(round((P2-1)/hdchnl.rate(vg.nad, U)*1000)*0.001);
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/entre ' p1txt ' et ' p2txt '/' comment];
     		cur =1;
     		% calcul de la distance inter-échantillon
     		% Xx =hCx.Dato.(Nx)(P1+1:P2, U)-hCx.Dato.(Nx)(P1:P2-1, U);
     		% Yy =hCy.Dato.(Ny)(P1+1:P2, U)-hCy.Dato.(Ny)(P1:P2-1, U);
     		% DXY =sqrt(Xx.^2+Yy.^2);
     	  DXY =sqrt(diff(hCx.Dato.(Nx)(P1:P2, U)).^2 + diff(hCy.Dato.(Ny)(P1:P2, U)).^2);
   		  for V = P1:P2-1
          D(cur+1, U) =D(cur, U)+DXY(cur);
          cur =cur+1;
        end
        hdchnl.frontcut(vg.nad, U) =hdchnl.frontcut(vg.nad, U)+(P1-1)/hdchnl.rate(vg.nad, U);
        hdchnl.nsmpls(vg.nad, U) =P2-P1;
   		end  % for U =1:vg.ess
   		close (hW);
   		S =max(hdchnl.nsmpls(vg.nad, :));
      hCx.Dato.(Nx) =D(1:S,:);
   		delete(hCy);
    end

    %--------------------------------------
    % CAlcul de la distance parcourue en 3D
    % sur l'interval choisi
    %-----------------------
    function hCx =parPoint3D(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      ptchnl =Ofich.Ptchnl;
      vg =Ofich.Vg;
      hCx =CDtchnl();
      hCy =CDtchnl();
      hCz =CDtchnl();
      Ofich.getcanal(hCx, tO.canX);
      Nx =hCx.Nom;
      Ofich.getcanal(hCy, tO.canY);
      Ny =hCy.Nom;
      Ofich.getcanal(hCz, tO.canZ);
      Nz =hCz.Nom;
   		hW =waitbar(0, 'Calcul en cours');
   		D =zeros(size(hCx.Dato.(Nx)));
   		canP =tO.GetCanPoint();
   		for U =1:vg.ess
   		  waitbar(U/vg.ess);
   		  comment =hdchnl.comment{tO.canX, U};
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/point invalide/' comment];
     		if hdchnl.npoints(canP, U) == 0
     			continue;
     		else
     			P =get(tO.Pt1, 'value');
     			if P > hdchnl.npoints(canP, U)
     				continue;
     			elseif ptchnl.Dato(P, hdchnl.point(canP, U), 2) == -1
     				continue;
     			else
     				P1 =double(ptchnl.Dato(P, hdchnl.point(canP, U), 1))/hdchnl.rate(canP, U);
     				if P1 > hdchnl.sweeptime(canP, U)
     				  continue;
     				end
     				P1 =max(1, round(P1*hdchnl.rate(vg.nad, U)));
     			end
     			P =get(tO.Pt2, 'value');
     			if P > hdchnl.npoints(canP, U)
     				continue;
     			elseif ptchnl.Dato(P, hdchnl.point(canP, U), 2) == -1
     				continue;
     			else
     				P2 =double(ptchnl.Dato(P, hdchnl.point(canP, U), 1))/hdchnl.rate(canP, U);
     				if P2 > hdchnl.sweeptime(canP, U)
     				  continue;
     				end
     				P2 =max(1, round(P2*hdchnl.rate(vg.nad, U)));
     			end
     			if P2 == P1
     				continue;
     			elseif P2 < P1
     				A =P2;
     				P2 =P1;
     				P1 =A;
     			end
     		end
     		p1txt =num2str(round(P1/hdchnl.rate(vg.nad, U)*1000)*0.001);
     		p2txt =num2str(round((P2-1)/hdchnl.rate(vg.nad, U)*1000)*0.001);
        hdchnl.comment{vg.nad, U} =['Dist-Parcourue/entre ' p1txt ' et ' p2txt '/' comment];
     		cur =1;
     		% calcul de la distance inter-échantillon
     		% Xx =hCx.Dato.(Nx)(P1+1:P2, U)-hCx.Dato.(Nx)(P1:P2-1, U);
     		% Yy =hCy.Dato.(Ny)(P1+1:P2, U)-hCy.Dato.(Ny)(P1:P2-1, U);
 		    % Zz =hCz.Dato.(Nz)(P1+1:P2, U)-hCz.Dato.(Nz)(P1:P2-1, U);
     		% DXYZ =sqrt(Xx.^2+Yy.^2+Zz.^2);
     	  DXY =sqrt(diff(hCx.Dato.(Nx)(P1:P2, U)).^2 + diff(hCy.Dato.(Ny)(P1:P2, U)).^2 + diff(hCz.Dato.(Nz)(P1:P2, U)).^2);
   		  for V = P1:P2-1
          D(cur+1, U) =D(cur, U)+DXYZ(cur);
          cur =cur+1;
        end
        hdchnl.frontcut(vg.nad, U) =hdchnl.frontcut(vg.nad, U)+(P1-1)/hdchnl.rate(vg.nad, U);
        hdchnl.nsmpls(vg.nad, U) =P2-P1;
   		end
   		lenom =hdchnl.adname{vg.nad};
      hdchnl.adname{vg.nad} =[lenom '/' deblank(hdchnl.adname{tO.canZ})];
   		close (hW);
   		S =max(hdchnl.nsmpls(vg.nad, :));
      hCx.Dato.(Nx) =D(1:S,:);
   		delete(hCy);
   		delete(hCz);
    end

    %------------------------------
    % retourne le canal sélectionné
    %--------------------------
    function V =GetCanPoint(tO)
      V =tO.lecan-3;
      switch tO.lecan
      case 1
      	V =tO.canX;
      case 2
      	V =tO.canY;
      case 3
      	V =tO.canZ;
      end
    end

    %---------
    % On ferme
    %--------------------------------
    function Terminus(tO, src, event)
      delete(tO.Fig);
    end

  end % methods
end % classdef
