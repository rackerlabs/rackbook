<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:exslt="http://exslt.org/common"
  xmlns:File="java.io.File"
  exclude-result-prefixes="File exslt"
  version="1.0">
  
  <xsl:param name="inputFile"/>
  
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="opf:item[starts-with(@media-type, 'image/')]"/>
</xsl:stylesheet>