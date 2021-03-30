
classdef covid < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        DatatoPlotButtonGroup      matlab.ui.container.ButtonGroup
        CasesButton                matlab.ui.control.RadioButton
        DeathsButton               matlab.ui.control.RadioButton
        BothsButton                matlab.ui.control.RadioButton
        OptionButtonGroup          matlab.ui.container.ButtonGroup
        CumulativeButton           matlab.ui.control.RadioButton
        DailyButton                matlab.ui.control.RadioButton
        AveragedofdaysSliderLabel  matlab.ui.control.Label
        AveragedofdaysSlider       matlab.ui.control.Slider
        StateorRegionListBoxLabel  matlab.ui.control.Label
        StateorRegionListBox       matlab.ui.control.ListBox
        CountryLabel               matlab.ui.control.Label
        CountryListBox             matlab.ui.control.ListBox
        UIAxes                     matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        country % country object
        state
        con_data
        plotc  % plot case data
        plotd  % plot deaths data
        plotcd % plot both
        
        plotdaily   %plot daily data
        plotcuml    % plot cumulative data
        daily_data % plotdaily function  property
        
        muvmean 
        slidervalue
        plotslider
        
        datetimes
        cases % country cases 
        deaths
         gcases % global cases
         gdeaths
         scases % state cases
         sdeaths
        countries
        current_state
        state_no
        nation  % unique countries
    end
 methods
     function plotn(app) %plot count
       if isequal(app.CountryListBox.Value,'Global')
                    if app.plotc
%                         axes(app.UIAxes)
%                         ax=fig.CurrentAxes;
%                         yt=get(app.UIAxes,'ytick');
% %                         set(app.UIAxes,'YTickLabel',arrayfun(@(v) sprintf('%d',v),yt,'UniformOuput', false))
%                         ax.YAxis.Exponent=0;
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on")
                        bar(app.UIAxes,app.datetimes, sum(app.gcases,1)) 
%                          xtickformat(app.UIAxes,'MM-dd')
                        title(app.UIAxes,"Cumulative Number of Cases Globally");
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               title(app.UIAxes,"Cumulative Number of Cases Globally");
                               x1=app.plotmuvmean(sum(app.gcases,1),app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                         end
                        if app.plotdaily
                       
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.gcases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,"Daily Number of Cases Globally");
                             
                            
                             
                          if  app.plotslider>1
                             
                              grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                        end
                        
                    end
                    if app.plotd
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                         grid(app.UIAxes,"on")
                        plot(app.UIAxes,app.datetimes, sum(app.gdeaths,1));
                        title(app.UIAxes,"Cumulative Number of deaths Globally");
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on")
                               title(app.UIAxes,"Cumulative Number of deaths Globally");
                               x2=app.plotmuvmean(sum(app.gdeaths,1),app.plotslider);
                               plot(app.UIAxes,app.datetimes,x2);
                              
                         end
                           if app.plotdaily  
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.gdeaths,1));
                             plot(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,"Daily Number of Deaths Globally");
                           
                             if  app.plotslider>1
                             
                               grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                             end
                           end
                    end
                    if app.plotcd
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on")
%                         title(app.UIAxes,"Cumulative Number of Cases Globally");
                        yyaxis(app.UIAxes,"left")
                        bar(app.UIAxes,app.datetimes, sum(app.gcases,1));
                     
                    

                        yyaxis(app.UIAxes,"right")
                        plot(app.UIAxes,app.datetimes, sum(app.gdeaths,1));
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               title(app.UIAxes,"Cumulative Number of Cases Globally");
                               grid(app.UIAxes,"on")
                               x1=app.plotmuvmean( sum(app.gcases,1),app.plotslider);
                               x2=app.plotmuvmean(sum(app.gdeaths,1),app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                                title(app.UIAxes,"Cumulative Number of Cases Globally");
                         end
                              
                          
                        if app.plotdaily
                        
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
                             yyaxis(app.UIAxes,"left")
                             a=app.daily(sum(app.gcases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,"Cumulative Number of Cases Globally");
                             
                             yyaxis(app.UIAxes,"right")
                             b=app.daily(sum(app.gdeaths,1));
                             plot(app.UIAxes,app.datetimes, b);
                           
                             
                         
                          if  app.plotslider>1
                             
                              grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               x2=app.plotmuvmean(b,app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                          end
                        end
                    end
                     return
       end
                          
               
          if app.CountryListBox.Value==app.nation{app.current_state}
                app.StateorRegionListBox.Items=[{'All'};app.countries{app.current_state}(:,1)]; % displays the state
                condata= cell2mat(app.countries{app.current_state}(:,2:end)); % data for each country
                app.cases=condata(:,1:2:end);    % case data for each country
                app.deaths=condata(:,2:2:end);
                    if app.plotc
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on") 
                        bar(app.UIAxes,app.datetimes,sum(app.cases,1))
                        title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                              title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));
                               x1=app.plotmuvmean(sum(app.cases,1),app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                          
                      if app.plotdaily
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.cases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Daily Number of Cases in %s", app.nation{app.current_state}));
                             
                         
                          if  app.plotslider>1
                             
                              grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                      end
                    end
                    
                   if app.plotd
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on") 
                        plot(app.UIAxes,app.datetimes, sum(app.deaths,1));
                        title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.nation{ app.current_state}));
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                              grid(app.UIAxes,"on") 
                               title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.nation{app.current_state}));
                               x2=app.plotmuvmean(sum(app.deaths,1),app.plotslider);
                               plot(app.UIAxes,app.datetimes,x2);
                              
                          end
                         if app.plotdaily  
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.deaths,1));
                             plot(app.UIAxes,app.datetimes,a);
                              title(app.UIAxes,sprintf("Daily Number of Deaths in %s", app.nation{app.current_state}));
                           
                          if  app.plotslider>1
                             
                               grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                          end
                         end
                   end
                 if app.plotcd
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on")
                        yyaxis(app.UIAxes,"left")
                        bar(app.UIAxes,app.datetimes,sum(app.cases,1))
                        title(app.UIAxes,sprintf("Cumulative Number of Cases and Deaths in %s", app.nation{app.current_state}));
                        
                        yyaxis(app.UIAxes,"right")
                        plot(app.UIAxes,app.datetimes, sum(app.deaths,1));
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                                grid(app.UIAxes,"on")
%                               title(app.UIAxes,sprintf("Cumulative Number of Cases and deaths in %s", app.nation{app.current_state}));
                               x1=app.plotmuvmean( sum(app.cases,1),app.plotslider);
                               x2=app.plotmuvmean(sum(app.deaths,1),app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                              
                          end

                   
                   if app.plotdaily
                       
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
                             yyaxis(app.UIAxes,"left")
                             a=app.daily(sum(app.cases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Daily Number of Cases and Deaths in %s", app.nation{app.current_state}));
                             
                             yyaxis(app.UIAxes,"right")
                             b=app.daily(sum(app.deaths,1));
                             plot(app.UIAxes,app.datetimes, b);
                       
                              
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                                grid(app.UIAxes,"on")
                               title(app.UIAxes,sprintf("Daily Number of Cases and Deaths in %s", app.nation{app.current_state}));
                               x1=app.plotmuvmean(a,app.plotslider);
                               x2=app.plotmuvmean(b,app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                          end
                   end
                 end
          end
     end
                          
      
     function plots(app)
          if ~(isequal(app.CountryListBox.Value,'Global')) % checks if CountryListBox is not  "Global", it necessary course Global is not part of the country so its does ot have coun
              if isequal(app.StateorRegionListBox.Value,'All') 
                    if app.plotc
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                         grid(app.UIAxes,"on") 
                        bar(app.UIAxes,app.datetimes, sum(app.cases,1)) 
                        title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));  %current country
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                              title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));  %current country
                               x1=app.plotmuvmean(sum(app.cases,1),app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                          
                      if app.plotdaily
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.cases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Daily Number of Cases in %s", app.nation{app.current_state}));  %current country
                          if  app.plotslider>1
                             
                              grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                      end
                    end
                    if app.plotd % plot deaths data
                        cla(app.UIAxes,'reset'); % reset axes before plotting 
                         grid(app.UIAxes,"on") 
                        plot(app.UIAxes,app.datetimes, sum(app.deaths));
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                             title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.nation{app.current_state}));  %current country
                               x1=app.plotmuvmean(sum(app.deaths,1),app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                         end
                       if app.plotdaily  
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.deaths,1));
                             plot(app.UIAxes,app.datetimes,a);
                           title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.nation{app.current_state}));  %current country
                           
                          if  app.plotslider>1
                             
                               grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                          end
                       end
                    end
                    if app.plotcd
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                        grid(app.UIAxes,"on") 
                        yyaxis(app.UIAxes,"left")
                        bar(app.UIAxes,app.datetimes, sum(app.cases,1)) 
                        title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));  %current country  
                        
                        yyaxis(app.UIAxes,"right")
                        plot(app.UIAxes,app.datetimes, sum(app.deaths));
                        if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                                title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));  %current country 
                               x1=app.plotmuvmean( sum(app.cases,1),app.plotslider);
                               x2=app.plotmuvmean(sum(app.deaths,1),app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                        end
                      if app.plotdaily
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                              grid(app.UIAxes,"on") 
                             yyaxis(app.UIAxes,"left")
                             a=app.daily(sum(app.cases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.nation{app.current_state}));
                             
                             yyaxis(app.UIAxes,"right")
                             b=app.daily(sum(app.deaths,1));
                             plot(app.UIAxes,app.datetimes, b);
                              
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               x2=app.plotmuvmean(b,app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                          end
                      end
                    end
                    return
              end
         
               if app.StateorRegionListBox.Value==app.state{app.state_no}  
                      app.scases=app.con_data(app.state_no,1:2:end);    % case data for each state
                      app.sdeaths=app.con_data(app.state_no,2:2:end);    % death data for each state
    
                    if app.plotc % plot cases data
                        cla(app.UIAxes,'reset'); % reset axes before plotting
                         grid(app.UIAxes,"on") 
                        bar(app.UIAxes,app.datetimes,sum(app.scases,1))    
                        title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                              title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));
                               x1=app.plotmuvmean(sum(app.scases,1),app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                       if app.plotdaily
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.scases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Daily Number of Cases in %s", app.state{app.state_no}));
                          if  app.plotslider>1
                             
                              grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               bar(app.UIAxes,app.datetimes,x1);
                              
                          end
                      end
                    end
                    if app.plotd % plot deaths data
                        cla(app.UIAxes,'reset'); % reset axes before plotting 
                         grid(app.UIAxes,"on") 
                        plot(app.UIAxes,app.datetimes, sum(app.sdeaths,1));
                        title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.state{app.state_no}));
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                            title(app.UIAxes,sprintf("Cumulative Number of Deaths in %s", app.state{app.state_no}));
                               x1=app.plotmuvmean(sum(app.sdeaths,1),app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                          end
                        if app.plotdaily  
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                             grid(app.UIAxes,"on") 
  
                             a=app.daily(sum(app.sdeaths,1));
                             plot(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Daily Number of Deaths in %s", app.state{app.state_no}));  %current country
                           
                          if  app.plotslider>1
                             
                               grid(app.UIAxes,"on") 
                               x1=app.plotmuvmean(a,app.plotslider);
                               plot(app.UIAxes,app.datetimes,x1);
                              
                          end
                       end
                    end
                     if app.plotcd
                         cla(app.UIAxes,'reset'); % reset axes before plotting  
                        yyaxis(app.UIAxes,"left")  
                        bar(app.UIAxes,app.datetimes, sum(app.scases,1)) 
                        title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));  %current country  
                        
                        yyaxis(app.UIAxes,"right")
                        plot(app.UIAxes,app.datetimes, sum(app.sdeaths));
                         if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                                title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));
                               x1=app.plotmuvmean( sum(app.scases,1),app.plotslider);
                               x2=app.plotmuvmean(sum(app.sdeaths,1),app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                         end
                          
                       if app.plotdaily
                         
                             cla(app.UIAxes,'reset'); % reset axes before plotting
                              grid(app.UIAxes,"on") 
                             yyaxis(app.UIAxes,"left")
                             a=app.daily(sum(app.scases,1));
                             bar(app.UIAxes,app.datetimes,a);
                             title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));
                             
                             yyaxis(app.UIAxes,"right")
                             b=app.daily(sum(app.sdeaths,1));
                             plot(app.UIAxes,app.datetimes,b);
                           
                                 
                          if  app.plotslider>1
                              cla(app.UIAxes,'reset'); % reset axes before plotting
                               grid(app.UIAxes,"on") 
                               title(app.UIAxes,sprintf("Cumulative Number of Cases in %s", app.state{app.state_no}));
                               x1=app.plotmuvmean(a,app.plotslider);
                               x2=app.plotmuvmean(b,app.plotslider);
                               
                               yyaxis(app.UIAxes,"left")
                               bar(app.UIAxes,app.datetimes,x1);
                               yyaxis(app.UIAxes,"right")
                               plot(app.UIAxes,app.datetimes,x2);
                          end
                             
                       end
                     end
               end
          end
     end
    
        function result=daily(app,daily)
                 app.daily_data=daily;
            for a=1:numel(app.daily_data)
                if a==1
                    result(a)=[app.daily_data(a)];
        
                elseif a<=numel(app.daily_data) && a>1
                result(a)=[app.daily_data(a)-app.daily_data(a-1)];
                else
                    result(end)=[app.daily_data(end)-app.daily_data(end-1)];      
                end
            end
         
        end
%      function [result1,result2]= plotmuvmean(app,muvmean,slider)
     function result= plotmuvmean(app,muvmean,slider)
         app.muvmean=muvmean;
         app.slidervalue=slider;

      result=movmean(app.muvmean,app.slidervalue);
  
     end
 end
    
 

    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            load covid_data.mat
            app.countries=splitapply(@(x) {x}, covid_data(2:end,2:end),findgroups(covid_data(2:end,1)))
            app.state=covid_data(2:end,2); %state data
            app.nation=unique(covid_data(2:end,1)); % unique countries
            
              
            app.con_data= cell2mat(covid_data(2:end,3:end));
            app.gcases=app.con_data(:,1:2:end);
            app.gdeaths=app.con_data(:,2:2:end);
            app.datetimes=datetime(covid_data(1,3:end));
%              datetick('x',6);
            
            app.UIAxes.XGrid="on";
            app.UIAxes.YGrid="on";
            
             app.plotc=app.CasesButton.Value;
             app.plotd=app.DeathsButton.Value;
             app.plotcd= app.BothsButton.Value;
             
             app.plotdaily= app.DailyButton.Value;
             app.plotcuml = app.CumulativeButton.Value;
       
            
 
             app.CountryListBox.Items= [{'Global'}; app.nation];  %add Global to country list box
             app.StateorRegionListBox.Items={'All'}; % Set global state to all 
              app.plotn();    

           
            
        end

        % Value changed function: CountryListBox
        function CountryListBoxValueChanged(app, event)
            value = app.CountryListBox.Value;

             [Lia,Locb]=ismember(value,app.nation); % checks if selected country is a member of Countries
              app.current_state=Locb;
              app.plotn();
              
   
               
        end

        % Value changed function: StateorRegionListBox
        function StateorRegionListBoxValueChanged(app, event)
            value = app.StateorRegionListBox.Value;
           
            [lai,loc]= ismember(value,app.state);
            app.state_no=loc;
            app.plots();

              
            
        end

        % Selection changed function: DatatoPlotButtonGroup
        function DatatoPlotButtonGroupSelectionChanged(app, event)
%             selectedButton = app.DatatoPlotButtonGroup.SelectedObject;
               app.plotc=app.CasesButton.Value;
               app.plotd=app.DeathsButton.Value;
               app.plotcd= app.BothsButton.Value;

               app.plots();
               app.plotn();
            

        end

        % Selection changed function: OptionButtonGroup
        function OptionButtonGroupSelectionChanged(app, event)
            %selectedButton = app.OptionButtonGroup.SelectedObject;
            app.plotdaily= app.DailyButton.Value;
            app.plotcuml = app.CumulativeButton.Value;
            
              app.plots();
              app.plotn();
            
        end

        % Value changing function: AveragedofdaysSlider
        function AveragedofdaysSliderValueChanging(app, event)

             app.plotslider=ceil(app.AveragedofdaysSlider.Value);
             app.plots();
             app.plotn();
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 677 480];
            app.UIFigure.Name = 'UI Figure';

            % Create DatatoPlotButtonGroup
            app.DatatoPlotButtonGroup = uibuttongroup(app.UIFigure);
            app.DatatoPlotButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @DatatoPlotButtonGroupSelectionChanged, true);
            app.DatatoPlotButtonGroup.Title = 'Data to Plot';
            app.DatatoPlotButtonGroup.Position = [377 12 123 106];

            % Create CasesButton
            app.CasesButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.CasesButton.Text = 'Cases';
            app.CasesButton.Position = [11 60 58 22];
            app.CasesButton.Value = true;

            % Create DeathsButton
            app.DeathsButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.DeathsButton.Text = 'Deaths';
            app.DeathsButton.Position = [11 38 65 22];

            % Create BothsButton
            app.BothsButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.BothsButton.Text = 'Boths';
            app.BothsButton.Position = [11 16 65 22];

            % Create OptionButtonGroup
            app.OptionButtonGroup = uibuttongroup(app.UIFigure);
            app.OptionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @OptionButtonGroupSelectionChanged, true);
            app.OptionButtonGroup.Title = 'Option';
            app.OptionButtonGroup.Position = [518 14 123 106];

            % Create CumulativeButton
            app.CumulativeButton = uiradiobutton(app.OptionButtonGroup);
            app.CumulativeButton.Text = 'Cumulative';
            app.CumulativeButton.Position = [11 60 82 22];
            app.CumulativeButton.Value = true;

            % Create DailyButton
            app.DailyButton = uiradiobutton(app.OptionButtonGroup);
            app.DailyButton.Text = 'Daily';
            app.DailyButton.Position = [11 38 65 22];

            % Create AveragedofdaysSliderLabel
            app.AveragedofdaysSliderLabel = uilabel(app.UIFigure);
            app.AveragedofdaysSliderLabel.HorizontalAlignment = 'right';
            app.AveragedofdaysSliderLabel.Position = [401 144 57 28];
            app.AveragedofdaysSliderLabel.Text = {'Averaged'; '# of days'};

            % Create AveragedofdaysSlider
            app.AveragedofdaysSlider = uislider(app.UIFigure);
            app.AveragedofdaysSlider.Limits = [1 15];
            app.AveragedofdaysSlider.ValueChangingFcn = createCallbackFcn(app, @AveragedofdaysSliderValueChanging, true);
            app.AveragedofdaysSlider.Position = [479 159 150 3];
            app.AveragedofdaysSlider.Value = 1;

            % Create StateorRegionListBoxLabel
            app.StateorRegionListBoxLabel = uilabel(app.UIFigure);
            app.StateorRegionListBoxLabel.HorizontalAlignment = 'right';
            app.StateorRegionListBoxLabel.Position = [197 98 51 28];
            app.StateorRegionListBoxLabel.Text = {'State or '; 'Region:'};

            % Create StateorRegionListBox
            app.StateorRegionListBox = uilistbox(app.UIFigure);
            app.StateorRegionListBox.Items = {'Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8', 'Item 9', 'Item 10', 'Item 11', 'Item 12', 'Item 13', 'Item 14', 'Item 15', 'Item 16', 'Item 17', 'Item 18', 'Item 19', 'Item 20', 'Item 21', 'Item 22', 'Item 23', 'Item 24', 'Item 25', 'Item 26', 'Item 27', 'Item 28', 'Item 29', 'Item 30', 'Item 31', 'Item 32', 'Item 33', 'Item 34', 'Item 35', 'Item 36', 'Item 37', 'Item 38', 'Item 39', 'Item 40', 'Item 41', 'Item 42', 'Item 43', 'Item 44', 'Item 45', 'Item 46', 'Item 47', 'Item 48', 'Item 49', 'Item 50', 'Item 51', 'Item 52', 'Item 53', 'Item 54', 'Item 55', 'Item 56', 'Item 57', 'Item 58', 'Item 59', 'Item 60', 'Item 61', 'Item 62', 'Item 63', 'Item 64', 'Item 65', 'Item 66', 'Item 67', 'Item 68', 'Item 69', 'Item 70', 'Item 71', 'Item 72', 'Item 73', 'Item 74', 'Item 75', 'Item 76', 'Item 77', 'Item 78', 'Item 79', 'Item 80', 'Item 81', 'Item 82', 'Item 83', 'Item 84', 'Item 85', 'Item 86', 'Item 87', 'Item 88', 'Item 89', 'Item 90', 'Item 91', 'Item 92', 'Item 93', 'Item 94', 'Item 95', 'Item 96', 'Item 97', 'Item 98', 'Item 99', 'Item 100', 'Item 101', 'Item 102', 'Item 103', 'Item 104', 'Item 105', 'Item 106', 'Item 107', 'Item 108', 'Item 109', 'Item 110', 'Item 111', 'Item 112', 'Item 113', 'Item 114', 'Item 115', 'Item 116', 'Item 117', 'Item 118', 'Item 119', 'Item 120', 'Item 121', 'Item 122', 'Item 123', 'Item 124', 'Item 125', 'Item 126', 'Item 127', 'Item 128', 'Item 129', 'Item 130', 'Item 131', 'Item 132', 'Item 133', 'Item 134', 'Item 135', 'Item 136', 'Item 137', 'Item 138', 'Item 139', 'Item 140', 'Item 141', 'Item 142', 'Item 143', 'Item 144', 'Item 145', 'Item 146', 'Item 147', 'Item 148', 'Item 149', 'Item 150', 'Item 151', 'Item 152', 'Item 153', 'Item 154', 'Item 155', 'Item 156', 'Item 157', 'Item 158', 'Item 159', 'Item 160', 'Item 161', 'Item 162', 'Item 163', 'Item 164', 'Item 165', 'Item 166', 'Item 167', 'Item 168', 'Item 169', 'Item 170', 'Item 171', 'Item 172', 'Item 173', 'Item 174', 'Item 175', 'Item 176', 'Item 177', 'Item 178', 'Item 179', 'Item 180', 'Item 181', 'Item 182', 'Item 183', 'Item 184', 'Item 185', 'Item 186', 'Item 187', 'Item 188', 'Item 189', 'Item 190'};
            app.StateorRegionListBox.ValueChangedFcn = createCallbackFcn(app, @StateorRegionListBoxValueChanged, true);
            app.StateorRegionListBox.Position = [263 9 100 113];

            % Create CountryLabel
            app.CountryLabel = uilabel(app.UIFigure);
            app.CountryLabel.HorizontalAlignment = 'right';
            app.CountryLabel.Position = [11 107 54 22];
            app.CountryLabel.Text = 'Country: ';

            % Create CountryListBox
            app.CountryListBox = uilistbox(app.UIFigure);
            app.CountryListBox.Items = {'Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8', 'Item 9', 'Item 10', 'Item 11', 'Item 12', 'Item 13', 'Item 14', 'Item 15', 'Item 16', 'Item 17', 'Item 18', 'Item 19', 'Item 20', 'Item 21', 'Item 22', 'Item 23', 'Item 24', 'Item 25', 'Item 26', 'Item 27', 'Item 28', 'Item 29', 'Item 30', 'Item 31', 'Item 32', 'Item 33', 'Item 34', 'Item 35', 'Item 36', 'Item 37', 'Item 38', 'Item 39', 'Item 40', 'Item 41', 'Item 42', 'Item 43', 'Item 44', 'Item 45', 'Item 46', 'Item 47', 'Item 48', 'Item 49', 'Item 50', 'Item 51', 'Item 52', 'Item 53', 'Item 54', 'Item 55', 'Item 56', 'Item 57', 'Item 58', 'Item 59', 'Item 60', 'Item 61', 'Item 62', 'Item 63', 'Item 64', 'Item 65', 'Item 66', 'Item 67', 'Item 68', 'Item 69', 'Item 70', 'Item 71', 'Item 72', 'Item 73', 'Item 74', 'Item 75', 'Item 76', 'Item 77', 'Item 78', 'Item 79', 'Item 80', 'Item 81', 'Item 82', 'Item 83', 'Item 84', 'Item 85', 'Item 86', 'Item 87', 'Item 88', 'Item 89', 'Item 90', 'Item 91', 'Item 92', 'Item 93', 'Item 94', 'Item 95', 'Item 96', 'Item 97', 'Item 98', 'Item 99', 'Item 100', 'Item 101', 'Item 102', 'Item 103', 'Item 104', 'Item 105', 'Item 106', 'Item 107', 'Item 108', 'Item 109', 'Item 110', 'Item 111', 'Item 112', 'Item 113', 'Item 114', 'Item 115', 'Item 116', 'Item 117', 'Item 118', 'Item 119', 'Item 120', 'Item 121', 'Item 122', 'Item 123', 'Item 124', 'Item 125', 'Item 126', 'Item 127', 'Item 128', 'Item 129', 'Item 130', 'Item 131', 'Item 132', 'Item 133', 'Item 134', 'Item 135', 'Item 136', 'Item 137', 'Item 138', 'Item 139', 'Item 140', 'Item 141', 'Item 142', 'Item 143', 'Item 144', 'Item 145', 'Item 146', 'Item 147', 'Item 148', 'Item 149', 'Item 150', 'Item 151', 'Item 152', 'Item 153', 'Item 154', 'Item 155', 'Item 156', 'Item 157', 'Item 158', 'Item 159', 'Item 160', 'Item 161', 'Item 162', 'Item 163', 'Item 164', 'Item 165', 'Item 166', 'Item 167', 'Item 168', 'Item 169', 'Item 170', 'Item 171', 'Item 172', 'Item 173', 'Item 174', 'Item 175', 'Item 176', 'Item 177', 'Item 178', 'Item 179', 'Item 180', 'Item 181', 'Item 182', 'Item 183', 'Item 184', 'Item 185', 'Item 186', 'Item 187', 'Item 188', 'Item 189', 'Item 190'};
            app.CountryListBox.ValueChangedFcn = createCallbackFcn(app, @CountryListBoxValueChanged, true);
            app.CountryListBox.Position = [80 12 100 113];

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.PlotBoxAspectRatio = [2.47058823529412 1 1];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [1 167 677 310];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = covid

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
