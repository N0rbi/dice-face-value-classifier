function varargout = diceGUI(varargin)
% DICEGUI MATLAB code for diceGUI.fig
%      DICEGUI, by itself, creates a new DICEGUI or raises the existing
%      singleton*.
%
%      H = DICEGUI returns the handle to a new DICEGUI or the handle to
%      the existing singleton*.
%
%      DICEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICEGUI.M with the given input arguments.
%
%      DICEGUI('Property','Value',...) creates a new DICEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before diceGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to diceGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help diceGUI

% Last Modified by GUIDE v2.5 24-Nov-2018 20:29:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @diceGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @diceGUI_OutputFcn, ...
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


% --- Executes just before diceGUI is made visible.
function diceGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to diceGUI (see VARARGIN)

% Choose default command line output for diceGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes diceGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = diceGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
[Filename, Pathname] = uigetfile('*.jpg','File Selector');
name = strcat(Pathname, Filename);
im = imread(name);
axes(handles.axes1);
imshow(im);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
ORIGINAL=im;
B = rgb2gray(ORIGINAL);
bw = im2bw(B);
bw = imcomplement(bw);
bw2 = imfill(bw, 'holes');

bw2 = bwareaopen(bw2, 100);
for k=1:2
    CC = bwconncomp(bw2)
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    bw2(CC.PixelIdxList{idx}) = 0;
    
end

se = strel('disk', 4);
bw2 = imerode(bw2, se);
bw2 = bwareaopen(bw2, 100);
bw2 = imerode(bw2, se);
CC = bwconncomp(bw2);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);

stats = regionprops('table',bw2,'Centroid',...
    'MajorAxisLength','MinorAxisLength')
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

[labeledImage, numberOfObject] = bwlabel(bw2);
hold on
viscircles(centers,radii);
hold off
[B,L, N, A] = bwboundaries(bw2,'noholes');
RGB = label2rgb(labeledImage);
axes(handles.axes1);
imshow(ORIGINAL); 
hold on
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end
text(5,30,strcat('\color{red}Value of dices:',num2str(numberOfObject)))
