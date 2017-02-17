<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="udata[@method = 'cart']//item">
		<xsl:variable name='price' select="price/actual" />
		<xsl:variable name='priceunit' select="document(concat( 'upage://', page/@id ))/udata//property[@name='price-unit']/value/item/@name" />
		<xsl:variable name='minnum' select="document(concat( 'upage://', page/@id ))/udata//property[@name='min-order']/value" />
		
		
		<tr data-id="{page/@id}" data-order-id="{@id}">
			<td>
				<a href="{$lang-prefix}{page/@link}">
					<xsl:apply-templates select="document(concat( 'upage://', page/@id ))/udata//group[@name='item-pasport']" mode="order-objects" />
					<strong> <xsl:value-of select="@name" /> </strong>
				</a>
			</td>
			<td class="item-order">
				<strong><xsl:value-of select="total-price/actual" /></strong>
			</td>
		<xsl:apply-templates select="document(concat( 'upage://', page/@id ))/udata//group[@name='price-param']" mode="order-objects"/>
		<td>
				<input type="number" value="{amount}" min="{$minnum}" step="{$minnum}" data-unit="{$priceunit}" data-price="{price}" />
				<a class="delitem" title="удалить" href="{$lang-prefix}/emarket/basket/remove/item/{@id}/" id="delete_{@id}" />
		</td>
		<!--xsl:call-template name="item-price-order">
      <xsl:with-param name="item-amount" select="amount"/>
			<xsl:with-param name="order-id" select="@id"/>
      <xsl:with-param name="item-order-id" select="page/@id"/>
    </xsl:call-template-->

			<!--
			<td>
				<a href="{$lang-prefix}{page/@link}">	<xsl:value-of select="@name" />	</a>
			</td>
			<td>
				<span><xsl:value-of select="price/actual | price/original" /></span>
				<input type="number" value="{amount}" />
				
				<input type="hidden" value="{amount}" />
			</td>
			<td>
				<span class="cart_item_price_{@id} size2">
					<xsl:value-of select="total-price/actual" />
				</span>
			</td>
			<td>
				<a href="{$lang-prefix}/emarket/basket/remove/item/{@id}/" id="del_basket_{@id}" class="del">x</a>
			</td>
		-->
		</tr>
	</xsl:template>
	
	<xsl:template match="group[@name='item-pasport']" mode="order-objects">
		<xsl:attribute name="class">
			<xsl:text>item-</xsl:text>
			<xsl:value-of select="property[@name='item-color']/value/item/@name"  />
		</xsl:attribute>
		<sup>
			<xsl:value-of select="property[@name='item-code']/value" />
		</sup>
		<xsl:text>&#160;</xsl:text>
	</xsl:template>	
	
	<xsl:template name="item-price-order">
		<xsl:param name="item-amount"/>
		<xsl:param name="order-id"/>
		<xsl:param name="item-order-id"/>
			<input type="number" value="{$item-amount}" />
			<a href="{$lang-prefix}/emarket/basket/remove/item/{$order-id}/" id="del_basket_{$order-id}">x</a>
	
	</xsl:template>	
	
	<xsl:template match="group[@name='price-param']" mode="order-objects">
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
			<xsl:value-of select="property[@name='price']/value" />
		</td>
		<td>
			<xsl:value-of select="property[@name='min-order']/value" />
			<xsl:value-of select="$priceunit" />
		</td>
		<td>
			<xsl:value-of select="property[@name='transupak']/value" />
			<xsl:value-of select="$priceunit" />
		</td>
	</xsl:template>	
	
</xsl:stylesheet>