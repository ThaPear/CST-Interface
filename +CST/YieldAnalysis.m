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

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

% This object offers the possibility to calculate a yield analysis.
classdef YieldAnalysis < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.YieldAnalysis object.
        function obj = YieldAnalysis(project, hProject)
            obj.project = project;
            obj.hYieldAnalysis = hProject.invoke('YieldAnalysis');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With YieldAnalysis and append End With
            obj.history = [ 'With YieldAnalysis', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define YieldAnalysis settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['YieldAnalysis', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function double = GetYield(obj)
            % Returns the value of the yield after a yield analysis calculation.
            double = obj.hYieldAnalysis.invoke('GetYield');
        end
        %% Methods Concerning Design Parameters
        function InitDesignParameters(obj)
            % Only the parameters which have been used for the sensitivity analysis can be considered as design parameters for the yield analysis. Though, the active sensitivity analysis parameters are initialized with the already defined design parameter.
            obj.AddToHistory(['.InitDesignParameters']);
        end
        function SelectDesignParameter(obj, paraName, bFlag)
            % Select the design parameter specified by its name paraName. If bFlag is True the design parameter named paraName is chosen to be used for the yield analysis.
            obj.AddToHistory(['.SelectDesignParameter "', num2str(paraName, '%.15g'), '", '...
                                                     '"', num2str(bFlag, '%.15g'), '"']);
        end
        function SetDesignParameterStatisticalDistribution(obj, distributionType)
            % Set the statistical distribution for the currently selected design parameter. You must select a design parameter using the SelectDesignParameter method before you can apply this method.
            % distributionType can have the value "Gaussian" or "Uniform".
            obj.AddToHistory(['.SetDesignParameterStatisticalDistribution "', num2str(distributionType, '%.15g'), '"']);
        end
        function SetDesignParameterStandardDeviation(obj, value)
            % Set the standard deviation value for the currently selected design parameter. You must select a design parameter using the SelectDesignParameter method before you can apply this method.
            obj.AddToHistory(['.SetDesignParameterStandardDeviation "', num2str(value, '%.15g'), '"']);
        end
        %% Methods Concerning Performance Specifications
        function long = AddPerformanceSpecification(obj, perfSpecificationType)
            % Creates a new performance specification and adds it to the internal list of performance specifications. Upon creation an ID is created for each performance specification which is returned by this function. The newly defined performance specification is selected automatically for use with the yield analysis.
            % perfSpecificationType can so far only have the following value "S Bound".
            long = obj.hYieldAnalysis.invoke('AddPerformanceSpecification', perfSpecificationType);
        end
        function SelectPerformanceSpecification(obj, id, bFlag)
            % Selects the performance specification specified by its ID id. The ID is returned when the performance specification is created using the AddPerformanceSpecification function. It is necessary to call this method before many other methods may be called because these other methods apply to a previously selected performance specification.
            %  If bFlag is True the selected performance specification is used for the yield analysis else it is ignored.
            obj.AddToHistory(['.SelectPerformanceSpecification "', num2str(id, '%.15g'), '", '...
                                                              '"', num2str(bFlag, '%.15g'), '"']);
        end
        function DeletePerformanceSpecification(obj, id)
            % Deletes the specified performance specification. To specify the performance specification use the ID that is returned by the AddPerformanceSpecification function when the performance specification is created.
            obj.AddToHistory(['.DeletePerformanceSpecification "', num2str(id, '%.15g'), '"']);
        end
        function DeleteAllPerformanceSpecifications(obj)
            % Deletes all performance specification that were previously created.
            obj.AddToHistory(['.DeleteAllPerformanceSpecifications']);
        end
        function SetPerformanceSpecificationType(obj, boundType)
            % For a previously selected S-parameter bound, you can choose which part of the S-parameter data is used for the evaluation of this performance specification. You may choose between the S-parameter magnitude in linear representation and the S-parameter phase. You must select a previously defined performance specification using the SelectPerformanceSpecification method before you can apply this method.
            % boundType: 'linear'
            %            'phase'
            obj.AddToHistory(['.SetPerformanceSpecificationType "', num2str(boundType, '%.15g'), '"']);
        end
        function SetPerformanceSpecificationOperator(obj, operatorType)
            % Every performance specification needs a bound operator that indicates how to evaluate the bound function value. The operators  "<", ">" indicate that a bound function should be lowered under or raised upon a certain value.
            % operatorType can have one of the following values:
            % <       lower bound function value under a given target value       S-parameter bound
            % >       raise bound function value upon a given target value        S-parameter bound
            obj.AddToHistory(['.SetPerformanceSpecificationOperator "', num2str(operatorType, '%.15g'), '"']);
        end
        function SetPerformanceSpecificationBound(obj, value)
            % Sets a bound value for a previously defined performance specification. You must select a previously defined performance specification using the SelectPerformanceSpecification method before you can apply this method.
            obj.AddToHistory(['.SetPerformanceSpecificationBound "', num2str(value, '%.15g'), '"']);
        end
        function SetPerformanceSpecificationRange(obj, fmin, fmax)
            % Set a frequency range for a previously selected S-parameter bound. You must select a previously defined S-parameter bound using the SelectPerformanceSpecification method before you can apply this method.
            obj.AddToHistory(['.SetPerformanceSpecificationRange "', num2str(fmin, '%.15g'), '", '...
                                                                '"', num2str(fmax, '%.15g'), '"']);
        end
        function SetPerformanceSpecificationPortModes(obj, outPort, outMode, stimPort, stimMode)
            % Set the port modes used for a previously defined S-parameter bound. You must select a previously defined S-parameter bound using the SelectPerformanceSpecification method before you can apply this method.
            obj.AddToHistory(['.SetPerformanceSpecificationPortModes "', num2str(outPort, '%.15g'), '", '...
                                                                    '"', num2str(outMode, '%.15g'), '", '...
                                                                    '"', num2str(stimPort, '%.15g'), '", '...
                                                                    '"', num2str(stimMode, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hYieldAnalysis
        history
        bulkmode

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% yieldanalysis = project.YieldAnalysis();
%       .InitDesignParameters
%       .SelectDesignParameter('face_distance', 1)
%       .SetDesignParameterStatisticalDistribution('Gaussian');
%       .SetDesignParameterStandardDeviation(1.0)
%       .SelectDesignParameter('face_radius', 1)
%       .SetDesignParameterStatisticalDistribution('Uniform');
%       .SetDesignParameterStandardDeviation(2.0)
%       boundID = .AddPerformanceSpecification('S Bound'); )
%       .SelectPerformanceSpecification(boundID , 1)
%       .SetPerformanceSpecificationType('linear');
%       .SetPerformanceSpecificationOperator('<');
%       .SetPerformanceSpecificationBound (0.0)
%       .SetPerformanceSpecificationRange(0, 5)
%       .SetPerformanceSpecificationPortModes(1, 1, 2, 1)
% 
