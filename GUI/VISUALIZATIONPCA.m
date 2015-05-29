function varargout = VISUALIZATIONPCA(varargin)
% VISUALIZATIONPCA MATLAB code for VISUALIZATIONPCA.fig
%      VISUALIZATIONPCA, by itself, creates a new VISUALIZATIONPCA or raises the existing
%      singleton*.
%
%      H = VISUALIZATIONPCA returns the handle to a new VISUALIZATIONPCA or the handle to
%      the existing singleton*.
%
%      VISUALIZATIONPCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZATIONPCA.M with the given input arguments.
%
%      VISUALIZATIONPCA('Property','Value',...) creates a new VISUALIZATIONPCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VISUALIZATIONPCA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VISUALIZATIONPCA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VISUALIZATIONPCA

% Last Modified by GUIDE v2.5 29-May-2015 12:13:30

% Begin initialization code - DO NOT EDIT
if size(varargin) == 0,
    h = msgbox('You should specify a struct argument in VISUALIZATIONPCA','Error message');
    return;   
end
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VISUALIZATIONPCA_OpeningFcn, ...
                   'gui_OutputFcn',  @VISUALIZATIONPCA_OutputFcn, ...
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


% --- Executes just before VISUALIZATIONPCA is made visible.
function VISUALIZATIONPCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VISUALIZATIONPCA (see VARARGIN)

%TODO extract from the first argument the struct necessary for the
%visualization.    
handles.data = varargin{1};

% Choose default command line output for VISUALIZATIONPCA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VISUALIZATIONPCA wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%Function to get the current string in a popupmenu
function str = getCurrentPopupString(hh)
%# getCurrentPopupString returns the currently selected string in the popupmenu with handle hh

%# could test input here
if ~ishandle(hh) || strcmp(get(hh,'Type'),'popupmenu')
error('getCurrentPopupString needs a handle to a popupmenu as input')
end

%# get the string - do it the readable way
list = get(hh,'String');
val = get(hh,'Value');
if iscell(list)
   str = list{val};
else
   str = list(val,:);
end

% --- Outputs from this function are returned to the command line.
function varargout = VISUALIZATIONPCA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in resomedaButton.
function resomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to resomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,1,handles.data.label);

% --- Executes on button press in modelomedaButton.
function modelomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,1,handles.data.label);

% --- Executes on selection change in classcorePopup.
function classcorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to classcorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classcorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classcorePopup


incoming_data=get(hObject,'Value');
string_evaluation=handles.data.new2{incoming_data};
handles.data.namePopupmenu15=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes=[];
    handles.data.classes=[];
else
    classes=evalin('base',string_evaluation);
    handles.data.classes=classes;
end

if ~isempty(handles.data.classes),
    if max(size(classes))~=size(handles.data.data_matrix,1) || min(size(classes))~=1,
        errordlg('Classes must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu15='emptyclasses';
        handles.data.classes=[];
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptyclasses'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function classcorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classcorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new2=[];
handles.data.classes=[];
set(hObject,'String',{'emptyclasses'});

handles.data.WorkSpace=evalin('base','who');
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new2=[];
    for i=1:length(handles.data.WorkSpace),
        new2=[new2 handles.data.WorkSpace(i,:)];
    end
    new2=[contents,new2];
    set(hObject,'String',strvcat(new2));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptyclasses'),
        val=i;
    end
end
handles.data.namePopupmenu15='emptyclasses';
set(hObject,'Value',val);
handles.data.new2=new2;
guidata(hObject, handles);


% --- Executes on selection change in labscorePopup.
function labscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to labscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labscorePopup


incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new1{incoming_data};
handles.data.namePopupmenu16=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label={};
    handles.data.label={};
else
    label=evalin('base',string_evaluation);
    handles.data.label=label;
end

if ~isempty(handles.data.label),
    if max(size(label))~=size(handles.data.data_matrix,1) || min(size(label))~=1,
        errordlg('Label must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu16='emptylabel';
        handles.data.label={};
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptylabel'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function labscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new1=[];
handles.data.label={};
set(hObject,'String',{'emptylabel'});

handles.data.WorkSpace=evalin('base','who');
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new1=[];
    for i=1:length(handles.data.WorkSpace),
        new1=[new1 handles.data.WorkSpace(i,:)];
    end
    new1=[contents,new1];
    set(hObject,'String',strvcat(new1));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptylabel'),
        val=i;
    end
end

set(hObject,'Value',val);
handles.data.new1=new1;
handles.data.namePopupmenu16='emptylabel';
guidata(hObject, handles);


% --- Executes on button press in resvarButton.
function resvarButton_Callback(hObject, eventdata, handles)
% hObject    handle to resvarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,2,handles.data.label_LP);

% --- Executes on button press in modelmedaButton.
function modelmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,2,handles.data.label_LP);

% --- Executes on selection change in clasvarPopup.
function clasvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to clasvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns clasvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clasvarPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new4{incoming_data};%Nombre correspondiente a la posici�n
handles.data.namePopupmenu19=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes_LP={};
    handles.data.classes_LP={};
else
    classes_LP=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.classes_LP=classes_LP;
end

if ~isempty(handles.data.classes_LP),
    if max(size(classes_LP))~=size(handles.data.data_matrix,2) || min(size(classes_LP))~=1,
        errordlg('Classes must have as many entries as number of variables in the data matrix.');
        handles.data.namePopupmenu19='emptyclasses';
        handles.data.classes_LP=[];
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptyclasses'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function clasvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clasvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new4=[];
handles.data.classes_LP=[];
set(hObject,'String',{'emptyclasses'});

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new4=[];
    for i=1:length(handles.data.WorkSpace),
        new4=[new4 handles.data.WorkSpace(i,:)];
    end
    new4=[contents,new4];
    set(hObject,'String',strvcat(new4));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptyclasses'),
        val=i;
    end
end
handles.data.namePopupmenu19='emptyclasses';
set(hObject,'Value',val);
handles.data.new4=new4;
guidata(hObject, handles);


% --- Executes on selection change in labvarPopup.
function labvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to labvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labvarPopup

incoming_data=get(hObject,'Value');
string_evaluation=handles.data.new3{incoming_data};
handles.data.namePopupmenu20=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label_LP={};
    handles.data.label_LP={};
else
    label_LP=evalin('base',string_evaluation);
    handles.data.label_LP=label_LP;
end

if ~isempty(handles.data.label_LP),
    if max(size(label_LP))~=size(handles.data.data_matrix,2) || min(size(label_LP))~=1,
        errordlg('Label must have as many tags as number of variables in the data matrix.');
        handles.data.namePopupmenu20='emptylabel';
        handles.data.label_LP={};
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptylabel'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function labvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new3=[];
handles.data.label_LP={};
set(hObject,'String',{'emptylabel'});

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new3=[];
    for i=1:length(handles.data.WorkSpace),
        new3=[new3 handles.data.WorkSpace(i,:)];
    end
    new3=[contents,new3];
    set(hObject,'String',strvcat(new3));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptylabel'),
        val=i;
    end
end
handles.data.namePopupmenu20='emptylabel';
set(hObject,'Value',val);
handles.data.new3=new3;
guidata(hObject, handles);


% --- Executes on button press in loadingButton.
function loadingButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PC1_LP=str2num(getCurrentPopupString(handles.xpcvarPopup));
handles.data.PC2_LP=str2num(getCurrentPopupString(handles.ypcvarPopup));

all_opened_graphs=get(0,'Children');
new_lp_ID_figures=[];
new_lp_matrix={};

for i=1:length(handles.data.lp_ID_figures),
    if ~isempty(find(handles.data.lp_ID_figures(i)==all_opened_graphs,1)),
        new_lp_ID_figures=[new_lp_ID_figures handles.data.lp_ID_figures(i)];
        new_lp_matrix={new_lp_matrix{:} handles.data.lp_matrix{:,i}};
    end
end

handles.data.lp_ID_figures=new_lp_ID_figures;%Identificadores de los Loadings Plots abiertos actualizado
handles.data.lp_matrix=new_lp_matrix;

if isempty(handles.data.label_LP) && isempty(handles.data.classes_LP),
    P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1);
else if ~isempty(handles.data.label_LP) && isempty(handles.data.classes_LP),
        P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, handles.data.label_LP);
    else if isempty(handles.data.label_LP) && ~isempty(handles.data.classes_LP),
            P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, [], handles.data.classes_LP);
        else P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, handles.data.label_LP, handles.data.classes_LP);
        end
    end
end
fig=gcf;
set(fig,'Tag','LoadingPlot');%A cada LoadingPlot que abro le pongo en su propiedad 'Tag' que es un LoadingPlot

matrixPCs_MEDA_LP=[P(:,handles.data.PC1_LP),P(:,handles.data.PC2_LP)];

handles.data.lp_ID_figures=[handles.data.lp_ID_figures fig];%Identificadores de los Score Plots abiertos
handles.data.lp_matrix={handles.data.lp_matrix{:} matrixPCs_MEDA_LP};

set(handles.selmedaButton,'Enable','on');

guidata(hObject,handles);

% --- Executes on selection change in ypcvarPopup.
function ypcvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ypcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ypcvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypcvarPopup
incoming_data_PC2_LP=get(hObject,'Value');%Incoming data position
handles.data.PC2_LP=incoming_data_PC2_LP;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ypcvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in xpcvarPopup.
function xpcvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to xpcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xpcvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpcvarPopup
incoming_data_PC1_LP=get(hObject,'Value');%Incoming data position
handles.data.PC1_LP=incoming_data_PC1_LP;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xpcvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in medaPopup.
function medaPopup_Callback(hObject, eventdata, handles)
% hObject    handle to medaPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns medaPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from medaPopup
PCs_MEDA_position=get(hObject,'Value');%Incoming data position
contents=get(hObject,'String');
PCs_MEDA=contents(PCs_MEDA_position,:);%Nombre correspondiente a la posición

handles.data.PCs_MEDA=PCs_MEDA;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function medaPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to medaPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in medaButton.
function medaButton_Callback(hObject, eventdata, handles)
% hObject    handle to medaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PCs_MEDA=getCurrentPopupString(handles.medaPopup);
PCs_MEDA_cell = strread(handles.data.PCs_MEDA,'%s','delimiter',':');
pcs = [str2num(PCs_MEDA_cell{1}):str2num(PCs_MEDA_cell{2})];
if get(handles.thresRadio,'Value')==1 && get(handles.serRadio,'Value')==0,
    handles.data.opt=2;
else if get(handles.thresRadio,'Value')==0 && get(handles.serRadio,'Value')==1,
        handles.data.opt=3;
    else if get(handles.serRadio,'Value')==0 && get(handles.serRadio,'Value')==0,
            handles.data.opt=1;
        else handles.data.opt=4;
        end
    end
end

[meda_map,meda_dis]=meda_pca(handles.data.data_matrix,pcs,handles.data.prep,handles.data.thres,handles.data.opt,handles.data.label_LP);

guidata(hObject,handles);

% --- Executes on button press in thresRadio.
function thresRadio_Callback(hObject, eventdata, handles)
% hObject    handle to thresRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thresRadio
if get(handles.thresRadio, 'Value'),
    set(handles.thresEdit, 'Enable', 'on');
    set(handles.text5, 'Enable', 'on');
else
    set(handles.thresEdit, 'Enable', 'off');
    set(handles.text5, 'Enable', 'off');
end

guidata(hObject,handles);


function thresEdit_Callback(hObject, eventdata, handles)
% hObject    handle to thresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresEdit as text
%        str2double(get(hObject,'String')) returns contents of thresEdit as a double
thres=str2double(get(hObject,'String'));
handles.data.thres = thres;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function thresEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', 0.1);
thresEdit_Callback(hObject, eventdata, handles);

% --- Executes on button press in selmedaButton.
function selmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa

check_tag=get(ID,'Tag');
if strcmp(check_tag,'LoadingPlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
else
    errordlg('To perform MEDA over a Loading Plot you must select one loading plot.');
    return;
end

% --- Executes on button press in serRadio.
function serRadio_Callback(hObject, eventdata, handles)
% hObject    handle to serRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serRadio


% --- Executes on button press in scoreButton.
function scoreButton_Callback(hObject, eventdata, handles)
% hObject    handle to scoreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PC1 = str2num(getCurrentPopupString(handles.xpcscorePopup));
handles.data.PC2 = str2num(getCurrentPopupString(handles.ypcscorePopup));

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

if isempty(handles.data.label) && isempty(handles.data.classes),
    [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1);
else if ~isempty(handles.data.label) && isempty(handles.data.classes),
        [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,handles.data.label);
    else if isempty(handles.data.label) && ~isempty(handles.data.classes),
            [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,[],handles.data.classes);
        else [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,handles.data.label,handles.data.classes);
        end
    end
end
fig=gcf;
set(fig,'Tag','ScorePlot');%En la opci�n etiqueta se indica que el gr�fico es un Score Plot

matrixPCs_oMEDA=[T(:,handles.data.PC1),T(:,handles.data.PC2)];

handles.data.sp_ID_figures=[handles.data.sp_ID_figures fig];%Vector con los identificadores de los Score Plots abiertos
handles.data.sp_matrix={handles.data.sp_matrix{:} matrixPCs_oMEDA};

%oMEDA (Select)
set(handles.selomedaButton,'Enable','on');

guidata(hObject,handles);

% --- Executes on selection change in ypcscorePopup.
function ypcscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to ypcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ypcscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypcscorePopup
incoming_data_PC2=get(hObject,'Value');%Incoming data position
handles.data.PC2=incoming_data_PC2;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ypcscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in xpcscorePopup.
function xpcscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to xpcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xpcscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpcscorePopup
incoming_data_PC1=get(hObject,'Value');%Incoming data position
handles.data.PC1=incoming_data_PC1;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xpcscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trendButton.
function trendButton_Callback(hObject, eventdata, handles)
% hObject    handle to trendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa

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

%Coordenadas del vector director de la recta que une ambos v�rtices:
u1=x2-x1;
u2=y2-y1;

%La ecuaci�n de la recta tendencia es:
A=u2;
B=-u1;
C=(u1*y1)-(u2*x1);

%Quiero el punto de corte de la tendencia con la recta que va de la observaci�n
%a la l�nea tendencia en perpendicular. Esto para cada una de las
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
    
    %La ecuacuaci�n de la recta es:
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

%Construcci�n de la nueva DUMMY con pesos:
%Calcular el punto medio entre las observaciones m�s cercanas obtenidas
%enteriormente, este ser� el nuevo cero para asignar pesos.
c1=Cutoff_points(ind1,:);
c2=Cutoff_points(ind2,:);
NewCenter=(c1+c2)/2;

%Asignaci�n de pesos
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

ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa

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
        set(coord,'marker','o');
        %set(coord,'markersize',6);
        set(coord,'markerfacecolor',[0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        
        handles.data.dummyGREEN(l)=1;
        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end

handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
set(handles.omedaButton,'Enable','on');
set(handles.trendButton,'Enable','on');
guidata(hObject,handles);

% --- Executes on button press in minusButton.
function minusButton_Callback(hObject, eventdata, handles)
% hObject    handle to minusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa

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
        %set(coord,'markersize',6);
        set(coord,'markerfacecolor', [0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        
        %Dummy:
        handles.data.dummyRED(l)=-1;

        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end

handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
set(handles.omedaButton,'Enable','on');
set(handles.trendButton,'Enable','on');
guidata(hObject,handles);

% --- Executes on button press in selomedaButton.
function selomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ID_list=get(0,'Children');
ID=ID_list(2);%Identificador de la gr�fica seleccionada (debe ser un Score Plot).

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Lanzar el Score Plot seleccionado para hacer oMEDA.
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

%Es necesario recuperar los datos del Score Plot seleccionado, es decir las observaciones ploteadas en el eje x e y:
%Voy a recorrer el vector de gcfs de score plots que se llama
%handles.data.sp_ID_figures, para buscar en que posici�n est� el gcf ID.
for i=1:length(handles.data.sp_ID_figures),
    if handles.data.sp_ID_figures(i)==ID,
        % codigo de compr de que est� vacio
%         ID
%         size(handles.data.sp_matrix)
        matrix_2PCs=handles.data.sp_matrix{:,i};
    end
end

irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Tama�o de la matriz:
%filas: n�mero de v�rtices del polinomio irregular
%columnas: contiene 2 columnas: coordenada x y coordenada y de cada v�rtice.

%PASO 1:
%Calcular los par�metros A, B y C de la ecuaci�n normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el n�mero de v�rtices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un v�rtice:
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente v�rtice:
    %El if controla el caso en que ya se hayan cogido todos los v�rtices,
    %el v�rtce en ese caso ser� el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos v�rtices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%C�lculo del par�metro C de la ec.normal de la recta.
    C=[C,c];%Lista del par�metro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(handles.data.data_matrix,1);%Number of observations in the score matrix.
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

handles.data.CORTES{1,ID}=CORTES;
handles.data.matrix_2PCs{1,ID}=matrix_2PCs;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;

guidata(hObject,handles);

% --- Executes on button press in omedaButton.
function omedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to omedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa

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

if ~isempty(handles.data.weightDummy{1,ID}),
    handles.data.weightDummy{1,ID}=handles.data.weightDummy{1,ID}./abs(max(handles.data.weightDummy{1,ID}));
    omeda_pca(handles.data.data_matrix,[min(handles.data.PC1,handles.data.PC2) max(handles.data.PC1,handles.data.PC2)],handles.data.data_matrix,handles.data.weightDummy{1,ID}',handles.data.prep,1,handles.data.label_LP);
else
    omeda_pca(handles.data.data_matrix,[min(handles.data.PC1,handles.data.PC2) max(handles.data.PC1,handles.data.PC2)],handles.data.data_matrix,handles.data.dummy{1,ID}',handles.data.prep,1,handles.data.label_LP);
end

guidata(hObject,handles);
