% 
% DialogBox pour demander les paramètres relatifs au CUT
% On pourra alors enlever des échantillons au début et/ou à la fin
% ou même enlever une section entre deux bornes/points
%
function couperData(varargin)
  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
    wch =guidata(gcf);
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  %--------------
  switch commande
  %---------------
  case 'ouverture'
    large =300; haut=470;
    lapos =positionfen('G','H',large,haut);
    fig =figure('Name','MENUCOUPER', 'Tag','LaCoupe', ...
            'Position',lapos, ...
            'CloseRequestFcn','couperData(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIPanelBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIPanelunits','pixels',...
            'defaultUIControlunits','pixels',...
            'defaultUIControlFontSize',12,...
            'Resize','off');
    haut=haut-45;
    uicontrol('Parent',fig, ...
            'Position',[25 haut 250 25], ...
            'FontSize',16,...
            'String','Temps à couper (sec.)', ...
            'Style','text');
    haut=haut-235; Hpan =220;
    lepan =uipanel('Parent',fig, 'tag','PanelUno', 'Position',[5 haut large-10 Hpan], 'bordertype','beveledin');
    hautp =Hpan-35;
    uicontrol('Parent',lepan, 'Position',[50 hautp 90 20], 'Style','text', 'String','Au début:');
    uicontrol('Parent',lepan, 'Position',[160 hautp 90 20], 'Style','text', 'String','À la fin:');
    hautp =hautp-30;
    uicontrol('Parent',lepan, 'Tag','TempsDebut', 'Position',[70 hautp 50 20], ...
            'Callback','couperData(''avant'')', 'string','0', 'Style','edit');
    uicontrol('Parent',lepan, 'tag','TempsFin', 'Position',[180 hautp 50 20], ...
            'Callback','couperData(''apres'')', 'string','0', 'Style','edit');
    hautp =hautp-45;
    tmptot =min(hdchnl.sweeptime(:));
    uicontrol('Parent',lepan, 'tag','TempsRestant', 'Position',[25 hautp 250 30], ...
            'Style','text', 'String',['Temps restant: ', num2str(tmptot), ' sec.']);
    hautp =hautp-30;
    uicontrol('Parent',lepan, 'tag','PtaZero', 'Position',[50 hautp 200 25], ...
            'style','checkbox', 'HorizontalAlignment','right', 'fontsize',9,...
            'visible','off', 'value',0, 'String','Remettre le premier point à T = 0');
    uicontrol('Parent',lepan, 'Callback','couperData(''DebutvsSect'')', ...
            'Position',[10 10 75 20], 'String','Section');
    lapos =get(lepan,'position'); hautp =Hpan;
    lepan =uipanel('Parent',fig, 'tag','PanelDuo', 'Position',[5 haut large-10 Hpan], ...
                 'bordertype','beveledin', 'visible','off');
    hautp =Hpan-35;
    uicontrol('Parent',lepan, 'Position',[50 hautp 90 20], 'Style','text', 'String','Début Sect.');
    uicontrol('Parent',lepan, 'Position',[160 hautp 90 20], 'Style','text', 'String','fin Sect.');
    hautp =hautp-30;
    uicontrol('Parent',lepan, 'Tag','SectionDebut', 'Position',[70 hautp 50 20], ...
            'string','0', 'Style','edit');
    uicontrol('Parent',lepan, 'tag','SectionFin', 'Position',[180 hautp 50 20], ...
            'string','0', 'Style','edit');
    hautp =hautp-65;
    uicontrol('Parent',lepan, 'Position',[40 hautp large-(2*40) 35], 'Style','text', 'FontSize',8, ...
            'String','Canal de référence si on y va par no. point: P0 P1 etc...');
    hautp =hautp-30;
    uicontrol('Parent',lepan, 'position',[20 hautp large-(2*20) 25], 'tag','CanalRef', ...
            'style','Popupmenu', 'string',hdchnl.Listadname);
    uicontrol('Parent',lepan, 'Callback','couperData(''SectvsDebut'')', ...
            'Position',[10 10 85 20], 'String','Début/fin');
    haut=haut-50;
    wch.control(2) = uicontrol('Parent',fig, ...
            'Callback','couperData(''oncoupe'')', ...
            'Position',[100 haut 100 20], ...
            'String','Au travail');
    haut =haut-110;
    wch.text(4) = uicontrol('Parent',fig, ...
            'Position',[25 haut 250 90], ...
            'Style','text',...
            'FontSize',11,...
            'String','Prenez note que les essais qui n''ont pas la même longueur temporelle seront comblées à la dimension du plus long essai');
    wch.pan =1;
    set(fig,'WindowStyle','modal');
    guidata(gcf,wch);
  %-----------------
  case 'DebutvsSect'
    set(findobj('tag','PanelDuo'),'visible','on');
    set(findobj('tag','PanelUno'),'visible','off');
    wch.pan =2;
    guidata(gcf,wch);
  %-----------------
  case 'SectvsDebut'
    set(findobj('tag','PanelUno'),'visible','on');
    set(findobj('tag','PanelDuo'),'visible','off');
    wch.pan =1;
    guidata(gcf,wch);
  %-----------
  case 'avant'
    [avant, apres] =LireLimit();
    tmptot =min(hdchnl.sweeptime(:));
    if tmptot-avant-apres > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-avant-apres), ' sec.']);
    elseif tmptot-avant > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-avant), ' sec.']);
      set(findobj('tag','TempsFin'),'String','0');
    elseif tmptot-apres > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-apres), ' sec.']);
      set(findobj('Tag','TempsDebut'),'String','0');
      avant =0;
    end
    if avant>0
      set(findobj('tag','PtaZero'),'visible','on');
    else
      set(findobj('tag','PtaZero'),'visible','off');
    end
  %-----------
  case 'apres'
    [avant, apres] =LireLimit();
    tmptot =min(hdchnl.sweeptime(:));
    if tmptot-avant-apres > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-avant-apres), ' sec.']);
    elseif tmptot-apres > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-apres), ' sec.']);
      set(findobj('Tag','TempsDebut'),'String','0');
      avant =0;
    elseif tmptot-avant > 0
      set(findobj('tag','TempsRestant'),'String',['Temps restant: ', num2str(tmptot-avant), ' sec.']);
      set(findobj('tag','TempsFin'),'String','0');
    end
    if avant > 0
      set(findobj('tag','PtaZero'),'visible','on');
    else
      set(findobj('tag','PtaZero'),'visible','off');
    end
  %-------------
  case 'oncoupe'
    FIG =gcf;
  	hWb =waitbar(0.001, 'On coupe, restez pas en dessous...');
    Dt =CDtchnl();
    vg =Ofich.Vg;
    Wtot =vg.nad*vg.ess;
    ptchnl =Ofich.Ptchnl;
    if wch.pan == 1
      [avant, apres] =LireLimit();
      av =num2str(avant);
      ap =num2str(apres);
      fc =get(findobj('tag','PtaZero'),'value');
      onyva =false;
      letemps =max(hdchnl.sweeptime(:));
      if letemps > min(hdchnl.sweeptime(:))
        large =300; haut=220;
        lapos =positionfen('G', 'H', large, haut, FIG);
        oeuf=figure('Name','Temps d''Acquisition?', 'tag','poquito',...
            'Position',lapos, 'CloseRequestFcn','set(gcf,''tag'',''lemek'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'defaultUIControlunits','pixels', 'defaultUIControlFontUnits', 'pixels', ...
            'defaultUIControlFontSize',12, 'Resize','off');
        ss1 =uicontrol('Parent',oeuf, 'Position',[25 haut-45 225 20], 'Style','checkbox', ...
            'String','rendre tous les canaux identiques', 'value',1);
        uicontrol('Parent',oeuf, 'Position',[25 haut-120 250 45], 'FontSize',14, ...
            'String',['Si activé, veuillez entrer le temps d''acquisition Total'], ...
            'Style','checkbox','Style','text');
        ss2 =uicontrol('Parent',oeuf, 'Position',[125 haut-150 50 20], ...
            'String',num2str(letemps), 'Style','edit');
        uicontrol('Parent',oeuf, 'Callback','set(gcf,''tag'',''lemek'')',...
            'Position',[100 haut-200 100 25], 'String','Appliquer');
        set(oeuf,'WindowStyle','modal');
        waitfor(gcf,'tag','lemek');
        if (get(ss1,'value') == 1)
          onyva =true;
          letemps =str2double(get(ss2,'string'));
          if isnan(letemps)
            disp(['valeur entr' char(130) 'e: non num' char(130) 'rique']);
            return;
          end
        end
        set(gcf,'CloseRequestFcn','delete(gcf)');
        delete(gcf);
      end
      for j =1:vg.nad
        Ofich.getcanal(Dt, j);
        N =Dt.Nom;
        for k =1:vg.ess
          lerate =hdchnl.rate(j,k);
          if avant
            total =hdchnl.nsmpls(j,k);
            nbavant =round(lerate*avant);
            Dt.Dato.(N)(1:total-nbavant,k) =Dt.Dato.(N)(nbavant+1:total,k);
            hdchnl.sweeptime(j,k) =hdchnl.sweeptime(j,k)-avant;
            hdchnl.nsmpls(j,k) =hdchnl.nsmpls(j,k)-nbavant;
            if fc
              hdchnl.frontcut(j,k) =0;
            else
              hdchnl.frontcut(j,k) =hdchnl.frontcut(j,k)+avant;
            end
            if hdchnl.npoints(j,k)
              for m =1:hdchnl.npoints(j,k)
                ptchnl.Dato(m,hdchnl.point(j,k),1) =ptchnl.Dato(m,hdchnl.point(j,k),1)-nbavant;
                if ptchnl.Dato(m,hdchnl.point(j,k),1) < 0
                  ptchnl.PointBidon(k, j, m);
                end
              end
            end
          end %if avant
          if onyva
            eltiempo =letemps;
            if apres
              eltiempo =letemps+apres;
            end
            vsmpls =round(lerate*letemps);
            if hdchnl.nsmpls(j,k) == 0
              Dt.Dato.(N)(1:vsmpls,k) =0;
            elseif vsmpls>hdchnl.nsmpls(j,k)
              Dt.Dato.(N)(hdchnl.nsmpls(j,k)+1:vsmpls,k) =Dt.Dato.(N)(hdchnl.nsmpls(j,k),k);
            end
            hdchnl.nsmpls(j,k) =vsmpls;
            hdchnl.sweeptime(j,k) =letemps;
          end %if onyva
          if apres
            total =hdchnl.nsmpls(j,k);
            nbapres =round(lerate*apres);
            Dt.Dato.(N)(total-nbapres+1:total,k) =0;
            hdchnl.sweeptime(j,k) =hdchnl.sweeptime(j,k)-apres;
            hdchnl.nsmpls(j,k) =hdchnl.nsmpls(j,k)-nbapres;
            if hdchnl.npoints(j,k)
              for m =1:hdchnl.npoints(j,k)
                if ptchnl.Dato(m,hdchnl.point(j,k),1) > hdchnl.nsmpls(j,k)
                	ptchnl.PointBidon(k, j, m);
                end
              end
            end
          end %if apres
          hdchnl.max(j,k) =max(Dt.Dato.(N)(1:hdchnl.nsmpls(j,k),k));
          hdchnl.min(j,k) =min(Dt.Dato.(N)(1:hdchnl.nsmpls(j,k),k));
          waitbar(((j-1)*vg.ess+k)/Wtot*.95, hWb);
        end %for k=1:vg.ess
        nouveau =max(hdchnl.nsmpls(j,:));
        Dt.Dato.(N)(nouveau+1:end,:)=[];
        Ofich.setcanal(Dt);
      end %for j=1:vg.nad
      for i=1:vg.ess
        for j=1:vg.nad
          if avant, textav =['av=' av ', '];
          else textav ='';
          end
          if apres, textap =['ap=' ap];
          else textap ='';
          end
          hdchnl.comment{j, i} =['Cut, ' textav textap '//' hdchnl.comment{j, i}];
        end
      end
    else  % wch.pan == 2
      tti =strtrim(get(findobj('Tag','SectionDebut'), 'string'));
      ttf =strtrim(get(findobj('Tag','SectionFin'), 'string'));
      cref =get(findobj('tag','CanalRef'), 'value');
      ppti =zeros(vg.nad, vg.ess, 'double');
      pptf =ppti;
      cOk =false;
    	for R =1:vg.ess
    		ptiref =ptchnl.valeurDePoint(tti, cref, R);
    		if isempty(ptiref)
    		  cOk =true;
    		else
    			ppti(:,R) =floor((((ptiref/hdchnl.rate(cref, R))+hdchnl.frontcut(cref, R))-hdchnl.frontcut(:, R)).*hdchnl.rate(:, R));
    		end
    	end
    	for R =1:vg.ess
    		ptfref =ptchnl.valeurDePoint(ttf, cref, R);
    		if isempty(ptfref)
    		  cOk =true;
    		else
    			pptf(:,R) =floor((((ptfref/hdchnl.rate(cref, R))+hdchnl.frontcut(cref, R))-hdchnl.frontcut(:, R)).*hdchnl.rate(:, R));
    		end
    	end
    	if cOk
    	  return;
    	end
      for U =1:vg.nad
        Ofich.getcanal(Dt, U);
        N =Dt.Nom;
        for V =1:vg.ess
          pti =ppti(U, V);
          if pptf(U, V) > hdchnl.nsmpls(U, V)
            ptf =hdchnl.nsmpls(U, V);
          else
            ptf =pptf(U, V);
          end
          lafin =hdchnl.nsmpls(U, V);
          Dt.Dato.(N)(pti:pti+lafin-ptf-1, V) =Dt.Dato.(N)(ptf+1:lafin, V);
          hdchnl.nsmpls(U, V) =lafin-(ptf-pti+1);
          hdchnl.sweeptime(U, V) =hdchnl.nsmpls(U, V)/hdchnl.rate(U, V);
          hdchnl.max(U, V) =max(Dt.Dato.(N)(1:hdchnl.nsmpls(U, V), V));
          hdchnl.min(U, V) =min(Dt.Dato.(N)(1:hdchnl.nsmpls(U, V), V));
          for Mm =hdchnl.npoints(U, V):-1:1
          	punto =ptchnl.Dato(Mm,hdchnl.point(U, V),1);
            if punto >= pti & punto <= ptf
              ptchnl.PointBidon(V, U, Mm);
            elseif punto > ptf
            	punto =punto-(ptf-pti+1);
            	ptchnl.marqettyp(U, V, Mm, punto, ptchnl.Dato(Mm,hdchnl.point(U, V),2));
            end
          end
          waitbar(((U-1)*vg.ess+V)/Wtot*.95, hWb);
        end
        nouveau =max(hdchnl.nsmpls(U,:));
        Dt.Dato.(N)(nouveau+1:end,:)=[];
        Ofich.setcanal(Dt);
      end
    end
    S =findobj('Tag','LaCoupe');
    if ~isempty(S)
      delete(S);
    end
    delete(hWb);
    vg.sauve=1;
    OA.OFig.affiche();
  %------------
  case 'fermer'
    S =findobj('Tag','LaCoupe');
    if ~isempty(S)
      delete(S);
    end
  end
end

function [A, B] =LireLimit()
    av =get(findobj('Tag','TempsDebut'),'String');
    ap =get(findobj('tag','TempsFin'),'String');
    A =str2double(av);
    if isnan(A)
      set(findobj('Tag','TempsDebut'),'String', '0');
      A =0;
    end
    B =str2double(ap);
    if isnan(B)
      set(findobj('Tag','TempsFin'),'String', '0');
      B =0;
    end
end