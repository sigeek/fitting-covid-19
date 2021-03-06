function [data_struct, dates] = getDataByRegion(region)
%
% Output: struct containing all the COVID-19 data about a specific region
% The offical data is taken from 'Presidenza del Consiglio dei Ministri - Dipartimento della Protezione Civile '
% Link to repository: https://github.com/pcm-dpc/COVID-19 
%

% raw file url
if region == "Molise"   
    url = urlread('https://raw.githubusercontent.com/sigeek/fitting-covid-19/main/data/dpc-covid19-ita-molise.csv');
else
    url = urlread('https://raw.githubusercontent.com/sigeek/fitting-covid-19/main/data/dpc-covid19-ita-sardegna.csv');
end

% definition of the data types for every column in the CSV file
C = textscan(url,'%s %s %d %s %f %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %s',...
    'delimiter',',','HeaderLines',1,'EndOfLine','\n');
% definition of the data structure
data_struct = cell2struct(C,{'data','stato', 'codice_regione','denominazione_regione', ...
    'lat', 'long', 'ricoverati_con_sintomi','terapia_intensiva',...
    'totale_ospedalizzati','isolamento_domiciliare','totale_positivi',...
    'variazione_totale_positivi','nuovi_positivi','dimessi_guariti',...
    'deceduti','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi',...
    'tamponi','casi_testati','ingressi_terapia_intensiva',...
    'totale_positivi_test_molecolare', ...
    'totale_positivi_test_antigenico_rapido', ...
    'tamponi_test_molecolare', 'tamponi_test_antigenico_rapido', ...
    'codice_nuts_1', 'codice_nuts_2'},2);

% removing additional columns we will not use in our analysis
data_struct = rmfield(data_struct, 'stato');

% date format
% from YYYY-MM-DDThh-mm to YYYY-MM-DD

for i = 1:size(data_struct.data)
    timestamp_array = split(data_struct.data(i),"T");
    date = timestamp_array(1);
    date = datetime(date,'InputFormat','yyyy-MM-dd');
    dates(i) = date;
end


data_struct.nuovi_positivi = data_struct.nuovi_positivi';



