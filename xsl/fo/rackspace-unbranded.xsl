<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
 ]>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <xsl:import href="docbook_custom.xsl" />

  <xsl:param name="alignment">start</xsl:param>

  <xsl:param name="paper.type">USLetter</xsl:param>

  <xsl:param name="chapter.autolabel" select="1"/>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>

  <!-- Define hard pagebreak -->
  <xsl:template match="processing-instruction('hard-pagebreak')">
    <fo:block break-after='page'/>
  </xsl:template>

  <xsl:attribute-set name="monospace.verbatim.properties">
      <xsl:attribute name="font-size">
          <xsl:choose>
              <xsl:when test="processing-instruction('db-font-size')"><xsl:value-of
              select="processing-instruction('db-font-size')"/></xsl:when>
              <xsl:otherwise>85%</xsl:otherwise>
          </xsl:choose>
      </xsl:attribute>
  </xsl:attribute-set>

  <!-- Wrap long examples -->
  <xsl:attribute-set name="monospace.verbatim.properties">
      <xsl:attribute name="wrap-option">wrap</xsl:attribute>
      <xsl:attribute name="hyphenation-character">\</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="hyphenate.verbatim.characters">\/?&amp;=,.</xsl:param>

  <xsl:param name="hyphenate.verbatim" select="1"/>

  <!-- DWC: See comment in this template for more info -->
<xsl:template name="hyphenate.verbatim">
  <xsl:param name="content"/>
  <xsl:variable name="head" select="substring($content, 1, 1)"/>
  <xsl:variable name="tail" select="substring($content, 2)"/>
  <xsl:choose>
    <!-- 
	 DWC: Don't put soft-hyphens after a space due to this fop bug:
	 https://issues.apache.org/bugzilla/show_bug.cgi?id=49837 It's
	 fixed, but apparently the version of fop we're using doesn't
	 include it yet :-(
    -->
    <!-- Place soft-hyphen after space or non-breakable space. -->
    <!-- <xsl:when test="$head = ' ' or $head = '&#160;'"> -->
    <!--   <xsl:text>&#160;</xsl:text> -->
    <!--   <xsl:text>&#x00AD;</xsl:text> -->
    <!-- </xsl:when> -->
    <xsl:when test="$hyphenate.verbatim.characters != '' and
                    translate($head, $hyphenate.verbatim.characters, '') = '' and not($tail = '')">
      <xsl:value-of select="$head"/>
      <xsl:text>&#x00AD;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$head"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$tail">
    <xsl:call-template name="hyphenate.verbatim">
      <xsl:with-param name="content" select="$tail"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="processing-instruction('sbr')">
  <xsl:text>&#x200B;</xsl:text>
</xsl:template>

<xsl:template match="*[processing-instruction('rax-fo') = 'keep-with-previous']">
  <fo:block keep-together.within-column="always"
	    keep-with-previous.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="*[processing-instruction('rax-fo') = 'keep-with-next']">
  <fo:block keep-together.within-column="always"
	    keep-with-next.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="*[processing-instruction('rax-fo') = 'keep-together']">
  <fo:block keep-together.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:attribute-set name="table.table.properties">
  <xsl:attribute name="font-size">8pt</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
