%
% Importation des paramètre à partir d'un fichier INI
%
% plate-forme de force Optima
%
function p =importCalculCOP(hObj)
  global leWb lemax iindx fid;
  leWb =laWaitbar(0, 'Lecture des paramètres', 'C', 'C', gcf);
  p.lesParam =false;
  fid =-1;
  [nom, pat] =uigetfile({'*.INI', 'Afficher les fichiers *.ini'; ...
                     '*.*', 'Afficher tous les fichiers' });
  if isequal(nom,0) || isequal(pat,0)
    % on a annulé en cours de route
    onFerme();
    return;
  end
  fid =fopen(fullfile(pat,nom), 'rt');
  if fid == -1
    % le fichier ne peut être ouvert
    onFerme();
    return;
  end
  lemax =2;
  tline = fgetl(fid);
  while ischar(tline)
  	lemax =lemax+1;
  	tline = fgetl(fid);
  end
  fseek(fid, 0, -1);  % retour au début "bof"
  % on garde l'index de la ligne pour la waitbar de lecture
  iindx =1;
  ligne =suivante();
  while ligne ~= -1
    if (length(ligne) < 3)||(ligne(1) == '#')
      ligne =suivante();
      continue;
    %***** LECTURE DES PARAMÈTRES OPTIMA
    elseif strncmpi(ligne,'[opti',5)
      while ~ strncmpi(ligne,'[\opti',6)
        if strncmpi(ligne, '[can', 4)             % CANAUX
          while ~ strncmpi(ligne, '[\can', 5)
            if strncmpi(ligne, 'fx', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canFx =str2num(ligne(i:end));
              end
            elseif strncmpi(ligne, 'fy', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canFy =str2num(ligne(i:end));
              end
            elseif strncmpi(ligne, 'fz', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canFz =str2num(ligne(i:end));
              end
            elseif strncmpi(ligne, 'mx', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canMx =str2num(ligne(i:end));
              end
            elseif strncmpi(ligne, 'my', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canMy =str2num(ligne(i:end));
              end
            elseif strncmpi(ligne, 'mz', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                p.canMz =str2num(ligne(i:end));
              end
            end
            ligne =suivante();
            if ligne == -1
              break;
            end
          end  % while ~ strncmpi(ligne, '[\can', 5)
        elseif strncmpi(ligne, '[calib', 6)             % CALIBRATION
          while ~ strncmpi(ligne, '[\calib', 7)
            if strncmpi(ligne, 'fc', 2)
              i =findstr(ligne,'=');
              if ~isempty(i)
                i =i(1);
                while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                  i =i+1;
                end
                laVal =str2num(ligne(i:end));
                if ~isempty(laVal)
                  p.optimaFC(1,1:length(laVal)) =laVal;
                end
              end
            end
            ligne =suivante();
            if ligne == -1
              break;
            end
          end  % while ~ strncmpi(ligne, '[\calib', 7)
        end
        ligne =suivante();
        if ligne == -1
          break;
        end
      end % while ~ strncmpi(ligne,'[\opti',6)
    end  % if (length(ligne) < 4)||(ligne(1) == '#')
    ligne =suivante();
  end  % while ligne ~= -1
  onFerme();
end

function li = suivante()
  global leWb lemax iindx fid;
  li =fgetl(fid);
  if li == -1
    return;
  end
  li =strtrim(li);
  waitbar(iindx/lemax, leWb);
  iindx =iindx+1;
end

function onFerme()
  global leWb lemax iindx fid;
  delete(leWb);
  if fid ~= -1
    fclose(fid);
  end
  clear global leWb lemax iindx fid;
end
