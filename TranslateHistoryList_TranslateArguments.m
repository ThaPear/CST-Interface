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

function line = TranslateHistoryList_TranslateArguments(line)

% Ensure 5 spaces at the start.
line = regexprep(line, '^[\s]*([\.][\w]*)[\s]*(.*)$', '     $1 $2');
% Numbers without quotes (And a number followed by a %.
line = regexprep(line, '(\s)([\d\+e\.]+%?)\s*([,]|$)', '$1''$2''$3');
% Replace double quoted arguments with single quotes.
line = regexprep(line, '([a-zA-Z])?(,*)\s*"([^"]*)"', '$1$2 ''$3''');
% Place opening brace.
line = regexprep(line, '([\w])\s''', '$1(''');
% Place closing brace.
line = regexprep(line, '''\s*$', ''');');
% Place (); after functions with no arguments.
line = regexprep(line, '([a-zA-Z])\s*$', '$1();');