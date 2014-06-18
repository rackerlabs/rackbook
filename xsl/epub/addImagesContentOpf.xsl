<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:File="java.io.File"
  exclude-result-prefixes="File xhtml"
  version="1.0">

  <xsl:param name="inputFile"/>
  
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="opf:manifest">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
      <xsl:variable name="backslashToSlashInputFile" select="translate($inputFile, '\\', '/')"/>
      <xsl:variable name="htmlFile" select="File:toURL(File:new($backslashToSlashInputFile))"/>
      <xsl:for-each select="document($htmlFile)//xhtml:img/@src">
        <xsl:element namespace="http://www.idpf.org/2007/opf" name="item">
          <xsl:attribute name="id"> <xsl:value-of select="generate-id()"/> </xsl:attribute>
          <xsl:attribute name="media-type">
            <xsl:choose>
              <xsl:when test="contains(., '.gif') or contains(., 'GIF')">
                <xsl:text>image/gif</xsl:text>
              </xsl:when>
              <xsl:when test="contains(., '.png') or contains(., 'PNG')">
                <xsl:text>image/png</xsl:text>
              </xsl:when>
              <xsl:when test="contains(., '.jpeg') or contains(., 'JPEG') or contains(., '.jpg') or contains(., 'JPG')">
                <xsl:text>image/jpeg</xsl:text>
              </xsl:when>
              <xsl:when test="contains(., '.svg') or contains(., 'SVG')">
                <xsl:text>image/svg+xml</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>