xquery version "3.0" encoding "UTF-8";
declare namespace cs = "http://checker.bintellix.de/checkset/";

(:
========================================================================
LICENSE AGREEMENT:
This software is distributed WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
========================================================================
This copy of Checker (an automated compare tool) is licensed under the
Lesser General Public License (LGPL), version 3 ("the License").

See the License for details about distribution rights, 
modification and transformation of it.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
========================================================================
Copyright:
(c) 2010-2015 by InterSecurity GmbH &amp; Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
:)

let $group := request:get-parameter('group', '')
let $step := request:get-parameter('step', '')
return

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    </head>
    <body>
        <ul>
            <li><a href="step_{$group}_{$step}.xml">Download step_{$group}_{$step}.xml</a></li>
        </ul>
    </body>
</html>