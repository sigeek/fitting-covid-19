function [data_struct] = getData()
%
% Output: struct containing all the COVID-19 data about Italy
% The offical data is taken from 'Presidenza del Consiglio dei Ministri - Dipartimento della Protezione Civile '
% Link to repository: https://github.com/pcm-dpc/COVID-19 
%

% raw file url
url = urlread('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv');
% definition of the data types for every column in the CSV file
C = textscan(url,'%s %s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %d %s %s','delimiter',',','HeaderLines',1,'EndOfLine','\n');
% definition of the data structure
data_struct = cell2struct(C,{'data','stato','ricoverati_con_sintomi','terapia_intensiva',...
    'totale_ospedalizzati','isolamento_domiciliare','totale_positivi',...
    'variazione_totale_positivi','nuovi_positivi','dimessi_guariti',...
    'deceduti','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi',...
    'tamponi','casi_testati','note','ingressi_terapia_intensiva','note_test','note_casi'},2);

% removing additional columns we will not use in our analysis
data_struct = rmfield(data_struct, 'stato');
data_struct = rmfield(data_struct, 'note');
data_struct = rmfield(data_struct, 'note_test');
data_struct = rmfield(data_struct, 'note_casi');

% date format
% from YYYY-MM-DDThh-mm to YYYY-MM-DD
for i = 1:size(data_struct.data)
    timestamp_array = split(data_struct.data(i),"T");
    data_struct.data(i) = timestamp_array(1);
end

