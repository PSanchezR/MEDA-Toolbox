function varargout = GuiV1(varargin)
% GUIV1 MATLAB code for GuiV1.fig
%      GUIV1, by itself, creates a new GUIV1 or raises the existing
%      singleton*.
%
%      H = GUIV1 returns the handle to a new GUIV1 or the handle to
%      the existing singleton*.
%
%      GUIV1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIV1.M with the given input arguments.
%
%      GUIV1('Property','Value',...) creates a new GUIV1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiV1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiV1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above textLambda to modify the response to help GuiV1

% Last Modified by GUIDE v2.5 26-Aug-2015 17:11:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiV1_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiV1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
              
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GuiV1 is made visible.
function GuiV1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiV1 (see VARARGIN)

% Choose default command line output for GuiV1
handles.output = hObject;
%Summary Panel:
handles.data.sumtext = [];

%Information Panel:
handles.data.messageNum=0;
handles.data.messageNum_max=10;
handles.data.text=[];

%Variables initialization:
handles.data.PCs=[];
handles.data.PC1=[];
handles.data.PC2=[];
handles.data.weightDummy=cell(1,1000);
handles.data.dummy={};
handles.data.sp_ID_figures=[];
handles.data.sp_matrix={};
handles.data.clean_control=zeros(1,1000);
handles.data.lp_ID_figures=[];
handles.data.lp_matrix={};
handles.data.PC1_LP=[];
handles.data.PC2_LP=[];
handles.data.control_Refresh=0;
handles.data.CORTES={};
handles.data.matrix_2PCs={};
handles.data.PCs_MEDA='';
handles.data.auxPCs=0;
handles.data.data_matrix=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiV1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiV1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function modelCalibration(hObject,evendata, handles)
global data_path;    
data_path = get(handles.textPath,'String'); 
if(strcmp(data_path,''))
     errordlg('Select data file.');
     return
end
load(data_path);
set(handles.editConsole,'string','');
%%%%%% Common Variables%%%%%%%
global Lmodel;
global console;
global step;
global lambda;

console = handles.editConsole;

if strcmp(get(handles.editLvs,'String'),'')
    errordlg('Introduce the number of latent variables.');
    return;
end
if strcmp(get(handles.editPrep,'String'),'')
    errordlg('Introduce the number of prep.');
    return;
end
if strcmp(get(handles.editNc,'String'),'')
    errordlg('Introduce the number of clusters.');
    return;
end
if strcmp(get(handles.editStep,'String'),'')
    errordlg('Introduce step factor.');
    return;
end
Lmodel{1} = Lmodel_ini;      
Lmodel{1}.lv = str2num(get(handles.editLvs,'String'));         
Lmodel{1}.prep = str2num(get(handles.editPrep,'String'));  
Lmodel{1}.prepy = str2num(get(handles.editPrepY,'String')); 
Lmodel{1}.nc = str2num(get(handles.editNc,'String'));        
lambda = str2double(get(handles.editLambda,'String'));        
step = str2double(get(handles.editStep,'String'));

listaComponentes1 = get(handles.popupmenuPC1,'String');
for k=1:Lmodel{1}.lv
    listaComponentes{k} = strcat('PC ',num2str(k));
end
set(handles.popupmenuPC1,'string',listaComponentes);
set(handles.popupmenuPC2,'string',listaComponentes);




function analize(hObject, eventdata,handles)
global Lmodel; global console; global step; global lambda; global data_path;
load(data_path);
if get(handles.radiobuttonPca,'Value') == 1 %Inclusión en el modelo del tipo de análisis
        Lmodel{1}.type = 1;
    else
        Lmodel{1}.type = 2;
end
if get(handles.checkboxGenInterModel,'Value') == 1 %Se ejecuta para generación de modelos intermedios.
    lista = get(handles.listboxModels,'String');
    lista{1} ='Lmodel_1';
    if get(handles.radiobuttonIterative,'Value') == 1 %Si se selecciona iterative
        Lmodel{1}.update = 2;     
        Lmodel{1} = update_iterative2(list(1),'',Lmodel{1},20,step,0,'',1,console);
    else %Si se seleccionan EWMA
        Lmodel{1}.update = 1; 
        if strcmp(get(handles.editLambda,'String'),'')
            errordlg('Introduce forgueting factor.');
            return;
        end    
        Lmodel{1} = update_ewma2(list(1),'',Lmodel{1},lambda,step,1,console);
    end
    for i=2:length(list) %  Para cada fichero de la lista se genera un modelo.
        if get(handles.radiobuttonIterative,'Value') == 2
            Lmodel{i}.update = 2;
            Lmodel{i} = update_iterative2(list(i),'',Lmodel{i-1},20,step,0,'',1,console);
        else
            Lmodel{i}.update = 1;
            Lmodel{i} = update_ewma2(list(i),'',Lmodel{i-1},lambda,step,1,console);
        end
        lista{i} = strcat('Lmodel_',num2str(i));       
    end
    set(handles.listboxModels,'String',lista);
else  
    if get(handles.radiobuttonIterative,'Value') == 1
        Lmodel{1}.update = 2; 
        Lmodel{1} = update_iterative2(list,'',Lmodel{1},20,step,0,'',1,console);
    else
        Lmodel{1}.update = 1;
        Lmodel{1} = update_ewma2(list,'',Lmodel{1},lambda,step,1,console);
    end
    lista{1} = 'Lmodel_1';
    set(handles.listboxModels,'String',lista);
end
assignin('base', 'Lmodel', Lmodel);


function pushbuttonStart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%Cleaning list%%%%%%%%%%%%%%%%%%%%%
set(handles.listboxModels,'String',{});
pause(0.001);
modelCalibration(hObject, eventdata, handles);
analize(hObject, eventdata, handles);


    



function editLvs_Callback(hObject, eventdata, handles)
% hObject    handle to editLvs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLvs as textLambda
%        str2double(get(hObject,'String')) returns contents of editLvs as a double


% --- Executes during object creation, after setting all properties.
function editLvs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLvs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPrep_Callback(hObject, eventdata, handles)
% hObject    handle to editPrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPrep as textLambda
%        str2double(get(hObject,'String')) returns contents of editPrep as a double


% --- Executes during object creation, after setting all properties.
function editPrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPrepY_Callback(hObject, eventdata, handles)
% hObject    handle to editPrepY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPrepY as textLambda
%        str2double(get(hObject,'String')) returns contents of editPrepY as a double


% --- Executes during object creation, after setting all properties.
function editPrepY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPrepY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNc_Callback(hObject, eventdata, handles)
% hObject    handle to editNc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNc as textLambda
%        str2double(get(hObject,'String')) returns contents of editNc as a double


% --- Executes during object creation, after setting all properties.
function editNc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonDataPath.
function pushbuttonDataPath_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename,pathname] = uigetfile
    cd(pathname);
    set(handles.textPath,'String',fullfile(pathname, filename));
    



function editLambda_Callback(hObject, eventdata, handles)
% hObject    handle to editLambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLambda as textLambda
%        str2double(get(hObject,'String')) returns contents of editLambda as a double


% --- Executes during object creation, after setting all properties.
function editLambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStep_Callback(hObject, eventdata, handles)
% hObject    handle to editLambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLambda as textLambda
%        str2double(get(hObject,'String')) returns contents of editLambda as a double


% --- Executes during object creation, after setting all properties.
function editStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxScores.
function checkboxScores_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxScores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxScores


% --- Executes on button press in checkboxMeda.
function checkboxMeda_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMeda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxMeda


% --- Executes on button press in checkboxOmeda.
function checkboxOmeda_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOmeda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOmeda
if get(handles.checkboxOmeda, 'Value') == 1
    set(handles.selomedaButton,'enable','on');
    %set(handles.plusButton,'enable','on');
    %set(handles.minusButton,'enable','on');
    %set(handles.trendButton,'enable','on');
    %set(handles.cleanButton,'enable','on');
    %set(handles.omedaButton,'enable','on');
else
    set(handles.selomedaButton,'enable','off');
    set(handles.plusButton,'enable','off');
    set(handles.minusButton,'enable','off');
    set(handles.trendButton,'enable','off');
    set(handles.cleanButton,'enable','off');
    set(handles.omedaButton,'enable','off');
end

% --- Executes on button press in radiobuttonEwma.
function radiobuttonEwma_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonEwma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonEwma
if get(handles.radiobuttonEwma,'Value') == 1
    set(handles.editLambda,'Enable','on')
    set(handles.textLambda,'Enable','on')
end


% --- Executes on button press in radiobuttonIterative.
function radiobuttonIterative_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonIterative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonIterative
if get(handles.radiobuttonIterative,'Value') == 1
    set(handles.editLambda,'Enable','off')
    set(handles.textLambda,'Enable','off')
end


% --- Executes on button press in radiobuttonPca.
function radiobuttonPca_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonPca
if get(handles.radiobuttonPca, 'Value') == 1
    set(handles.textPrepy,'Enable','off')
     set(handles.editPrepY,'Enable','off')
end


% --- Executes on button press in radiobuttonPls.
function radiobuttonPls_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonPls
if get(handles.radiobuttonPls, 'Value') == 1
    set(handles.textPrepy,'Enable','on')
    set(handles.editPrepY,'Enable','on')
end


% --- Executes on button press in checkboxGenInterModel.
function checkboxGenInterModel_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGenInterModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGenInterModel


% --- Executes on selection change in listboxModels.
function listboxModels_Callback(hObject, eventdata, handles)
% hObject    handle to listboxModels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxModels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxModels


% --- Executes during object creation, after setting all properties.
function listboxModels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxModels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.





function editConsole_Callback(hObject, eventdata, handles)
% hObject    handle to editConsole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editConsole as text
%        str2double(get(hObject,'String')) returns contents of editConsole as a double


% --- Executes during object creation, after setting all properties.
function editConsole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editConsole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function preparaOmeda(hObject,eventdata,handles)
all_opened_graphs=get(0,'Children');
new_sp_ID_figures=[];
new_sp_matrix={};
clean_ind=[];

for i=1:length(handles.data.sp_ID_figures),
    if ~isempty(find(handles.data.sp_ID_figures(i)==all_opened_graphs,1)),
        new_sp_ID_figures=[new_sp_ID_figures handles.data.sp_ID_figures(i)];
        new_sp_matrix={new_sp_matrix{:} handles.data.sp_matrix{:,i}};
    else
        clean_ind=[clean_ind i];%Identificadores de lo Score Plots cerrados
        for j=1:length(clean_ind),
            aux=clean_ind(j);
            handles.data.clean_control(aux)=0;
            handles.data.CORTES{1,aux}=[];
            handles.data.weightDummy{1,aux}=[];
            handles.data.matrix_2PCs{1,aux}=[];
            %Dummy:
            M=size(handles.data.data_matrix,1);
            dummy=zeros(1,M);
            handles.data.dummy{1,aux}=dummy;
            handles.data.dummyRED=dummy;
            handles.data.dummyGREEN=dummy;
        end
    end
end

handles.data.sp_ID_figures=new_sp_ID_figures;%Vector actualizado con los identificadores de los Score Plots abiertos 
handles.data.sp_matrix=new_sp_matrix;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonVisualize.
function pushbuttonVisualize_Callback(hObject, eventdata, handles)
global Lmodel;
handles.data.sp_ID_figures=[];
handles.data.sp_ID_figure=[];
if(isequal(get(handles.popupmenuPC1,'value'),get(handles.popupmenuPC2,'value')))
     errordlg('PC1 and PC2 can´t be equals');
    return;
end
if((get(handles.popupmenuPC1,'value'))<(get(handles.popupmenuPC2,'value')))
    handles.data.PCMin = get(handles.popupmenuPC1,'value');
    handles.data.PCMax = get(handles.popupmenuPC2,'value');
else
    handles.data.PCMin = get(handles.popupmenuPC2,'value');
    handles.data.PCMax = get(handles.popupmenuPC1,'value');
end
fig = 0;
if length(Lmodel)> 1  
    i = get(handles.listboxModels,'Value');
else
    i = 1;
end
if Lmodel{i}.type == 2 && rank(Lmodel{i}.XY) > 0
    if get(handles.checkboxScores,'Value') == 1
        [T,TT] = scores_Lpls(Lmodel{i},handles.data.PCMin:handles.data.PCMax);
        preparaOmeda(hObject,eventdata,handles);
        fig = gcf;
        set(fig,'Tag','ScorePlot');%A cada ScorePlot que abro le pongo en su propiedad 'Tag' que es un ScorePlot
        matrixPCs_oMEDA =[T(:,handles.data.PCMin:handles.data.PCMax),T(:,handles.data.PCMin:handles.data.PCMax)];
        handles.data.sp_matrix = {handles.data.sp_matrix{:} matrixPCs_oMEDA};
    end
    if get(handles.checkboxMeda,'Value') == 1
        map = meda_Lpls(Lmodel{i},handles.data.PCMin:handles.data.PCMax,0,3);
    end
else
    if get(handles.checkboxScores,'Value') == 1
        [T,TT]=  scores_Lpca(Lmodel{i},handles.data.PCMin:handles.data.PCMax);
        preparaOmeda(hObject,eventdata,handles);
        handles.data.T = T;
        fig = gcf;  
        set(fig,'Tag','ScorePlot');%A cada ScorePlot que abro le pongo en su propiedad 'Tag' que es un ScorePlot
        matrixPCs_oMEDA =[T(:,handles.data.PCMin),T(:,handles.data.PCMax)];
        handles.data.sp_matrix = {handles.data.sp_matrix{:} matrixPCs_oMEDA};
    end
    if get(handles.checkboxMeda,'Value') == 1
         map = meda_Lpca(Lmodel{i},handles.data.PCMin:handles.data.PCMax,0,3);
    end
end
handles.data.sp_ID_figures=[handles.data.sp_ID_figures fig];
guidata(hObject,handles);
%



% --- Executes on button press in trendButton.
function trendButton_Callback(hObject, eventdata, handles)
% hObject    handle to trendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

matrix_2PCs=handles.data.matrix_2PCs{1,ID};
trend_line=imline;
setColor(trend_line,[0 0 0]);
vertex_line=getPosition(trend_line);

x1=vertex_line(1,1);
y1=vertex_line(1,2);
x2=vertex_line(2,1);
y2=vertex_line(2,2);

%Coordenadas del vector director de la recta que une ambos vï¿½rtices:
u1=x2-x1;
u2=y2-y1;

%La ecuaciï¿½n de la recta tendencia es:
A=u2;
B=-u1;
C=(u1*y1)-(u2*x1);

%Quiero el punto de corte de la tendencia con la recta que va de la observaciï¿½n
%a la lï¿½nea tendencia en perpendicular. Esto para cada una de las
%observaciones.
Cutoff_points=[];
M=size(handles.data.data_matrix,1);
for m=1:M,
    p1=matrix_2PCs(m,1);
    p2=matrix_2PCs(m,2);
    
    %El vector director de la recta que va de la observacion a la
    %tendencia en perpendicular es:
    v1=A;
    v2=B;
    
    %La ecuacuaciï¿½n de la recta es:
    A2=v2;
    B2=-v1;
    C2=(v1*p2)-(v2*p1);
    
    %Ahora se obtiene el punto de corte de ambas rectas:
    %Ax+By+C=0;
    %A2x+B2y+C2=0;
    y_corte=(-C2+(A2/A)*C)/(((-A2/A)*B)+B2);
    x_corte=((-B*y_corte)-C)/A;
    Cutoff_points(m,1)=x_corte;
    Cutoff_points(m,2)=y_corte;
end
%Quedarse con la menor distancia entre un 1 y -1
lowest_dist=Inf;
ind1=1;
ind2=1;
dummy=handles.data.dummy{1,ID};
for k=1:M,
    if dummy(k)==1,
        %Coordenadas del punto que tiene asignado un 1 en la variable
        %dummy
        p1=Cutoff_points(k,1);
        p2=Cutoff_points(k,2);
        
        for l=1:M,
            if dummy(l)==-1,
                q1=Cutoff_points(l,1);
                q2=Cutoff_points(l,2);
                dist=sqrt((q1-p1)^2+(q2-p2)^2);
                if dist< lowest_dist,
                    lowest_dist=dist;
                    ind1=k;
                    ind2=l;
                end
            end
        end
        
    end
end

%Construcciï¿½n de la nueva DUMMY con pesos:
%Calcular el punto medio entre las observaciones mï¿½s cercanas obtenidas
%enteriormente, este serï¿½ el nuevo cero para asignar pesos.
c1=Cutoff_points(ind1,:);
c2=Cutoff_points(ind2,:);
NewCenter=(c1+c2)/2;

%Asignaciï¿½n de pesos
for m=1:M,
    weights(m)=sum((Cutoff_points(m,:)-NewCenter).^2);
end
weightDummy=weights.*dummy;

handles.data.weightDummy{1,ID}= weightDummy;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;

guidata(hObject,handles);


% --- Executes on button press in cleanButton.
function cleanButton_Callback(hObject, eventdata, handles)
% hObject    handle to cleanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
else
    errordlg('To clean a figure this must be a Score Plot.');
    return;
end

clean_times=handles.data.clean_control(ID);

a=get(ID,'Children');
b=a(length(a));
c=get(b,'Children');
delete(c(1:clean_times));

handles.data.clean_control(ID)=0;
handles.data.weightDummy{1,ID}=[];
%Dummy:
M=size(handles.data.data_matrix,1);
dummy=zeros(1,M);
handles.data.dummy{1,ID}=dummy;
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

guidata(hObject,handles);


% --- Executes on button press in plusButton.
function plusButton_Callback(hObject, eventdata, handles)
% hObject    handle to plusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Lmodel;
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

p = get(handles.listboxModels,'value');
M=size(Lmodel{p}.centr,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2PCs=handles.data.matrix_2PCs{1,ID};
dummy=zeros(1,M);
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;
for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2PCs(l,1);
        Ydata=matrix_2PCs(l,2);
        coord=plot(Xdata,Ydata);
        set(coord,'marker','o');
        set(coord,'markerfacecolor',[0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        handles.data.dummyGREEN(l)=1;
        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end
set(handles.omedaButton,'Enable','on');
set(handles.trendButton,'Enable','on');
handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% --- Executes on button press in minusButton.
function minusButton_Callback(hObject, eventdata, handles)
% hObject    handle to minusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

M=size(handles.data.data_matrix,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2PCs=handles.data.matrix_2PCs{1,ID};

for l=1:M,
    if mod(CortesVector(l),2)==1,
        
        Xdata=matrix_2PCs(l,1);
        Ydata=matrix_2PCs(l,2);
        
        coord=plot(Xdata,Ydata);
        set(coord,'marker','s');
        set(coord,'markerfacecolor', [0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        
        %Dummy:
        handles.data.dummyRED(l)=-1;

        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end

handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
guidata(hObject,handles);



% --- Executes on button press in selomedaButton.
function selomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to selomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Lmodel;
p  = get(handles.listboxModels,'value');
data_matrix = Lmodel{p}.centr;
ID_list=get(0,'Children');
ID=ID_list(2);%Identificador de la grï¿½fica seleccionada (debe ser un Score Plot).
check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Lanzar el Score Plot seleccionado para hacer oMEDA.
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

%Es necesario recuperar los datos del Score Plot seleccionado, es decir las observaciones ploteadas en el eje x e y:
%Voy a recorrer el vector de gcfs de score plots que se llama
%handles.data.sp_ID_figures, para buscar en que posición está el gcf ID.
for i=1:length(handles.data.sp_ID_figures),
   if handles.data.sp_ID_figures(i)==ID,
        % codigo de compr de que estï¿½ vacio
        %ID
        %size(handles.data.sp_matrix)
       matrix_2PCs=handles.data.sp_matrix{:,i};
   end
end
irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Tamaï¿½o de la matriz:
%filas: nï¿½mero de vï¿½rtices del polinomio irregular
%columnas: contiene 2 columnas: coordenada x y coordenada y de cada vï¿½rtice.

%PASO 1:
%Calcular los parï¿½metros A, B y C de la ecuaciï¿½n normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el nï¿½mero de vï¿½rtices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un vï¿½rtice:
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente vï¿½rtice:
    %El if controla el caso en que ya se hayan cogido todos los vï¿½rtices,
    %el vï¿½rtce en ese caso serï¿½ el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos vï¿½rtices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%Cï¿½lculo del parï¿½metro C de la ec.normal de la recta.
    C=[C,c];%Lista del parï¿½metro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(data_matrix,1);%Number of observations in the score matrix.
X=[];
corte=0;
CORTES=[];
for j=1:M, %Se recorren todas las observaciones
    Y=matrix_2PCs(j,2);
    corte=0;
    for k=1:N,%Todas las rectas del poligono irregular
        X=(-(B(k)*Y)-C(k))/A(k);
        
        if k+1>N,
            if (Y>min(vertex(k,2),vertex(1,2)))&&(Y<max(vertex(k,2),vertex(1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        else
            if (Y>min(vertex(k,2),vertex(k+1,2)))&&(Y<max(vertex(k,2),vertex(k+1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        end
    end
    CORTES=[CORTES,corte];
end

set(handles.minusButton,'Enable','on');
set(handles.plusButton,'Enable','on');
set(handles.cleanButton,'Enable','on');

handles.data.CORTES{1,ID.Number}=CORTES;
handles.data.matrix_2PCs{1,ID.Number}=matrix_2PCs;
handles.data.clean_control(ID.Number)=handles.data.clean_control(ID.Number)+1;

guidata(hObject,handles);

% --- Executes on button press in omedaButton.
function omedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to omedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Lmodel;
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end
check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end
if isequal(handles.data.dummy{1,ID},zeros(1,size(handles.data.dummy{1,ID},2))) && isempty(handles.data.weightDummy{1,ID}),
    errordlg('To perform oMEDA you must select a Score Plot with at least one object selected.');
    return;
end
p = get(handles.listboxModels,'value');
if ~isempty(handles.data.weightDummy{1,ID}),
    handles.data.weightDummy{1,ID}=handles.data.weightDummy{1,ID}./abs(max(handles.data.weightDummy{1,ID}));
    omeda_Lpca(Lmodel{p},handles.data.PCMin:handles.data.PCMax,Lmodel{p},handles.data.weightDummy{1,ID}',1);
else
    omeda_Lpca(Lmodel{p},handles.data.PCMin:handles.data.PCMax,Lmodel{p},handles.data.dummy{1,ID}',1);
end
guidata(hObject,handles);


% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editLvs,'string','');
set(handles.editPrep,'string','');
set(handles.editPrepY,'string','');
set(handles.editNc,'string','');
set(handles.editStep,'string','');
set(handles.editLambda,'string','');
set(handles.editConsole,'string','');


% --------------------------------------------------------------------
function uipushtoolSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Lmodel;
last_path = pwd;
[file,path] = uiputfile('*.mat','Save Workspace as');
assignin('base', 'path', path);
assignin('base', 'last_path', last_path);
cd(path);
save(file,'Lmodel');
cd(last_path);


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Lmodel;
[filename,path] = uigetfile;
last_path = pwd;
cd(path);
load(filename);
cd(last_path);
assignin('base', 'Lmodel', Lmodel);
lista = get(handles.listboxModels,'String');
if length(Lmodel)>1
    set(handles.checkboxGenInterModel,'value',1);
end
for i=1:length(Lmodel)
    set(handles.editLvs,'string',Lmodel{i}.lv);
    set(handles.editPrep,'string',Lmodel{i}.prep);
    set(handles.editPrepY,'string',Lmodel{i}.prepy);
    set(handles.editNc,'string',Lmodel{i}.nc);
    %set(handles.editStep,'string',Lmodel{i});
    %set(handles.editLambda,'string','');  
    lista{i} = strcat('Lmodel_',num2str(i));
end
set(handles.listboxModels,'String',lista);


% --- Executes on button press in pushbuttonClearVis.
function pushbuttonClearVis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClearVis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listboxModels,'String','');
set(handles.checkboxScores,'Value',0);
set(handles.checkboxMeda,'Value',0);
set(handles.checkboxOmeda,'Value',0);


% --- Executes on selection change in popupmenuPC1.
function popupmenuPC1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.popupmenuPC1,'value'),get(handles.popupmenuPC2,'value')))
     errordlg('PC1 and PC2 can´t be equals');
    return;
end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPC1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPC1


% --- Executes during object creation, after setting all properties.
function popupmenuPC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuPC2.
function popupmenuPC2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.popupmenuPC1,'value'),get(handles.popupmenuPC2,'value')))
     errordlg('PC1 and PC2 can´t be equals');
    return;
end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPC2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPC2


% --- Executes during object creation, after setting all properties.
function popupmenuPC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
