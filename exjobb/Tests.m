classdef Tests < handle
%TESTS Summary of this class goes here
%   Detailed explanation goes here

properties
    % number_of_tests {mustBeNumeric} = 200 => fix so that all tasts have
    % same sample size !!!!
    tests {mustBeCell} = {};
end

methods
    function self = Tests()
        %TESTS Construct an instance of this class
        %   Detailed explanation goes here
    end
    
    function run(self,varargin)
        %METHOD1 Summary of this method goes here
        %   Detailed explanation goes here
        t = Test(varargin{:});
        t.run()
        self.tests{end+1} = t;
    end

    function plot(self, x)
        %METHOD2 Summary of this method goes here
        %   Detailed explanation goes here
        results_all = [];
        results_time_all = [];
        results_trivial_all = [];
        for t = self.tests
            results_all(end+1,:) = t{1}.results_cost;
            results_time_all(end+1,:) = t{1}.results_time;
            results_trivial_all(end+1,:) = t{1}.results_trivial;
        end
        tests_plot(results_all, results_time_all, results_trivial_all, x)
        self.tests = {};
    end
end
end




function tests_plot(results_all, results_time_all, results_trivial_all, x)
    display_name = "display_name";
    graph_name = "graph_name";

    mycolors = [
    238,64,53;
    243,155,54;
    123,192,67;
    3,146,207;
    17,0,255;
    175,56,255;
    ]./255;

    subplot(1,3,1);
    hold on;
    mean_list = [];
    for r = 1:size(results_all, 1)
        mean_list(:,end+1) = mean(results_all(r,:));
    end
    plot(x, mean_list, "-o", 'DisplayName', display_name)
    title("Cost")
    ylabel("Cost [-]")
    xlabel("Fractions")
    ylim([0 1])
    xlim([min(x) max(x)])
    ax = gca; 
    ax.ColorOrder = mycolors;
    
    hold off;

    subplot(1,3,2);
    hold on;
    
    mean_list = [];
    for r = 1:size(results_time_all, 1)
        mean_list(:,end+1) = mean(results_time_all(r,:));
    end
    plot(x, mean_list, "-o", 'DisplayName', display_name)
    title(graph_name + newline + "Runtime")
    ylabel("Time [s]")
    xlabel("Fractions")
    xlim([min(x) max(x)])
    ax = gca; 
    ax.ColorOrder = mycolors;

    hold off;

    subplot(1,3,3);
    hold on;
    
    mean_list = [];
    for r = 1:size(results_trivial_all, 1)
        mean_list(:,end+1) = mean(results_trivial_all(r,:)); 
    end
    plot(x, mean_list, "-o", 'DisplayName', display_name)
    title("Trivial solutions")
    ylabel("Index [-]")
    xlabel("Fractions")
    ylim([0 1])
    xlim([min(x) max(x)])
    ax = gca; 
    ax.ColorOrder = mycolors;
    lgd = legend;
    title(lgd,'size')
    hold off;
end