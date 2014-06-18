<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml" 
                exclude-result-prefixes="xsl xhtml">

  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  
  <xsl:param name="folderOfPasteTargetXml"/>
  
  <!-- Main block-level conversions -->
  <xsl:template match="xhtml:html">
    <xsl:apply-templates select="xhtml:body" mode="checkHeadings"/>
  </xsl:template>
  
  <!-- 
      MsoTitle - attr value for MS Word titles. 
      In XHTML that comes from MS Word the last node is a comment with the content 'EndFragment'.
  -->
  <xsl:template match="xhtml:div[xhtml:p[@class = 'MsoTitle']]">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="
      (following-sibling::xhtml:h1,
       following-sibling::xhtml:h2,
       following-sibling::xhtml:h3,
       following-sibling::xhtml:h4,
       following-sibling::xhtml:h5,
       following-sibling::xhtml:h6)
       [. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title" select="xhtml:p[@class = 'MsoTitle']//text()"/>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name="fillSectionBody">
    <xsl:param name="title"/>
    <xsl:param name="firstChild"/>
    <xsl:param name="sentinel"/>
    <xsl:param name="bodySet"/>
    <xsl:variable name="body">
      <xsl:choose>
        <xsl:when test="$firstChild">
          <xsl:apply-templates select="$bodySet[. &lt;&lt; $firstChild]" mode="preprocess"/>
        </xsl:when>
        <xsl:when test="$sentinel">
          <xsl:apply-templates select="$bodySet[. &lt;&lt; $sentinel]" mode="preprocess"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="some $x in $bodySet satisfies 
                local-name($x) = 'h1' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h1'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]">
              </xsl:variable>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h2' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h2'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]"/>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h3' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h3'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]"/>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h4' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h4'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]"/>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h5' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h5'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]"/>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h6' and namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:variable name="limit" select="(for $x in $bodySet return $x 
                [local-name() = 'h6'][namespace-uri() = 'http://www.w3.org/1999/xhtml'])[1]"/>
              <xsl:apply-templates select="$bodySet[. &lt;&lt; $limit]" mode="preprocess"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$bodySet"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="afterBody">
      <xsl:choose>
        <xsl:when test="$sentinel">
          <xsl:choose>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h1' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h1']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h2' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h2']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h3' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h3']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h4' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h4']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h5' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h5']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h6' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml' and
              $x &lt;&lt; $sentinel">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h6']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']
                [$x &lt;&lt; $sentinel]"/>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h1' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h1']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h2' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h2']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h3' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h3']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h4' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h4']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h5' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h5']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
            <xsl:when test="some $x in $bodySet satisfies 
              local-name($x) = 'h6' and 
              namespace-uri($x) = 'http://www.w3.org/1999/xhtml'">
              <xsl:apply-templates select="for $x in $bodySet return $x 
                [local-name($x) = 'h6']
                [namespace-uri($x) = 'http://www.w3.org/1999/xhtml']"/>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::xhtml:td | ancestor::xhtml:th">
        <xsl:copy-of select="$title"/>
        <xsl:copy-of select="$body"/>
        <xsl:copy-of select="$afterBody"/>
      </xsl:when>
      <xsl:otherwise>
        <section xmlns="http://docbook.org/ns/docbook">
          <title>
            <xsl:copy-of select="$title"/>
          </title>
          <xsl:copy-of select="$body"/>
          <xsl:copy-of select="$afterBody"/>
        </section>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xhtml:h1">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="
      (following-sibling::xhtml:h2, 
       following-sibling::xhtml:h3,
       following-sibling::xhtml:h4,
       following-sibling::xhtml:h5,
       following-sibling::xhtml:h6)
      [. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h2">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::xhtml:h2
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="
      (following-sibling::xhtml:h3,
       following-sibling::xhtml:h4,
       following-sibling::xhtml:h5,
       following-sibling::xhtml:h6)
       [. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h3">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::xhtml:h2
      | following-sibling::xhtml:h3
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="
      (following-sibling::xhtml:h4,
       following-sibling::xhtml:h5,
       following-sibling::xhtml:h6)
       [. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h4">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::xhtml:h2
      | following-sibling::xhtml:h3
      | following-sibling::xhtml:h4
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="
      (following-sibling::xhtml:h5,
       following-sibling::xhtml:h6)
       [. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h5">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::xhtml:h2
      | following-sibling::xhtml:h3
      | following-sibling::xhtml:h4
      | following-sibling::xhtml:h5
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="firstChild" select="following-sibling::xhtml:h6[. &lt;&lt; $sentinel][1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="firstChild" select="$firstChild"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h6">
    <xsl:variable name="sentinel" select="
      ( following-sibling::xhtml:div[xhtml:p[@class = 'MsoTitle']]
      | following-sibling::xhtml:h1
      | following-sibling::xhtml:h2
      | following-sibling::xhtml:h3
      | following-sibling::xhtml:h4
      | following-sibling::xhtml:h5
      | following-sibling::xhtml:h6
      | following-sibling::comment()[. = 'EndFragment'])[1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="fillSectionBody">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="sentinel" select="$sentinel"/>
      <xsl:with-param name="bodySet" select="following-sibling::text() | following-sibling::xhtml:*"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h1[ancestor::xhtml:dl] 
    | xhtml:h2[ancestor::xhtml:dl] 
    | xhtml:h3[ancestor::xhtml:dl] 
    | xhtml:h4[ancestor::xhtml:dl] 
    | xhtml:h5[ancestor::xhtml:dl]
    | xhtml:h6[ancestor::xhtml:dl]">
    <emphasis role="bold" xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  
  <xsl:template match="xhtml:p">
   <xsl:choose>
     <xsl:when test="not(parent::xhtml:th | parent::xhtml:td) and not(normalize-space(.) = '')">
       <para  xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="." mode="checkHeadings"/>
       </para>  
     </xsl:when>
     <xsl:otherwise>
        <xsl:apply-templates select="@*"/>
       <xsl:apply-templates select="." mode="checkHeadings"/>
      </xsl:otherwise>
   </xsl:choose>
  </xsl:template>

  <xsl:template match="xhtml:div[xhtml:br] | xhtml:p[xhtml:br]">
    <xsl:call-template name="brContent"/>
  </xsl:template>
  
  <xsl:template name="brContent">
    <xsl:variable name="subsetContent">
      <xhtml:div>
        <xsl:copy-of select="node()[not(preceding-sibling::xhtml:br)]"/>
      </xhtml:div>
    </xsl:variable>
    <xsl:variable name="preceding-text">
      <xsl:apply-templates select="$subsetContent/xhtml:div" mode="checkHeadings"/>
    </xsl:variable>
    <xsl:if test="string-length(normalize-space($preceding-text)) > 0">
      <para xmlns="http://docbook.org/ns/docbook"><xsl:copy-of select="$preceding-text"/></para>
    </xsl:if>
    <xsl:for-each select="xhtml:br">
      <xsl:variable name="subsetContent">
        <xhtml:div>
          <xsl:copy-of select="parent::*[1]/node()[current() is preceding-sibling::xhtml:br[1]]"/>
        </xhtml:div>
      </xsl:variable>
      <xsl:variable name="following-text">
        <xsl:apply-templates select="$subsetContent/xhtml:div" mode="checkHeadings"/>
      </xsl:variable>
      <xsl:if test="string-length(normalize-space($following-text)) > 0">
        <para xmlns="http://docbook.org/ns/docbook"><xsl:copy-of select="$following-text"/></para>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template match="xhtml:li[xhtml:br]">
    <listitem xmlns="http://docbook.org/ns/docbook">
      <xsl:call-template name="brContent"/>
    </listitem>
  </xsl:template>
  
  <xsl:template match="xhtml:pre">
    <programlisting xmlns="http://docbook.org/ns/docbook">
    <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="." mode="checkHeadings"/>
   </programlisting>
  </xsl:template>
  
  <!-- Hyperlinks -->
  <xsl:template match="xhtml:a[starts-with(@href, 'https://') or starts-with(@href,'http://') or starts-with(@href,'ftp://')]" priority="1.5">
    <link xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://docbook.org/ns/docbook">
      <xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
        <xsl:value-of select="normalize-space(@href)"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="." mode="checkHeadings"/>
   </link>
  </xsl:template>
  
  <xsl:template match="xhtml:a[contains(@href,'#')]" priority="0.6">
    <xref xmlns="http://docbook.org/ns/docbook">
    <xsl:attribute name="linkend">
       <xsl:call-template name="make_id">
        <xsl:with-param name="string" select="normalize-space(@href)"/>
       </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
    </xref>
    <xsl:apply-templates select="." mode="checkHeadings"/>
  </xsl:template>
  
  <xsl:template match="xhtml:a[@name != '']" priority="0.6">
    <anchor xmlns="http://docbook.org/ns/docbook">
        <xsl:attribute name="xml:id" namespace="http://www.w3.org/XML/1998/namespace">
          <xsl:call-template name="make_id">
          <xsl:with-param name="string" select="normalize-space(@name)"/>
       </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </anchor>
  </xsl:template>
  
  <xsl:template match="xhtml:a[@href != '']">
    <xref xmlns="http://docbook.org/ns/docbook">
    <xsl:attribute name="linkend">
       <xsl:call-template name="make_id">
         <xsl:with-param name="string" select="normalize-space(@href)"/>
       </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
    </xref>
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template name="make_id">
   <xsl:param name="string" select="''"/>
   <xsl:variable name="fixedname">
    <xsl:call-template name="getFilename">
     <xsl:with-param name="path" select="translate($string,' \()','_/_')"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:choose>
     <xsl:when test="contains($fixedname,'.html')">
       <xsl:value-of select="substring-before($fixedname,'.html')"/>
       <xsl:text>.xml</xsl:text>
       <xsl:value-of select="substring-after($fixedname,'.html')"/>
     </xsl:when>
     <xsl:when test="contains($fixedname,'.htm')">
     <xsl:value-of select="substring-before($fixedname,'.htm')"/>
     <xsl:text>.xml</xsl:text>
     <xsl:value-of select="substring-after($fixedname,'.htm')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$fixedname"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <xsl:template name="string.subst">
   <xsl:param name="string" select="''"/>
   <xsl:param name="substitute" select="''"/>
   <xsl:param name="with" select="''"/>
   <xsl:choose>
    <xsl:when test="contains($string,$substitute)">
     <xsl:variable name="pre" select="substring-before($string,$substitute)"/>
     <xsl:variable name="post" select="substring-after($string,$substitute)"/>
     <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="concat($pre,$with,$post)"/>
      <xsl:with-param name="substitute" select="$substitute"/>
      <xsl:with-param name="with" select="$with"/>
     </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$string"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <!-- Images -->
  <xsl:template match="xhtml:img">
    <xsl:variable name="pastedImageURL" 
      xmlns:URL="java:java.net.URL"
      xmlns:URLUtil="java:ro.sync.util.URLUtil"
      xmlns:UUID="java:java.util.UUID">
      <xsl:choose>
        <xsl:when test="namespace-uri-for-prefix('o', .) = 'urn:schemas-microsoft-com:office:office'">
          <!-- Copy from MS Office. Copy the image from user temp folder to folder of XML document
            that is the paste target. -->
          <xsl:variable name="imageFilename">
            <xsl:variable name="fullPath" select="URL:getPath(URL:new(translate(@src, '\', '/')))"/>
            <xsl:variable name="srcFile">
              <xsl:choose>
                <xsl:when test="contains($fullPath, ':')">
                  <xsl:value-of select="substring($fullPath, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$fullPath"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="getFilename">
              <xsl:with-param name="path" select="string($srcFile)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="stringImageFilename" select="string($imageFilename)"/>
          <xsl:variable name="uid" select="UUID:hashCode(UUID:randomUUID())"/>
          <xsl:variable name="uniqueTargetFilename" select="concat(substring-before($stringImageFilename, '.'), '_', $uid, '.', substring-after($stringImageFilename, '.'))"/>
          <xsl:variable name="sourceURL" select="URL:new(translate(@src, '\', '/'))"/>
          <xsl:variable name="correctedSourceFile">
            <xsl:choose>
              <xsl:when test="contains(URL:getPath($sourceURL), ':')">
                <xsl:value-of select="substring-after(URL:getPath($sourceURL), '/')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="URL:getPath($sourceURL)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="sourceFile" select="URLUtil:uncorrect($correctedSourceFile)"/>
          <xsl:variable name="targetURL" select="URL:new(concat($folderOfPasteTargetXml, '/', $uniqueTargetFilename))"/>
          <xsl:value-of select="URLUtil:copyURL($sourceURL, $targetURL)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@src"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
   <xsl:variable name="tag_name">
    <xsl:choose>
     <xsl:when test="boolean(parent::xhtml:p) and 
          boolean(normalize-space(string-join(parent::xhtml:p/text(), ' ')))">
      <xsl:text>inlinemediaobject</xsl:text>
     </xsl:when>
     <xsl:otherwise>mediaobject</xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
    
   <xsl:element name="{$tag_name}" namespace="http://docbook.org/ns/docbook">
     <imageobject xmlns="http://docbook.org/ns/docbook">
       <imagedata fileref="{$pastedImageURL}" xmlns="http://docbook.org/ns/docbook">
        <xsl:if test="@height != ''">
          <xsl:attribute name="depth">
            <xsl:value-of select="@height"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
        </xsl:if>
      </imagedata>
    </imageobject>
   </xsl:element>
  </xsl:template>
  
  <xsl:template name="getFilename">
   <xsl:param name="path"/>
   <xsl:choose>
    <xsl:when test="contains($path,'/')">
     <xsl:call-template name="getFilename">
      <xsl:with-param name="path" select="substring-after($path,'/')"/>
     </xsl:call-template>
    </xsl:when>
     <xsl:when test="contains($path,'\')">
       <xsl:call-template name="getFilename">
         <xsl:with-param name="path" select="substring-after($path,'\')"/>
       </xsl:call-template>
     </xsl:when>
     <xsl:otherwise>
     <xsl:value-of select="$path"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <!-- List elements -->
  <xsl:template match="xhtml:ul">
    <itemizedlist xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="." mode="checkHeadings"/>
    </itemizedlist>
  </xsl:template>
  
  <xsl:template match="xhtml:ol">
    <orderedlist xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="." mode="checkHeadings"/>
    </orderedlist>
  </xsl:template>
  
  
  <!-- 
         MS Office START 
  -->
  
  <!-- Unordered lists from MS Word can be translated as Docbook unordered lists only when they can
    be identified, that is the @style attrib contains ''. This is true for single level lists
    but never for multi-level list. If they cannot be identified as unordered lists will be
    translated as ordered lists. -->
  
  <!-- Unordered lists. -->
  <!-- <p> and <span> can be separated by <i> and <b>. -->
  <xsl:template match="xhtml:p[contains(@class,
    'MsoListParagraphCxSpFirst')][descendant::xhtml:span[contains(@style,
    'mso-fareast-font-family')]]" priority="1">    
    <itemizedlist xmlns="http://docbook.org/ns/docbook">
      <listitem>
        <para>
          <xsl:value-of select=".//text()"/>
        </para>
      </listitem>
      <xsl:variable name="sentinel" select="following-sibling::xhtml:p[contains(@class, 'MsoListParagraphCxSpLast')]
        [descendant::xhtml:span[contains(@style, 'mso-fareast-font-family')]][1]/following-sibling::*[1]"/> 
      <xsl:for-each select="following-sibling::xhtml:p[contains(@class, 'MsoListParagraphCxSp')][. &lt;&lt; $sentinel]">
        <listitem>
          <para>
            <xsl:value-of select=".//text()"/>
          </para>
        </listitem>
      </xsl:for-each>
    </itemizedlist>
  </xsl:template>
  
  <!-- Ordered lists from MS Word -->
  <xsl:template match="xhtml:p[contains(@class, 'MsoListParagraphCxSpFirst')]">    
    <orderedlist xmlns="http://docbook.org/ns/docbook">
      <listitem>
        <para>
          <xsl:value-of select=".//text()"/>
        </para>
      </listitem>
      <xsl:variable name="sentinel" select="following-sibling::xhtml:p[contains(@class, 'MsoListParagraphCxSpLast')][1]/following-sibling::*[1]"/>
      <xsl:for-each select="following-sibling::xhtml:p[contains(@class, 'MsoListParagraphCxSp')][. &lt;&lt; $sentinel]">
        <listitem>
          <para>
            <xsl:value-of select=".//text()"/>
          </para>
        </listitem>
      </xsl:for-each>
    </orderedlist>
  </xsl:template>
  
  <xsl:template match="xhtml:p[contains(@class, 'MsoListParagraphCxSpMiddle') or contains(@class, 'MsoListParagraphCxSpLast')]"/>
  
  <!-- 
         MS Office END 
  -->  


  <xsl:template match="xhtml:kbd">
    <userinput xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </userinput>
  </xsl:template>
  
  <xsl:template match="xhtml:samp">
    <screen xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </screen>
  </xsl:template>
  
  <xsl:template match="xhtml:blockquote">
    <blockquote xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="xhtml:q">
    <quote xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </quote>
  </xsl:template>
  
  <!-- This template makes a DocBook variablelist from an HTML definition list -->
  <xsl:template match="xhtml:dl">
    <variablelist xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
    	<xsl:variable name="dataBeforeTitle" select="xhtml:dd[empty(preceding-sibling::xhtml:dt)]"/>
    	<xsl:if test="not(empty($dataBeforeTitle))">
    		<varlistentry xmlns="http://docbook.org/ns/docbook">
    			<term xmlns="http://docbook.org/ns/docbook"/>
    			<listitem xmlns="http://docbook.org/ns/docbook">
			    	<xsl:for-each select="$dataBeforeTitle">
			          <xsl:apply-templates select="."/>
			    	</xsl:for-each>
    			</listitem>
    		</varlistentry>
    	</xsl:if>
      <xsl:for-each select="xhtml:dt">
	      <varlistentry xmlns="http://docbook.org/ns/docbook">
	        <term xmlns="http://docbook.org/ns/docbook">
	          <xsl:apply-templates select="node()" mode="preprocess"/>
	        </term>
	        <listitem xmlns="http://docbook.org/ns/docbook">
	        	<xsl:apply-templates select="following-sibling::xhtml:dd[current() is preceding-sibling::xhtml:dt[1]]"/>
		  </listitem>
	     </varlistentry>
     </xsl:for-each>
   </variablelist>
  </xsl:template>
  
  <xsl:template match="xhtml:dd">
   <xsl:choose>
    <xsl:when test="xhtml:p">
      <xsl:apply-templates select="node()" mode="preprocess"/>
    </xsl:when>
    <xsl:otherwise>
      <para xmlns="http://docbook.org/ns/docbook">
        <xsl:apply-templates select="node()" mode="preprocess"/>
      </para>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xhtml:li">
    <listitem xmlns="http://docbook.org/ns/docbook">
    <xsl:choose>
     <xsl:when test="count(xhtml:p) = 0">
       <para xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="." mode="checkHeadings"/>
       </para>
     </xsl:when>
     <xsl:otherwise>
       <xsl:apply-templates select="." mode="checkHeadings"/>
     </xsl:otherwise>
    </xsl:choose>
   </listitem>
  </xsl:template>
          
  <xsl:template match="*" mode="checkHeadings">
    <xsl:choose>
      <xsl:when test="xhtml:div[xhtml:p[@class = 'MsoTitle']]">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:div[xhtml:p[@class = 'MsoTitle']][1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:div[xhtml:p[@class = 'MsoTitle']]"/>
      </xsl:when>
      <xsl:when test="xhtml:h1">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h1[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h1"/>
      </xsl:when>
      <xsl:when test="xhtml:h2">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h2[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h2"/>
      </xsl:when>
      <xsl:when test="xhtml:h3">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h3[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h3"/>
      </xsl:when>
      <xsl:when test="xhtml:h4">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h4[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h4"/>
      </xsl:when>
      <xsl:when test="xhtml:h5">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h5[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h5"/>
      </xsl:when>
      <xsl:when test="xhtml:h6">
        <xsl:apply-templates select="(xhtml:* | text())[. &lt;&lt; current()/xhtml:h6[1]]" mode="preprocess"/>
        <xsl:apply-templates select="xhtml:h6"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@id" mode="#all">
    <xsl:attribute name="xml:id" namespace="http://www.w3.org/XML/1998/namespace">
    <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@class[parent::xhtml:table] | @title[parent::xhtml:table] | @style[parent::xhtml:table] |
    @width[parent::xhtml:table] | @border[parent::xhtml:table]" mode="#all"> 
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@*" mode="#all">
    <!--<xsl:message>No template for attribute <xsl:value-of select="name()"/></xsl:message>-->
  </xsl:template>
  
  <!-- Inline formatting -->
  <xsl:template match="xhtml:b | xhtml:strong">
    <emphasis role="bold" xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </emphasis>
  </xsl:template>
  <xsl:template match="xhtml:i | xhtml:em">
    <emphasis role="italic" xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </emphasis>
  </xsl:template>
  <xsl:template match="xhtml:u">
    <emphasis role="underline" xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </emphasis>
  </xsl:template>
          
  <!-- Ignored elements -->
  <xsl:template match="xhtml:hr"/>
  <xsl:template match="xhtml:br"/>
  <xsl:template match="xhtml:meta"/>
  <xsl:template match="xhtml:style"/>
  <xsl:template match="xhtml:script"/>
  <xsl:template match="xhtml:p[normalize-space(.) = '' and count(*) = 0]"/>
  <xsl:template match="text()" mode="#all">
   <xsl:choose>
    <xsl:when test="normalize-space(.) = ''"><xsl:text> </xsl:text></xsl:when>
    <xsl:otherwise><xsl:copy/></xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xhtml:a[@href != '' 
                        and not(boolean(ancestor::xhtml:p|ancestor::xhtml:li))]" 
                priority="1">
    <para xmlns="http://docbook.org/ns/docbook">
      <xref xmlns="http://docbook.org/ns/docbook">
        <xsl:attribute name="linkend">
         <xsl:call-template name="make_id">
           <xsl:with-param name="string" select="normalize-space(@href)"/>
         </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="@*"/>
      </xref>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </para>
  </xsl:template>
  
  <xsl:template match="xhtml:a[contains(@href,'#') 
                      and not(boolean(ancestor::xhtml:p|ancestor::xhtml:li))]" 
                priority="1.1">
    <para xmlns="http://docbook.org/ns/docbook">
      <xref xmlns="http://docbook.org/ns/docbook">
        <xsl:attribute name="linkend">
         <xsl:call-template name="make_id">
           <xsl:with-param name="string" select="normalize-space(@href)"/>
         </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="@*"/>
      </xref>
      <xsl:apply-templates select="." mode="checkHeadings"/>
   </para>
  </xsl:template>
  
  <!-- Table conversion -->
  
  <!-- In Docbook 4 the XHTML table elements are transformed to the elements of Docbook table. -->
  <xsl:template match="xhtml:table">
    <xsl:choose>
      <xsl:when test="not(local-name(*[1]) = 'caption')">
        <informaltable xmlns="http://docbook.org/ns/docbook">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="." mode="checkHeadings"/>
        </informaltable>
      </xsl:when>
      <xsl:otherwise>
        <table xmlns="http://docbook.org/ns/docbook">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="." mode="checkHeadings"/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xhtml:colgroup">
    <colgroup xmlns="http://docbook.org/ns/docbook">
      <xsl:if test="@span">
        <xsl:attribute name="span" select="@span"/>
      </xsl:if>
      <xsl:if test="@align">
        <xsl:attribute name="align" select="translate(@align, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
      </xsl:if>
      <xsl:if test="@width">
        <xsl:attribute name="width" select="@width"/>
      </xsl:if>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </colgroup>
  </xsl:template>


  <xsl:template match="xhtml:col">
    <col xmlns="http://docbook.org/ns/docbook">
      <xsl:if test="@align">
        <xsl:attribute name="align" select="translate(@align, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
      </xsl:if>
      <xsl:if test="@width">
        <xsl:attribute name="width" select="@width"/>
      </xsl:if>
    </col>
  </xsl:template>
  
  <xsl:template match="xhtml:caption | xhtml:thead | xhtml:tfoot | xhtml:tbody | xhtml:tr | xhtml:th | xhtml:td">
    <xsl:element name="{local-name()}" namespace="http://docbook.org/ns/docbook">
      <xsl:if test="number(@rowspan)">
        <xsl:attribute name="rowspan" select="@rowspan"/>
      </xsl:if>
      <xsl:if test="number(@colspan)">
        <xsl:attribute name="colspan" select="@colspan"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@align">
          <xsl:attribute name="align" select="translate(@align, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:when>
        <xsl:when test="xhtml:p/@align">
          <xsl:attribute name="align" select="translate((xhtml:p/@align)[1], 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@valign">
          <xsl:attribute name="valign" select="translate(@valign, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:when>
        <xsl:when test="xhtml:p/@valign">
          <xsl:attribute name="valign" select="translate((xhtml:p/@valign)[1], 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="." mode="checkHeadings"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*" mode="preprocess">
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates select="." mode="checkHeadings"/>
  </xsl:template>
  
  <xsl:template match="xhtml:h1 | xhtml:h2 | xhtml:h3 | xhtml:h4 | xhtml:h5 |xhtml:h6" mode="preprocess">
    <para xmlns="http://docbook.org/ns/docbook">
      <emphasis role="bold" xmlns="http://docbook.org/ns/docbook">
        <xsl:value-of select="."/>
      </emphasis>
    </para>
  </xsl:template>
</xsl:stylesheet>