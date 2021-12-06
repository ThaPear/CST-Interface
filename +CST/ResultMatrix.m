% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
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
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object offers access functions to matrix results. A ResultMatrix object can hold a two dimensional array of numbers.
classdef ResultMatrix < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.Project, ?CST.ResultTree})
        % Only CST.Project can create a CST.ResultMatrix object.
        function obj = ResultMatrix(project, hProject)
            obj.project = project;
            obj.hResultMatrix = hProject.invoke('ResultMatrix');
        end
    end
    %% CST Object functions.
    methods
        %% Initialization
        % A ResultMatrix object can be created via the ResultTree object:
        % Dim matrix As Object
        % Set matrix = ResultTree.GetResultFromTreeItem("1D Results\Es Solver\Capacitance Matrix",GetLastResultID())
        % The first argument needs to be a tree path to an existing matrix result in the navigation tree.
        %% Queries
        function long = GetSize(obj, row_or_column)
            % The method returns the number of rows or columns. The argument is expected to be the string "row" or "column" to indicate which size is queried.
            long = obj.hResultMatrix.invoke('GetSize', row_or_column);
        end
        function str = GetName(obj, row_or_column, index)
            % This method returns the name of a row or column. The first argument is expected to be the string "row" or "column" . The second argument is the zero-based index of the queried row or column.
            str = obj.hResultMatrix.invoke('GetName', row_or_column, index);
        end
        function str = GetElementType(obj)
            % This method returns the ResultObjectType of a single matrix element, e.g. the string "0D".
            str = obj.hResultMatrix.invoke('GetElementType');
        end
        function Result0D = GetElement(obj, row, column)
            % This method returns a Result 0D object which contains the data of the matrix at the given row and column.
            Result0D = obj.hResultMatrix.invoke('GetElement', row, column);
        end
        function str = GetResultObjectType(obj)
            % Returns the string "matrix". This method can be used to distinguish this result object from other objects (e.g. Result1D,  Result1DComplex)  in a context where the type of a result object is unknown.
            str = obj.hResultMatrix.invoke('GetResultObjectType');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResultMatrix

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% This example loads a matrix result, iterates over all its elements and reports the value of each matrix entry to the message window.
% 
% Dim m As Object
% Set m = Resulttree.GetResultFromTreeItem('1D Results\Es Solver\Capacitance Matrix', GetLastResultID())
% If(m Is Nothing) Then
%     ReportError('empty object');
% End If
% 
% Dim row As Long, col As Long
% For row = 0 To m.GetSize('row');-1
%     For col = 0 To m.GetSize('column');-1
%         Dim o As Object
%         Set o = m.GetElement(row,col)
%         If o.GetResultObjectType() =('0D'); Then
%             Dim data As Double
%             o.GetData( data )
%             ReportInformationToWindow(Cstr(row) + ', ' + Cstr(col) +(':(' + Cstr(data))
%         Else
%             ReportWarningToWindow('not a 0D object');
%         End If
%     Next
% Next
% 
% 
% CST Studio Suite 2020 | 3DS.COM/SIMULIA
% 
