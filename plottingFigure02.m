%% Manuscript title: INDIVIDUAL RECOGNITION MEMORY IN A JUMPING SPIDER

%% plot figure 2
% This script recreates Figure 2 from the manuscript.
% Make sure the data structure STUDY.m is loaded into the workspace.
% The plotting routine relies on a precalculated sub-structure
% "SUBJ.EXPSESSION", which consists of 3 x 4 x numberOfSubject (20 or 16
% for experiments 1 or 2, respectively). If you are interested in learning
% more about how we got to the "SUBJ.EXPSESSION" values, please run the
% script "calculateSubjectData.m".

close all 

% open a new figure
figure(1)

% parameter settings
numberOfExp = 2;
numberOfSets = 3;
degree = 5;
% binnumbers = 8;
% maxdist = 185;
% mindist = 5;
binnumbers = 5;
maxdist = 620;
mindist = 20;
xmax = [.15, .35];
xpos = [.25 .525];

% define the x-axis and text locations
pox = [270 930 1590];
offset = [0 maxdist + 50, (maxdist + 50)*2];
re = linspace(mindist,maxdist,binnumbers);
xax = round(re(1:end-1)+diff(re)./2,1);

% figure layout settings
fontname = 'Helvetica';
set(1,'defaultaxesfontname',fontname);
set(1,'defaulttextfontname',fontname);

fontsize = 10;
set(1,'defaultaxesfontsize',fontsize);
set(1,'defaulttextfontsize',fontsize);

% define the figure's position and size
set(gcf,'Position',[1500 100 725 600]);

LABEL = {'a','b'};
subfigPlacing{1} = [1:7];
subfigPlacing{2} = [9:19];
yoff = [0, -.1];

% Do the following for both experiments:
for exp = 1:numberOfExp
    
    % assign space to subfigure 2a, b
    subplot(19,1,subfigPlacing{exp})

    % Experiment 1
    SUBJ = eval(strcat('STUDY.SUBJ',num2str(exp)));

    % circle through the three sets (see maintext) and plot each separately
    for j = 1:numberOfSets

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plot the dishabituation trials %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        DY = squeeze(SUBJ.EXPSESSION(j,:,:));
        tx = mean(DY,2);
        hold on
        plot([1 maxdist*3.5],[0 0],'k-')

        % calculate the SEM
        s1 = mean(DY,2)-std(DY,[],2)./sqrt(size(DY,2));
        s2 = mean(DY,2)+std(DY,[],2)./sqrt(size(DY,2));

        % plot the SEM
        for i = 1:length(xax)
            plot([xax(i) xax(i)]+offset(j),[s1(i) s2(i)],'k-')
        end

        % plot the mean
        for i = 1:size(DY,1)
            plot([xax(i) ]+offset(j),[ tx(i)],'o','MarkerFaceColor', [0 0 1],'MarkerEdgeColor', [0 0 1], 'MarkerSize', 4) 
            hold on
        end

%         % fit a polynomial p of degree (see variable degree) to the data
%         p = polyfit(xax+offset(j),tx',degree);
%         x1 = linspace(min(xax+offset(j)),max(xax+offset(j)),20*length(tx));
% 
%         % evaluate the fitted polynomial p
%         y1 = polyval(p,x1);
% 
%         % plot the fit
%         plot(x1,y1,'Color',[0 0 1])

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plot the habituation trials %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % similar structure as above

        DY2 = squeeze(SUBJ.BASESESSION(j,:,:));
        tx2 = mean(DY2,2);
        hold on
        s1 = mean(DY2,2)-std(DY2,[],2)./sqrt(size(DY2,2));
        s2 = mean(DY2,2)+std(DY2,[],2)./sqrt(size(DY2,2));
        for i = 1:length(xax)
            plot([xax(i) xax(i)]+offset(j),[s1(i) s2(i)],'k-')
        end
        for i = 1:size(DY2,1)
            plot([xax(i)]+offset(j),[tx2(i)],'o','MarkerFaceColor', [1 0 0],'MarkerEdgeColor', [1 0 0], 'MarkerSize', 4) 
            hold on
        end
%         p = polyfit(xax+offset(j),tx2',degree);
%         x1 = linspace(min(xax+offset(j)),max(xax+offset(j)),20*length(tx));
%         y1 = polyval(p,x1);
%         plot(x1,y1,'Color',[1 0 0])

        % plot the transparent front panel and the back wall, as well as some
        % useful text labels
        if exp == 1
            plot([6 6]+offset(j),[-.195 -.125],'-','Color',[.75 .75 1],'linewidth',3)
        else
            plot([6 6]+offset(j),[-.295 -.225],'-','Color',[.75 .75 1],'linewidth',3)
        end
            
        str1 = ['proximal'];
        str3 = ['distal'];

        text(15 + offset(j), -.15 + yoff(exp), str1,'Color','k','Fontsize',8)
        ha = annotation('arrow');  
        ha.Parent = gca;           
        ha.X = [73 + offset(j) 13 + offset(j)];         
        ha.Y = [-.18 -.18] + yoff(exp) ;   
        ha.LineWidth  = 1; ha.HeadWidth  = 5; ha.HeadLength = 5;

        text(540 + offset(j), -.15 + yoff(exp), str3,'Color','k','Fontsize',8)
        hb = annotation('arrow');  
        hb.Parent = gca;           
        hb.X = [570 + offset(j) 630 + offset(j)];         
        hb.Y = [-.18 -.18] + yoff(exp);   
        hb.LineWidth  = 1; hb.HeadWidth  = 5; hb.HeadLength = 5;
        axis([-10 maxdist*3.7 -.2 xmax(exp)])
        
        strx = ['Relative distance [bins]'];
        stry = ['Frequency'];
        if j == 1 
            ylabel(stry,'FontSize',10,'Color','k')
        end
        if exp == 1
            strs = strcat('Set',{' '},num2str(j));
            text(pox(j),.17, strs,'Color','k')
        end

        axex = [ 5.0000   68.3333  131.6667  195.0000].*3.3;
        for k = 4
            if exp == 1
                plot([axex(k) axex(k)]+offset(j)-1,[-.195 -.125],'-','Color',[ .75 .75 .75],'linewidth',3)
            else
                plot([axex(k) axex(k)]+offset(j)-1,[-.195 -.125]-.1,'-','Color',[ .75 .75 .75],'linewidth',3)
            end
        end
    end

    % determine the x- and y-axis for the whole figure

    axe = ({'-.4','-.3','-.2','-.1','0','.1','.2','.3','.4'});
    bxe = ({'0','1/3','2/3','1','','','','','','','',''});

    xTickLabels = cell(1,numel(bxe)); 
    tickStep = 1;
    xTickLabels(1:tickStep:numel(bxe)) = bxe(1:tickStep:numel(bxe));

    yTickLabels = cell(1,numel(axe)); 
    tickStep = 1;
    yTickLabels(1:tickStep:numel(axe)) = axe(1:tickStep:numel(axe));

    % plot the x- and y- axes, add x- and y-axis labels, adjust the ticks
    set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'      , ...
    'XTick'       , [axex, axex+offset(2), axex+offset(3)], ...
    'YTick'       , [-.4:.1:.4]     , ...
    'XTickLabel'       , xTickLabels,...
    'YTickLabel'       , yTickLabels,...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'XColor'      , [0 0 0], ...
    'YColor'      , [0 0 0], ...
    'LineWidth'   , .75         );
    text(-105,xpos(exp),LABEL{exp},'Fontsize',16)
    axis([0 2000 -.2+ yoff(exp)  .2])
end

% add the long-term dishabituation trials

% assign space to subfigure 2b (long-term dishabituation trials)
subplot(19,1,[9:19])
hold on

% make sure STUDY.m is loaded into the work space
DY = STUDY.SUBJ2LTD.EX - STUDY.SUBJ2LTD.BA;
s1 = mean(DY,1)-std(DY,[],1)./sqrt(size(DY,1));
s2 = mean(DY,1)+std(DY,[],1)./sqrt(size(DY,1));
for i = 1:length(xax)
    plot([xax(i) xax(i)]+offset(3),[s1(i) s2(i)],'k-')
end
tx = mean(DY);
for i = 1:size(DY,2)
    plot([xax(i) ]+offset(3),[ tx(i)],'o','MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0], 'MarkerSize', 4) 
    hold on
end
axis([0 2000 -.3 .5])

% p = polyfit(xax+offset(3),tx',degree);
% x1 = linspace(min(xax+offset(3)),max(xax+offset(3)),20*length(tx));
% y1 = polyval(p,x1);
% plot(x1,y1,'--','Color',[0 0 0])



      