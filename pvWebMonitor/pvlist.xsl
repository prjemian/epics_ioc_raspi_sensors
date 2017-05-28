<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# Copyright (c) 2005-2015, UChicago Argonne, LLC.
# See LICENSE file for details.
 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"
	description="XSLT to display list of EPICS PVs to be monitored"
>

    <xsl:template match="/">
        <html>
            <head>
                <title>pvWebMonitor: EPICS process variables to be monitored and reported</title>
            </head>
            <body>
                <h1>pvWebMonitor: EPICS process variables to be monitored and reported</h1>
                <small>
                <p>
                	XML version: 
                	<xsl:value-of select="pvwatch/@version"/>
                	(update version if format of XML file changes)
                </p>
                </small>
                
                <h2>definitions</h2>
                <dl>

                	<xsl:apply-templates select="pvwatch/definition"/>

                </dl>

                <table border="2">
                    <tr style="background-color: grey; color: white;">
                        <th>mne</th>
                        <th>PV</th>
                        <th>_ignore_</th>
                        <th>description</th>
                        <th>display_format</th>
                    </tr>

                    <xsl:apply-templates select="pvwatch/EPICS_PV"/>

                </table>

                <hr />
                <p>
                    <small>
                        report page: <pre>pvlist.xsl</pre>
                    </small>
                </p>
            </body>
        </html>
    </xsl:template>


    <xsl:template match="definition">
        <dt><xsl:value-of select="@name"/></dt>
        <dd><xsl:value-of select="."/></dd>
    </xsl:template>


    <xsl:template match="EPICS_PV">
        <tr>
 	    <xsl:if test="position() mod 2=0">
 	      <xsl:attribute name="bgcolor">Azure</xsl:attribute>
 	    </xsl:if>
            <td><xsl:value-of select="@mne"/></td>
            <td><xsl:value-of select="@PV"/></td>
            <td><xsl:value-of select="@_ignore_"/></td>
            <td><xsl:value-of select="@description"/></td>
            <td><xsl:value-of select="@display_format"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
