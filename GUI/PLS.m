function varargout = PLS(varargin)
%%
%GUI for Partial Least Squares (PLS) analysis
%
%This M-file include routines from the EDA Toolbox: 
%loading_pls.m, meda_pls.m, omeda_pls.m, scores_pls.m,
%sqresiduals_pls.m and var_pls.m
%
% coded by: Elena Jiménez Mañas (elenajm@correo.ugr.es).
%           Rafael Rodriguez Gomez (rodgom@ugr.es)
% version: 2.0
% last modification: 31/Jan/15.
%
% Copyright (C) 2014  Elena Jiménez Mañas
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% PLS M-file for PLS.fig
%      PLS, by itself, creates a new PLS or raises the existing
%      singleton*.
%
%      H = PLS returns the handle to a new PLS or the handle to
%      the existing singleton*.
%
%      PLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLS.M with the given input arguments.
%
%      PLS('Property','Value',...) creates a new PLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PLS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PLS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PLS

% Last Modified by GUIDE v2.5 04-Feb-2015 13:13:05
% Fixing some minor bugs on the GUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PLS_OpeningFcn, ...
    'gui_OutputFcn',  @PLS_OutputFcn, ...
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


% --- Executes just before PLS is made visible.
function PLS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PLS (see VARARGIN)

% Choose default command line output for PLS
handles.output = hObject;

%Definición del estado inicial de la interfaz gráfica PLS:

%Score plot
set(handles.text7,'Enable','off');
set(handles.text8,'Enable','off');
set(handles.xlvscorePopup,'Enable','off');
set(handles.ylvscorePopup,'Enable','off');
set(handles.text15,'Enable','off');
set(handles.text16,'Enable','off');
set(handles.labscorePopup,'Enable','off');
set(handles.classcorePopup,'Enable','off');
set(handles.scoreButton,'Enable','off');

%MEDA
set(handles.medaPopup,'Enable','off');
set(handles.medaPopup,'String',' ');
set(handles.text5,'Enable','off');
set(handles.thresEdit,'Enable','off');
set(handles.thresRadio,'Enable','off');
set(handles.serRadio,'Enable','off');
set(handles.medaButton,'Enable','off');
set(handles.selmedaButton,'Enable','off');

%oMEDA
set(handles.omedaButton,'Enable','off');
set(handles.selomedaButton,'Enable','off');
set(handles.minusButton,'Enable','off');
set(handles.plusButton,'Enable','off');
set(handles.cleanButton,'Enable','off');
set(handles.trendButton,'Enable','off');

%Loading plot
set(handles.text9,'Enable','off');
set(handles.text10,'Enable','off');
set(handles.xlvloadingPopup,'Enable','off');
set(handles.ylvloadingPopup,'Enable','off');
set(handles.text17,'Enable','off');
set(handles.text18,'Enable','off');
set(handles.clasloadingPopup,'Enable','off');
set(handles.labloadingPopup,'Enable','off');
set(handles.loadingButton,'Enable','off');

%Residue
set(handles.resomedaButton,'Enable','off');
set(handles.resmedaButton,'Enable','off');

%Model
set(handles.modelomedaButton,'Enable','off');
set(handles.modelmedaButton,'Enable','off');

%Summary Pannel:
handles.data.sumtext = [];

%Information Panel:
handles.data.messageNum=0;
handles.data.messageNum_max=10;
handles.data.text=[];
information_message(handles);

%Variables initialization
handles.data.LVs=[];
handles.data.LV1=[];
handles.data.LV2=[];
handles.data.weightDummy=cell(1,1000);
handles.data.dummy={};
handles.data.sp_ID_figures=[];
handles.data.sp_matrix={};
handles.data.clean_control=zeros(1,1000);
handles.data.lp_ID_figures=[];
handles.data.lp_matrix={};
handles.data.LV1_LP=[];
handles.data.LV2_LP=[];
handles.data.control_Refresh=0;
handles.data.CORTES={};
handles.data.matrix_2LVs={};
handles.data.LVs_MEDA='';
handles.data.auxLVs=0;

%Change icon
%warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%javaFrame = get(hObject,'JavaFrame');
%javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.jpg'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PLS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PLS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLS Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% Fuction to show the corresponding message in the information panel
function information_message(handles)
    switch handles.data.messageNum
        case 0
            text=sprintf('To begin the analysis:\nChoose (for x and y) the data matrix and select the preprocessing of the data from the corresponding popupmenus. If no data appears, please charge it from WorkSpace by clicking on REFRESH button.');
        case 1
            text=sprintf('Enter the number of latent variables in the general plots section and select between Var Y, Var Y + scores, Y-SVI Plot and Y-crossval.\nThen press the plot button.');
        case 2
            text=sprintf('Enter the number of latent variables to work with and press on the PCA button to perform the initial analysis and activate the Score Plot, Loading Plot and MEDA menus.');
        case 3
            text=sprintf('Plot a Score plot, a Loading plot, a MEDA plot or Residual/Model plot, by clicking on  the proper menu.');
        case 4
            text=sprintf('Label is a cell having this format:\n{`x`,`x`,`y`,`y`,...,`z`,`z`}, containing as many tags as the number of observations.');
        case 5
            text=sprintf('Classes is an array having this format:\n[1,1,2,2,...,3,3], containing as many entries as the number of observations.');
        case 6
            text=sprintf('To use label or classes, define the tags or class cell arrays and charge it from the workspace by clicking on the REFRESH button.');
        case 7
            text=sprintf('To perform an oMEDA plot push on the SELECT button in the oMEDA menu (upon selection of a Score Plot).');
        case 8
            text=sprintf('Over the selected Score Plot draw a polinomial enclosing the required points and push on the (+) button to assign them +1 or on the (-) button to assign them -1.');
        case 9
            text=sprintf('Optionally push on the Trend button and draw a line over the Score Plot to include weigths in the analysis.\nFinally push on the Plot button to obtain the oMEDA plot.');
        case 10
            text=sprintf('To perform a MEDA plot, push on the SELECT button in the MEDA menu (upon selection of a Loading Plot).\nOver the selected Loading Plot draw a polinomial enclosing the required points.');
        otherwise
            disp('No case detected')
    end
    handles.data.text=cprint(handles.inforText,text,handles.data.text,0);


% --- Executes on selection change in xdataPopup.
%xdataPopup==X Data
function xdataPopup_Callback(hObject, eventdata, handles)
% hObject    handle to xdataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xdataPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xdataPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.WorkSpace{incoming_data};%Nombre correspondiente a la posición
data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
handles.data.data_matrixX=data_matrix;
[M N]=size(data_matrix);
%Summary Panel:
sumtext = sprintf('Data Loaded:\n%s - > <%dx%d>\nMin %d\nMax %d',string_evaluation,M,N,min(min(data_matrix)),max(max(data_matrix)));
handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);

%Initialize dummy variable:
M=size(data_matrix,1);%Number of observations
dummy=zeros(1,M);
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

set(handles.labscorePopup,'Value',1);
handles.data.label={};
set(handles.classcorePopup,'Value',1);
handles.data.classes=[];
set(handles.labloadingPopup,'Value',1);
handles.data.label_LP={};
set(handles.clasloadingPopup,'Value',1);
handles.data.classes_LP=[];

handles.data.namePopupmenu6=string_evaluation;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function xdataPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xdataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.data.namePopupmenu6='';
handles.data.data_matrixX=[];
handles.data.WorkSpace=evalin('base','who');%nombres de las variables

if ~isempty(handles.data.WorkSpace),
    set(hObject,'String',handles.data.WorkSpace);
    string_evaluation=handles.data.WorkSpace{1};%Nombre correspondiente a la posición
    data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.data_matrixX=data_matrix;
    handles.data.namePopupmenu6=string_evaluation;
    %Initialize dummy variable:
    M=size(data_matrix,1);%Number of observations
    dummy=zeros(1,M);
    handles.data.dummyRED=dummy;
    handles.data.dummyGREEN=dummy;
else
    set(hObject,'String',' ');
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);

% --- Executes on selection change in ydataPopup.
%ydataPopup==Y Data
function ydataPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ydataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ydataPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ydataPopup
incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.WorkSpace{incoming_data};%Nombre correspondiente a la posición
data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
handles.data.data_matrixY=data_matrix;

%Summary Panel:
[M N]=size(data_matrix);
sumtext = sprintf('Data Loaded:\n%s - > <%dx%d>\nMin %d\nMax %d',string_evaluation,M,N,min(min(data_matrix)),max(max(data_matrix)));
handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);

%Change the selectPopup
cellPopup = cell(1,N);
for i=1:N
    cellPopup{i} = num2str(i);
end
set(handles.selectPopup,'String',cellPopup);

%Initialize dummy variable:
M=size(data_matrix,1);%Number of observations
dummy=zeros(1,M);
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

handles.data.namePopupmenu14=string_evaluation;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ydataPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ydataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.data.namePopupmenu14='';
handles.data.data_matrixY=[];
handles.data.WorkSpace=evalin('base','who');%nombres de las variables

if ~isempty(handles.data.WorkSpace),
    set(hObject,'String',handles.data.WorkSpace);
    string_evaluation=handles.data.WorkSpace{1};%Nombre correspondiente a la posición
    data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.data_matrixY=data_matrix;
    handles.data.namePopupmenu14=string_evaluation;
    %Initialize dummy variable:
    M=size(data_matrix,1);%Number of observations
    dummy=zeros(1,M);
    handles.data.dummyRED=dummy;
    handles.data.dummyGREEN=dummy;
    
else
    set(hObject,'String',' ');
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);

% --- Executes on button press in pushbutton1.
%pushbutton1==Refresh
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.WorkSpace=evalin('base','who');

if ~isempty(handles.data.WorkSpace),
    
    set(handles.xdataPopup, 'String', handles.data.WorkSpace);
    nombres=cellstr(get(handles.xdataPopup,'String'));
    if ~isempty(handles.data.namePopupmenu6),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu6),
                val=i;
            end
        end
        set(handles.xdataPopup,'Value',val);
        handles.data.data_matrixX=evalin('base',handles.data.WorkSpace{val});
    end
    
    set(handles.ydataPopup, 'String', handles.data.WorkSpace);
    nombres=cellstr(get(handles.ydataPopup,'String'));
    if ~isempty(handles.data.namePopupmenu14),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu14),
                val=i;
            end
        end
        set(handles.ydataPopup,'Value',val);
        handles.data.data_matrixY=evalin('base',handles.data.WorkSpace{val});
    end
    
    if handles.data.control_Refresh==0 && isempty(handles.data.data_matrixX) && isempty(handles.data.data_matrixY),
        string_evaluation=handles.data.WorkSpace{1};%Nombre correspondiente a la posición
        data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
        handles.data.data_matrixX=data_matrix;
        handles.data.namePopupmenu6=string_evaluation;
        
        string_evaluation=handles.data.WorkSpace{2};%Nombre correspondiente a la posición
        data_matrix=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
        handles.data.data_matrixY=data_matrix;
        handles.data.namePopupmenu14=string_evaluation;
    end
    
    %Refresh de los popupmenus Label y Classes:
    contents=get(handles.classcorePopup,'String');
    aux=[];
    for i=1:length(handles.data.WorkSpace),
        aux=[aux handles.data.WorkSpace(i,:)];
    end
    a1=contents(1,:);
    for j=1:length(a1),
        if ~isspace(a1(j)),
            b1(j)=a1(j);
        end
    end
    aux=[b1,aux];
    set(handles.classcorePopup,'String',strvcat(aux));
    nombres=cellstr(get(handles.classcorePopup,'String'));
    if ~strcmp(handles.data.namePopupmenu16,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu16),
                val=i;
            end
        end
        set(handles.classcorePopup,'Value',val);
        handles.data.classes=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.labscorePopup,'String');
    aux2=[];
    for i=1:length(handles.data.WorkSpace),
        aux2=[aux2 handles.data.WorkSpace(i,:)];
    end
    a2=contents(1,:);
    for j=1:length(a2),
        if ~isspace(a2(j)),
            b2(j)=a2(j);
        end
    end
    aux2=[b2,aux2];
    set(handles.labscorePopup,'String',strvcat(aux2));
    nombres=cellstr(get(handles.labscorePopup,'String'));
    if ~strcmp(handles.data.namePopupmenu17,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu17),
                val=i;
            end
        end
        set(handles.labscorePopup,'Value',val);
        handles.data.label=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.clasloadingPopup,'String');
    aux3=[];
    for i=1:length(handles.data.WorkSpace),
        aux3=[aux3 handles.data.WorkSpace(i,:)];
    end
    a3=contents(1,:);
    for j=1:length(a3),
        if ~isspace(a3(j)),
            b3(j)=a3(j);
        end
    end
    aux3=[b3,aux3];
    set(handles.clasloadingPopup,'String',strvcat(aux3));
    nombres=cellstr(get(handles.clasloadingPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu18,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu18),
                val=i;
            end
        end
        set(handles.clasloadingPopup,'Value',val);
        handles.data.classes_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.labloadingPopup,'String');
    aux4=[];
    for i=1:length(handles.data.WorkSpace),
        aux4=[aux4 handles.data.WorkSpace(i,:)];
    end
    a4=contents(1,:);
    for j=1:length(a4),
        if ~isspace(a4(j)),
            b4(j)=a4(j);
        end
    end
    aux4=[b4,aux4];
    set(handles.labloadingPopup,'String',strvcat(aux4));
    nombres=cellstr(get(handles.labloadingPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu19,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu19),
                val=i;
            end
        end
        set(handles.labloadingPopup,'Value',val);
        handles.data.label_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    handles.data.control_Refresh=1;
else
    set(handles.xdataPopup, 'String', ' ');
    handles.data.data_matrixX=[];
    set(handles.ydataPopup, 'String',' ');
    handles.data.data_matrixY=[];
    
    contents=get(handles.classcorePopup,'String');
    aux=[];
    aux=[contents(1,:),aux];
    
    contents=get(handles.labscorePopup,'String');
    aux2=[];
    aux2=[contents(1,:),aux2];
    
    contents=get(handles.clasloadingPopup,'String');
    aux3=[];
    aux3=[contents(1,:),aux3];
    
    contents=get(handles.labloadingPopup,'String');
    aux4=[];
    aux4=[contents(1,:),aux4];
    
    %Information panel:
    text=sprintf('Warning: No data matrices in workspace');
    handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);
end

handles.data.new1=aux2;%popupmenu17
handles.data.new2=aux;%popupmenu16
handles.data.new3=aux4;%popupmenu19
handles.data.new4=aux3;%popupmenu18
guidata(hObject,handles);

%edit text==LVs
function lvsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lvsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lvsEdit as text
%        str2double(get(hObject,'String')) returns contents of lvsEdit as a double
LVs=str2num(get(hObject,'String'));


handles.data.LVs = LVs;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function lvsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lvsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in generalButton.
%pushbutton==VAR
function generalButton_Callback(hObject, eventdata, handles)
% hObject    handle to generalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sizeMat = size(handles.data.data_matrixX);
[LVs_num,status]=str2num(get(handles.generalEdit, 'String'));
if status == false
    errordlg('Please enter a number of latent variables.');
    return;
elseif LVs_num > sizeMat(2) || LVs_num < 1
    errordlg(sprintf('The number of LVs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end

%Detect the selected general plot and plot it
generalPlot = getCurrentPopupString(handles.generalPopup);
switch generalPlot
    case 'Var Y'
        var_pls(handles.data.data_matrixX,handles.data.data_matrixY,LVs_num,handles.data.prepX,handles.data.prepY,1);
    case 'Var Y + scores'
        var_pls(handles.data.data_matrixX,handles.data.data_matrixY,LVs_num,handles.data.prepX,handles.data.prepY,2);
    case 'Y-SVI plot'
        chosenVar = str2num(getCurrentPopupString(handles.selectPopup));
        SVIplot([handles.data.data_matrixY handles.data.data_matrixX],LVs_num,1,7,handles.data.prepX);
    case 'Y-crossval'
        crossval_pls(handles.data.data_matrixX,handles.data.data_matrixY,0:LVs_num,Inf,handles.data.prepX,handles.data.prepY,1);
    otherwise
        disp('No case detected')
end

% --- Executes on selection change in xprepPopup.
%xprepPopup==X Prep
function xprepPopup_Callback(hObject, eventdata, handles)
% hObject    handle to xprepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xprepPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xprepPopup
nombres=cellstr(get(hObject,'String'));
val=nombres{get(hObject,'Value')};

switch val,
    case 'no preprocessing',
        prep=0;
        if handles.data.controlX==1,
            sumtext = sprintf('Preprocessing of X matrix:\nNo preprocessing.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
    case 'mean centering',
        prep=1;
        if handles.data.controlX==1,
            sumtext = sprintf('Preprocessing of X matrix:\nMean Centering.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
    case 'auto-scaling',
        prep=2;
        if handles.data.controlX==1,
            sumtext = sprintf('Preprocessing of X matrix:\nAuto-scaling.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
end

handles.data.prepX = prep;
handles.data.controlX=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xprepPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xprepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',strvcat('no preprocessing','mean centering','auto-scaling'));

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.data.controlX=0;
set(hObject, 'Value', 2);%Default value for the preprocessing method: mean-centering
xprepPopup_Callback(hObject, eventdata, handles)%Para llamar al valor por defecto

% --- Executes on selection change in yprepPopup.
%yprepPopup==Y Prep
function yprepPopup_Callback(hObject, eventdata, handles)
% hObject    handle to yprepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns yprepPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from yprepPopup
nombres=cellstr(get(hObject,'String'));
val=nombres{get(hObject,'Value')};

switch val,
    case 'no preprocessing',
        prep=0;
        if handles.data.controlY==1,
            sumtext = sprintf('Preprocessing of Y matrix:\nNo preprocessing.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
    case 'mean centering',
        prep=1;
        if handles.data.controlY==1,
            sumtext = sprintf('Preprocessing of Y matrix:\nMean Centering.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
    case 'auto-scaling',
        prep=2;
        if handles.data.controlY==1,
            sumtext = sprintf('Preprocessing of Y matrix:\nAuto-scaling.');
            handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);
        end
end

handles.data.prepY = prep;
handles.data.controlY=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function yprepPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yprepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',strvcat('no preprocessing','mean centering','auto-scaling'));

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.data.controlY=0;
set(hObject, 'Value', 2);%Default value for the preprocessing method: mean-centering
yprepPopup_Callback(hObject, eventdata, handles)%Para llamar al valor por defecto

% --- Executes on button press in plsButton.
%plsButton==PLS
function plsButton_Callback(hObject, eventdata, handles)
% hObject    handle to plsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Take the values of the GUI
[LVs_num,status]=str2num(get(handles.lvsEdit, 'String'));
sizeMat = size(handles.data.data_matrixX);
if status == false
    errordlg('No LVs defined, please define them properly.');
    return;
elseif LVs_num > sizeMat(2) || LVs_num < 1
    errordlg(sprintf('The number of LVs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end

%Information panel:
if isempty(handles.data.data_matrixX) || isempty(handles.data.data_matrixY),
    errordlg('No data matrix selected, please select one.');
    return;
end



handles.data.LVs = [1:LVs_num];
%Si la variable handles.data.LVs es distinta de vacía, imprimir en xlvscorePopup,
%xlvloadingPopup, ylvloadingPopup y ylvscorePopup las LVs posibles.
if ~isempty(handles.data.LVs),
    set(handles.xlvscorePopup, 'String',handles.data.LVs);
    set(handles.ylvscorePopup, 'String',handles.data.LVs);
    set(handles.xlvloadingPopup, 'String',handles.data.LVs);
    set(handles.ylvloadingPopup, 'String',handles.data.LVs);
    
    %Imprimir en popupmenu de submenu MEDA todas las combinaciones posibles
    %para hacer MEDA
    k=min(handles.data.LVs);
    options=[];
    for i=min(handles.data.LVs):max(handles.data.LVs),
        for j=k:LVs_num,
            options=[options,i,j];
        end
        k=k+1;
    end
    
    set(handles.medaPopup,'String','');
    for i=1:2:(length(options)-1),
        contents=get(handles.medaPopup,'String');
        set(handles.medaPopup,'String',strvcat(contents,sprintf('%d:%d',options(i),options(i+1))));
    end
end

if handles.data.auxLVs==0,
handles.data.LV1=min(handles.data.LVs);
handles.data.LV2=min(handles.data.LVs);
handles.data.LV1_LP=min(handles.data.LVs);
handles.data.LV2_LP=min(handles.data.LVs);
handles.data.LVs_MEDA=sprintf('%d:%d',min(handles.data.LVs),min(handles.data.LVs));
handles.data.auxLVs=1;
end

%Definición del estado de la interfaz tras pulsar PLS:
%Score plot
set(handles.xlvscorePopup,'Enable','on');
set(handles.ylvscorePopup,'Enable','on');
set(handles.scoreButton,'Enable','on');
set(handles.text7,'Enable','on');
set(handles.text8,'Enable','on');
set(handles.text15,'Enable','on');
set(handles.text16,'Enable','on');
set(handles.labscorePopup,'Enable','on');
set(handles.classcorePopup,'Enable','on');

%MEDA
set(handles.thresRadio,'Enable','on');
set(handles.serRadio,'Enable','on');
set(handles.medaButton,'Enable','on');
set(handles.medaPopup,'Enable','on');

%Loading plot
set(handles.text9,'Enable','on');
set(handles.text10,'Enable','on');
set(handles.xlvloadingPopup,'Enable','on');
set(handles.ylvloadingPopup,'Enable','on');
set(handles.text17,'Enable','on');
set(handles.text18,'Enable','on');
set(handles.clasloadingPopup,'Enable','on');
set(handles.labloadingPopup,'Enable','on');
set(handles.loadingButton,'Enable','on');

%Residue
set(handles.resomedaButton,'Enable','on');
set(handles.resmedaButton,'Enable','on');

%Model
set(handles.modelomedaButton,'Enable','on');
set(handles.modelmedaButton,'Enable','on');

%Information panel:
text=sprintf('Model generated successully!');
handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Score Plot Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in xlvscorePopup.
%xlvscorePopup==LV X-axes
function xlvscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to xlvscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xlvscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xlvscorePopup
incoming_data_LV1=get(hObject,'Value');%Incoming data position
handles.data.LV1=incoming_data_LV1;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function xlvscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlvscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in ylvscorePopup.
%ylvscorePopup==LV Y-axes
function ylvscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to ylvscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ylvscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ylvscorePopup
incoming_data_LV2=get(hObject,'Value');%Incoming data position
handles.data.LV2=incoming_data_LV2;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ylvscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylvscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in labscorePopup.
%labscorePopup==Label
function labscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to labscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labscorePopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new1{incoming_data};%Nombre correspondiente a la posición
handles.data.namePopupmenu17=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label={};
    handles.data.label={};
else
    label=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.label=label;
end

if ~isempty(handles.data.label),
    if max(size(label))~=size(handles.data.data_matrixX,1) || min(size(label))~=1,
        errordlg('Label must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu17='emptylabel';
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

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
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
handles.data.namePopupmenu17='emptylabel';
set(hObject,'Value',val);
handles.data.new1=new1;
guidata(hObject, handles);

% --- Executes on selection change in classcorePopup.
%classcorePopup==Classes
function classcorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to classcorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classcorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classcorePopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new2{incoming_data};%Nombre correspondiente a la posición
handles.data.namePopupmenu16=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes=[];
    handles.data.classes=[];
else
    classes=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.classes=classes;
end

if ~isempty(handles.data.classes),
    if max(size(classes))~=size(handles.data.data_matrixX,1) || min(size(classes))~=1,
        errordlg('Classes must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu16='emptyclasses';
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

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
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
handles.data.namePopupmenu16='emptyclasses';
set(hObject,'Value',val);
handles.data.new2=new2;
guidata(hObject, handles);

% --- Executes on button press in scoreButton.
%Pushbutton==Plot
function scoreButton_Callback(hObject, eventdata, handles)
% hObject    handle to scoreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if isempty(handles.data.LV1) || isempty(handles.data.LV2),
%    errordlg('Error: select the combination of LVs to plot the scores.');
%end
LV1=str2num(getCurrentPopupString(handles.xlvscorePopup));
LV2=str2num(getCurrentPopupString(handles.ylvscorePopup));

all_opened_graphs=get(0,'Children');
new_sp_ID_figures=[];
new_sp_matrix={};
clean_ind=[];
for i=1:length(handles.data.sp_ID_figures),
    if ~isempty(find(handles.data.sp_ID_figures(i)==all_opened_graphs,1)),
        new_sp_ID_figures=[new_sp_ID_figures handles.data.sp_ID_figures(i)];
        new_sp_matrix={new_sp_matrix{:} handles.data.sp_matrix{:,i}};
    else
        clean_ind=[clean_ind i];%Me da los IDs de las cerradas
        for j=1:length(clean_ind),
            aux=clean_ind(j);
            handles.data.clean_control(aux)=0;
            handles.data.CORTES{1,aux}=[];
            handles.data.weightDummy{1,aux}=[];
            handles.data.matrix_2LVs{1,aux}=[];
            %Dummy:
            M=size(handles.data.data_matrixX,1);%Number of observations
            dummy=zeros(1,M);
            handles.data.dummy{1,aux}=dummy;
            handles.data.dummyRED=dummy;
            handles.data.dummyGREEN=dummy;
        end
    end
end

handles.data.sp_ID_figures=new_sp_ID_figures;%Identificadores de los Score Plots abiertos actualizado
handles.data.sp_matrix=new_sp_matrix;

if isempty(handles.data.label) && isempty(handles.data.classes),
    [T,TT]=scores_pls(handles.data.data_matrixX,handles.data.data_matrixY,[LV1 LV2],[],handles.data.prepX,handles.data.prepY,1);
else if ~isempty(handles.data.label) && isempty(handles.data.classes),
        [T,TT]=scores_pls(handles.data.data_matrixX,handles.data.data_matrixY,[LV1 LV2],[],handles.data.prepX,handles.data.prepY,1,handles.data.label);
    else if isempty(handles.data.label) && ~isempty(handles.data.classes),
            [T,TT]=scores_pls(handles.data.data_matrixX,handles.data.data_matrixY,[LV1 LV2],[],handles.data.prepX,handles.data.prepY,1,[],handles.data.classes);
        else [T,TT]=scores_pls(handles.data.data_matrixX,handles.data.data_matrixY,[LV1 LV2],[],handles.data.prepX,handles.data.prepY,1,handles.data.label,handles.data.classes);
        end
    end
end
fig=gcf;
set(fig,'Tag','ScorePlot');%A cada ScorePlot que abro le pongo en su propiedad 'Tag' que es un ScorePlot

matrixLVs_oMEDA=[T(:,LV1),T(:,LV2)];

handles.data.sp_ID_figures=[handles.data.sp_ID_figures fig];%Identificadores de los Score Plots abiertos
handles.data.sp_matrix={handles.data.sp_matrix{:} matrixLVs_oMEDA};

%oMEDA (Select)
set(handles.selomedaButton,'Enable','on');

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%oMEDA Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in selomedaButton.
%selomedaButton==SELECT
function selomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selomedaButton (see GCBO)
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
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

%Ahora vamos a recuperar su matriz:
%Voy a recorrer el vector de gcfs de score plots
%handles.data.sp_ID_figures, para buscar en que posición esta el gcf ID.
for i=1:length(handles.data.sp_ID_figures),
    if handles.data.sp_ID_figures(i)==ID,
        matrix_2LVs=handles.data.sp_matrix{:,i};
    end
end

irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Tamaño de la matriz:
%filas: número de vértices del polinomio irregular
%columnas: contiene 2 columnas: coordenada x y coordenada y de cada
%vértice.

%PASO 1:
%Calcular los parámetros A, B y C de la ecuación normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el número de vértices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un vértice
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente vértice:
    %El if controla el caso en que ya se hayan cogido todos los vértices,
    %el vértce en ese caso será el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos vértices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%Cálculo del parámetro C de la ec.normal de la recta.
    C=[C,c];%Lista del parámetro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(handles.data.data_matrixX,1);%Number of observations in the score matrix.
X=[];
corte=0;
CORTES=[];

for j=1:M, %Se recorren todas las observaciones
    Y=matrix_2LVs(j,2);
    corte=0;
    for k=1:N,%Todas las rectas del poligono irregular
        X=(-(B(k)*Y)-C(k))/A(k);
        
        if k+1>N,
            if (Y>min(vertex(k,2),vertex(1,2)))&&(Y<max(vertex(k,2),vertex(1,2))),
                if X>matrix_2LVs(j,1),
                    corte=corte+1;
                end
            end
        else
            if (Y>min(vertex(k,2),vertex(k+1,2)))&&(Y<max(vertex(k,2),vertex(k+1,2))),
                if X>matrix_2LVs(j,1),
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
handles.data.matrix_2LVs{1,ID}=matrix_2LVs;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;

guidata(hObject,handles);

% --- Executes on button press in minusButton.
%minusButton==- -> RED
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

M=size(handles.data.data_matrixX,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2LVs=handles.data.matrix_2LVs{1,ID};

for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2LVs(l,1);
        Ydata=matrix_2LVs(l,2);
        
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

% --- Executes on button press in plusButton.
%plusButton==+ -> GREEN
function plusButton_Callback(hObject, eventdata, handles)
% hObject    handle to plusButton (see GCBO)
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

M=size(handles.data.data_matrixX,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2LVs=handles.data.matrix_2LVs{1,ID};

for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2LVs(l,1);
        Ydata=matrix_2LVs(l,2);
        
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


% --- Executes on button press in trendButton.
%trendButton==TREND LINE
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

matrix_2LVs=handles.data.matrix_2LVs{1,ID};
trend_line=imline;
setColor(trend_line,[0 0 0]);
vertex_line=getPosition(trend_line);

x1=vertex_line(1,1);
y1=vertex_line(1,2);
x2=vertex_line(2,1);
y2=vertex_line(2,2);

%Coordenadas del vector director de la recta que une ambos vértices:
u1=x2-x1;
u2=y2-y1;

%La ecuación de la recta tendencia es:
A=u2;
B=-u1;
C=(u1*y1)-(u2*x1);

%Quiero el punto de corte de la tendencia con la recta que va de la observación
%a la línea tendencia en perpendicular. Esto para cada una de las
%observaciones.
Cutoff_points=[];
M=size(handles.data.data_matrixX,1);
for m=1:M,
    p1=matrix_2LVs(m,1);
    p2=matrix_2LVs(m,2);
    
    %El vector director de la recta que va de la observacion a la
    %tendencia en perpendicular es:
    v1=A;
    v2=B;
    
    %La ecuacuación de la recta es:
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

%Construcción de la nueva DUMMY con pesos:
%Calcular el punto medio entre las observaciones más alejadas obtenidas
%enteriormente, este será el nuevo cero para asignar pesos.
c1=Cutoff_points(ind1,:);
c2=Cutoff_points(ind2,:);
NewCenter=(c1+c2)/2;

%Asignación de pesos
for m=1:M,
    weights(m)=sum((Cutoff_points(m,:)-NewCenter).^2);
end
weightDummy=weights.*dummy;

handles.data.weightDummy{1,ID}= weightDummy;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
guidata(hObject,handles);

% --- Executes on button press in cleanButton.
%cleanButton==CLEAN
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
M=size(handles.data.data_matrixX,1);%Number of observations
dummy=zeros(1,M);
handles.data.dummy{1,ID}=dummy;
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

guidata(hObject,handles);

% --- Executes on button press in omedaButton.
%omedaButton==Plot (oMEDA)
function omedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to omedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

LV1=str2num(getCurrentPopupString(handles.xlvscorePopup));
LV2=str2num(getCurrentPopupString(handles.ylvscorePopup));

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
    omeda_pls(handles.data.data_matrixX,handles.data.data_matrixY,[min(LV1,LV2) max(LV1,LV2)],handles.data.data_matrixX,handles.data.weightDummy{1,ID}',handles.data.prepX,handles.data.prepY,1,handles.data.label_LP);
else
    omeda_pls(handles.data.data_matrixX,handles.data.data_matrixY,[min(LV1,LV2) max(LV1,LV2)],handles.data.data_matrixX,handles.data.dummy{1,ID}',handles.data.prepX,handles.data.prepY,1,handles.data.label_LP);
end

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Residue%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in resomedaButton.
%resomedaButton==Plot(residue)
function resomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to resomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pls(handles.data.data_matrixX,handles.data.data_matrixY,min(handles.data.LVs):max(handles.data.LVs),[],handles.data.prepX,handles.data.prepY,1,handles.data.label);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Loading Plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in xlvloadingPopup.
%xlvloadingPopup==LVs X-axes
function xlvloadingPopup_Callback(hObject, eventdata, handles)
% hObject    handle to xlvloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xlvloadingPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xlvloadingPopup
incoming_data_LV1_LP=get(hObject,'Value');%Incoming data position
handles.data.LV1_LP=incoming_data_LV1_LP;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xlvloadingPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlvloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in ylvloadingPopup.
%ylvloadingPopup==LVs Y-axes
function ylvloadingPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ylvloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ylvloadingPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ylvloadingPopup
incoming_data_LV2_LP=get(hObject,'Value');%Incoming data position
handles.data.LV2_LP=incoming_data_LV2_LP;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ylvloadingPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylvloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in labloadingPopup.
%labloadingPopup==Label
function labloadingPopup_Callback(hObject, eventdata, handles)
% hObject    handle to labloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labloadingPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labloadingPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new3{incoming_data};%Nombre correspondiente a la posición
handles.data.namePopupmenu19=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label_LP={};
    handles.data.label_LP={};
else
    label_LP=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.label_LP=label_LP;
end

if ~isempty(handles.data.label_LP),
    if max(size(label_LP))~=size(handles.data.data_matrixX,2) || min(size(label_LP))~=1,
        errordlg('Label must have as many tags as number of variables in the data matrix.');
        handles.data.namePopupmenu19='emptylabel';
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
function labloadingPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labloadingPopup (see GCBO)
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
handles.data.namePopupmenu19='emptylabel';
set(hObject,'Value',val);
handles.data.new3=new3;
guidata(hObject, handles);


% --- Executes on selection change in clasloadingPopup.
%clasloadingPopup==Classes
function clasloadingPopup_Callback(hObject, eventdata, handles)
% hObject    handle to clasloadingPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns clasloadingPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clasloadingPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new4{incoming_data};%Nombre correspondiente a la posición
handles.data.namePopupmenu18=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes_LP={};
    handles.data.classes_LP={};
else
    classes_LP=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.classes_LP=classes_LP;
end

if ~isempty(handles.data.classes_LP),
    if max(size(classes_LP))~=size(handles.data.data_matrixX,2) || min(size(classes_LP))~=1,
        errordlg('Classes must have as many entries as number of variables in the data matrix.');
        handles.data.namePopupmenu18='emptyclasses';
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
function clasloadingPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clasloadingPopup (see GCBO)
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
handles.data.namePopupmenu18='emptyclasses';
set(hObject,'Value',val);
handles.data.new4=new4;
guidata(hObject, handles);

% --- Executes on button press in loadingButton.
%loadingButton==Plot (loading plot)
function loadingButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if isempty(handles.data.LV1_LP) || isempty(handles.data.LV2_LP),
%    errordlg('Error: select the combination of LVs to plot the loadings.');
%end

LV1_LP=str2num(getCurrentPopupString(handles.xlvloadingPopup));
LV2_LP=str2num(getCurrentPopupString(handles.ylvloadingPopup));

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
    P = loadings_pls (handles.data.data_matrixX, handles.data.data_matrixY, [LV1_LP LV2_LP], handles.data.prepX, handles.data.prepY, 1);
else if ~isempty(handles.data.label_LP) && isempty(handles.data.classes_LP),
        P = loadings_pls (handles.data.data_matrixX, handles.data.data_matrixY, [LV1_LP LV2_LP], handles.data.prepX, handles.data.prepY, 1, handles.data.label_LP);
    else if isempty(handles.data.label_LP) && ~isempty(handles.data.classes_LP),
            P = loadings_pls (handles.data.data_matrixX, handles.data.data_matrixY, [LV1_LP LV2_LP], handles.data.prepX, handles.data.prepY, 1, [], handles.data.classes_LP);
        else         P = loadings_pls (handles.data.data_matrixX, handles.data.data_matrixY, [LV1_LP LV2_LP], handles.data.prepX, handles.data.prepY, 1, handles.data.label_LP, handles.data.classes_LP);
        end
    end
end
fig=gcf;
set(fig,'Tag','LoadingPlot');%A cada LoadingPlot que abro le pongo en su propiedad 'Tag' que es un LoadingPlot

matrixLVs_MEDA_LP=[P(:,LV1_LP),P(:,LV2_LP)];

handles.data.lp_ID_figures=[handles.data.lp_ID_figures fig];%Identificadores de los Score Plots abiertos
handles.data.lp_matrix={handles.data.lp_matrix{:} matrixLVs_MEDA_LP};

set(handles.selmedaButton,'Enable','on');

text=sprintf('To perform a MEDA plot, push on the SELECT button in the MEDA menu (upon selection of Loading Plot).');

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MEDA Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%thresEdit==thresold
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

% --- Executes on button press in thresRadio.
%thresRadio==thresold
function thresRadio_Callback(hObject, eventdata, handles)
% hObject    handle to thresRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of thresRadio
%Si radio button señalado q ecit 6 este ON si no señalado q este OFF
if get(handles.thresRadio, 'Value'),
    set(handles.thresEdit, 'Enable', 'on');
    set(handles.text5, 'Enable', 'on');
else
    set(handles.thresEdit, 'Enable', 'off');
    set(handles.text5, 'Enable', 'off');
end

guidata(hObject,handles);


% --- Executes on button press in serRadio.
%serRadio==seriation
function serRadio_Callback(hObject, eventdata, handles)
% hObject    handle to serRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serRadio


% --- Executes on selection change in medaPopup.
%medaPopup==MEDA popupmenu
function medaPopup_Callback(hObject, eventdata, handles)
% hObject    handle to medaPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns medaPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from medaPopup

LVs_MEDA_position=get(hObject,'Value');%Incoming data position
contents=get(hObject,'String');%Incoming data position
LVs_MEDA=contents(LVs_MEDA_position,:);%Nombre correspondiente a la posición

handles.data.LVs_MEDA=LVs_MEDA;

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
%medaButton==Plot (MEDA)
function medaButton_Callback(hObject, eventdata, handles)
% hObject    handle to medaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LVs_MEDA = getCurrentPopupString(handles.medaPopup);
%split LVsMEDA
LVs_MEDA_cell = strread(LVs_MEDA,'%s','delimiter',':');
lvs = [str2num(LVs_MEDA_cell{1}):str2num(LVs_MEDA_cell{2})];
%if isempty(handles.data.LVs_MEDA),
%    errordlg('To perform MEDA select the LVs from the popupmenu.');
%    return;
%end

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

[meda_map,meda_dis]=meda_pls(handles.data.data_matrixX,handles.data.data_matrixY,lvs,handles.data.prepX,handles.data.prepY,handles.data.thres,handles.data.opt,handles.data.label_LP);
guidata(hObject,handles);

% --- Executes on button press in selmedaButton.
%selmedaButton==Select (MEDA)
function selmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'LoadingPlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
else
    errordlg('To perform MEDA over a Loading Plot you must select one loading plot.');
end

%Ahora vamos a recuperar su matriz:
%Voy a recorrer el vector de gcfs de score plots
%handles.data.sp_ID_figures, para buscar en que posición esta el gcf ID.
for i=1:length(handles.data.lp_ID_figures),
    if handles.data.lp_ID_figures(i)==ID,
        matrix_2LVs=handles.data.lp_matrix{:,i};
    end
end

irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Matrix size:
%rows: number of vertex in the irregular polynomial
%columns: this matrix contains always 2 colomns: one for the X
%coordinate and the other one for the Y coordinate of each
%vertex.

%PASO 1:
%Calcular los parámetros A, B y C de la ecuación normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el número de vértices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un vértice
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente vértice:
    %El if controla el caso en que ya se hayan cogido todos los vértices,
    %el vértce en ese caso será el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos vértices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%Cálculo del parámetro C de la ec.normal de la recta.
    C=[C,c];%Lista del parámetro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(handles.data.data_matrixX,2);%Number of variables.
X=[];
corte=0;
CORTES=[];

for j=1:M, %All the observations from the Score Matrix: t
    Y=matrix_2LVs(j,2);
    corte=0;
    for k=1:N,%Todas las rectas del poligono irregular
        X=(-(B(k)*Y)-C(k))/A(k);
        
        if k+1>N,
            if (Y>min(vertex(k,2),vertex(1,2)))&&(Y<max(vertex(k,2),vertex(1,2))),
                if X>matrix_2LVs(j,1),
                    corte=corte+1;
                end
            end
        else
            if (Y>min(vertex(k,2),vertex(k+1,2)))&&(Y<max(vertex(k,2),vertex(k+1,2))),
                if X>matrix_2LVs(j,1),
                    corte=corte+1;
                end
            end
        end
    end
    CORTES=[CORTES,corte];
end

CortesVector=CORTES;
vector_vars=[];
for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2LVs(l,1);
        Ydata=matrix_2LVs(l,2);
        
        coord=plot(Xdata,Ydata);
        set(coord,'marker','o');
        set(coord,'markersize',6);
        set(coord,'markerfacecolor','b');
        set(coord,'markeredgecolor','b');
        
        vector_vars=[vector_vars l];
    end
end

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

[meda_map,meda_dis]=meda_pls(handles.data.data_matrixX,handles.data.data_matrixY,[min(handles.data.LV1_LP,handles.data.LV2_LP) max(handles.data.LV1_LP,handles.data.LV2_LP)],handles.data.prepX,handles.data.prepY,handles.data.thres,handles.data.opt,handles.data.label_LP,vector_vars);

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Residue%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in resmedaButton.
%resmedaButton==Plot (residue)
function resmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to resmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pls(handles.data.data_matrixX,handles.data.data_matrixY,min(handles.data.LVs):max(handles.data.LVs),[],handles.data.prepX,handles.data.prepY,2,handles.data.label_LP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Information panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inforText==Static text-Information panel
% --- Executes during object creation, after setting all properties.
function inforText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inforText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in modelmedaButton.
function modelmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pls(handles.data.data_matrixX,handles.data.data_matrixY,min(handles.data.LVs):max(handles.data.LVs),[],handles.data.prepX,handles.data.prepY,2,handles.data.label_LP);

% --- Executes on button press in modelomedaButton.
function modelomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pls(handles.data.data_matrixX,handles.data.data_matrixY,min(handles.data.LVs):max(handles.data.LVs),[],handles.data.prepX,handles.data.prepY,1,handles.data.label);
% --- Executes on selection change in generalPopup.
function generalPopup_Callback(hObject, eventdata, handles)
% hObject    handle to generalPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns generalPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from generalPopup
generalSelection = getCurrentPopupString(hObject);

switch generalSelection
    case 'Y-SVI plot'
        set(handles.selectText,'Enable','on');
        set(handles.selectPopup,'Enable','on');
    otherwise
        set(handles.selectText,'Enable','off');
        set(handles.selectPopup,'Enable','off');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function generalPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generalPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function generalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to generalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of generalEdit as text
%        str2double(get(hObject,'String')) returns contents of generalEdit as a double


% --- Executes during object creation, after setting all properties.
function generalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prevButton.
function prevButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.messageNum > 0
    handles.data.messageNum = handles.data.messageNum -1;
    information_message(handles);
end
guidata(hObject,handles);

% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.messageNum < handles.data.messageNum_max
    handles.data.messageNum = handles.data.messageNum +1;
    information_message(handles);
end
guidata(hObject,handles);



function selectEdit_Callback(hObject, eventdata, handles)
% hObject    handle to selectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selectEdit as text
%        str2double(get(hObject,'String')) returns contents of selectEdit as a double


% --- Executes during object creation, after setting all properties.
function selectEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function selectPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectPopup.
function selectPopup_Callback(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectPopup


% --- Executes during object creation, after setting all properties.
function popupmenu31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
