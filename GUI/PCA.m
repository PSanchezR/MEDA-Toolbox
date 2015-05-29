function varargout = PCA(varargin)

%%
%GUI for Principal Components Analysis (PCA) analysis
%
%This M-file include routines from the EDA Toolbox: 
%loading_pca.m, meda_pca.m, omeda_pca.m, pca_pp.m, scores_pca.m,
%sqresiduals_pca.m and var_pca.m
%
% coded by: Elena Jim√©nez Ma√±as (elenajm@correo.ugr.es).
%           Rafael Rodriguez Gomez (rodgom@ugr.es)
% version: 2.0
% last modification: 31/Jan/15.
%
% Copyright (C) 2014  Elena Jim√©nez Ma√±as
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

% PCA M-file for PCA.fig
%      PCA, by itself, creates a new PCA or raises the existing
%      singleton*.
%
%      H = PCA returns the handle to a new PCA or the handle to
%      the existing singleton*.
%
%      PCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCA.M with the given input arguments.
%
%      PCA('Property','Value',...) creates a new PCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PCA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PCA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PCA

% Last Modified by GUIDE v2.5 29-May-2015 12:35:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PCA_OpeningFcn, ...
    'gui_OutputFcn',  @PCA_OutputFcn, ...
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


% --- Executes just before PCA is made visible.
function PCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PCA (see VARARGIN)

% Choose default command line output for PCA
handles.output = hObject;

%DefiniciÔøΩn del estado inicial de la interfaz grÔøΩfica PCA:

% %Score plot
% set(handles.text7,'Enable','off');
% set(handles.text8,'Enable','off');
% set(handles.xpcscorePopup,'Enable','off');
% set(handles.ypcscorePopup,'Enable','off');
% set(handles.text13,'Enable','off');
% set(handles.text14,'Enable','off');
% set(handles.classcorePopup,'Enable','off');
% set(handles.scoreButton,'Enable','off');
% 
% %MEDA
% set(handles.medaPopup,'Enable','off');
% set(handles.medaPopup,'String',' ');
% set(handles.text5,'Enable','off');
% set(handles.thresEdit,'Enable','off');
% set(handles.thresRadio,'Enable','off');
% set(handles.serRadio,'Enable','off');
% set(handles.medaButton,'Enable','off');
% set(handles.selmedaButton,'Enable','off');
% 
% %oMEDA
% set(handles.omedaButton,'Enable','off');
% set(handles.selomedaButton,'Enable','off');
% set(handles.minusButton,'Enable','off');
% set(handles.plusButton,'Enable','off');
% set(handles.cleanButton,'Enable','off');
% set(handles.trendButton,'Enable','off');
% 
% %Loading plot
% set(handles.text9,'Enable','off');
% set(handles.text10,'Enable','off');
% set(handles.xpcvarPopup,'Enable','off');
% set(handles.ypcvarPopup,'Enable','off');
% set(handles.text17,'Enable','off');
% set(handles.text18,'Enable','off');
% set(handles.clasvarPopup,'Enable','off');
% set(handles.labvarPopup,'Enable','off');
% set(handles.medaButton,'Enable','off');
% set(handles.loadingButton,'Enable','off');
% 
% %Residue
% set(handles.resomedaButton,'Enable','off');
% set(handles.resvarButton,'Enable','off');
% 
% %Model
% set(handles.modelomedaButton,'Enable','off');
% set(handles.modelmedaButton,'Enable','off');

%Summary Panel:
handles.data.sumtext = [];

%Information Panel:
handles.data.messageNum=0;
handles.data.messageNum_max=10;
handles.data.text=[];
information_message(handles);

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
handles.data.visualizationPopup = {};
handles.data.visualizationPopupStruct = {};

%Change icon
%warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%javaFrame = get(hObject,'JavaFrame');
%javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.jpg'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PCA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PCA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PCA Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% --- Executes on selection change in dataPopup.
%dataPopup==Data
function dataPopup_Callback(hObject, eventdata, handles)
% hObject    handle to dataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.WorkSpace{incoming_data};%Name of the incoming data position
data_matrix=evalin('base',string_evaluation);%Data content in that name
handles.data.data_matrix=data_matrix;

%Summary Panel
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

% set(handles.labscorePopup,'Value',1);
handles.data.label={};
% set(handles.classcorePopup,'Value',1);
handles.data.classes=[];
% set(handles.labvarPopup,'Value',1);
handles.data.label_LP={};
% set(handles.clasvarPopup,'Value',1);
handles.data.classes_LP=[];

handles.data.namePopupmenu6=string_evaluation;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dataPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.data.namePopupmenu6='';
handles.data.data_matrix=[];
handles.data.WorkSpace=evalin('base','who');%name of the variables in the workspace

if ~isempty(handles.data.WorkSpace),
    set(hObject,'String',handles.data.WorkSpace);
    string_evaluation=handles.data.WorkSpace{1};%Name of the incoming data position
    data_matrix=evalin('base',string_evaluation);%Data content in that name
    handles.data.data_matrix=data_matrix;
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


% --- Executes on button press in pushbutton1.
%pushbutton1==Refresh
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.WorkSpace=evalin('base','who');

if ~isempty(handles.data.WorkSpace),
    
    set(handles.dataPopup, 'String', handles.data.WorkSpace);
    nombres=cellstr(get(handles.dataPopup,'String'));
    if ~isempty(handles.data.namePopupmenu6),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu6),
                val=i;
            end
        end
        set(handles.dataPopup,'Value',val);
        handles.data.data_matrix=evalin('base',handles.data.WorkSpace{val});
    end
    %Para que la primera vez que se pulse Refresh con el workspace distinto
    %de vacio coja la primera matriz automaticamente
    if handles.data.control_Refresh==0 && isempty(handles.data.data_matrix),
        string_evaluation=handles.data.WorkSpace{1};
        data_matrix=evalin('base',string_evaluation);
        handles.data.data_matrix=data_matrix;
        handles.data.namePopupmenu6=string_evaluation;
    end
    
    %Refresh the Label and Classes popupmenus:
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
    if ~strcmp(handles.data.namePopupmenu15,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu15),
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
    if ~strcmp(handles.data.namePopupmenu16,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu16),
                val=i;
            end
        end
        set(handles.labscorePopup,'Value',val);
        handles.data.label=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    
    contents=get(handles.clasvarPopup,'String');
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
    set(handles.clasvarPopup,'String',strvcat(aux3));
    nombres=cellstr(get(handles.clasvarPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu19,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu19),
                val=i;
            end
        end
        set(handles.clasvarPopup,'Value',val);
        handles.data.classes_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.labvarPopup,'String');
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
    set(handles.labvarPopup,'String',strvcat(aux4));
    nombres=cellstr(get(handles.labvarPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu20,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu20),
                val=i;
            end
        end
        set(handles.labvarPopup,'Value',val);
        handles.data.label_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    handles.data.control_Refresh=1;
else
    set(handles.dataPopup, 'String', ' ');
    handles.data.data_matrix=[];
    
    contents=get(handles.classcorePopup,'String');
    aux=[];
    aux=[contents(1,:),aux];
    
    contents=get(handles.labscorePopup,'String');
    aux2=[];
    aux2=[contents(1,:),aux2];
    
    contents=get(handles.clasvarPopup,'String');
    aux3=[];
    aux3=[contents(1,:),aux3];
    
    contents=get(handles.labvarPopup,'String');
    aux4=[];
    aux4=[contents(1,:),aux4];
    
    %TODO substitute by error dialog
    %Information panel:
    text=sprintf('Warning: No data matrices in workspace.');
    handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);
end

handles.data.new2=aux;
handles.data.new1=aux2;
handles.data.new4=aux3;
handles.data.new3=aux4;
guidata(hObject,handles);

%edit text==PCs
function pcEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pcEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcEdit as text
%        str2double(get(hObject,'String')) returns contents of pcEdit as a double
PCs=str2num(get(hObject,'String'));

handles.data.PCs = PCs;

guidata(hObject,handles);

% Fuction to show the corresponding message in the information panel
function information_message(handles)
    switch handles.data.messageNum
        case 0
            text=sprintf('To begin the analysis:\nChoose a data matrix and select the preprocessing of the data from the corresponding popupmenus. If no data appears, please charge it from WorkSpace by clicking on REFRESH button.');
        case 1
            text=sprintf('Enter the number of principal components in the general plots section and select between Var X, Var X + ckf, SVI plot, ekf crossval and cekf crossval. If SVI plot is selected a PC should be additionally chosen.\nThen press the plot button.');
        case 2
            text=sprintf('Enter the number of principal components to work with and press on the PCA button to perform the initial analysis and activate the Score Plot, Loading Plot and MEDA menus.');
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
    handles.data.text=cprint(handles.infoText,text,handles.data.text,0);


% --- Executes during object creation, after setting all properties.
function pcEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcEdit (see GCBO)
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

[pc_num,status]=str2num(get(handles.generalEdit, 'String'));
sizeMat = size(handles.data.data_matrix);
if status == false
    errordlg('Please enter a number of PCs.');
    return;
elseif pc_num > sizeMat(2) || pc_num < 1
    errordlg(sprintf('The number of PCs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end

%Detect the selected general plot and plot it
generalPlot = getCurrentPopupString(handles.generalPopup);
switch generalPlot
    case 'Var X'
        x_var = var_pca(handles.data.data_matrix,pc_num,handles.data.prep,1);
    case 'Var X + ckf'
        x_var = var_pca(handles.data.data_matrix,pc_num,handles.data.prep,2);
    case 'ekf crossval '
        x_var = crossval_pca(handles.data.data_matrix,0:pc_num,'ekf',Inf,Inf,handles.data.prep);
    case 'cekf crossval'
        x_var = crossval_pca(handles.data.data_matrix,0:pc_num,'cekf',Inf,Inf,handles.data.prep);
    case 'SVI plot'
        chosenVar = str2num(getCurrentPopupString(handles.selectPopup));
        SVIplot(handles.data.data_matrix,pc_num,chosenVar,7,handles.data.prep);
    otherwise
        disp('No case detected')
end

% --- Executes on selection change in prepPopup.
%prepPopup==Prep
function prepPopup_Callback(hObject, eventdata, handles)
% hObject    handle to prepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns prepPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prepPopup
nombres=cellstr(get(hObject,'String'));
val=nombres{get(hObject,'Value')};

switch val,
    case 'no preprocessing',
        prep=0;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nNo preprocessing.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
    case 'mean centering',
        prep=1;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nMean Centering.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
    case 'auto-scaling',
        prep=2;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nAuto-scaling.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
end

handles.data.prep = prep;
handles.data.control=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function prepPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',strvcat('no preprocessing','mean centering','auto-scaling'));

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.data.control=0;
set(hObject, 'Value', 2);%Default value for the preprocessing method: mean-centering
prepPopup_Callback(hObject, eventdata, handles)%Para llamar al valor por defecto


% --- Executes on button press in pcaButton.
%pcaButton==PCA
function pcaButton_Callback(hObject, eventdata, handles)
% hObject    handle to pcaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Information panel:
if isempty(handles.data.data_matrix),
    errordlg('No data matrix selected, please select one.');
    return;
end
[pc_num,status]=str2num(get(handles.pcEdit, 'String'));
sizeMat = size(handles.data.data_matrix);
if status == false
    errordlg('Please enter a number of PCs.');
    return;
elseif pc_num > sizeMat(2) || pc_num < 1
    errordlg(sprintf('The number of PCs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end
handles.data.PCs=[1:pc_num];

if handles.data.auxPCs==0,
handles.data.PC1=min(handles.data.PCs);
handles.data.PC2=min(handles.data.PCs);
handles.data.PC1_LP=min(handles.data.PCs);
handles.data.PC2_LP=min(handles.data.PCs);
handles.data.PCs_MEDA=sprintf('%d:%d',min(handles.data.PCs),min(handles.data.PCs));
handles.data.auxPCs=1;
end

[handles.data.matrixLoadings,handles.data.matrixScores]=pca_pp(handles.data.data_matrix,max(handles.data.PCs));

%Information panel:
text=sprintf('Model generated successully!');
handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);


%Crear estructura con la informaciÛn que necesita la parte de
%visualizaciÛn
title = strcat(num2str(length(handles.data.visualizationPopup)+1),'-',getCurrentPopupString(handles.dataPopup),'-PCs-',get(handles.pcEdit,'string'));
handles.data.title = title;
handles.data.visualizationPopupStruct{end + 1} = handles.data;

%AÒadir un identificador a este struct en el visualizationPopup
handles.data.visualizationPopup{end + 1} = title;
set(handles.visualizationPopup, 'String',handles.data.visualizationPopup);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Score Plot Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in xpcscorePopup.
%xpcscorePopup==PC X-axes
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

% --- Executes on selection change in ypcscorePopup.
%ypcscorePopup==PC Y-axes
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

% --- Executes on selection change in labscorePopup.
%labscorePopup==Label
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

% --- Executes on selection change in classcorePopup.
%classcorePopup==Classes
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Information panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%infoText==Static text-Information panel
% --- Executes during object creation, after setting all properties.
function infoText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

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

% --- Executes on button press in crossButton.
function crossButton_Callback(hObject, eventdata, handles)
% hObject    handle to crossButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sviButton.
function sviButton_Callback(hObject, eventdata, handles)
% hObject    handle to sviButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on selection change in generalPopup.
function generalPopup_Callback(hObject, eventdata, handles)
% hObject    handle to generalPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns generalPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from generalPopup

generalSelection = getCurrentPopupString(hObject);

switch generalSelection
    case 'SVI plot'
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


% --- Executes on selection change in selectPopup.
function selectPopup_Callback(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectPopup


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

% --- Executes during object creation, after setting all properties.
function visualizationPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to visualizationPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in visualizationButton.
function visualizationButton_Callback(hObject, eventdata, handles)
% hObject    handle to visualizationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take the selected struct in visualizationPopup
chosenStruct = getCurrentPopupString(handles.visualizationPopup);
%Get struct with the associated name
dataStruct = handles.data.visualizationPopupStruct{get(handles.visualizationPopup,'Value')};
%Run visualization with selected struct
VISUALIZATIONPCA(dataStruct);



% --- Executes on selection change in visualizationPopup.
function visualizationPopup_Callback(hObject, eventdata, handles)
% hObject    handle to visualizationPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns visualizationPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from visualizationPopup
