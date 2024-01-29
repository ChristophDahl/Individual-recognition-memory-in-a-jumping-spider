%% Manuscript title: INDIVIDUAL RECOGNITION MEMORY IN A JUMPING SPIDER

% The script illustrates how one gets from the raw values (distance values 
% of the spiders) to the subject specific mean values, needed for
% statistical analysis and for plotting Figure 2. 
% 
% The products of this script are the following data matrices:
% (1) Subject x distance (4 bins): 20 x 4 (for experiment 1) and 16 x 4
% (for experiment 2).
% (2) Session x distance x Subject: 3 x 4 x 20, or 3 x 4 x 16.
%
% You can also find these matrices in the STUDY struct: STUDY.SUBJ1.BASE,
% STUDY.SUBJ1.EXP for Subject x distance, and STUDY.SUBJ1.BASESESSION and
% STUDY.SUBJ1.EXPSESSION for Session x distance x Subject

%%%%%%%%%%%%%%%%
% Experiment 1 %
%%%%%%%%%%%%%%%%

% bins [#] and dimensions in pixels
binnumbers = 5;
maxdist = 620;
mindist = 20;

% Baseline comparisons
DX = [];
for i = 1:size(STUDY.EXP1.Baseline,2)
   i1 = ([STUDY.EXP1.Baseline{i}.T1.val1(:,1),   STUDY.EXP1.Baseline{i}.T1.val1(:,2)]);
   i2 = ([STUDY.EXP1.Baseline{i}.T1.val2(:,1),   STUDY.EXP1.Baseline{i}.T1.val2(:,2)]);
   D1 = pdist2(i1,i2,'euclidean');
   ax = diag(D1)';
   
   j1 = ([STUDY.EXP1.Baseline{i}.T2.val1(:,1),   STUDY.EXP1.Baseline{i}.T2.val1(:,2)]);
   j2 = ([STUDY.EXP1.Baseline{i}.T2.val2(:,1),   STUDY.EXP1.Baseline{i}.T2.val2(:,2)]);
   D2 = pdist2(j1,j2,'euclidean');
   bx = diag(D2)';
   
   [er re] = histcounts(ax,linspace(mindist,maxdist,binnumbers));
   [er2 re2] = histcounts(bx,linspace(mindist,maxdist,binnumbers));
        
   dx = (er2./sum(er2) - er./sum(er));
   DX = [DX; dx];
end

% Experimental comparisons
DX2 = [];
for i = 1:size(STUDY.EXP1.Experimental,2)
   i1 = ([STUDY.EXP1.Experimental{i}.T1.val1(:,1),   STUDY.EXP1.Experimental{i}.T1.val1(:,2)]);
   i2 = ([STUDY.EXP1.Experimental{i}.T1.val2(:,1),   STUDY.EXP1.Experimental{i}.T1.val2(:,2)]);
   D1 = pdist2(i1,i2,'euclidean');
   ax = diag(D1)';
   
   j1 = ([STUDY.EXP1.Experimental{i}.T2.val1(:,1),   STUDY.EXP1.Experimental{i}.T2.val1(:,2)]);
   j2 = ([STUDY.EXP1.Experimental{i}.T2.val2(:,1),   STUDY.EXP1.Experimental{i}.T2.val2(:,2)]);
   D2 = pdist2(j1,j2,'euclidean');
   bx = diag(D2)';
   
   [er re] = histcounts(ax,linspace(mindist,maxdist,binnumbers));
   [er2 re2] = histcounts(bx,linspace(mindist,maxdist,binnumbers));
        
   dx = (er2./sum(er2) - er./sum(er));
   DX2 = [DX2; dx];
end

% Reorganise according to subject ID
subjx = [1,2,3,4;5,6,7,8;9,10,11,12;13,14,15,16;17,18,19,20];
STRC = [];
for i = 1:length(subjx(:))
    STRC.BASE.SUBJ{i} = [];
end
BL = [];
for j = 1:5 % number of groups
    BL = [BL;repmat(j, 9,1)]
end
BL = [BL; BL];   
    
for i = 1:size(DX,1)
    if strcmp(STUDY.EXP1.Baseline{i}.I1.name,'A') 
        STRC.BASE.SUBJ{subjx(BL(i,1),1)} = [STRC.BASE.SUBJ{subjx(BL(i,1),1)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I1.name,'B') 
        STRC.BASE.SUBJ{subjx(BL(i,1),2)} = [STRC.BASE.SUBJ{subjx(BL(i,1),2)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I1.name,'C')
        STRC.BASE.SUBJ{subjx(BL(i,1),3)} = [STRC.BASE.SUBJ{subjx(BL(i,1),3)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I1.name,'D') 
        STRC.BASE.SUBJ{subjx(BL(i,1),4)} = [STRC.BASE.SUBJ{subjx(BL(i,1),4)};DX(i,:)];
    end
    if strcmp(STUDY.EXP1.Baseline{i}.I2.name,'A')
        STRC.BASE.SUBJ{subjx(BL(i,1),1)} = [STRC.BASE.SUBJ{subjx(BL(i,1),1)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I2.name,'B')
        STRC.BASE.SUBJ{subjx(BL(i,1),2)} = [STRC.BASE.SUBJ{subjx(BL(i,1),2)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I2.name,'C')
        STRC.BASE.SUBJ{subjx(BL(i,1),3)} = [STRC.BASE.SUBJ{subjx(BL(i,1),3)};DX(i,:)];
    elseif strcmp(STUDY.EXP1.Baseline{i}.I2.name,'D')
        STRC.BASE.SUBJ{subjx(BL(i,1),4)} =  [STRC.BASE.SUBJ{subjx(BL(i,1),4)};DX(i,:)];
    end
end

for i = 1:length(subjx(:))
    STRC.EXP.SUBJ{i} = [];
end
EX = [];
for j = 1:5 % number of groups
    EX = [EX;repmat(j, 9,1)]
end
EX = [EX; EX];   

for i = 1:size(DX2,1)
    if strcmp(STUDY.EXP1.Experimental{i}.I1.name,'A') 
        STRC.EXP.SUBJ{subjx(EX(i,1),1)} = [STRC.EXP.SUBJ{subjx(EX(i,1),1)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I1.name,'B') 
        STRC.EXP.SUBJ{subjx(EX(i,1),2)} = [STRC.EXP.SUBJ{subjx(EX(i,1),2)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I1.name,'C')
        STRC.EXP.SUBJ{subjx(EX(i,1),3)} = [STRC.EXP.SUBJ{subjx(EX(i,1),3)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I1.name,'D') 
        STRC.EXP.SUBJ{subjx(EX(i,1),4)} = [STRC.EXP.SUBJ{subjx(EX(i,1),4)};DX2(i,:)];
    end
    if strcmp(STUDY.EXP1.Experimental{i}.I2.name,'A')
        STRC.EXP.SUBJ{subjx(EX(i,1),1)} = [STRC.EXP.SUBJ{subjx(EX(i,1),1)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I2.name,'B')
        STRC.EXP.SUBJ{subjx(EX(i,1),2)} = [STRC.EXP.SUBJ{subjx(EX(i,1),2)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I2.name,'C')
        STRC.EXP.SUBJ{subjx(EX(i,1),3)} = [STRC.EXP.SUBJ{subjx(EX(i,1),3)};DX2(i,:)];
    elseif strcmp(STUDY.EXP1.Experimental{i}.I2.name,'D')
        STRC.EXP.SUBJ{subjx(EX(i,1),4)} =  [STRC.EXP.SUBJ{subjx(EX(i,1),4)};DX2(i,:)];
    end
end


% for each subject accross all sessions
SUBJ = [];
EXP = [];
BASE = [];
for i = 1:size(STRC.EXP.SUBJ,2)
    EXP = [EXP; mean(STRC.EXP.SUBJ{i})];
    BASE = [BASE; mean(STRC.BASE.SUBJ{i})];
end
SUBJ.EXP = EXP;
SUBJ.BASE = BASE;

% for each subject and session
sessions = [1,2,3;4,5,6;7,8,9;10,11,12;13,14,15];
SUBJ.EXPSESSION = [];
SUBJ.BASESESSION = [];
for i = 1:size(STRC.EXP.SUBJ,2)
    BASESESSIONS = [];
    EXPSESSIONS = [];
    for j = 1:3
        EXPSESSIONS = [EXPSESSIONS; mean(STRC.EXP.SUBJ{i}(sessions(j,:),:))];
        BASESESSIONS = [BASESESSIONS; mean(STRC.BASE.SUBJ{i}(sessions(j,:),:))];
    end
    SUBJ.EXPSESSION = cat(3,SUBJ.EXPSESSION,EXPSESSIONS);
    SUBJ.BASESESSION = cat(3,SUBJ.BASESESSION,BASESESSIONS);
end

%%%%%%%%%%%%%%%%
% Experiment 2 %
%%%%%%%%%%%%%%%%

% same as above, but for experiment 2, there were two groups run simultaneously
binnumbers = 5;
maxdist = 620;
mindist = 20;

% Baseline comparisons
DX = [];
for i = 1:size(STUDY.EXP2.Baseline,2)
   i1 = ([STUDY.EXP2.Baseline{i}.T1.val1(:,1),   STUDY.EXP2.Baseline{i}.T1.val1(:,2)]);
   i2 = ([STUDY.EXP2.Baseline{i}.T1.val2(:,1),   STUDY.EXP2.Baseline{i}.T1.val2(:,2)]);
   D1 = pdist2(i1,i2,'euclidean');
   ax = diag(D1)';
   
   j1 = ([STUDY.EXP2.Baseline{i}.T2.val1(:,1),   STUDY.EXP2.Baseline{i}.T2.val1(:,2)]);
   j2 = ([STUDY.EXP2.Baseline{i}.T2.val2(:,1),   STUDY.EXP2.Baseline{i}.T2.val2(:,2)]);
   D2 = pdist2(j1,j2,'euclidean');
   bx = diag(D2)';
   
   [er re] = histcounts(ax,linspace(mindist,maxdist,binnumbers));
   [er2 re2] = histcounts(bx,linspace(mindist,maxdist,binnumbers));
        
   dx = (er2./sum(er2) - er./sum(er));
   DX = [DX; dx];
end

% Experimental comparisons
DX2 = [];
for i = 1:size(STUDY.EXP2.Experimental,2)
   i1 = ([STUDY.EXP2.Experimental{i}.T1.val1(:,1),   STUDY.EXP2.Experimental{i}.T1.val1(:,2)]);
   i2 = ([STUDY.EXP2.Experimental{i}.T1.val2(:,1),   STUDY.EXP2.Experimental{i}.T1.val2(:,2)]);
   D1 = pdist2(i1,i2,'euclidean');
   ax = diag(D1)';
   
   j1 = ([STUDY.EXP2.Experimental{i}.T2.val1(:,1),   STUDY.EXP2.Experimental{i}.T2.val1(:,2)]);
   j2 = ([STUDY.EXP2.Experimental{i}.T2.val2(:,1),   STUDY.EXP2.Experimental{i}.T2.val2(:,2)]);
   D2 = pdist2(j1,j2,'euclidean');
   bx = diag(D2)';
   
   [er re] = histcounts(ax,linspace(mindist,maxdist,binnumbers));
   [er2 re2] = histcounts(bx,linspace(mindist,maxdist,binnumbers));
        
   dx = (er2./sum(er2) - er./sum(er));
   DX2 = [DX2; dx];
end

subjx = [1,2,3,4,5,6,7,8;9,10,11,12,13,14,15,16];
STRC = [];
for i = 1:length(subjx(:))
    STRC.BASE.SUBJ{i} = [];
end
BL = [];
for j = 1:2 % number of groups
    BL = [BL;repmat(j, 9,1)]
end
BL = [BL; BL; BL; BL];   
    
% A to H, since there were two groups simultaneously
for i = 1:size(DX,1)
    if strcmp(STUDY.EXP2.Baseline{i}.I1.name,'A') 
        STRC.BASE.SUBJ{subjx(BL(i,1),1)} = [STRC.BASE.SUBJ{subjx(BL(i,1),1)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'B') 
        STRC.BASE.SUBJ{subjx(BL(i,1),2)} = [STRC.BASE.SUBJ{subjx(BL(i,1),2)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'C')
        STRC.BASE.SUBJ{subjx(BL(i,1),3)} = [STRC.BASE.SUBJ{subjx(BL(i,1),3)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'D') 
        STRC.BASE.SUBJ{subjx(BL(i,1),4)} = [STRC.BASE.SUBJ{subjx(BL(i,1),4)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'E') 
        STRC.BASE.SUBJ{subjx(BL(i,1),5)} = [STRC.BASE.SUBJ{subjx(BL(i,1),5)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'F')
        STRC.BASE.SUBJ{subjx(BL(i,1),6)} = [STRC.BASE.SUBJ{subjx(BL(i,1),6)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'G') 
        STRC.BASE.SUBJ{subjx(BL(i,1),7)} = [STRC.BASE.SUBJ{subjx(BL(i,1),7)};DX(i,:)]; 
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'H') 
        STRC.BASE.SUBJ{subjx(BL(i,1),8)} = [STRC.BASE.SUBJ{subjx(BL(i,1),8)};DX(i,:)];
    end
    
    if strcmp(STUDY.EXP2.Baseline{i}.I2.name,'A')
        STRC.BASE.SUBJ{subjx(BL(i,1),1)} = [STRC.BASE.SUBJ{subjx(BL(i,1),1)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'B')
        STRC.BASE.SUBJ{subjx(BL(i,1),2)} = [STRC.BASE.SUBJ{subjx(BL(i,1),2)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'C')
        STRC.BASE.SUBJ{subjx(BL(i,1),3)} = [STRC.BASE.SUBJ{subjx(BL(i,1),3)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'D')
        STRC.BASE.SUBJ{subjx(BL(i,1),4)} = [STRC.BASE.SUBJ{subjx(BL(i,1),4)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'E')
        STRC.BASE.SUBJ{subjx(BL(i,1),5)} = [STRC.BASE.SUBJ{subjx(BL(i,1),5)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'F')
        STRC.BASE.SUBJ{subjx(BL(i,1),6)} = [STRC.BASE.SUBJ{subjx(BL(i,1),6)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'G')
        STRC.BASE.SUBJ{subjx(BL(i,1),7)} = [STRC.BASE.SUBJ{subjx(BL(i,1),7)};DX(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'H')
        STRC.BASE.SUBJ{subjx(BL(i,1),8)} = [STRC.BASE.SUBJ{subjx(BL(i,1),8)};DX(i,:)];
    end
end

for i = 1:length(subjx(:))
    STRC.EXP.SUBJ{i} = [];
end
EX = [];
for j = 1:2 % number of groups
    EX = [EX;repmat(j, 9,1)]
end
EX = [EX; EX; EX; EX];   

for i = 1:size(DX2,1)
    if strcmp(STUDY.EXP2.Baseline{i}.I1.name,'A') 
        STRC.EXP.SUBJ{subjx(EX(i,1),1)} = [STRC.EXP.SUBJ{subjx(EX(i,1),1)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'B') 
        STRC.EXP.SUBJ{subjx(EX(i,1),2)} = [STRC.EXP.SUBJ{subjx(EX(i,1),2)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'C')
        STRC.EXP.SUBJ{subjx(EX(i,1),3)} = [STRC.EXP.SUBJ{subjx(EX(i,1),3)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'D') 
        STRC.EXP.SUBJ{subjx(EX(i,1),4)} = [STRC.EXP.SUBJ{subjx(EX(i,1),4)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'E') 
        STRC.EXP.SUBJ{subjx(EX(i,1),5)} = [STRC.EXP.SUBJ{subjx(EX(i,1),5)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'F')
        STRC.EXP.SUBJ{subjx(EX(i,1),6)} = [STRC.EXP.SUBJ{subjx(EX(i,1),6)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'G') 
        STRC.EXP.SUBJ{subjx(EX(i,1),7)} = [STRC.EXP.SUBJ{subjx(EX(i,1),7)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I1.name,'H') 
        STRC.EXP.SUBJ{subjx(EX(i,1),8)} = [STRC.EXP.SUBJ{subjx(EX(i,1),8)};DX2(i,:)];
    end
    if strcmp(STUDY.EXP2.Baseline{i}.I2.name,'A')
        STRC.EXP.SUBJ{subjx(EX(i,1),1)} = [STRC.EXP.SUBJ{subjx(EX(i,1),1)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'B')
        STRC.EXP.SUBJ{subjx(EX(i,1),2)} = [STRC.EXP.SUBJ{subjx(EX(i,1),2)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'C')
        STRC.EXP.SUBJ{subjx(EX(i,1),3)} = [STRC.EXP.SUBJ{subjx(EX(i,1),3)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'D')
        STRC.EXP.SUBJ{subjx(EX(i,1),4)} =  [STRC.EXP.SUBJ{subjx(EX(i,1),4)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'E')
        STRC.EXP.SUBJ{subjx(EX(i,1),5)} = [STRC.EXP.SUBJ{subjx(EX(i,1),5)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'F')
        STRC.EXP.SUBJ{subjx(EX(i,1),6)} = [STRC.EXP.SUBJ{subjx(EX(i,1),6)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'G')
        STRC.EXP.SUBJ{subjx(EX(i,1),7)} = [STRC.EXP.SUBJ{subjx(EX(i,1),7)};DX2(i,:)];
    elseif strcmp(STUDY.EXP2.Baseline{i}.I2.name,'H')
        STRC.EXP.SUBJ{subjx(EX(i,1),8)} = [STRC.EXP.SUBJ{subjx(EX(i,1),8)};DX2(i,:)];
    end
end

% for each subject accross sessions
SUBJ2 = [];
EXP2 = [];
BASE2 = [];
for i = 1:size(STRC.EXP.SUBJ,2)
    EXP2 = [EXP2; mean(STRC.EXP.SUBJ{i},1)];
    BASE2 = [BASE2; mean(STRC.BASE.SUBJ{i},1)];
end
SUBJ.EXP2 = EXP2;
SUBJ.BASE2 = BASE2;

% for each subject and session
sessions = [1,2,3;4,5,6;7,8,9;10,11,12;13,14,15];
SUBJ.EXPSESSION2 = [];
SUBJ.BASESESSION2 = [];
for i = 1:size(STRC.EXP.SUBJ,2)
    BASESESSIONS2 = [];
    EXPSESSIONS2 = [];
    for j = 1:3
        EXPSESSIONS2 = [EXPSESSIONS2; mean(STRC.EXP.SUBJ{i}(sessions(j,:),:))];
        BASESESSIONS2 = [BASESESSIONS2; mean(STRC.BASE.SUBJ{i}(sessions(j,:),:))];
    end
    SUBJ.EXPSESSION2 = cat(3,SUBJ.EXPSESSION2,EXPSESSIONS2);
    SUBJ.BASESESSION2 = cat(3,SUBJ.BASESESSION2,BASESESSIONS2);
end