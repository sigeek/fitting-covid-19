function [data_struct, dates] = getData()
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
    date = timestamp_array(1);
    date = datetime(date,'InputFormat','yyyy-MM-dd');
    dates(i) = date;
end

% define vectors with daily variation 
% nuovi_isolamento_domicialiare
% nuovi_dimessi_guariti
% nuovi_deceduti
data_struct.nuovi_isolamento_domiciliare(1) = data_struct.isolamento_domiciliare(1);
data_struct.nuovi_dimessi_guariti(1) = data_struct.dimessi_guariti(1);
data_struct.nuovi_deceduti(1) = data_struct.deceduti(1);
data_struct.nuovi_ospedalizzati(1) = data_struct.totale_ospedalizzati(1);

for i = 2:size(data_struct.data)
    data_struct.nuovi_isolamento_domiciliare(i)=...
        data_struct.isolamento_domiciliare(i)-data_struct.isolamento_domiciliare(i-1);
    data_struct.nuovi_dimessi_guariti(i)=...
        data_struct.dimessi_guariti(i)-data_struct.dimessi_guariti(i-1);
    data_struct.nuovi_deceduti(i)=...
        data_struct.deceduti(i)-data_struct.nuovi_deceduti(i-1);
    data_struct.nuovi_ospedalizzati(i)=...
        data_struct.totale_ospedalizzati(i)-data_struct.totale_ospedalizzati(i-1);
end

data_struct.nuovi_positivi = data_struct.nuovi_positivi';

%for i = 1:size(data_struct)
%    data_struct(i) = cast(data_struct(i), 'double');
%end
%data_struct.nuovi_isolamento_domiciliare = data_struct.nuovi_isolamento_domiciliare';
%data_struct.nuovi_dimessi_guariti = data_struct.nuovi_dimessi_guariti';
%data_struct.nuovi_deceduti = data_struct.nuovi_deceduti';


