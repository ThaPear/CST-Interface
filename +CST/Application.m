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

classdef Application < handle
    properties
    end
    methods(Static)
        function cst = GetHandle()
%             persistent cst_handle;
%             if(~isempty(cst_handle))
%                 if(~isa(cst_handle, 'COM.CSTStudio_Application'))
%                     error(['Invalid CST handle of type ', class(cst_handle)]);
%                 end
%                 cst = cst_handle;
%             else
                cst_handle = actxserver('CSTStudio.Application');
                cst = cst_handle;
%             end
        end
        
        function project = NewMWS()
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewMWS');
            project = CST.Project(hProject);
        end
        
        function project = NewEMS()
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewEMS');
            project = CST.Project(hProject);
        end
        
        function project = OpenFile(filename)
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('OpenFile', filename);
            if(isempty(hProject))
                error('File not found or file is already open.');
            end
            project = CST.Project(hProject);
        end
        
        function project = Active3D()
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('Active3D');
            project = CST.Project(hProject);
        end
        
        function dsproject = ActiveDS()
            cst = CST.Application.GetHandle();
            hDSProject  = cst.invoke('ActiveDS');
            dsproject = CST.DS.Project(hDSProject);
        end
        
        function Quit()
            cst = CST.Application.GetHandle();
            cst.invoke('Quit');
        end
    end
end