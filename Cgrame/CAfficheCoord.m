%
% Classe CAfficheCoord
%
% gestion d'une DataCursorBar dans l'axe principale afin de connaître la
% position (X,Y) du curseur. On exploite l'objet "cursorbar" de matlab.
%
% nov 2013
%
classdef CAfficheCoord < handle

  properties
    hnd =[];         % handle du DataCursorBar
    hdcb;            % tous les handles du DataCursorBar pour in/visible
    x;
    y;
  end

  methods

    %------------
    % CONSTRUCTOR
    %---------------------------
    function tO =CAfficheCoord()
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hp =Ofich.Lestri(:, 8);
      tO.hnd = graphics.cursorbar(hp);
      drawnow;
      hnd =tO.hnd;
      hnd.CursorLineColor = [.9,.25,.5];  % default=[0,0,0]='k'
      %hnd.CursorLineStyle = '-.';        % default='-'
      hnd.CursorLineWidth = 1.5;          % default=1
      hnd.Orientation = 'vertical';       % =default
      hnd.TargetMarkerSize = 10;          % default=8
      hnd.TargetMarkerStyle = '+';        % default='s' (square)
      hnd.UpdateFcn =@tO.updateMoi;
      tO.updateMoi(hnd);
      tO.finalise();
    end

    %-----------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if isa(tO.hnd, 'graphics.cursorbar')
        delete(tO.hnd);
      end
    end

    %--------------------
    function finalise(tO)
      if isa(tO.hnd, 'graphics.cursorbar')
        s =tO.hnd.DisplayHandle;
        tO.hdcb =[tO.hnd s(:)'];
      else
        disp('on efface')
        tO.hdcb =[];
      end
    end

    %-----------------------------------------
    % fonction pour créer/modifier à partir de
    % la fonction defaultUpdateFcn de Matlab
    % DEFAULTUPDATEFCN
    % Copyright 2003 The MathWorks, Inc.
    %------------------------------------
    function updateMoi(tO, hnd, varargin)
      hText = get( hnd,'DisplayHandle');
      if strcmp( hnd.ShowText,'off') 
        if ~isempty(hText)
          delete(hText);
           hnd.DisplayHandle = [];
          return
        end
        return  
      end
      % get the locations of the markers
      xData = get( hnd.TargetMarkerHandle,'XData');
      yData = get( hnd.TargetMarkerHandle,'YData');
      numIntersections = length(xData);
      % get the handles for the text objects, corrseponding to each intersection
      hAxes = get( hnd,'Parent');
      %%%%%%%%%%%%%
      AXCOLOR = get(hAxes,'Color');
      if isstr(AXCOLOR)
        AXCOLOR = get(hAxes,'Color');
      end
      % light colored axes
      if sum(AXCOLOR)>1.5 
        TEXTCOLOR = [0,0,0]; FACECOLOR = [1 1 238/255]; EDGECOLOR = [.8 .8 .8];
      % dark colored axes (i.e. simulink scopes)
      else 
        TEXTCOLOR = [.8 .8 .6]; FACECOLOR = 48/255*[1 1 1]; EDGECOLOR = [.8 .8 .6];
      end
      %%%%%%%%%%%%%
      % create text objects if necessary
      if isempty(hText)  | any(~ishandle(hText))    
        hText = zeros(numIntersections,1);
        for n = 1:numIntersections,
          hText(n) =text(xData(n),yData(n),'', 'Parent',hAxes, 'Color',TEXTCOLOR,...
                         'EdgeColor',EDGECOLOR, 'BackgroundColor',FACECOLOR, 'Visible','off');
        end
        numText = numIntersections;
      else
        % if the number of intersections isn't equal to the number of text objects,
        % add/delete them as necessary  
        set(hText,'Visible','off');
        numText = length(hText);
        if numText ~= numIntersections
          % unequal number of text objects and intersections
          delete(hText)
          hText = [];
          for n = numIntersections: -1 : 1
            hText(n) =text(xData(n),yData(n),'', 'Parent',hAxes, 'Color',TEXTCOLOR,...
                           'EdgeColor',EDGECOLOR, 'BackgroundColor',FACECOLOR, 'Visible','off');
          end
          numText = numIntersections;
        end
      end
      % now update the text objects
      set(hText,'Visible','off','Units','data')
      xl = get(hAxes,'XLim');
      yl = get(hAxes,'YLim');
      xdir = get(hAxes,'XDir');
      ydir = get(hAxes,'YDir');
      pixperdata = getPixelsPerData( hnd);
      pixoffset = 12;
      xoffset = 0;
      yoffset = 0;
      for n = 1:numText
        x = xData(n);
        y = yData(n);
        if x >= mean(xl)
          if strcmp(xdir,'normal')
            halign = 'right';
            xoffset = -pixoffset * 1/pixperdata(1);
          else
            halign = 'left';
            xoffset = pixoffset * 1/pixperdata(1);
          end
        else
          if strcmp(xdir,'normal')
            halign = 'left';
            xoffset = pixoffset * 1/pixperdata(1);
          else
            halign = 'right';
            xoffset = -pixoffset * 1/pixperdata(1);
          end
        end   
        if y >= mean(yl)
          if strcmp(ydir,'normal')
            valign = 'top';
            yoffset = -pixoffset * 1/pixperdata(2);
          else
            valign = 'bottom';
            yoffset = pixoffset * 1/pixperdata(2);
          end
        else
          if strcmp(ydir,'normal')
            valign = 'bottom';
            yoffset = pixoffset * 1/pixperdata(2);
          else
            valign = 'right';
            yoffset = -pixoffset * 1/pixperdata(2);
          end
        end
        tO.x =x;
        tO.y =y;
        set(hText(n),'Position',[x+xoffset, y+yoffset, 0], 'String',tO.makeString,...
            'HorizontalAlignment',halign, 'VerticalAlignment',valign);    
      end
      set( hnd,'DisplayHandle',hText);
      set(hText,'Visible','on');
    end

    % ---------------------------
    function str = makeString(tO)
      str =['<' num2str(tO.x) '>  <' num2str(tO.y) '>'];
    end

    %-----------------------------
    % Toggle entre: Montrer/Cacher
    % Cacher
    %-----------------
    function cache(tO)
      if ~isempty(tO.hdcb)
        set(tO.hdcb, 'Visible','off');
      end
    end
    %-----------------------------
    % Montrer
    %------------------------------
    function ilyaerreur =montre(tO)
      ilyaerreur =true;
      if ~isempty(tO.hdcb) & isa(tO.hnd, 'graphics.cursorbar')
        set(tO.hdcb, 'Visible','on');
        ilyaerreur =false;
      end
    end

  end % methods
end