function plotBodeDataInteractive
    % 创建主窗口
    fig = figure('Position', [100, 100, 1300, 600], 'Name', 'Interactive Bode Plot');

    % 创建按钮组
    buttonGroup = uibuttongroup(fig, 'Position', [0.1, 0.05, 0.8, 0.9], 'BorderType', 'none');

    % 创建按钮
    buttonNames = {
        'Vdd', 'Vla', 'Vo', 'Vra', 'Vref', 'Vrl', ...
        'Ix(x1:VDD)', 'Ix(x1:VIN+)', 'Ix(x1:VIN-)', 'Ix(x1:VOUT)', ...
        'Ix(x2:VDD)', 'Ix(x2:VIN+)', 'Ix(x2:VIN-)', 'Ix(x2:VOUT)', ...
        'Ix(x3:VDD)', 'Ix(x3:VIN+)', 'Ix(x3:VIN-)', 'Ix(x3:VOUT)', ...
        'Ix(x4:VDD)', 'Ix(x4:VIN+)', 'Ix(x4:VIN-)', 'Ix(x4:VOUT)', ...
        'Ix(x5:VECG+)', 'Ix(x5:VECG-)', 'Ix(x5:VLA)', 'Ix(x5:VRA)', 'Ix(x5:VRL)'
    };
    
    % 创建按钮名字到列索引的映射表
    colIndexMap = containers.Map(buttonNames, 2:length(buttonNames)+1);
    
    numRows = 4;
    numCols = [6, 8, 8, 5];
    buttonIndex = 1;
    
    for col = 1:length(numCols)
        for row = 1:numCols(col)
            uicontrol(buttonGroup, 'Style', 'pushbutton', 'String', buttonNames{buttonIndex}, ...
                'Position', [(col-1)*300 + 10, 550 - row*50, 120, 30], 'Callback', {@plotSelectedData, buttonNames{buttonIndex}});
            buttonIndex = buttonIndex + 1;
        end
    end

    % 绘制图形
    function plotSelectedData(~, ~, buttonName)
        T = readtable('project_test.txt', 'VariableNamingRule', 'preserve');
        colIndex = colIndexMap(buttonName);
        
        magnitudeData = str2double(extractBetween(T{:, colIndex}, '(', 'dB'));
        phaseData = str2double(extractBetween(T{:, colIndex}, ',', '°'));

        figure;
        subplot(2, 1, 1);
        semilogx(T.('Freq.'), magnitudeData);
        grid on;
        ylabel('Magnitude (dB)');
        xlabel('Frequency (Hz)');
        title(['Magnitude of ' T.Properties.VariableNames{colIndex}]);

        subplot(2, 1, 2);
        semilogx(T.('Freq.'), phaseData);
        grid on;
        ylabel('Phase (°)');
        xlabel('Frequency (Hz)');
        title(['Phase of ' T.Properties.VariableNames{colIndex}]);
    end
end
