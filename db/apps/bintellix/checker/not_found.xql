xquery version "3.0";
declare namespace xdb="http://exist-db.org/xquery/xmldb";
declare namespace cs="http://checker.bintellix.de/checkset/";

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

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $ct-home-db := request:get-attribute('ct-home-web')
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>404 - not found</title>
    </head>
    <body>
        <h3>The site you requested was not found</h3>
    </body>
</html>