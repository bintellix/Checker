<!-- 
========================================================================
LICENSE AGREEMENT:
This software is distributed WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
========================================================================
This copy of the Compare Tool is licensed under the
Lesser General Public License (LGPL), version 3 ("the License").

See the License for details about distribution rights, 
modification and transformation of it.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
========================================================================
Copyright:
(c) 2010-2014 by InterSecurity GmbH & Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:diff="http://compare.intersecurity.net/diff/" 
    xmlns:cs="http://checker.bintellix.de/checkset/" 
    xmlns:xxx="http://compare.intersecurity.net/dummy/" 
    version="2.0">
    <xsl:output omit-xml-declaration="yes" indent="no"/>
    <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xxx"/>
    <xsl:variable name="NamespaceList" select="/cs:step/cs:namespaces"/>
    <xsl:variable name="IgnoredOrderList" select="/cs:step/cs:checksets/cs:config/cs:ignore-orders"/>
    <xsl:template match="/">
        <xxx:stylesheet xmlns:er="http://compare.intersecurity.net/error-report/" exclude-result-prefixes="cs" version="2.0">
            <xsl:for-each select="$NamespaceList/cs:namespace">
                <xsl:namespace name="{@prefix}" select="@uri"/>
            </xsl:for-each>
            <xxx:output method="xml" indent="yes"/>
            <xxx:template match="/">
                <result>
                    <xxx:apply-templates/>
                </result>
            </xxx:template>
            <xxx:template match="diff">
                <xxx:apply-templates/>
            </xxx:template>
            <xxx:template match="current">
                <current>
                    <xxx:apply-templates>
                        <xxx:with-param name="MasterRoot" select="/diff/master"/>
                    </xxx:apply-templates>
                </current>
            </xxx:template>
            <xxx:template match="master">
                <master>
                    <xxx:apply-templates>
                        <xxx:with-param name="MasterRoot" select="/diff/current"/>
                        <xxx:with-param name="MasterMode" select="true()"/>
                    </xxx:apply-templates>
                </master>
            </xxx:template>
            <xxx:template match="*" priority="-1">
                <xxx:param name="MasterRoot"/>
                <xxx:param name="MasterMode" select="false()"/>
                <xxx:variable name="Name" select="local-name()"/>
                <xxx:variable name="Namespace" select="namespace-uri()"/>
                <xxx:variable name="Pos" select="count(preceding-sibling::*)+1"/>
                <!--modified-->
                <!--delete-->
                <xxx:choose>
                    <xxx:when test="$MasterRoot">
                        <xxx:variable name="MyPos">
                            <xsl:choose>
                                <xsl:when test="$IgnoredOrderList/cs:ignore-order">
                                    <xxx:choose>
                                        <xsl:for-each select="$IgnoredOrderList/cs:ignore-order">
                                            <xxx:when test="name()='{@element}'">
                                                <xxx:choose>
                                                    <xsl:for-each select="cs:match">
                                                        <xxx:when test="$MasterRoot/{@xpath}">
                                                            <xxx:value-of>
                                                                <xsl:attribute name="select">
                                                                    <xsl:text>count($MasterRoot/</xsl:text>
                                                                    <xsl:value-of select="@xpath"/>
                                                                    <xsl:text>/preceding-sibling::</xsl:text>
                                                                    <xsl:value-of select="../@element"/>
                                                                    <xsl:text>)+1</xsl:text>
                                                                </xsl:attribute>
                                                            </xxx:value-of>
                                                        </xxx:when>
                                                    </xsl:for-each>
                                                    <xxx:otherwise>
                                                        <xxx:value-of select="count(preceding-sibling::*[local-name()=$Name and namespace-uri()=$Namespace])+1"/>
                                                    </xxx:otherwise>
                                                </xxx:choose>
                                            </xxx:when>
                                        </xsl:for-each>
                                        <xxx:otherwise>
                                            <xxx:value-of select="count(preceding-sibling::*[local-name()=$Name and namespace-uri()=$Namespace])+1"/>
                                        </xxx:otherwise>
                                    </xxx:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xxx:value-of select="count(preceding-sibling::*[local-name()=$Name and namespace-uri()=$Namespace])+1"/>    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xxx:variable>
                        <xxx:variable name="Master" select="$MasterRoot/*[local-name()=$Name and namespace-uri()=$Namespace][number($MyPos)]"/>
                        <xxx:choose>
                            <xxx:when test="$Master">
                                <!-- <xxx:message>[<xxx:value-of select="name()"/> = <xxx:value-of select="name($Master)"/>]</xxx:message> -->
                                <xxx:copy>
                                    <xxx:for-each select="@*">
                                        <xxx:variable name="AttrName" select="local-name()"/>
                                        <xxx:variable name="MasterAttr" select="$Master/@*[name()=$AttrName]"/>
                                        <xxx:choose>
                                            <xxx:when test="$MasterAttr">
                                                <xxx:choose>
                                                    <xxx:when test=". != $MasterAttr">
                                                        <xxx:attribute name="diff:{{$AttrName}}">changed: <xxx:value-of select="$MasterAttr"/>
                                                        </xxx:attribute>
                                                    </xxx:when>
                                                </xxx:choose>
                                                <xxx:copy-of select="."/>
                                            </xxx:when>
                                            <xxx:otherwise>
                                                <xxx:attribute name="diff:{{$AttrName}}">
                                                    <xxx:value-of select="."/>
                                                </xxx:attribute>
                                            </xxx:otherwise>
                                        </xxx:choose>
                                    </xxx:for-each>
                                    <xxx:if test="$Pos != count($Master/preceding-sibling::*)+1">
                                        <xxx:attribute name="diff:moved" select="concat('pos ', count($Master/preceding-sibling::*)+1)"/>
                                    </xxx:if>
                                    <xxx:choose>
                                        <xxx:when test="$Master/text() = ' '  and text() != ' '">
                                            <xxx:value-of select="text()"/>
                                            <diff:changed>
                                                <xxx:value-of select="$Master/text()"/>
                                            </diff:changed>
                                        </xxx:when>
                                        <!-- normalize-space() needed? -->
                                        <xxx:when test="text() != $Master/text()">
                                            <xxx:value-of select="text()"/>
                                            <diff:changed>
                                                <xxx:value-of select="$Master/text()"/>
                                            </diff:changed>
                                        </xxx:when>
                                        <xxx:when test="text()">
                                            <xxx:value-of select="text()"/>
                                        </xxx:when>
                                    </xxx:choose>
                                    <xxx:apply-templates>
                                        <xxx:with-param name="MasterRoot" select="$Master"/>
                                        <xxx:with-param name="MasterMode" select="$MasterMode"/>
                                    </xxx:apply-templates>
                                </xxx:copy>
                            </xxx:when>
                            <xxx:otherwise>
                                <xxx:copy>
                                    <xxx:attribute name="diff:added" select="'element'"/>
                                    <xxx:copy-of select="@*"/>
                                    <xxx:copy-of select="node()"/>
                                </xxx:copy>
                            </xxx:otherwise>
                        </xxx:choose>
                    </xxx:when>
                    <xxx:otherwise>
                    <!--  <xxx:message>Current[<xxx:value-of select="name()"/> != new?]</xxx:message>-->
                        <xxx:apply-templates/>
                    </xxx:otherwise>
                </xxx:choose>
            </xxx:template>
            <xxx:template match="node()|@*" priority="-2">
                <xxx:apply-templates select="node()|@*"/>
            </xxx:template>
        </xxx:stylesheet>
    </xsl:template>
    <xsl:template match="node()|@*" priority="-1"/>
</xsl:stylesheet>