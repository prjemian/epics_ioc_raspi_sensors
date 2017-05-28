<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# Copyright (c) 2005-2015, UChicago Argonne, LLC.
# See LICENSE file for details.
 -->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"
	description="default index.html page"
>
    
    <xsl:template match="/">

        <html>
            <head>
                <title>pvWebMonitor: default index.html page</title>
            </head>
            
            <body>
                
                <h1>pvWebMonitor: default index.html page</h1>
            
	            <h2>purpose</h2>
	            
	            The <b>pvWebMonitor</b> project was built to post EPICS PVs to read-only (static) web page(s)
	            
	            <h2>page(s) available</h2>
	            <h3>written: <xsl:value-of select="/pvWebMonitor/datetime"/></h3>
	            
                <table>
                    <tr>
						<th bgcolor="lightblue">web page</th>
						<th bgcolor="lightblue">description</th>
				    </tr>
                    <tr>
						<td>
							<a href="index.html">index.html</a>
						</td>
						<td>this page</td>
				    </tr>
                    <tr>
						<td>
							<a href="livedata.html">livedata.html</a>
						</td>
						<td>example XSLT to make a custom display of monitored EPICS PVs</td>
				    </tr>
                    <tr>
						<td>
							<a href="pvlist.html">pvlist.html</a>
						</td>
						<td>XSLT to display list of EPICS PVs to be monitored</td>
				    </tr>
                    <tr>
						<td>
							<a href="rawdata.html">rawdata.html</a>
						</td>
						<td>XSLT file to display the raw values of monitored EPICS PVs</td>
				    </tr>
                </table>
                
            </body>
            
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>
