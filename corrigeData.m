% 
% Fonction (Appelé par CCorrige) pour demander les infos relatives à la
% correction des datas puis on passe à l'action.
%
% Les calculs se font par différentes méthodes.
% 
% Polynomial où on spécifie l'ordre du polynome désiré ainsi que la fenêtre de travail.
%
% Il n'y a rien de mieux que de faire quelques tests avant de procéder au traitement final.
%
% Fonction pour corriger les données manquantes et/ou mises à zéros par les logiciels
%
function ETPUIS =corrigeData(hO)
  % Barre de défilement
  txtWb ='Correction des datas... ';
  leWb =laWaitbarModal(0, txtWb, 'C', 'C', gcf);
  % on récupère les infos du fichier à traiter
  ETPUIS =false;
  Ofich =hO.Ofich;
  vg =hO.Vg;
  dtchnl =CDtchnl();
  hdchnl =hO.Hdchnl;
  ptchnl =Ofich.Ptchnl;
  % quel tache a été choisi?
  ccc =get(findobj('tag','GroupBTN'), 'selectedobject');
  Foo =get(ccc, 'tag');
  vcritic =0;
  fen ='0';
  tiempo =0;
  NbPasse =1;
  afaire =str2num(Foo(4:end));
  if afaire < 4
    popo =get(findobj('tag','CPolyFit'),'Value');          % Polynome(1) ou Spline(0)
    if popo
      polyord =get(findobj('tag','COrdrePoly'),'String');
      polyordre =str2double(polyord);                      % ordre du polynome
    end
    vcritic =str2num(get(findobj('tag','CValeur'),'String'));
    fen =get(findobj('tag','CFenCalcul'),'String');
  elseif afaire == 4
    VCR =str2num(get(findobj('tag','CDiffIsmp'),'String'));
    Ffen =str2num(get(findobj('tag','CLargePic'),'String'));
    vcritic =[];
    fen =[];
    NbPasse =length(VCR)*length(Ffen);
    IPic =get(findobj('tag','CPicInterpol'), 'Value');
    for FOO1 =1:length(Ffen)
      for FOO2 =1:length(VCR)
        vcritic(end+1) =VCR(FOO2);
        fen =[fen num2str(Ffen(FOO1)) ' '];
      end
    end
  elseif afaire == 5
    vcritic =str2num(get(findobj('tag','CNouvVal'),'String'));
  else
    vradi =get(findobj('tag','CRadianDegre'),'value');
    vangl =pi-(get(findobj('tag','CDomaine'),'value')*pi)/2;
    if ~vradi
      vangl =vangl/pi*180;
    end
    vanglm =-2*vangl;
    vanglp =2*vangl;
  end
  if isempty(vcritic) && afaire < 6
    return;
  end
  if ~hO.Interv
    Premier =get(hO.LbPti,'string');
    Dernier =get(hO.LbPtf,'string');
    if ~(isSyntaxBornesValid(Premier) && isSyntaxBornesValid(Dernier))
      return;
    end
  end
  lesess =get(findobj('tag','CEssTous'),'Value');     % tous les essais ou ceux sélectionnés
  if lesess
    lesess =1:vg.ess;
  else
    lesess =get(hO.LbEss,'Value');
  end
  nbess =length(lesess);
  rayon =str2num(fen);                             % Nb de point pour le lissage en chiffre
  lescan =hO.CualCan;
  nombre =length(lescan);
  % paramètre pour la barre de défilement
  leBout =nombre*nbess*NbPasse+1;
  renduA =1;
  waitbar(renduA/leBout, leWb);
  if ~hO.ecraser
    hdchnl.duplic(lescan);
  end
  for qQ =1:NbPasse
    for i =1:nombre    % sur le nombre de canaux
      if ~hO.ecraser
        lec =vg.nad+i;
      else
        lec =lescan(i);
      end
      Ofich.getcanal(dtchnl, lescan(i));
      N =dtchnl.Nom;
      %___________________________________________
      % ON TRAITE UN ESSAI À LA FOIS
      %-------------------------------------------
      for jj = 1:nbess
        % barre de défilement
        renduA =renduA+1;
        lesMots =[txtWb 'passe: ' num2str(qQ) ', canal: ' num2str(i) ', essai: ' num2str(jj)];
        waitbar((renduA)/leBout, leWb,lesMots);
        alldata =hdchnl.nsmpls(lec, lesess(jj));
        Vrate =hdchnl.rate(hO.lecan(i), lesess(jj));
        Nrate =hdchnl.rate(lec, lesess(jj));
        %_________________________________________
        % On détermine l'intervale de travail
        %-----------------------------------------
        if hO.Interv
          %_______________________________________
          % tous les smpls
          %---------------------------------------
          Desde =1;
          Hasta =alldata;
        else
          %_______________________________________
          % les smpls choisis
          %---------------------------------------
          Desde =(ptchnl.valeurDePoint(Premier, hO.lecan(i), lesess(jj))/Vrate)+hdchnl.frontcut(hO.lecan(i), lesess(jj));
          Desde =max(1, ceil((Desde-hdchnl.frontcut(lec, lesess(jj)))*Nrate));
          Hasta =(ptchnl.valeurDePoint(Dernier, hO.lecan(i), lesess(jj))/Vrate)+hdchnl.frontcut(hO.lecan(i), lesess(jj));
          Hasta =min(alldata, ceil((Hasta-hdchnl.frontcut(lec, lesess(jj)))*Nrate));
        end
        vi =[];
        if afaire == 1
          vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) <= vcritic);  % contient l'adresse des <= à
        elseif afaire == 2
          vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) >= vcritic);  % contient l'adresse des >= à
        elseif afaire == 3
          vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) == vcritic);  % contient l'adresse des == à
        elseif afaire == 5 & hO.critere
          switch hO.choixcritere
          case 1
            vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) >= hO.vcritere);  % contient l'adresse des >= à
          case 2
            vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) == hO.vcritere);  % contient l'adresse des == à
          case 3
            vi =find(dtchnl.Dato.(N)(1:alldata,lesess(jj)) <= hO.vcritere);  % contient l'adresse des <= à
          end
          oncheck =find(vi<Desde | vi>Hasta);
          if ~isempty(oncheck)
            vi(oncheck) =[];
          end
        else
          vi(1) =Desde;
          vi(2) =Hasta;
          if afaire == 4
          	tiempo =round(rayon*1.25*Nrate);
            elbuf =dtchnl.Dato.(N)(vi(1)+1:vi(2),lesess(jj))-dtchnl.Dato.(N)(vi(1):vi(2)-1,lesess(jj));
            corrvi =esunpico(elbuf, vcritic(qQ), tiempo(qQ));          % contient l'adresse des Pics
          end
        end
        ladat = 1;          % pointeur pour savoir quelle data on traite dans vi
        lvi = length(vi);
        if lvi > 0   % on a des points à corrigés
          %
          % Pour les débuts-fins
          % Si on choisit un interval de pt, autre que Pi-Pf,
          % alors le début ou la fin modifier ne sera pas corrigé
          %
          if afaire < 4 & hO.DebFin
            V =1;
            if Desde == 1 & V == vi(V)
              while V <= lvi & V == vi(V) & V < Hasta
                V =V+1;
              end
              V =V-1;
              if V < alldata
                dtchnl.Dato.(N)(1:V,lesess(jj)) =dtchnl.Dato.(N)(V+1,lesess(jj));
              end
            end
            V =alldata;
            dernier =find(vi == V);
            if ~isempty(dernier) & V == Hasta
              while dernier >= 1 & V == vi(dernier)
                V =V-1;
                dernier =dernier-1;
              end
              V =V+1;
              if V > 1
                dtchnl.Dato.(N)(V:end,lesess(jj)) =dtchnl.Dato.(N)(V-1,lesess(jj));
              end
            end
          elseif afaire < 4
            while ladat <= lvi
              if (vi(ladat) < Desde) | (vi(ladat) > Hasta)
                ladat =ladat+1;
                continue;
              end
              nbdat = 1;          % nombre de zéros consécutifs
              while ((ladat+nbdat) <= lvi) && ((vi(ladat+nbdat)-vi(ladat+nbdat-1))==1)
                nbdat =nbdat+1;
              end
              r = [0 0 0 0];
              temps = [];
              %******************************************************
              % Sélection d'une fenêtre de datas à gauche des zéros *
              %******************************************************
              if vi(ladat) > rayon
                r(1) =vi(ladat)-rayon;
                r(2) =vi(ladat)-1;
                temps =[r(1):r(2)];
              elseif vi(ladat) == 2
                r(1) =1;
                temps =[r(1)];
              elseif vi(ladat) == 1
                temps =[];
              elseif vi(ladat) <= rayon
                r(1) =1;
                r(2) =vi(ladat)-1;
                temps =[r(1):r(2)];
              end
              %******************************************************
              % Sélection d'une fenêtre de datas à droite des zéros *
              %******************************************************
              if vi(ladat + nbdat - 1) == alldata
              elseif vi(ladat + nbdat - 1) == alldata-1
                r(3) = alldata;
                temps=[temps,r(3)];
              elseif vi(ladat + nbdat - 1) <= alldata-rayon
                r(3) = vi(ladat)+nbdat;
                if (ladat+nbdat-1<lvi)
                  if vi(ladat+nbdat)>(vi(ladat)+nbdat+rayon-1)
                    r(4)=r(3)+rayon-1;
                    temps=[temps,r(3):r(4)];
                  elseif r(3) == vi(ladat+nbdat)-1
                    temps=[temps,r(3)];
                  else
                    r(4)=vi(ladat+nbdat)-1;
                    temps=[temps,r(3):r(4)];
                  end
                else
                  r(4)=r(3)+rayon-1;
                  temps=[temps,r(3):r(4)];
                end
              else
                r(3) = vi(ladat)+nbdat;
                if (ladat+nbdat-1<lvi)
                  if r(3) == vi(ladat+nbdat)-1
                    temps=[temps,r(3)];
                  else
                    r(4)=vi(ladat+nbdat)-1;
                    temps=[temps,r(3):r(4)];
                  end
                else
                  r(4)=alldata;
                  temps=[temps,r(3):r(4)];
                end
              end
              if length(temps) > 2
                if popo
                  lescoef =polyfit(temps'/Nrate, dtchnl.Dato.(N)(temps,lesess(jj)),polyordre);  % '
                  dtchnl.Dato.(N)(vi(ladat):vi(ladat)+nbdat-1,lesess(jj)) =polyval(lescoef,(vi(ladat):vi(ladat)+nbdat-1)/Nrate);
                else
                	if length(vi(ladat):vi(ladat)+nbdat-1) >= 1
                    dtchnl.Dato.(N)(vi(ladat):vi(ladat)+nbdat-1,lesess(jj)) =spline(temps/Nrate, dtchnl.Dato.(N)(temps,lesess(jj)),(vi(ladat):vi(ladat)+nbdat-1)/Nrate);
                  end
                end
              end
              ladat = ladat + nbdat;
            end
          elseif afaire == 4
            if tiempo(qQ) > 0
              while ~ isempty(corrvi)
                Ti =corrvi(2)+vi(1)-1;
                Tf =corrvi(corrvi(1)+1)+vi(1)-1;
                DeltaY =dtchnl.Dato.(N)(Ti+1, lesess(jj))-dtchnl.Dato.(N)(Ti, lesess(jj));
                if IPic
                	dtchnl.Dato.(N)(Ti+1:Tf-1,lesess(jj)) =dtchnl.Dato.(N)(Ti+1:Tf-1, lesess(jj))-DeltaY;
                elseif Ti == 1
                	dtchnl.Dato.(N)(Ti:Tf,lesess(jj)) =dtchnl.Dato.(N)(Tf,lesess(jj));
                else
                  pente =(dtchnl.Dato.(N)(Tf,lesess(jj))-dtchnl.Dato.(N)(Ti,lesess(jj)))/(corrvi(1)-1);
                  for U =Ti+1:Tf-1
                    dtchnl.Dato.(N)(U,lesess(jj)) =dtchnl.Dato.(N)(U-1,lesess(jj))+pente;
                  end
                end
                corrvi(1:corrvi(1)+1) =[];
              end
            else
              Foo =size(corrvi,1);
              for A =1:Foo
                Ti =corrvi(A, 1);
                if Ti > 4
                  DeltaY =mean(dtchnl.Dato.(N)(Ti-3:Ti-1, lesess(jj))-dtchnl.Dato.(N)(Ti-4:Ti-2, lesess(jj)));
                else
                  DeltaY =0;
                end
                dtchnl.Dato.(N)(Ti:end, lesess(jj)) =dtchnl.Dato.(N)(Ti:end, lesess(jj))-corrvi(A, 2)+DeltaY;
              end
            end
          elseif afaire == 5 & hO.critere
            dtchnl.Dato.(N)(vi,lesess(jj)) =vcritic;
          elseif vi(1)>0 && vi(2)>= vi(1)
            if afaire == 5
              dtchnl.Dato.(N)(vi(1):vi(2),lesess(jj))=vcritic;
            else
              sss=abs(dtchnl.Dato.(N)(vi(1)+1:vi(2),lesess(jj))-...
                      dtchnl.Dato.(N)(vi(1):vi(2)-1,lesess(jj)));
              ttt=find(sss > vangl);
              if mod(length(ttt),2) == 1
                for u=1:2:(length(ttt)-1)
                  if dtchnl.Dato.(N)(ttt(u),lesess(jj)) > 0
                    dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))=...
                            dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))+vanglp;
                  else
                    dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))=...
                            dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))+vanglm;
                  end
                end
                if dtchnl.Dato.(N)(ttt(end),lesess(jj)) > 0
                  dtchnl.Dato.(N)(ttt(end)+1:vi(2),lesess(jj))=...
                                  dtchnl.Dato.(N)(ttt(end)+1:vi(2),lesess(jj))+vanglp;
                else
                  dtchnl.Dato.(N)(ttt(end)+1:vi(2),lesess(jj))=...
                                  dtchnl.Dato.(N)(ttt(end)+1:vi(2),lesess(jj))+vanglm;
                end
              else
                for u=1:2:length(ttt)
                  if dtchnl.Dato.(N)(ttt(u),lesess(jj)) > 0
                    dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))=...
                            dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))+vanglp;
                  else
                    dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))=...
                            dtchnl.Dato.(N)(ttt(u)+1:ttt(u+1),lesess(jj))+vanglm;
                  end
                end
              end
            end
          end
        end
        hdchnl.max(lec,lesess(jj)) =max(dtchnl.Dato.(N)(1:hdchnl.nsmpls(lec, lesess(jj)),lesess(jj)));
        hdchnl.min(lec,lesess(jj)) =min(dtchnl.Dato.(N)(1:hdchnl.nsmpls(lec, lesess(jj)),lesess(jj)));
      end
      Ofich.setcanal(dtchnl, lec);
    end
  end
  if ~hO.ecraser
    for i=1:nombre
      nc = ['CORR-0(' deblank(hdchnl.adname{lescan(i)}) ')'];
      hdchnl.adname{vg.nad+i} =nc;
      for jj =1:nbess
        hdchnl.comment{vg.nad+i, lesess(jj)} =['Corr-0/' hdchnl.comment{lescan(i), lesess(jj)} ', Fen=' fen '//'];
      end
    end
    vg.nad =vg.nad+nombre;
  else
    for i=1:nombre
      for jj=1:nbess
        hdchnl.comment{lescan(i), lesess(jj)} =['Corr-0/' hdchnl.comment{lescan(i), lesess(jj)} ', Fen=' fen '//'];
      end
    end
  end
  delete(leWb);
  ETPUIS =true;
end

%---------------------------------------------------
% Cherche les pics positifs ou négatifs et soustrait
% cette valeur à toutes la courbe à droite
%
% Au retour on aura une matrice ordonnée de cette façon
% [length(Xi) Xi(:) length(Xu) Xu(:) ...]
%-------
function salida =esunpico(ladiff, V, larg)
  if larg > 0
    salida =ZZesunpico(ladiff, V, larg);
  else
    salida =[];
  	Vv =abs(V);
  	pbuf =find(abs(ladiff) >= Vv);
  	if isempty(pbuf)
    	return;
    end
    salida =[pbuf+1 ladiff(pbuf)];
  end
end

%------------------------------------------------
% Cherche les pics positifs ou négatifs à enlever
%
% Au retour on aura une matrice ordonnée de cette façon
% [length(Xi) Xi(:) length(Xu) Xu(:) ...]
%-------
function salida =ZZesunpico(ladiff, V, larg)
  salida =[];
  Nb =length(ladiff);
	Vv =abs(V);
	checkV =Vv;
	pbuf =find(abs(ladiff) >= Vv);
	if isempty(pbuf)
  	return;
  end
  depart =pbuf(1);
  while depart < Nb
    if ladiff(depart) > 0
    	cc =lamonter(ladiff, depart, -checkV, Nb);
    else
    	cc =ladescente(ladiff, depart, checkV, Nb);
    end
    if length(cc) <= larg
      salida(end+1) =length(cc);
      salida(end+1:end+(length(cc))) =cc;
      dernier =cc(end);
    else
      dernier =depart+1;
    end
  	while pbuf(1) < dernier
  		pbuf(1) =[];
  		if isempty(pbuf)
  		  return;
  		end
  	end
  	depart =pbuf(1);
  end
end

%----------------------------
% Dato contient les Xi+1 - Xi
% debut le premier échantillon supérieur à la valeur critique
% Vcritic est la valeur critique
% Nsmpl le nombre d'échantillon total
%
% On va faire la somme des différences et lorsque l'on
% va revenir sous la valeur critique... le pic sera
% considéré comme terminé
%-------
function Tt =lamonter(Dato, debut, Vcritic, Nsmpl)
  cur =debut+1;
  while cur < Nsmpl
  	if Dato(cur) > -Vcritic
  	  cur =Nsmpl-1;
  	  break;
  	elseif Dato(cur) < Vcritic
  		break;
  	end
		cur =cur+1;
  end
  Tt =debut:cur+1;
end
%-------
function Tt =ladescente(Dato, debut, Vcritic, Nsmpl)
  cur =debut+1;
  while cur < Nsmpl
  	if Dato(cur) < -Vcritic
  	  cur =Nsmpl-1;
  	  break;
  	elseif Dato(cur) > Vcritic
  		break;
  	end
		cur =cur+1;
  end
  Tt =debut:cur+1;
end
