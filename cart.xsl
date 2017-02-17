<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="item.xsl" />

	<xsl:template match="result[@method = 'cart']">
		<xsl:if test="not(contains($purchase-method, 'purchasing_one_step'))">
			<xsl:apply-templates select="//steps" />
		</xsl:if>
		<xsl:apply-templates select="document('udata://emarket/cart')/udata" />
	</xsl:template>

	<xsl:template match="udata[@method = 'cart']">
		<div class="basket">
			<h4 class="empty-content">&basket-empty;</h4>
			<p>&return-to-catalog;</p>
		</div>
	</xsl:template>


	<xsl:template match="udata[@method = 'cart'][count(items/item) &gt; 0]">
		<table data-role="objects">
				<thead>
					<tr>
						<th>
							товарные позиции
						</th>
						<th>
							на сумму
						</th>
						<th>
							упаковка
						</th>
						<th>
							ед.изм
						</th>						
						<th>
							цена
						</th>
						<th>
							мин. заказ
						</th>
						<th>
							трансп. упак.
						</th>
						<th>
							в заказе
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="items/item" />
				</tbody>
			</table>
			<h3 class="summary">
				Общая сумма заказа: <span></span>
			</h3>
			
			<div class="cart-buttons">
				<a id="clearCart" href="#">
					<xsl:text>&clear-basket;</xsl:text>
				</a>
				<a href="{$lang-prefix}/" class="toCatalog">&continue-shopping;</a>		
				<a href="{$lang-prefix}{$purchase-method}" class="basket_purchase size2">
					<xsl:text>&begin-purchase;</xsl:text>
				</a>
			</div>

	</xsl:template>

	

	<xsl:template match="udata[@method = 'cart']/summary">

		<xsl:apply-templates select="price/delivery[.!='']" mode="cart" />
		<div class="size2 tfoot">
			<xsl:text>&summary-price;: </xsl:text>
			<xsl:value-of select="$currency-prefix" />
			<xsl:text> </xsl:text>
			<span class="cart_summary size3">
				<xsl:apply-templates select="price/actual" />
			</span>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$currency-suffix" />
		</div>
	</xsl:template>

	<xsl:template match="delivery[.!='']" mode="cart">
		<div class="info">
			<xsl:text>&delivery;: </xsl:text>
			<xsl:value-of select="$currency-prefix" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="." />
			<xsl:text> </xsl:text>
			<xsl:value-of select="$currency-suffix" />
		</div>
	</xsl:template>

</xsl:stylesheet>