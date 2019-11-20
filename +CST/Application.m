%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Authors: Cyrus Tirband, Bart de Vos                              %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
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
            project = CST.Project(hProject);
        end
        
        function project = Active3D()
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('Active3D');
            project = CST.Project(hProject);
        end
    end
end