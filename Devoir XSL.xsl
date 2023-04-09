<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="text" indent="yes"/>
    
    <!-- Définition d'une variable auteur-->
    <xsl:variable name="auteur">
        <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/author[1]"/>
    </xsl:variable>
    
    <!-- Définition d'une variable titre-->
    <xsl:variable name="titre">
        <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1]"/>
    </xsl:variable>
    
    <!--Définition d'une variable journal--> 
    <xsl:variable name="journal">
        <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/biblFull[1]/publicationStmt[1]/publisher[1]/name[1]"/>
    </xsl:variable>
    
    <!--Définition d'une variable date de publication-->
    <xsl:variable name="date_pub">
        <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/biblFull[1]/publicationStmt[1]/date[1]"/>
    </xsl:variable>
    
    <xsl:template match="/">
            
        <xsl:result-document href="le_tour_du_monde_en_80_jours_chap3et4.tex">
            <xsl:text>\documentclass[]{book}
            \usepackage[utf8]{inputenc}
            \usepackage[T1]{fontenc}
            \usepackage[a4paper]{geometry}
            \geometry{left=3cm, right=3cm, top=3cm, bottom=3cm}
            \usepackage[french]{babel}
            \usepackage[protrusion=true,expansion=true,letterspace=50,wordspacing=true]{microtype}
            \usepackage{fancyhdr}
            \usepackage{titlesec}
            \titleformat{\chapter}[block]{\Large\bfseries}{}{1em}{}
            
            \usepackage[splitindex]{imakeidx}
            \makeindex[name=persName,title=Index des noms de personnages]
            \makeindex[name=placeName,title=Index des noms de lieux]
            
            \usepackage[hidelinks, pdfstartview=FitH, plainpages=false]{hyperref}</xsl:text> 
 
            \title{\textbf{<xsl:value-of select="$titre"/>}}
            \author{<xsl:value-of select="$auteur"/>}
            \date{<xsl:value-of select="$date_pub"/>}
            
            \begin{document}
            \maketitle
  
            \pagestyle{fancy}
            \fancyhf{}
            \fancyfoot[C]{\thepage}
            \renewcommand{\headrulewidth}{1pt}

    
 Ce document PDF a été compilé à partir d'une feuille de style XSL rédigée dans le cadre du Master TNAH de l'École nationale des chartes pour le cours de Jean-Damien GENERO.
            Il contient les chapitres <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/biblFull[1]/seriesStmt[1]/biblScope[2]"/> du \textit{<xsl:value-of select="$titre"/>} de <xsl:value-of select="$auteur"/>, publié alors en roman-feuilleton dans \textit{<xsl:value-of select="$journal"/>}. Ces chapitres ont été publiés dans les colonnes du journal le <xsl:value-of select="$date_pub"/>.
        
\newpage
    
            <xsl:apply-templates select="//body"/>
            
            \printindex[persName]
            \addcontentsline{toc}{chapter}{Index des noms de personnages}
            \printindex[placeName]
            \addcontentsline{toc}{chapter}{Index des noms de lieux}
            
            \tableofcontents
            \addcontentsline{toc}{chapter}{Table des matières}
            
            \end{document}
        </xsl:result-document>
        
    </xsl:template>
   
    <xsl:template match="//body">
        
        <xsl:for-each select="./head">
            <xsl:value-of select="./text()"/>
        </xsl:for-each>
        
        <xsl:for-each select="./div">
            \chapter{Chapitre <xsl:value-of select="./head//num"/>}
            
            <xsl:for-each select=".//p">
                <xsl:apply-templates/>
            </xsl:for-each>
            
            
            
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="//body//persName | //body//placeName">
        <xsl:variable name="ref" select="./@ref"/>
        <xsl:apply-templates/>
        <xsl:text>\index[</xsl:text>
        <xsl:choose>
            <xsl:when test="self::persName">
                <xsl:text>persName</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>placeName</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]{{</xsl:text><xsl:value-of select="//listPerson/person[contains($ref,@xml:id)]/persName | (//listPlace/place[contains($ref,@xml:id)]//*[not(./*)])[1]"/><xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="//body//said">
        <xsl:apply-templates/>\newline</xsl:template>
    
    <xsl:template match="//body//note">\footnote{<xsl:value-of select="."/>}</xsl:template>
    
    <xsl:template match="//text()[matches(.,'-\n')]">
        <xsl:value-of select="replace(.,'-\n +','')"/>
    </xsl:template>
    
    <xsl:template match="//body//p/text()[following-sibling::*[1][self::cb]]"><xsl:value-of select="replace(.,'[\n ]+',' ','m')"/></xsl:template>
    
    <xsl:template match="//body/p//text()[preceding-sibling::*[1][self::cb]]"><xsl:value-of select="replace(.,'[\n ]+','','m')"/></xsl:template>
    
</xsl:stylesheet>