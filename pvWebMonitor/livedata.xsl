<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# Copyright (c) 2005-2015, UChicago Argonne, LLC.
# See LICENSE file for details.
 -->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"
	description="example XSLT to make a custom display of monitored EPICS PVs"
>
    
    <xsl:template match="/">

        <html>
            <head>
                <meta http-equiv="Pragma" content="no-cache"/>
                <meta http-equiv="Refresh" content="300"/>
                <title>Instrument Status</title>
                <style type="text/css">
                    
                    body {
                        font: x-small Verdana, Arial, Helvetica, sans-serif; 
                    }
                    h1 {
                       font-size: 145%; 
                       margin-bottom: .5em; 
                    }
                    h2 {
                       font-size: 125%;
                       margin-top: 1.5em;
                       margin-bottom: .5em; 
                    }
                    h3 {
                        font-size: 115%;
                        margin-top: 1.2em;
                        margin-bottom: .5em
                    }
                    h4 {
                        font-size: 100%;
                       margin-top: 1.2em;
                       margin-bottom: .5em; 
                    }
                    p {
                      font: x-small Verdana, Arial, Helvetica, sans-serif;
                      color: #000000; 
                    }
                    .description {  
                        font-weight: bold; 
                        font-size: 150%;
                    }
                    td {
                        font-size: x-small; 
                    }
                    
                    li {
                        margin-top: .75em;
                        margin-bottom: .75em; 
                    }
                    ul {   
                        list-style: disc; 
                    }
                    
                    ul ul, ol ol , ol ul, ul ol {
                      margin-top: 1em;
                      margin-bottom: 1em; 
                    }
                    li p {
                      margin-top: .5em;
                      margin-bottom: .5em; 
                    }
                    
                    .dt {
                        margin-bottom: -1em; 
                    }
                    .indent {
                        margin-left: 1.5em; 
                    }
                    sup {
                       text-decoration: none;
                       font-size: smaller; 
                    }
                    
                </style>
            </head>
            <body>
                
                <table border="0" width="96%" rules="none" bgcolor="darkblue">
                    <tr>
						<td align="center" class="description">
			 			    <font color="white">Instrument Status</font>
						</td>
				    </tr>
		            <tr>
				        <td align="center">
					    <font color="white">HTML page refresh interval 0:05:00 (h:mm:ss)</font>
						</td>
				    </tr>
                    <tr bgcolor="lightblue">
                        <td align="center">
                            <table border="1" width="100%" rules="all" bgcolor="lightblue">
                                <tr>
                                    <td>
									content updated: <xsl:value-of select="/pvWebMonitor/datetime"/>
								    </td>
                                    <td align="center"><a href="raw-report.html">raw info</a> </td>
								</tr>
                            </table>
                        </td>
                    </tr>
                </table>
                
                <br/>
                <hr />

                <table border="0" width="96%" rules="none" bgcolor="bisque">
                    <tr style="background-color: mintcream">
                        <th>description</th>
                        <th>value</th>
                    </tr>
                    <tr>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='hostname']/description"/></td>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='hostname']/value"/></td>
				    </tr>
		            <tr>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='engineer']/description"/></td>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='engineer']/value"/></td>
				    </tr>
		            <tr>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='starttod']/description"/></td>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='starttod']/value"/></td>
				    </tr>
		            <tr>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='uptime']/description"/></td>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='uptime']/value"/></td>
				    </tr>
		            <tr>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='tod']/description"/></td>
						<td align="center" bgcolor="white"><xsl:value-of select="//pv[@id='tod']/value"/></td>
				    </tr>
                </table>
                
                <br/>
                <hr />

                <h4>motors</h4>
                <table border="2">
                    <tr style="background-color: grey; color: white;">
                        <th>motor</th>
                        <th>value</th>
                        <th>last updated</th>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="//pv[@id='DCM_theta']/description"/></td>
                        <td bgcolor="white"><xsl:value-of select="//pv[@id='DCM_theta']/value"/></td>
                        <td><xsl:value-of select="//pv[@id='DCM_theta']/timestamp"/></td>
                    </tr>
                    
                    <tr>
                        <td><xsl:value-of select="//pv[@id='VDM_Stripe']/description"/></td>
                        <td bgcolor="white"><xsl:value-of select="//pv[@id='VDM_Stripe']/value"/></td>
                        <td><xsl:value-of select="//pv[@id='VDM_Stripe']/timestamp"/></td>
                    </tr>
                </table>
                
                <br/>
                <hr/>
                
                <p><small><center>
                	<tt>livedata.xsl</tt> and 
                	<tt><xsl:value-of select="/pvWebMonitor/written_by"/></tt>
                </center></small></p>
                
            </body>
            
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>
