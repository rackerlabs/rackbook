<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:XSLTExtensionIOUtil="java:ro.sync.io.XSLTExtensionIOUtil"
  xmlns:opf="http://www.idpf.org/2007/opf"
  exclude-result-prefixes="XSLTExtensionIOUtil"
  version="1.0">
  
  <!-- Dir of input XML. -->
  <xsl:param name="inputDir"/>
  
  <!-- Dir of output HTML. -->
  <xsl:param name="outputDir"/>
  
  <!-- Dir of images. -->
  <xsl:param name="imagesDir"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@src[parent::xhtml:img]">
    <xsl:variable name="imagePath" select="XSLTExtensionIOUtil:copyFile($inputDir, ., $outputDir, $imagesDir)"/>
    <xsl:attribute name="src"><xsl:value-of select="$imagePath"/></xsl:attribute>
  </xsl:template>
</xsl:stylesheet>