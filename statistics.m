%% Manuscript title: INDIVIDUAL RECOGNITION MEMORY IN A JUMPING SPIDER

% This script runs the statistical tests relevant for this manuscript.
% Define "figpath" (Figure path) as your destination pathway to save the
% figure created below or uncomment the code line 566 - 577, if you wish not to save the figure.

%% statistics

s_exp1 = [11,12,13,18,2,4,8,9,1,3,6,7,14,15,17,19,5,10,16,20];
s_exp2 = [1,3,11,12,6,7,13,18,2,14,8,17,4,15,9,19];

sexp1 = [1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,2,1,1,1,1];
sexp2 = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2];


BS = [];
for i = 1:size(STRC.BASE.SUBJ,2)
    DX = STRC.BASE.SUBJ{i};
    [xi yi] = size(DX);
    [Dist, Trial] = meshgrid(1:yi,1:xi);
    Subj = repmat(s_exp1(i),size(DX,1), size(DX,2));
    Condition = repmat(1,size(DX,1), size(DX,2));
    Experiment = repmat(1,size(DX,1), size(DX,2));
    Sex = repmat(sexp1(i),size(DX,1), size(DX,2));
    Session = repmat([1,1,1,2,2,2,3,3,3]',1,size(DX,2));
    BS = [BS;[DX(:),Dist(:),Session(:),Subj(:),Experiment(:),Sex(:),Condition(:)]];
end
EX = [];
for i = 1:size(STRC.EXP.SUBJ,2)
    DX = STRC.EXP.SUBJ{i};
    [xi yi] = size(DX);
    [Dist, Trial] = meshgrid(1:yi,1:xi);
    Subj = repmat(s_exp1(i),size(DX,1), size(DX,2));
    Condition = repmat(2,size(DX,1), size(DX,2));
    Experiment = repmat(1,size(DX,1), size(DX,2));
    Sex = repmat(sexp1(i),size(DX,1), size(DX,2));
    Session = repmat([1,1,1,2,2,2,3,3,3]',1,size(DX,2));
    EX = [EX;[DX(:),Dist(:),Session(:),Subj(:),Experiment(:),Sex(:),Condition(:)]];
end

EXP1 = [BS;EX];

BS2 = [];
BASELINE2 = [];
for i = 1:size(STRC2.BASE.SUBJ,2)
    DX = STRC2.BASE.SUBJ{i};
    [xi yi] = size(DX);
    [Dist, Trial] = meshgrid(1:yi,1:xi);
    Subj = repmat(s_exp2(i),size(DX,1), size(DX,2));
    Condition = repmat(1,size(DX,1), size(DX,2));
    Experiment = repmat(2,size(DX,1), size(DX,2));
    Sex = repmat(sexp2(i),size(DX,1), size(DX,2));
    Session = repmat([1,1,1,2,2,2,3,3,3]',1,size(DX,2));
    BS2 = [BS2;[DX(:),Dist(:),Session(:),Subj(:),Experiment(:),Sex(:),Condition(:)]];
    BASELINE2 = [BASELINE2;mean(DX(7:9,:))];
end
EX2 = [];
EXPERIMENT2 = [];
for i = 1:size(STRC2.EXP.SUBJ,2)
    DX = STRC2.EXP.SUBJ{i};
    [xi yi] = size(DX);
    [Dist, Trial] = meshgrid(1:yi,1:xi);
    Subj = repmat(s_exp2(i),size(DX,1), size(DX,2));
    Condition = repmat(2,size(DX,1), size(DX,2));
    Experiment = repmat(2,size(DX,1), size(DX,2));
    Sex = repmat(sexp2(i),size(DX,1), size(DX,2));
    Session = repmat([1,1,1,2,2,2,3,3,3]',1,size(DX,2));
    EX2 = [EX2;[DX(:),Dist(:),Session(:),Subj(:),Experiment(:),Sex(:),Condition(:)]];
    EXPERIMENT2 = [EXPERIMENT2; mean(DX(7:9,:))];
end

EXP2 = [BS2;EX2];

%% MODEL experiment 1

clear COMPLETE
COMPLETE = [];
COMPLETE = [EXP1];
% COMPLETE(:,1) = rand(length(COMPLETE),1);
h = kstest(COMPLETE(:,1))

tcomplete = table((COMPLETE(:,1)),categorical(COMPLETE(:,2)),categorical(COMPLETE(:,3)),categorical(COMPLETE(:,4)),categorical(COMPLETE(:,6)),categorical(COMPLETE(:,7)));
header = {'VAR','DIST','SESSION','SUBJECT','SEX','CONDITION'};
dcomplete1 = cell2table(table2cell(tcomplete), 'VariableNames', header);

% F= fitmethis(dcomplete.VAR)
 
 
FullModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:SESSION + DIST:CONDITION + SESSION:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
      'Distribution','Normal','Link','identity','DummyVarCoding','effects');

NullModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + (1|SUBJECT) + (1|SEX)', ...
       'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(NullModel1,FullModel1)     

%     Model         DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue    
%     NullModel1     7    -681.78    -644.87    347.89                                   
%     FullModel1    27    -747.28    -604.93    400.64    105.51    20         1.2867e-13

 
anova(FullModel1)

%     ANOVA marginal tests: DFMethod = 'residual'
% 
%     Term                              FStat         DF1    DF2     pValue    
%     {'(Intercept)'           }         2.424e-99    1      1416             1
%     {'DIST'                  }        5.8147e-32    3      1416             1
%     {'SESSION'               }        6.0085e-31    2      1416             1
%     {'CONDITION'             }        6.5288e-32    1      1416             1
%     {'DIST:SESSION'          }            1.5328    6      1416       0.16369
%     {'DIST:CONDITION'        }            21.834    3      1416    7.9928e-14
%     {'SESSION:CONDITION'     }        1.8123e-32    2      1416             1
%     {'DIST:SESSION:CONDITION'}            5.7949    6      1416    5.6361e-06
    

% + SESSION:CONDITION

FinalModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');
    
 results = compare(FinalModel1,FullModel1)     

%     Model          DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue 
%     FinalModel1    19    -754.11    -653.94    396.06                                
%     FullModel1     27    -747.28    -604.93    400.64    9.1678    8          0.32834


[beta,betanames,stats2] = randomEffects(FinalModel1,'alpha',0.05)


DISTModel1 = fitglme(dcomplete1,'VAR ~ 1 - DIST + SESSION + CONDITION + DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,DISTModel1)     

%     Model          DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue
%     DISTModel1     16    -760.11    -675.76    396.06                               
%     FinalModel1    19    -754.11    -653.94    396.06    0         3          1      

SESSIONModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST - SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
        'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,SESSIONModel1) 

%     Model            DF    AIC        BIC        LogLik    LRStat        deltaDF    pValue
%     SESSIONModel1    17    -758.11    -668.48    396.06                                   
%     FinalModel1      19    -754.11    -653.94    396.06    5.6843e-13    2          1     

CONDITIONModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION - CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,CONDITIONModel1)

%     Model              DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue
%     CONDITIONModel1    18    -756.11    -661.21    396.06                               
%     FinalModel1        19    -754.11    -653.94    396.06    0         1          1    

DIST_CONDITIONModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION - DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,DIST_CONDITIONModel1)

%     Model                   DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue    
%     DIST_CONDITIONModel1    16    -696.46     -612.1    364.23                                   
%     FinalModel1             19    -754.11    -653.94    396.06    63.658    3          9.7145e-14

DIST_SESSION_CONDITIONModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION - DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,DIST_SESSION_CONDITIONModel1)

%     Model                           DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue   
%     DIST_SESSION_CONDITIONModel1    13    -731.97    -663.43    378.99                                  
%     FinalModel1                     19    -754.11    -653.94    396.06    34.141    6          6.319e-06
    
SUBJECTModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SEX)', ...
       'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,SUBJECTModel1)

%     Model            DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue
%     SUBJECTModel1    18    -756.11    -661.21    396.06                               
%     FinalModel1      19    -754.11    -653.94    396.06    0         1          1           

SEXModel1 = fitglme(dcomplete1,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel1,SEXModel1)

%     Model          DF    AIC        BIC        LogLik    LRStat    deltaDF    pValue
%     SEXModel1      18    -756.11    -661.21    396.06                               
%     FinalModel1    19    -754.11    -653.94    396.06    0         1          1        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MODEL experiment 2

clear COMPLETE
COMPLETE = [];
COMPLETE = [EXP2];
% COMPLETE(:,1) = rand(length(COMPLETE),1);
h = kstest(COMPLETE(:,1))

tcomplete = table((COMPLETE(:,1)),categorical(COMPLETE(:,2)),categorical(COMPLETE(:,3)),categorical(COMPLETE(:,4)),categorical(COMPLETE(:,6)),categorical(COMPLETE(:,7)));
header = {'VAR','DIST','SESSION','SUBJECT','SEX','CONDITION'};
dcomplete2 = cell2table(table2cell(tcomplete), 'VariableNames', header);

% F= fitmethis(dcomplete.VAR)
 
 
FullModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:SESSION + DIST:CONDITION + SESSION:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
      'Distribution','Normal','Link','identity','DummyVarCoding','effects');

NullModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + (1|SUBJECT) + (1|SEX)', ...
       'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(NullModel2,FullModel2)     

%     Model         DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue   
%     NullModel2     7     80.69    116.04    -33.345                                  
%     FullModel2    27    77.067     213.4    -11.533    43.624    20         0.0016896
 
anova(FullModel2)

%     Term                              FStat         DF1    DF2     pValue    
%     {'(Intercept)'           }        4.5855e-32    1      1128             1
%     {'DIST'                  }        1.6072e-32    3      1128             1
%     {'SESSION'               }        8.7769e-33    2      1128             1
%     {'CONDITION'             }        2.8659e-31    1      1128             1
%     {'DIST:SESSION'          }            0.7909    6      1128       0.57706
%     {'DIST:CONDITION'        }            11.225    3      1128    2.9266e-07
%     {'SESSION:CONDITION'     }        4.2201e-31    2      1128             1
%     {'DIST:SESSION:CONDITION'}            1.0066    6      1128        0.4194
    

% + SESSION:CONDITION

FinalModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');
    
 results = compare(FinalModel2,FullModel2)     

%     Model          DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue 
%     FinalModel2    19    65.802    161.74    -13.901                                
%     FullModel2     27    77.067     213.4    -11.533    4.7357    8          0.78542

[beta,betanames,stats2] = randomEffects(FinalModel2,'alpha',0.05)


DISTModel2 = fitglme(dcomplete2,'VAR ~ 1 - DIST + SESSION + CONDITION + DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,DISTModel2)     

%     Model          DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue
%     DISTModel2     16    59.802    140.59    -13.901                               
%     FinalModel2    19    65.802    161.74    -13.901    0         3          1       

SESSIONModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST - SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
        'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,SESSIONModel2) 

%     Model            DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue
%     SESSIONModel2    17    61.802    147.64    -13.901                               
%     FinalModel2      19    65.802    161.74    -13.901    0         2          1     
      

CONDITIONModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION - CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,CONDITIONModel2)

%     Model              DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue
%     CONDITIONModel2    18    63.802    154.69    -13.901                               
%     FinalModel2        19    65.802    161.74    -13.901    0         1          1   

DIST_CONDITIONModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION - DIST:CONDITION + DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,DIST_CONDITIONModel2)

%     Model                   DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue    
%     DIST_CONDITIONModel2    16    92.861    173.65     -30.43                                   
%     FinalModel2             19    65.802    161.74    -13.901    33.058    3          3.1308e-07

DIST_SESSION_CONDITIONModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION - DIST:SESSION:CONDITION + (1|SUBJECT) + (1|SEX)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,DIST_SESSION_CONDITIONModel2)

%     Model                           DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue 
%     DIST_SESSION_CONDITIONModel2    13    59.801    125.44    -16.901                                
%     FinalModel2                     19    65.802    161.74    -13.901    5.9989    6          0.42331

SUBJECTModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SEX)', ...
       'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,SUBJECTModel2)

%     Model            DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue
%     SUBJECTModel2    18    63.802    154.69    -13.901                               
%     FinalModel2      19    65.802    161.74    -13.901    0         1          1       

SEXModel2 = fitglme(dcomplete2,'VAR ~ 1 + DIST + SESSION + CONDITION + DIST:CONDITION  + DIST:SESSION:CONDITION + (1|SUBJECT)', ...
         'Distribution','Normal','Link','identity','DummyVarCoding','effects');

results = compare(FinalModel2,SEXModel2)

%     Model          DF    AIC       BIC       LogLik     LRStat    deltaDF    pValue
%     SEXModel2      18    63.802    154.69    -13.901                               
%     FinalModel2    19    65.802    161.74    -13.901    0         1          1    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
%% ANOVA for the dishabituation long-term trials

EXP2 = EXPERIMENT2 - BASELINE2;
EXP3 = STRC3.EX - STRC3.BA;
Xi = [EXP2(:);EXP3(:)];
Ex = [repmat(1,length(EXP2(:)),1);repmat(2,length(EXP3(:)),1)];

[xi yi] = size(EXP2);
[Dist1, Trial] = meshgrid(1:yi,1:xi);
[xi yi] = size(EXP3);
[Dist2, Trial] = meshgrid(1:yi,1:xi);

Di = [Dist1(:); Dist2(:)];

[P,T,STATS,TERMS] = anovan(Xi, {Di  Ex}, ...
                        'model',2, 'sstype',2, ...
                        'varnames',strvcat('Distance', 'Trial type'))

%   Source                Sum Sq.   d.f.   Mean Sq.     F     Prob>F
% ------------------------------------------------------------------
%   Distance               2.8266     3    0.9422     13.61   0     
%   Trial type             0          1    0           0      1     
%   Distance*Trial type    1.1015     3    0.36717     5.3    0.0018
%   Error                  8.3072   120    0.06923                  
%   Total                 12.2353   127                             
  


%% EXP 1

fitt = fitted(FinalModel1);
ress = dcomplete1.VAR-fitt;
xf = ress(1:end-1); 
xg = ress(2:end);

%% additional figure showing residuals of finalmodel

figure(3)
set(gcf,'Position',[1000 500 1000 700])

subplot(2,3,1),
%# histogram
numbins = 100;
[n,x] = hist(ress, numbins);
n = n./sum(n);
dd(1) = stairs(x, n,'k')
set(dd(1),'LineWidth',.75)

[bincounts,binpos] = hist(ress, numbins);
binwidth = x(2) - x(1);
histarea = binwidth*sum(n);

%# fit a gaussian
[muhat,sigmahat] = normfit(ress);
x = linspace(binpos(1),binpos(end),100);
y = normpdf(x, muhat, sigmahat);
dd(2) = line(x, y*histarea, 'Color','b', 'LineWidth',.75);

%# kernel estimator
[f,x,u] = ksdensity( ress );
dd(3) = line(x, f*histarea, 'Color','r', 'LineWidth',.75);

legend(gca, {'freq hist','fitted Gaussian','kernel estimator'})
legend boxoff 
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [-1:.5:1], ...
      'YTick'       , [0:.025:.15], ...
      'LineWidth'   , .75         ); 
    axis([-1 1 0 .15])
    axis square

xlabel('Residuals [bins]')    
ylabel('Relative number of observations')
text(-1.45, .1575,'a','Fontsize',16)
    
% plot of residuals vs fitted values
subplot(2,3,2),
plot(fitt,ress,'.','MarkerEdgeColor',[.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5])
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [-.08:.04:.08], ...
      'YTick'       , [-1:.5: 1], ...
      'LineWidth'   , .75         ); 
    axis([-.1 .1 -1 1])
    axis square
hold on
plot([-1 1], [0 0],'k','LineWidth',.75)
% plot([0 0],[-1 1],'k','LineWidth',.75)
xlabel('Fitted values')    
ylabel('Residuals')
text(-.14, 1.1,'b','Fontsize',16)
text (-.05, 1.25, 'Experiment 1', 'Fontsize',12)

% symmetry of upper and lower tails around the median
subplot(2,3,3),
hold on
plot([0 1], [0 1],'k','LineWidth',.75)
[xe re] = sort(ress,'ascend');
upper = flipud(xe(find(xe >= median(ress))));
lower = xe(find(xe < median(ress)));
plot(upper(1:575),abs(lower(1:575)),'.','MarkerEdgeColor',[.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5])
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [0:.25:1], ...
      'YTick'       , [0:.25:1], ...
      'LineWidth'   , .75         ); 
    axis([0 1 0 1])
    axis square

% plot([0 0],[-1 1],'k','LineWidth',.75)
xlabel('Upper tail')    
ylabel('Lower tail')
% text(-.1, 1.1,'D','Fontsize',16)
text(-.2, 1.05,'c','Fontsize',16)


%% EXP 2

fitt = fitted(FinalModel2);
ress = dcomplete2.VAR-fitt;
xf = ress(1:end-1); 
xg = ress(2:end);

%% additional figure showing residuals of finalmodel

subplot(2,3,4),
%# histogram
numbins = 100;
[n,x] = hist(ress, numbins);
n = n./sum(n);
dd(1) = stairs(x, n,'k')
set(dd(1),'LineWidth',.75)

[bincounts,binpos] = hist(ress, numbins);
binwidth = x(2) - x(1);
histarea = binwidth*sum(n);

%# fit a gaussian
[muhat,sigmahat] = normfit(ress);
x = linspace(binpos(1),binpos(end),100);
y = normpdf(x, muhat, sigmahat);
dd(2) = line(x, y*histarea, 'Color','b', 'LineWidth',.75);

%# kernel estimator
[f,x,u] = ksdensity( ress );
dd(3) = line(x, f*histarea, 'Color','r', 'LineWidth',.75);

legend(gca, {'freq hist','fitted Gaussian','kernel estimator'})
legend boxoff 
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [-1:.5:1], ...
      'YTick'       , [0:.025:.1], ...
      'LineWidth'   , .75         ); 
    axis([-1 1 0 .1])
    axis square

xlabel('Residuals [bins]')    
ylabel('Relative number of observations')
text(-1.45, .105,'d','Fontsize',16)
    
% plot of residuals vs fitted values
subplot(2,3,5),
plot(fitt,ress,'.','MarkerEdgeColor',[.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5])
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [-.08:.04:.08], ...
      'YTick'       , [-1:.5: 1], ...
      'LineWidth'   , .75         ); 
    axis([-.1 .1 -1 1])
    axis square
hold on
plot([-1 1], [0 0],'k','LineWidth',.75)
xlabel('Fitted values')    
ylabel('Residuals')
text(-.14, 1.1,'e','Fontsize',16)
text (-.05, 1.25, 'Experiment 2', 'Fontsize',12)

% symmetry of upper and lower tails around the median
subplot(2,3,6),
hold on
plot([0 1], [0 1],'k','LineWidth',.75)
[xe re] = sort(ress,'ascend');
upper = flipud(xe(find(xe >= median(ress))));
lower = xe(find(xe < median(ress)));
plot(upper(1:575),abs(lower(1:575)),'.','MarkerEdgeColor',[.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5])
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.01 .01] , ...
      'XMinorTick'  , 'off'      , ...
      'YMinorTick'  , 'off'      , ...
      'XGrid'       , 'off'      , ...
      'YGrid'       , 'off'      , ...
      'XColor'      , [0 0 0], ...
      'YColor'      , [0 0 0], ...
      'XTick'       , [0:.25:1], ...
      'YTick'       , [0:.25:1], ...
      'LineWidth'   , .75         ); 
    axis([0 1 0 1])
    axis square

xlabel('Upper tail')    
ylabel('Lower tail')
text(-.2, 1.05,'f','Fontsize',16)


cd(figpath)
for i=3
    figure(i)
    set(gcf,'renderer','painters')
    print(gcf,strcat('figure',num2str(i),'.tiff'),'-dtiff','-r300');
   
    set(gcf,'renderer','painters')
    print(gcf,'-depsc2',strcat('figure',num2str(i),'.eps'));
   
    set(gcf,'renderer','painters')
    print(gcf,'-dpng',strcat('figure',num2str(i),'.png'));
end


