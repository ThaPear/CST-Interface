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

% The Project Object offers access to all Cable Studio
classdef Project < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Application)
        % CST.Application can create a CS.Project object.
        function obj = Project(hCSProject)
            obj.hCSProject = hCSProject;
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            obj.command = [...
                	    'With CableStudio', newline, ...
                        '    .Reset', newline, ...
                        ];
        end
        function InputName(obj, objType, cmdId, name)
            obj.command = [obj.command, ...
                sprintf('    .InputName "%s", "%s", "%s"', num2str(objType, '%.15g'), ...
                                                           num2str(cmdId, '%.15g'), ...
                                                           num2str(name, '%.15g')), newline, ...
                ];
        end
        function OutputName(obj, objType, cmdId, name)
            obj.command = [obj.command, ...
                sprintf('    .OutputName "%s", "%s", "%s"', num2str(objType, '%.15g'), ...
                                                            num2str(cmdId, '%.15g'), ...
                                                            num2str(name, '%.15g')), newline, ...
                ];
        end
        function AddInputName(obj, objType, cmdId, name)
            obj.command = [obj.command, ...
                sprintf('    .AddInputName "%s", "%s", "%s"', num2str(objType, '%.15g'), ...
                                                              num2str(cmdId, '%.15g'), ...
                                                              num2str(name, '%.15g')), newline, ...
                ];
        end
        function AddOutputName(obj, objType, cmdId, name)
            obj.command = [obj.command, ...
                sprintf('    .AddOutputName "%s", "%s", "%s"', num2str(objType, '%.15g'), ...
                                                               num2str(cmdId, '%.15g'), ...
                                                               num2str(name, '%.15g')), newline, ...
                ];
        end
        function AddStringArgument(obj, propertyId, value)
            obj.command = [obj.command, ...
                sprintf('    .AddStringArgument "%s", "%s"', num2str(propertyId, '%.15g'), ...
                                                             num2str(value, '%.15g')), newline, ...
                ];
        end
        function AddArgument3(obj, cmdId, x, y, z)
            obj.command = [obj.command, ...
                sprintf('    .AddArgument3 "%s", "%s", "%s", "%s"', num2str(cmdId, '%.15g'), ...
                                                                    num2str(x, '%.15g'), ...
                                                                    num2str(y, '%.15g'), ...
                                                                    num2str(z, '%.15g')), newline, ...
                ];
        end
        function Execute(obj, command)
            if(isempty(obj.command))
                obj.command = ['With CableStudio', newline];
            end
            obj.command = [obj.command, ...
                sprintf('    .Execute "%s"', command), newline, ...
                	    'End With', newline];
            % Run the code in obj.command.
            obj.RunVBACode(obj.command);
            obj.command = [];
        end
        %% Data import
        function CableImport(obj, filetype, filename, mapfilename)
            % The command imports external data for geometry and cable information.
            % This includes:
            %     NASTRAN CBAR (nodes & segments only)
            %     Legacy projects from SimLab CableMod
            %     KBL exchange data (geometry and optional cable data).
            %
            % filetype: 'Nastran': Nastran CBAR data exported from e.g. Catia
            %           'KBL': Cable exchange data (see Harness Description List)
            %           'SMLB': Legacy file format of SimLab CableMod (slh & zlh format)
            % filename: the full path to the file to import
            % mapfilename: the full path to the mapping file to use during import in 'value'. This value is optional.
            obj.Reset();
                obj.AddStringArgument('Type', filetype);
                obj.AddStringArgument('Filename', filename);
            if(nargin > 3)
                obj.AddStringArgument('MapFilename', mapfilename);
            end
            obj.Execute('CableImport');
        end
        %% Material
        function MaterialDefine(obj, name, type, varargin)
            %    MaterialDefine(obj, name, type, propertyId, value, ext, propertyId, value, ext, ...)
            % Creates or modifies a material entry.
            %
            % name: defines the name of the material. An existing material will be modified.
            % type: 'conductor'
            %       'dielectric'
            % propertyId: 'Conductivity'    % conductor only, conductivity (Siemens/m).
            %             'Epsilon'         % dielectric only, permittivity.
            %             'Mu'              % dielectric only, permeability.
            %             'Lossangle_el'    % dielectric only, the electrical part of the loss angle.
            %             'Lossangle_mag'   % dielectric only, the magnetic part of the loss angle.
            %             'Frequency_el'    % dielectric only, the electrical part of the loss angle.
            %             'Frequency_mag'   % dielectric only, the magnetic part of the loss angle.
            % value gives the value for the given propertyId
            % ext: SI unit name like Milli, Mega, Kilo. (none) for values without SI extension
            if(mod(nargin-3, 3) ~= 0)
                error('Invalid number of arguments, propertyId-value-ext triplets expected.');
            end
            obj.Reset();
                obj.OutputName('CSMaterial', 'Name', name);
                obj.AddStringArgument('Material', type);
            for(i = 1:3:nargin-3)
                obj.AddUnitArgument(varargin{i}, varargin{i+1}, varargin{i+2});
            end
            obj.Execute('MaterialRename');
        end
        function MaterialRename(obj, oldname, newname)
            % Renames an existing material.
            obj.Reset();
                obj.InputName('CSMaterial', 'OldName', oldname);
                obj.OutputName('CSMaterial', 'NewName', newname);
            obj.Execute('MaterialRename');
        end
        function MaterialDelete(obj, name)
            % Deletes the material by its name.
            obj.Reset();
                obj.AddInputName('CSMaterial', 'Name', name);
            obj.Execute('MaterialDelete');
        end
        function MaterialDeleteUnused(obj)
            % Deletes all unused materials.
            obj.Reset();
            obj.Execute('MaterialDeleteUnused');
        end
        function MaterialDuplicate(obj, name)
            % Duplicates a material by name.
            obj.Reset();
                obj.AddInputName('CSMaterial', 'Name', name);
            obj.Execute('MaterialDuplicate');
        end
        %% Cable Groups
        % TODO: CableGroupDefine
%         function CableGroupDefine(obj, )
%         end
        function CableGroupDelete(obj, name)
            % Delete a node by its name.
            obj.Reset();
                obj.AddInputName('CSCableGroup', 'Name', name);
            obj.Execute('CableGroupDelete');
        end
        function CableGroupRename(obj, oldname, newname)
            % Renames a node element
            obj.Reset();
                obj.InputName('CSCableGroup', 'OldName', oldname);
                obj.OutputName('CSCableGroup', 'NewName', newname);
            obj.Execute('CableGroupRename');
        end
        %% Nodes
        function NodeDefine(obj, name, x, y, z)
            % Defines a new node element for segment and cable bundle definition
            obj.Reset();
                obj.OutputName('CSNode', 'Name', name);
                obj.AddArgument('x', x);
                obj.AddArgument('y', y);
                obj.AddArgument('z', z);
            obj.Execute('NodeDefine');
        end
        function NodeDelete(obj, name)
            % Delete a node by its name.
            obj.Reset();
                obj.AddInputName('CSNode', 'Name', name);
            obj.Execute('NodeDelete');
        end
        function NodeDeleteUnused(obj)
            % Deletes all not used nodes.
            obj.Reset();
            obj.Execute('NodeDeleteUnused');
        end
        function NodeDuplicate(obj, name)
            % Duplicates a given node element
            obj.Reset();
                obj.AddInputName('CSNode', 'Name', name);
            obj.Execute('NodeDuplicate');
        end
        function NodeSnapToShape(obj, name)
            % Snaps, e.g. moves, a give nodes to the closest metallic shape
            obj.Reset();
                obj.InputName('CSNode', 'Name', name);
            obj.Execute('NodeSnapToShape');
        end
        function NodeRename(obj, oldname, newname)
            % Renames a node element
            obj.Reset();
                obj.InputName('CSNode', 'OldName', oldname);
                obj.OutputName('CSNode', 'NewName', newname);
            obj.Execute('NodeRename');
        end
        %% Segments
        function SegmentDefine(obj, name, node1, node2, materialname)
            % Create or modify a segment and its contents.
            % For naming conventions and the idea behind hierarchical elements like bundles and sub-cables please refer to Hierarchical structure definition.
            %
            % name: specifies the name of the segment to be created or modified.
            % node1/2: uses a valid node ID as value for start (N1)/end(N2) nodes of a segment.
            % material: assigns value as background material, either DEFAULT_ENV_MAT or a valid material ID.
            obj.Reset();
                obj.AddOutputName('CSSegment', 'Name', name);
                obj.AddInputName('CSNode', 'Node1', node1);
                obj.AddInputName('CSNode', 'Node2', node2);
                obj.AddInputName('CSMaterial', 'Material', materialname);
                obj.AddStringArgument('IsUserDefined', 'true');
            obj.Execute('SegmentDefine');
        end
        function SegmentRename(obj, oldname, newname)
            % Rename a segment by name.
            obj.Reset();
                obj.InputName('CSSegment', 'OldName', oldname);
                obj.OutputName('CSSegment', 'NewName', newname);
            obj.Execute('SegmentRename');
        end
        function SegmentDelete(obj, name)
            % Delete a segment  by ID.
            obj.Reset();
                obj.AddInputName('CSSegment', 'Name', name);
            obj.Execute('SegmentDelete');
        end
        function SegmentDeleteUnused(obj)
            % Delete all segments not in use by other objects.
            obj.Reset();
            obj.Execute('SegmentDeleteUnused');
        end
        function SegmentChangeNodes(obj, name, varargin)
            %    SegmentChangeNodes(obj, name, varargin)
            % Adds, removes and modifies internal segment nodes. Those nodes are used to define non-straight segments (curves, bends).
            %
            % name: sets the name of the segment to be modified.
            if(mod(nargin-2, 3) ~= 0)
                error('Invalid number of arguments, x-y-z triplets expected.');
            end
            obj.Reset();
                obj.AddOutputName('CSSegment', 'Name', name);
            for(i = 1:3:nargin-2)
                obj.AddArgument3('SNode', varargin{i}, varargin{i+1}, varargin{i+2});
            end
            obj.Execute('SegmentChangeNodes');
        end
        function SegmentBundleReset(obj, name)
            % Resets a segment bundle definition to its defaults. This removes any additional sub-bundle and cross section modifications.
            obj.Reset();
                obj.AddOutputName('CSSegment', 'Name', name);
            obj.Execute('SegmentBundleReset');
        end
%         function SegmentBundle(obj, )
%         end
        function SegmentEnvironmentMaterial(obj, name, materialname)
            % Changes the default environment material for a segment.
            %
            % material: either DEFAULT_ENV_MAT or a valid material ID.
            obj.Reset();
                obj.AddOutputName('CSSegment', 'Name', name);
                obj.AddInputName('CSMaterial', 'Material', materialname);
            obj.Execute('SegmentEnvironmentMaterial');
        end
        function CalculateImpedance(obj, name, position, varargin)
            %    CalculateImpedance(obj, name, position, cmdId, value, cmdId, value, ...)
            % This command is an interface to the CST CABLE STUDIO Impedance Calculator. It lets the user calculate the basic modes of the given segment at the given position.
            % Performs a calculation of the impedance of the given segment at the given position. The results are calculated base mode characteristic curves for each given input set. If defined, 0D and Touchstone files will be generated as well.
            if(mod(nargin-3, 2) ~= 0)
                error('Invalid number of arguments, cmdId-value pairs expected.');
            end
            obj.Reset();
                obj.AddStringArgument('Name', name);
                obj.AddStringArgument('Position', position);
            for(i = 1:2:nargin-3)
                obj.AddStringArgument(varargin{i}, varargin{i+1});
            end
            obj.Execute('CalculateImpedance');
        end
        function SegmentSubdivide(obj, name, distance, removezerolengthsubsegments)
            % Subdivides a given segment into shorter sub-segments of a given maximum length.
            % Note: This command was formerly called SegmentSplit. Old commands will be executed correctly.
            % Changes the default environment material for a segment.
            %
            % name: the already existing segment to subdivide
            % distance: the maximum length of the newly created sub-segments.
            % removezerolengthsubsegments: (0/1) remove sub-segments with zero length.
            obj.Reset();
                obj.AddInputName('CSSegment', 'Name', name);
                obj.AddArgument('distance', distance);
                obj.AddStringArgument('RemoveZeroLengthSubsegments', removezerolengthsubsegments);
            obj.Execute('SegmentSubdivide');
        end
        function SegmentSplitSubNodes(obj, name, index)
            % This command splits an existing segment at a given internal sub-node. The sub-node is selected by index.
            % The result of this operation is as follows:
            % The existing segment ends at the new node and an extra segment from the new node to the old end-node is created.
            obj.Reset();
                obj.AddInputName('CSSegment', 'Name', name);
                obj.AddInputName('CSSegment', 'Index', index);
            obj.Execute('SegmentSplitSubNodes');
        end
        %% Cable Bundles
        % TODO: CableBundleDefine
%         function CableBundleDefine(obj, )
%         end
        function CreateCableBundelFromCurve(obj, routename, curvename)
            % Define a cable bundle from an arbitrary curve definition.
            % For details on initial curve creation please refer to the corresponding help sections on Arc, Curve, Line, Spline and others.
            functionString = sprintf('CableStudio.CreateCableBundelFromCurve "%s", "%s"', routename, curvename);

            obj.RunVBACode(functionString);
        end
        function CableBundleRename(obj, oldname, newname)
            % Renames a cable bundle by ID.
            obj.Reset();
                obj.InputName('CSBundle', 'OldName', oldname);
                obj.OutputName('CSBundle', 'NewName', newname);
            obj.Execute('CableBundleRename');
        end
        function CableInstanceRename(obj, oldname, newname)
            % Rename a cable instance element
            obj.Reset();
                obj.InputName('CSCable', 'OldName', oldname);
                obj.OutputName('CSCable', 'NewName', newname);
            obj.Execute('CableInstanceRename');
        end
        function BundleRename(obj, oldname, newname, bundlename)
            % Renames a cable bundle element.
            obj.Reset();
                obj.InputName('CSBundle', 'OldName', oldname);
                obj.OutputName('CSBundle', 'NewName', newname);
                obj.OutputName('CSBundle', 'BundleName', bundlename);
            obj.Execute('BundleRename');
        end
        function NodeSetGrounded(obj, nodeId, grounded)
            % Defines the grounded property for given nodes in a cable bundle
            obj.Reset();
                obj.AddOutputName('CSNode', 'Name', nodeId);
                obj.AddStringArgument(nodeId, grounded);
            obj.Execute('NodeSetGrounded');
        end
        function CableBundleDelete(obj, name)
            % Delete a cable bundle by ID.
            obj.Reset();
                obj.AddInputName('CSBundle', 'Name', name);
            obj.Execute('CableBundleDelete');
        end
        function CableBundleFromStartAndEndNode(obj, bundlename, startnode, endnode, tracechoicerule, length)
            % Defines a new cable bundle from a given start and end node.
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            %
            % bundlename: defines the name for this cable bundle.
            % tracechoicerule: 'CLOSEST'
            %                  'SHORTEST' (default)"
            %
            % The optional parameter "TraceChoiceRule" defines which trace must be chosen in case that more than one trace exists between start and end nodes.
            % If the "TraceChoiceRule" value is not defined (or SHORTEST is passed) the shortest trace is chosen by default.
            % If the "TraceChoiceRule" value is "CLOSEST" the parameter "Length" must be defined. In this case the trace with the length value closest to the value of "Length" is chosen.
            obj.Reset();
                obj.OutputName('CSBundle', 'Name', bundlename);
                obj.AddInputName('CSNode', 'StartNode', startnode);
                obj.AddInputName('CSNode', 'EndNode', endnode);
            if(nargin > 4)
                obj.AddStringArgument('TraceChoiceRule', grounded);
                if(strcmpi(tracechoicerule, 'CLOSEST'))
                    obj.AddArgument('Length', length);
                end
            end
            obj.Execute('CableBundleFromStartAndEndNode');
        end
        %% Connection to 3D
        function ConnectionSegmentDefine(obj, segmentname, bundle, nodeId)
            % Creates a new connecting segment between a Cable Studio cable bundle and a 3D structure
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            obj.Reset();
                obj.AddOutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
            obj.Execute('ConnectionSegmentDefine');
        end
        function ConnectionSegmentApplyTerminals(obj, segmentname, bundle, nodeId, terminalname, varargin)
            %    ConnectionSegmentApplyTerminals(obj, segmentname, bundle, nodeId, terminalname, terminalname, ...)
            % Adds cable bundle terminals to the given connecting segment.
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            obj.Reset();
                obj.AddOutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.AddInputName('CSTerminal', 'Name', terminalname);
            for(i = 1:nargin-5)
                obj.AddInputName('CSTerminal', 'Name', varargin{i});
            end
            obj.Execute('ConnectionSegmentApplyTerminals');
        end
        function ConnectionSegmentAutoConnect(obj, segmentname, bundle, nodeId, autoconnect)
            % Defines the AutoConnect property for the given connecting segment. The command can handle more than one bundle with multiple node.
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            %
            % segmentname: the name for this connecting segment. The name of the connectiong segment is determined by the notation <bundle name>$<node name>$<connection segment name>
            % nodeId: the notation is <bundle name>$<node name>.
            % autoconnect: 'true'
            %              'false'
            obj.Reset();
                obj.AddOutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.StringArgument('AutoConnect', autoconnect);
            obj.Execute('ConnectionSegmentAutoConnect');
        end
%         function ConnectionSegmentBundle(obj, )
%         end
        function ConnectionSegmentChangeNodes(obj, segmentname, bundle, nodeId, nodex, nodey, noderot, varargin)
            %    ConnectionSegmentChangeNodes(obj, segmentname, bundle, nodeId, nodex, nodey, noderot, nodex, nodey, noderot, nodex, nodey, noderot)
            % Changes/adds the internal segment node data of a connecting segment between a Cable Studio cable bundle and a 3D structure.
            % If more than a straight segment is required the user can add intermediate nodes to create a custom path
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            obj.Reset();
                obj.OutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.AddArgument3('SNode', nodex, nodey, noderot);
            for(i = 1:3:nargin-7)
                obj.AddArgument3('SNode', varargin{i}, varargin{i+1}, varargin{i+2});
            end
            obj.Execute('ConnectionSegmentChangeNodes');
        end
        function ConnectionSegmentDelete(obj, segmentname, bundle, nodeId)
            % Deletes an existing connecting segment between a Cable Studio cable bundle and a 3D structure.
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            %
            % segmentname: the name for this connecting segment by a <cable bundle name>$<node name>$<connection segment name> syntax.
            % nodeId: the notation is <bundle name>$<node name>.
            obj.Reset();
                obj.AddInputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
            obj.Execute('ConnectionSegmentDelete');
        end
        function ConnectionSegmentRename(obj, oldsegmentname, bundle, nodeId, newsegmentname)
            % Renames an existing connecting segment between a Cable Studio cable bundle and a 3D structure
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            obj.Reset();
                obj.AddInputName('CSConnectionSegment', 'OldName', oldsegmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.OutputName('CSConnectionSegment', 'NewName', newsegmentname);
            obj.Execute('ConnectionSegmentRename');
        end
        function ConnectionSegmentEnvironmentMaterial(obj, segmentname, bundle, nodeId, materialname)
            % Modifies the default environment (surrounding the cable structure) of a connecting segment between a Cable Studio cable bundle and a 3D structure
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            obj.Reset();
                obj.OutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.AddInputName('CSMaterial', 'Name', materialname);
            obj.Execute('ConnectionSegmentEnvironmentMaterial');
        end
        function ConnectionSegmentWireType(obj, segmentname, bundle, nodeId, terminalname, singlewirename)
            % Deletes an existing connecting segment between a Cable Studio cable bundle and a 3D structure.
            % For naming conventions and the idea behind hierarchical segment elements like cables, bundles and sub-cables please refer to Hierarchical structure definition.
            %
            % segmentname: the name for this connecting segment by a <cable bundle name>$<node name>$<connection segment name> syntax.
            % terminalname: the name of an existing Cable Studio cable bundle by a <cable bundle name>$<node name>$<connection segment name>$<> syntax
            % singlewirename: the name of an existing Cable Studio single wire. An empty ("") name resets to the default wire.
            if(nargin < 6)
                singlewirename = '';
            end
            obj.Reset();
                obj.AddOutputName('CSConnectionSegment', 'Name', segmentname);
                obj.AddInputName('CSBundle', 'Name', bundle);
                obj.AddInputName('CSNode', 'Name', nodeId);
                obj.AddInputName('CSTerminal', 'Name', terminalname);
                obj.AddInputName('CSSingleWire', 'WireType', singlewirename);
            obj.Execute('ConnectionSegmentWireType');
        end
        %% Signals
        function SignalDefine(obj, name, colorr, colorg, colorb, varargin)
            %    SignalDefine(obj, name, colorr, colorg, colorb, colorr, colorg, colorb, colorr, colorg, colorb, ...)
            % Defines signal color setting.
            obj.Reset();
                obj.AddOutputName('CSSignal', 'Name', name);
                obj.AddStringArgument('Color', colorr, colorg, colorb);
            for(i = 1:3:nargin-5)
                obj.AddStringArgument('Color', varargin{i}, varargin{i+1}, varargin{i+2});
            end
            obj.Execute('SignalDefine');
        end
        function SignalRename(obj, oldname, newname)
            % Renames a signal.
            obj.Reset();
                obj.InputName('CSSignal', 'OldName', oldname);
                obj.OutputName('CSSignal', 'NewName', newname);
            obj.Execute('SignalRename');
        end
        %% Connectors
        function ConnectorDefine(obj, name, x, y, z, rotx, roty, rotz, pluginname, pinname)
            % Create or modify a connector.
            %
            % x, y, z: the value for the position of the connector. Default value "0.0"
            % rotx, roty, rotz: the rotation for the connector. Default value "0.0"
            % pluginname: adds a plugin named 'pluginname'
            % pinname: adds a connector pin 'pinname'
            obj.Reset();
                obj.OutputName('CSConnector', 'Name', name);
                obj.AddArgument('X', x);
                obj.AddArgument('Y', y);
                obj.AddArgument('Z', z);
                obj.AddArgument('RotX', rotx);
                obj.AddArgument('RotY', roty);
                obj.AddArgument('RotZ', rotz);
            if(nargin > 8)
                obj.AddStringArgument('Connector', pluginname);
            end
            if(nargin > 9)
                obj.AddStringArgument([pluginname, '$Plugin'], pinname);
            end
            obj.Execute('ConnectorDefine');
        end
        function ConnectorDelete(obj, name)
            % Deletes a connector by its name.
            obj.Reset();
                obj.AddInputName('CSConnector', 'Name', name);
            obj.Execute('ConnectorDelete');
        end
        function ConnectorDeleteUnused(obj)
            % Delete all connectors that have no signals or line terminals attached.
            obj.Reset();
            obj.Execute('ConnectorDeleteUnused');
        end
        function ConnectorRename(obj, oldname, newname)
            % Rename an existing connector.
            obj.Reset();
                obj.InputName('CSConnector', 'OldName', oldname);
                obj.OutputName('CSConnector', 'NewName', newname);
            obj.Execute('ConnectorRename');
        end
        function ConnectorDuplicate(obj, name)
            % Duplicates an existing connector.
            obj.Reset();
                obj.AddInputName('CSConnector', 'Name', name);
            obj.Execute('ConnectorDuplicate');
        end
        function ConnectorAutoCreate(obj)
            % Automatically create connector(s) at the end points of all cable bundles of the current project.
            obj.Reset();
            obj.Execute('ConnectorAutoCreate');
        end
        %% Junctions
        function CabConnectionDefine(obj, name, hideinschematic, connector1name, connector1pluginname, connector1pluginpinname, ...
                                                                 connector2name, connector2pluginname, connector2pluginpinname)
            % Create or modify a shortcut between pins of one or more connectors
            %
            % hideinschematic: determines whether to show this connection in the overview.
            obj.Reset();
                obj.OutputName('CSCabConnection', 'Name', name);
                obj.AddStringArgument('hide_in_schematic', hideinschematic);
                obj.AddStringArgument('cab_connection', connector1name);
                obj.AddStringArgument(connector1name, connector1pluginname);
                obj.AddStringArgument(connector1pluginname, connector1pluginpinname);
                obj.AddStringArgument('cab_connection', connector2name);
                obj.AddStringArgument(connector2name, connector2pluginname);
                obj.AddStringArgument(connector2pluginname, connector2pluginpinname);
            obj.Execute('CabConnectionDefine')
        end
        function CabConnectionRename(obj, oldname, newname)
            % Rename an existing shortcut.
            obj.Reset();
                obj.InputName('CSCabConnection', 'OldName', oldname);
                obj.OutputName('CSCabConnection', 'NewName', newname);
            obj.Execute('CabConnectionRename');
        end
        function CabConnectionDelete(obj, name)
            % Delete a shortcut between connector pins
            obj.Reset();
                obj.AddInputName('CSCabConnection', 'Name', name);
            obj.Execute('CabConnectionDelete');
        end
        function CabConnectionHide(obj, name, hide)
            % Modifies the visibility of a connection in the cable schematic viewer.
            obj.Reset();
                obj.AddInputName('CSCabConnection', 'Name', name);
                obj.AddStringArgument('hide', hide);
            obj.Execute('CabConnectionHide');
        end
        %% TL Modeling
        function TLMNodeSettings(obj, varargin)
            % This command handles selection and options for the 2DTL models
            %
            % varargin contains sets of parametername-value or, in the case of
            % ReductionFreq, parametername-value-unit.
            %
            % parametername: 'ReductionFreq', requires value and unit
            %                'SearchDistance', numerical value
            %                'MinSampleLength', numerical value
            %                'TwistingAccuracy', values may be 'normal', 'medium', 'high', 'very high'.
            %                'OhmicLosses', values may be 'true' or 'false'.
            %                'AllowModalModels', values may be 'true' or 'false'.
            %                'DielectricLosses', values may be 'true' or 'false'.
            %                'ReductionLF', values may be 'true' or 'false'.
            %                'UpdateSelect', value is the name of an existing signal.
            % unit: an SI unit string (Kilo, Mega, Giga, Milli, Pico,...)
            %
            % Defaults:
            % Parameter           Default
            % SearchDistance      50.0
            % MinSampleLength     5.0
            % ReductionFreq       10.0 Mega
            % TwistingAccuracy    medium
            % OhmicLosses         true
            % AllowModalModels    false
            % DielectricLosses    false
            % ReductionLF         false
            % UpdateSelect        All available signals
            obj.Reset();
            i = 1;
            while(i < nargin-1)
                parametername = varargin{i};
                value = varargin{i+1};
                if(strcmpi(parametername, 'ReductionFreq'))
                    unit = varargin{i+2};
                    obj.AddUnitArgument(parametername, value, unit);
                    i = i + 3;
                    continue;
                end
                if(any(strcmpi(parametername, {'SearchDistance', 'MinSampleLength'})))
                    obj.AddArgument(parametername, value);
                else
                    obj.AddStringArgument(parametername, value);
                end
                i = i + 2;
            end
            obj.Execute('TLMNodeSettings');
        end
        function TLModelExport(obj, exportfile, exportmodelname, exportsimulator)
            % This command family defines and exports specific external models to a file.
            % exportfile: a valid file path including the file itself.
            % exportmodelname: the name the exported model should have.
            % exportsimulator: 'PSpice'
            %                  'Saber'
            %                  'HSpice'
            %                  'SPICE 2G.6'
            %                  'Spice3'
            %                  'Design Studio'
            obj.Reset();
                obj.AddStringArgument('ExportFile', exportfile);
                obj.AddStringArgument('ExportModelName', exportmodelname);
                obj.AddStringArgument('ExportSimulator', exportsimulator);
            obj.Execute('TLExportSettings');
            obj.TLExportSettings(exportfile, exportmodelname, exportsimulator);

            % Trigger the export
            obj.Execute('TLStartExport');
        end
        function TLStartModelling(obj)
            % This command starts the modelling with the current 2DTL settings
            obj.command = [];
            obj.Execute('TLStartModelling');
        end
        %% Functions from CST.Project.
        function RunScript(obj, scriptname)
            % Reads the script input of a file.
            obj.hProject.invoke('RunScript', scriptname);
        end
        %% Utility functions.
        function RunVBACode(obj, functionstring)
            % functionstring specifies the VBA code to be run.

            % Run the code in CST.
            obj.StoreGlobalDataValue('matlabfcn', functionstring);
            obj.RunScript(GetFullPath('CST-Interface\Bas\RunVBACode.bas'));
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        hCSProject

        command
    end
end

%% MaterialDefine
%             functionString = [...
%                 	    'With CableStudio', newline, ...
%                         '    .Reset', newline, ...
%                 sprintf('    .OutputName "CSMaterial", "Name", "%s"', name), newline, ...
%                 sprintf('    .AddStringArgument "Material", "%s"', type), newline];
%             for(i = 1:3:nargin-3);  functionString = [functionString, ...
%                 sprintf('    .AddUnitArgument "%s", "%s", "%s"', varargin{i}, num2str(varargin{i+1}, '%.15g'), varargin{i+2}), newline]; %#ok<AGROW>
%             end
%             functionString = [functionString, ...
%                         '    .Execute "MaterialDefine"', newline, ...
%                 	    'End With', newline];
%             obj.RunVBACode(functionString);
%% MaterialRename
%             functionString = [...
%                 	    'With CableStudio', newline, ...
%                         '    .Reset', newline, ...
%                 sprintf('    .InputName "CSMaterial", "OldName", "%s"', oldname), newline, ...
%                 sprintf('    .OutputName "CSMaterial", "NewName", "%s"', newname), newline, ...
%                         '    .Execute "MaterialRename"', newline, ...
%                 	    'End With', newline];
%             obj.RunVBACode(functionString);
%% MaterialDelete
%             functionString = [...
%                 	    'With CableStudio', newline, ...
%                         '    .Reset', newline, ...
%                 sprintf('    .AddInputName "CSMaterial", "Name", "%s"', name), newline, ... % For some reason this one uses AddInputName instead of InputName
%                         '    .Execute "MaterialRename"', newline, ...
%                 	    'End With', newline];
%             obj.RunVBACode(functionString);