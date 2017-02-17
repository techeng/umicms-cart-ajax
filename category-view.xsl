<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:variable name="filters" select="document(concat('udata://catalog/getSmartFilters//', $document-page-id, '/0/1'))/udata" />
	<xsl:variable name="temple-category-id" select="document(concat('udata://catalog/getSmartFilters//', $document-page-id, '/0/1'))/udata/@type-id" />
	<xsl:variable name="main-name" select="/result/@header" />
	<xsl:variable name="abbr-name" select=".//property[@name = 'abbr']/value" />
	
	<xsl:template match="result[@module = 'catalog'][page/@type-id='119']">
		<xsl:apply-templates select="//property[@name='h1']/value" mode="page-header" />
		<div class="prod-desc" umi:element-id="{$document-page-id}" umi:field-name="content" umi:empty="&empty-page-content;">
		<h2>
			<xsl:apply-templates select=".//property[@name = 'typemodel']/value" mode="type-model"/>
			<xsl:value-of select="$abbr-name" />
		</h2>
			<xsl:apply-templates select=".//property[@name = 'icons-set']/value" mode="promo-icons"/>
			<xsl:value-of select=".//property[@name = 'descr']/value" disable-output-escaping="yes" />
			<xsl:apply-templates select=".//property[@name = 'pagedocs']/value" mode="page-docs" />
		</div>
		<div class="prod-img">
			<xsl:apply-templates select=".//property[@name = 'product-img']/value" mode="base-product-img"/>
		</div>
		
		<xsl:apply-templates select=".//property[@name = 'product-draw']/value" mode="product-draw"/>
		
		<ul class="additional pallet">
    	<li class="folder">
        	<a class="jump" href="#">Товарные позиции</a>
            <div class="addinfo">
				<xsl:apply-templates select="document(concat('udata://catalog/getSmartCatalog//', page/@id, '///1/'))/udata" mode="object-table" />
			</div>
        </li>
			<xsl:apply-templates select=".//group[@name = 'show-links']/property" mode="folder-show"/>
		</ul>
		
		 <!--xsl:apply-templates select="document(concat('udata://catalog/getSmartCatalog//', page/@id, '///2/', document('utype://catalog-object')//field[@name='price']/@name  ,'/', $sort_direction,'/'))/udata" /-->
		 
	</xsl:template>
	
	<xsl:template match="value" mode="type-model">
		<span>
			<xsl:value-of select="item/@name" />
		</span>
	</xsl:template>
	
	<xsl:template match="property" mode="folder-show">
		<li class="folder">
        	<a class="jump {@name}" href="#"><xsl:value-of select="title" /></a>
            <div class="addinfo">
			<ul class="catalog-categories">
				<xsl:apply-templates select="value/page" mode="folder-show"/>
			</ul>
			</div>
        </li>
	</xsl:template>

	<xsl:template match="page[@type-id='59']" mode="folder-show">
		<li class="addarticles">
			<a href="{@link}">
				<xsl:value-of select="name" />
			</a>
        </li>
	</xsl:template>
	
	<xsl:template match="page" mode="folder-show">
		<li>
			<a href="{@link}" data-hreftype="product-icon">
			<xsl:apply-templates select="document(concat('upage://',@id))//properties/group[@name='menu_view']/property[@name='header_pic']/value" mode="icons-img"/>
			</a>
			<a href="{@link}">
			<xsl:apply-templates select="document(concat('upage://',@id))//properties/group[@name='nodesettings']/property[@name='abbr']/value" mode="acronym"/>
			<xsl:value-of select="document(concat('upage://',@id))//properties/group[@name='common']/property[@name='meta_descriptions']/value" />
			</a>
        </li>
	</xsl:template>
	
	<xsl:template match="value" mode="acronym">
		<h6>
			<xsl:value-of select="." />
		</h6>
	</xsl:template>
	
	<!--xsl:template match="/result[@method = 'category'][count(/result/parents/page) &gt; 0]">
        <xsl:choose>
            <xsl:when test="$sort_field = 'Price'">
                <xsl:apply-templates select="document(concat('udata://catalog/getSmartCatalog//', page/@id, '///2/', document('utype://catalog-object')//field[@name='price']/@name  ,'/', $sort_direction,'/'))/udata" />
            </xsl:when>
            <xsl:when test="$sort_field = 'Name'">
                <xsl:apply-templates select="document(concat('udata://catalog/getSmartCatalog//', page/@id, '///2/', document('utype://catalog-object')//field[@name='title']/@name  ,'/', $sort_direction,'/'))/udata" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document(concat('udata://catalog/getSmartCatalog//', page/@id, '///2/'))/udata" />
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template-->

	<xsl:template match="udata[@method = 'getSmartCatalog']" mode="object-table">
	    
            <xsl:if test="$filters/error">
				<h2>Ошибка индексации раздела каталога</h2>
			</xsl:if>
			<table data-role="objects">
				<thead>
					<xsl:if test="not($filters/error)">
						<xsl:apply-templates select="$filters" mode="object-table-head" />
					</xsl:if>
				</thead>
				<tbody>
					<xsl:apply-templates select="lines" mode="object-table-items" />
				</tbody>
			</table>
			<p class="itemstotal">всего позиций: <xsl:value-of select="total" /><a href="/emarket/cart/">сумма заказа: <span></span></a></p>
		
	</xsl:template>
	<xsl:template match="udata[@method = 'getSmartFilters']" mode="object-table-head">
			<tr>
				<xsl:apply-templates select="group[@name='item-pasport']" mode="object-table-head" />
				<xsl:apply-templates select="group[@name='dimensions']" mode="object-table-head" />
				<xsl:apply-templates select="group[@name='blockattributes']" mode="object-table-head" />
				<xsl:apply-templates select="group[@name='attributes']" mode="object-table-head" />
				<xsl:apply-templates select="group[@name='price-param']" mode="object-table-head" />
				<th rowspan="2">заказ<a href="/emarket/cart/" id="toBasket"></a></th>
			</tr>
			<xsl:if test="group[@name='dimensions'] or group[@name='blockattributes']">
				<tr>
					<xsl:apply-templates select="group[@name='dimensions']" mode="object-row2-head" />
					<xsl:apply-templates select="group[@name='blockattributes']" mode="object-row2-head" />
				</tr>
			</xsl:if>
	</xsl:template>
	
	<xsl:template match="group[@name='item-pasport']" mode="object-table-head">
			<th>
			<xsl:attribute name="rowspan"><xsl:value-of select="2" /></xsl:attribute>
				товарные позиции
				<xsl:if test="field[@name='item-color']">
				<xsl:text>/ </xsl:text><xsl:value-of select="field[@name='item-color']/@title" />
				</xsl:if>
			</th>
	</xsl:template>
	<xsl:template match="group[@name='dimensions' or @name='blockattributes']" mode="object-table-head">
			<xsl:variable name="colspan" select="count(field)" />
			<th style="white-space: nowrap;">
			<xsl:attribute name="colspan"><xsl:value-of select="$colspan" /></xsl:attribute>
				<xsl:value-of select="@title" />
			</th>
	</xsl:template>
	<xsl:template match="group" mode="object-table-head">
			<xsl:apply-templates select="document(concat('utype://',$temple-category-id,'.',@name))/udata/group" mode="table-head-field" />
	</xsl:template>	
	<xsl:template match="field" mode="table-head-field">
			<th>
			<xsl:attribute name="rowspan"><xsl:value-of select="2" /></xsl:attribute>
				<xsl:value-of select="@title" />
			</th>
	</xsl:template>	
	<xsl:template match="group[@name='dimensions' or @name='blockattributes']" mode="object-row2-head">
			<xsl:apply-templates select="document(concat('utype://',$temple-category-id,'.',@name))/udata/group" mode="table-head2-field" />
	</xsl:template>	
	<xsl:template match="field" mode="table-head2-field">
			<th class="field-min">
				<xsl:value-of select="@title" />
			</th>
	</xsl:template>	
	
	<xsl:template match="item" mode="object-table-items">
			<tr data-id="{@id}">
				<xsl:apply-templates select="document(concat('upage://', @id, '?show-empty' ))/udata/page" mode="object-row" />
			</tr>
	</xsl:template>	
	<xsl:template match="page" mode="object-row">
			<td class="tradecode">
				<a href="{@link}">
					<xsl:attribute name="class">
						<xsl:text>item-</xsl:text>
						<xsl:value-of select=".//property[@name='item-color']/value/item/@name"  />
					</xsl:attribute>
					<xsl:value-of select="name"  />
					<xsl:apply-templates select=".//property[@name='item-tm']/value" mode="brandname" />
				<span>
					код товара:<xsl:value-of select=".//property[@name='item-code']/value"  />
				</span>
				</a>
			</td>
			<xsl:apply-templates select="properties" mode="object-row" />
	</xsl:template>	
	<xsl:template match="properties" mode="object-row">
			<xsl:apply-templates select="group[@name='dimensions']" mode="object-row" />
			<xsl:apply-templates select="group[@name='blockattributes']" mode="object-row" />
			<xsl:apply-templates select="group[@name='attributes']" mode="object-row" />
			<xsl:apply-templates select="group[@name='price-param']" mode="object-row" />
	</xsl:template>	
	<xsl:template match="group[@name='dimensions']" mode="object-row">
			<xsl:apply-templates select="property" mode="object-row" />
	</xsl:template>	
	<xsl:template match="group[@name='price-param']" mode="object-row">
			<xsl:variable name='priceunit' select="property[@name='price-unit']/value/item/@name" />
			<xsl:variable name='iprice' select="property[@name='price']/value" />
			<xsl:variable name='minnum' select="property[@name='min-order']/value" />
			<td>
				<xsl:value-of select="property[@name='upak']/value" />
			</td>
			<td>
				<xsl:value-of select="$priceunit" />
			</td>
			<td>
				<xsl:value-of select="$iprice" />
			</td>
			<td>
				<nobr>
				<xsl:value-of select="property[@name='min-order']/value" />
				<xsl:text>&#160;</xsl:text>
				<xsl:value-of select="$priceunit" />
				</nobr>
			</td>
			<td>
				<nobr>
				<xsl:value-of select="property[@name='transupak']/value" />
				<xsl:text>&#160;</xsl:text>
				<xsl:value-of select="$priceunit" />
				</nobr>
			</td>
			<td>
				<input type="number" min="{$minnum}" step="{$minnum}" placeholder="кол-во" value="" data-unit="{$priceunit}" data-price="{$iprice}"/>
				
			</td>
	</xsl:template>
	<xsl:template match="group" mode="object-row">
			<xsl:apply-templates select="property" mode="object-row" />
	</xsl:template>	
	<xsl:template match="property" mode="object-row">
			<td>
				<xsl:value-of select="value" />
			</td>
	</xsl:template>	
	<xsl:template match="property[@type='relation']" mode="object-row">
			<td>
				<xsl:value-of select="value/item/@name" />
			</td>
	</xsl:template>	
	<xsl:template match="value" mode="brandname">
			<sup>(
				<xsl:value-of select="item/@name"  />
			)</sup>
	</xsl:template>	
	
	
	<!--xsl:template match="udata[@method = 'getSmartCatalog'][total &gt; 0]">
		<xsl:if test="not($filters/error)">
			<xsl:apply-templates select="$filters" />
		</xsl:if>

		<div class="catalog {$catalog}">
            <xsl:call-template name="sorting" />
			<div class="objects" umi:element-id="{category_id}" umi:module="catalog" umi:method="getObjectsList" umi:sortable="sortable">
				<xsl:apply-templates select="lines/item" mode="short-view">
					<xsl:with-param name="cart_items" select="document('udata://emarket/cart/')/udata/items" />
				</xsl:apply-templates>
				<div class="clear" />
			</div>
		</div>
		
		<xsl:apply-templates select="total" />
	</xsl:template-->
	
	<xsl:template match="value" mode="base-product-img">
		<a href="{.}" class="swipebox" title="{$main-name}">
			<img src="{.}" alt="{$main-name}" />
		</a>
	</xsl:template>
	<xsl:template match="value" mode="product-draw">
			<img class="drawimage" src="{.}" alt="{@alt}" />
	</xsl:template>
	
	<xsl:template match="value" mode="promo-icons">
			<ul class="iconset">
				<xsl:apply-templates select="page" mode="promo-icons" />
			</ul>
	</xsl:template>
	<xsl:template match="page" mode="promo-icons">
			<xsl:variable name="icontitle" select="document(concat('uobject://', @object-id))/udata/object/properties/group[@name='common']/property[@name='title']/value" />
			<xsl:variable name="svgicon" select="document(concat('uobject://', @object-id))/udata/object/properties/group[@name='photo_props']/property[@name='icon-svg']/value" />
			<li><img type="image/svg+xml" class="itip" title="{$icontitle}" src="{$svgicon}" /></li>
	</xsl:template>
	
	
	<xsl:template match="value" mode="page-docs">
			<ul class="pagedocs">
				<xsl:apply-templates select="page" mode="page-docs" />
			</ul>
	</xsl:template>
	<xsl:template match="page" mode="page-docs">
		<li>
			<a href="/filemanager/download/{@id}">
				<xsl:value-of select="name" />
			</a>
		</li>
	</xsl:template>
	
	
</xsl:stylesheet>