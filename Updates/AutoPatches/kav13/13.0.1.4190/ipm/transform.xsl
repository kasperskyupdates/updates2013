<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <!-- constants -->
  <xsl:variable name="ItemNumberMaxLength">4</xsl:variable>
  <xsl:variable name="LicenseNotificationSettingsUniqueId">0x35731C6F</xsl:variable>
  <xsl:variable name="SlideShowUniqueId">0xCBF622BF</xsl:variable>
  <xsl:variable name="SlideShowImageUniqueId">0x20D0F4BD</xsl:variable>
  <xsl:variable name="ScheduleUniqueId">0x87ED8826</xsl:variable>
  <xsl:variable name="WelcomePageUniqueId">0x3E6D9C24</xsl:variable>
  <xsl:variable name="RegretPageUniqueId">0xE00858C7</xsl:variable>
  <xsl:variable name="EndOfLicenseUniqueId">0x7619D07F</xsl:variable>
  <xsl:variable name="NewsUniqueId">0x10D0D041</xsl:variable>
  <xsl:variable name="NewsItemUniqueId">0xA232DC45</xsl:variable>
  <xsl:variable name="ApplicationButtonListUniqueId">0xFFEF47B5</xsl:variable>
  <xsl:variable name="ApplicationButtonUniqueId">0x818B9DCD</xsl:variable>
  <xsl:variable name="LicenseNotificationUniqueId">0x398EA778</xsl:variable>
  <xsl:variable name="MessageBoxSettingsUniqueId">0x26113741</xsl:variable>
  <xsl:variable name="BalloonSettingsUniqueId">0x3487BF5C</xsl:variable>
  <xsl:variable name="ProblemListSettingsUniqueId">0x1605AE48</xsl:variable>
  <xsl:variable name="ApplicationMainPageSettingsUniqueId">0x10656BE1</xsl:variable>
  <xsl:variable name="LicenseManagerSettingsUniqueId">0xEE49F394</xsl:variable>
  <xsl:variable name="BackgroundSettingsUniqueId">0x0F145804</xsl:variable>
  <xsl:variable name="LicenseManagerButtonUniqueId">0xBBA48DDC</xsl:variable>
  <xsl:variable name="RootUniqueId">0xCF742638</xsl:variable>
  <xsl:variable name="FilterContainerUniqueId">0x8BFCB846</xsl:variable>
  <xsl:variable name="FilterDateUniqueId">0x88875F16</xsl:variable>
  <xsl:variable name="FilterIntegerUniqueId">0x0F2F0F07</xsl:variable>
  <xsl:variable name="FilterStringUniqueId">0x47D0764F</xsl:variable>
  <xsl:variable name="UcpReadySettingsUniqueId">0xBA440D2</xsl:variable>
  <xsl:variable name="LicenseUpdateParamsUniqueId">0x2023038F</xsl:variable>
  
  <!-- /constants -->
  <!-- main -->
  <xsl:template match="/IpmContentCustomization">
    <root>
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$RootUniqueId"/>
      </xsl:attribute>
      <Items>
        <xsl:for-each select="*">
          <xsl:variable name="strItemNumber">
            <xsl:call-template name="prepend-pad">
              <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
              <xsl:with-param name="padChar" select="0"/>
              <xsl:with-param name="padVar" select="string(position()-1)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:apply-templates select="current()">
            <xsl:with-param name="sourcePath" select="current()"/>
            <xsl:with-param name="itemNumber" select="$strItemNumber"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </Items>
    </root>
  </xsl:template>
  <!-- /main -->

  <!--UcpReady-->
  <xsl:template match="UcpReadySettings">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$UcpReadySettingsUniqueId"/>
      </xsl:attribute>

      <xsl:attribute name="contentId">
        <xsl:value-of select="Id"/>
      </xsl:attribute>

      <xsl:attribute name="connectionType">
        <xsl:choose>
          <xsl:when test="UcpConnectionType = 'Disable'">
            <xsl:value-of select="1" />
          </xsl:when>
          <xsl:when test="UcpConnectionType = 'RegistrationOnDemand'">
            <xsl:value-of select="2" />
          </xsl:when>

          <xsl:when test="UcpConnectionType = 'RegistrationAlways'">
            <xsl:value-of select="3" />
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="portalUri">
        <xsl:value-of select="UcpPortalUri"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <!-- /UcpReadySettingsSettings-->
  
  <!--LicenseNotificationSettings-->
  <xsl:template match="LicenseNotificationSettings">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$FilterContainerUniqueId"/>
      </xsl:attribute>
      <xsl:call-template name="Schedule">
        <xsl:with-param name="sourcePath" select="$sourcePath/Schedule"/>
      </xsl:call-template>
      <Items>
        <item_0000>
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$LicenseNotificationSettingsUniqueId"/>
          </xsl:attribute>
		  <xsl:attribute name="contentId">
			<xsl:value-of select="Id"/>
		  </xsl:attribute>
          <xsl:attribute name="enable">
            <xsl:choose>
              <xsl:when test="$sourcePath/EnableIpmMessagesOnly='true'">
                <xsl:value-of select="'0'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'1'"/>
              </xsl:otherwise>
              </xsl:choose>
          </xsl:attribute>
        </item_0000>
      </Items>
    </xsl:element>
  </xsl:template>
  <!-- /LicenseNotificationSettings-->
  <!--EndOfLicense-->
  <xsl:template match="EndOfLicense">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$EndOfLicenseUniqueId"/>
      </xsl:attribute>
      <xsl:attribute name="contentId">
        <xsl:value-of select="Id"/>
      </xsl:attribute>
      <xsl:call-template name="BooleanAsInt">
        <xsl:with-param name="resultAttributeName" select="'show'"/>
        <xsl:with-param name="sourcePath" select="$sourcePath/DisableEndOfLicense"/>
        <xsl:with-param name="isNegative" select="true()"/>
      </xsl:call-template>
      <xsl:attribute name="contentUri">
        <xsl:value-of select="ContentUri"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <!--/EndOfLicense-->
  <!--WelcomePage-->
  <xsl:template match="WelcomePage">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$FilterContainerUniqueId"/>
      </xsl:attribute>
      <Items>
        <item_0000>
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$WelcomePageUniqueId"/>
          </xsl:attribute>
          <xsl:attribute name="contentId">
            <xsl:value-of select="Id"/>
          </xsl:attribute>
          <xsl:call-template name="BooleanAsInt">
            <xsl:with-param name="resultAttributeName" select="'show'"/>
            <xsl:with-param name="sourcePath" select="$sourcePath/DisableWelcomePage"/>
            <xsl:with-param name="isNegative" select="true()"/>
          </xsl:call-template>
          <xsl:attribute name="contentUri">
            <xsl:value-of select="ContentUri"/>
          </xsl:attribute>
        </item_0000>
      </Items>
    </xsl:element>
  </xsl:template>
  <!--/WelcomePage-->
  <!--RegretPage-->
  <xsl:template match="RegretPage">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$RegretPageUniqueId"/>
      </xsl:attribute>
      <xsl:attribute name="contentId">
        <xsl:value-of select="Id"/>
      </xsl:attribute>
      <xsl:attribute name="url">
        <xsl:value-of select="ContentUri"/>
      </xsl:attribute>
      <xsl:call-template name="BooleanAsInt">
        <xsl:with-param name="resultAttributeName" select="'enable'"/>
        <xsl:with-param name="sourcePath" select="$sourcePath/DisableRegretPage"/>
        <xsl:with-param name="isNegative" select="true()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <!--/RegretPage-->

  <xsl:template match="LicenseUpdateParams">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$FilterContainerUniqueId"/>
      </xsl:attribute>
      <xsl:call-template name="Schedule">
        <xsl:with-param name="sourcePath" select="$sourcePath/Schedule"/>
      </xsl:call-template>
      <Items>
        <item_0000>
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$LicenseUpdateParamsUniqueId"/>
          </xsl:attribute>

          <xsl:attribute name="UpdateInterval">
            <xsl:value-of select="UpdateInterval"/>
          </xsl:attribute>

          <xsl:attribute name="UpdateIntervalOnVisit">
            <xsl:value-of select="UpdateIntervalOnVisit"/>
          </xsl:attribute>

          <xsl:attribute name="OnVisitUpdateDuration">
            <xsl:value-of select="OnVisitUpdateDuration"/>
          </xsl:attribute>
        </item_0000>
      </Items>

    </xsl:element>
  </xsl:template>

  <!--News-->
  <xsl:template match="News">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$FilterContainerUniqueId"/>
      </xsl:attribute>
      <xsl:call-template name="Schedule">
        <xsl:with-param name="sourcePath" select="$sourcePath/Schedule"/>
      </xsl:call-template>
      <Items>
        <item_0000>
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$NewsUniqueId"/>
          </xsl:attribute>
          <items>
            <item_0000>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$NewsItemUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="contentId">
                <xsl:value-of select="Id"/>
              </xsl:attribute>
              <xsl:attribute name="contentUri">
                <xsl:value-of select="ContentUri"/>
              </xsl:attribute>
              <xsl:call-template name="Severity">
                <xsl:with-param name="sourcePath" select="Severity"/>
              </xsl:call-template>
              <xsl:attribute name="title">
                <xsl:value-of select="Title"/>
              </xsl:attribute>
              <xsl:attribute name="announcement">
                <xsl:value-of select="Announcement"/>
              </xsl:attribute>
              <xsl:attribute name="creationDate">
                <xsl:value-of select="PublicationDate"/>
              </xsl:attribute>
              <xsl:call-template name="BooleanAsInt">
                <xsl:with-param name="resultAttributeName" select="'show'"/>
                <xsl:with-param name="sourcePath" select="$sourcePath/AutoOpenInApplication"/>
                <xsl:with-param name="isNegative" select="false()"/>
              </xsl:call-template>
              <xsl:call-template name="BooleanAsInt">
                <xsl:with-param name="resultAttributeName" select="'ignoreUserSettings'"/>
                <xsl:with-param name="sourcePath" select="$sourcePath/IgnoreDisableShowSetting"/>
                <xsl:with-param name="isNegative" select="false()"/>
              </xsl:call-template>
            </item_0000>
          </items>
        </item_0000>
      </Items>
    </xsl:element>
  </xsl:template>
  <!--/News-->
  <!--ApplicationButtonList-->
  <xsl:template match="ApplicationButtonList">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$ApplicationButtonListUniqueId"/>
      </xsl:attribute>

      <xsl:attribute name="contentId">
        <xsl:value-of select="Id"/>
      </xsl:attribute>


      <xsl:call-template name="ApplicationButton">
        <xsl:with-param name="sourcePath" select="$sourcePath"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <xsl:template name="ApplicationButton">
    <xsl:param name="sourcePath"/>
    <items>
      <xsl:for-each select="$sourcePath/Button">
        <xsl:variable name="strItemNumber">
          <xsl:call-template name="prepend-pad">
            <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
            <xsl:with-param name="padChar" select="0"/>
            <xsl:with-param name="padVar" select="string(position()-1)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="{concat('item_', $strItemNumber)}">
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$ApplicationButtonUniqueId"/>
          </xsl:attribute>
          <xsl:attribute name="contentId">
            <xsl:value-of select="Id"/>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="ButtonName"/>
          </xsl:attribute>
          <!--<xsl:attribute name="type"><xsl:value-of select="ButtonType"/></xsl:attribute>-->

          <xsl:call-template name="ButtonType">
            <xsl:with-param name="buttonType" select="current()/ButtonType" />
          </xsl:call-template>

          <xsl:attribute name="target">
            <xsl:choose>
              <xsl:when test="current()/CustomUri != ''">
                <xsl:value-of select="current()/CustomUri" />
              </xsl:when>
              <xsl:when test="current()/ProductStoreUri != ''">
                <xsl:value-of select="concat('ipp:',ProductStoreUri)" />
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </items>
  </xsl:template>
  <xsl:template name="ButtonType">
    <xsl:param name="buttonType" />
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="$buttonType = 'Buy'">
          <xsl:value-of select="1" />
        </xsl:when>
        <xsl:when test="$buttonType = 'Renew'">
          <xsl:value-of select="2" />
        </xsl:when>
        <xsl:when test="$buttonType = 'Upgrade'">
          <xsl:value-of select="3" />
        </xsl:when>
        <xsl:when test="$buttonType = 'ManageLicense'">
          <xsl:value-of select="4" />
        </xsl:when>
        <xsl:when test="$buttonType = 'ManageSubscription'">
          <xsl:value-of select="5" />
        </xsl:when>
        <xsl:when test="$buttonType = 'SubscriptionProvider'">
          <xsl:value-of select="6" />
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="ActionTarget">
    <xsl:param name="applicationAction" />
    <xsl:param name="customUri" />
    <xsl:param name="productStoreUri" />
    <xsl:attribute name="target">
      <xsl:choose>
        <xsl:when test="$applicationAction = 'OpenCustomUri'">
          <xsl:value-of select="$customUri" />
        </xsl:when>
        <xsl:when test="$applicationAction = 'OpenCustomProductStore'">
          <xsl:value-of select="concat('ipp:',$productStoreUri)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$applicationAction" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <!--/ApplicationButtonList-->
  <!--LicenseNotification-->
  <xsl:template match="LicenseNotification">
    <xsl:param name="sourcePath"/>
    <xsl:param name="itemNumber"/>
    <xsl:element name="{concat('item_', $itemNumber)}">
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$FilterContainerUniqueId"/>
      </xsl:attribute>
      <xsl:call-template name="Schedule">
        <xsl:with-param name="sourcePath" select="$sourcePath/Schedule"/>
      </xsl:call-template>
      <Items>
        <item_0000>
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$LicenseNotificationUniqueId"/>
          </xsl:attribute>
          <xsl:attribute name="contentId">
            <xsl:value-of select="Id"/>
          </xsl:attribute>
          <xsl:call-template name="Severity">
            <xsl:with-param name="sourcePath" select="Severity"/>
          </xsl:call-template>
          <xsl:call-template name="BooleanAsInt">
              <xsl:with-param name="resultAttributeName" select="'showToast'" />
              <xsl:with-param name="sourcePath" select="$sourcePath/ShowToast" />
              <xsl:with-param name="isNegative" select="false()" />
          </xsl:call-template>
          <xsl:if test="$sourcePath/MessageBox">
            <messageBoxSettings>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$MessageBoxSettingsUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="height">
                <xsl:value-of select="$sourcePath/MessageBox/WindowHeigth"/>
              </xsl:attribute>
              <xsl:attribute name="width">
                <xsl:value-of select="$sourcePath/MessageBox/WindowWidth"/>
              </xsl:attribute>
              <xsl:attribute name="contentUri">
                <xsl:value-of select="$sourcePath/MessageBox/ContentUri"/>
              </xsl:attribute>
            </messageBoxSettings>
          </xsl:if>
          <xsl:if test="$sourcePath/Balloon">
            <balloonSettings>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$BalloonSettingsUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="description">
                <xsl:value-of select="$sourcePath/Balloon/Description"/>
              </xsl:attribute>
            </balloonSettings>
          </xsl:if>
          <xsl:if test="$sourcePath/ProblemList">
            <problemListSettings>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$ProblemListSettingsUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="$sourcePath/ProblemList/Title"/>
              </xsl:attribute>
              <xsl:attribute name="description">
                <xsl:value-of select="$sourcePath/ProblemList/LicenseProblemDescription"/>
              </xsl:attribute>
            </problemListSettings>
          </xsl:if>
          <xsl:if test="$sourcePath/ApplicationMainPage">
            <mainWindowSettings>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$ApplicationMainPageSettingsUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="protectionState">
                <xsl:value-of select="$sourcePath/ApplicationMainPage/ProtectionStateName"/>
              </xsl:attribute>
              <xsl:attribute name="licenseState">
                <xsl:value-of select="$sourcePath/ApplicationMainPage/LicenseStateName"/>
              </xsl:attribute>
              <xsl:call-template name="BooleanAsInt">
                <xsl:with-param name="resultAttributeName" select="'forceShowButton'"/>
                <xsl:with-param name="sourcePath" select="$sourcePath/ApplicationMainPage/ShowApplicationButton"/>
                <xsl:with-param name="isNegative" select="false()"/>
              </xsl:call-template>
            </mainWindowSettings>
          </xsl:if>
          <xsl:if test="$sourcePath/LicenseManager">
            <licenseManagerSettings>
              <xsl:attribute name="unique_id">
                <xsl:value-of select="$LicenseManagerSettingsUniqueId"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="$sourcePath/LicenseManager/Title"/>
              </xsl:attribute>
              <xsl:attribute name="description">
                <xsl:value-of select="$sourcePath/LicenseManager/Description"/>
              </xsl:attribute>
              <xsl:if test="$sourcePath/LicenseManager/Background">
                <background>
                  <xsl:attribute name="unique_id">
                    <xsl:value-of select="$BackgroundSettingsUniqueId"/>
                  </xsl:attribute>
                  <xsl:attribute name="contentUri">
                    <xsl:value-of select="$sourcePath/LicenseManager/Background/BackgroundImageUri"/>
                  </xsl:attribute>
                  <xsl:attribute name="rightMargin">
                    <xsl:value-of select="$sourcePath/LicenseManager/Background/RightMargin"/>
                  </xsl:attribute>
                  <xsl:attribute name="topMargin">
                    <xsl:value-of select="$sourcePath/LicenseManager/Background/TopMargin"/>
                  </xsl:attribute>
                  <xsl:attribute name="leftMargin">
                    <xsl:value-of select="$sourcePath/LicenseManager/Background/LeftMargin"/>
                  </xsl:attribute>
                  <xsl:attribute name="bottomMargin">
                    <xsl:value-of select="$sourcePath/LicenseManager/Background/BottomMargin"/>
                  </xsl:attribute>
                </background>
              </xsl:if>
              <xsl:call-template name="LicenseManagerButtonList">
                <xsl:with-param name="sourcePath" select="$sourcePath/LicenseManager/Buttons"/>
              </xsl:call-template>
            </licenseManagerSettings>
          </xsl:if>
        </item_0000>
      </Items>
    </xsl:element>
  </xsl:template>
  <xsl:template name="LicenseManagerButtonList">
    <xsl:param name="sourcePath"/>
    <buttons>
      <xsl:for-each select="$sourcePath/Button">
        <xsl:variable name="strItemNumber">
          <xsl:call-template name="prepend-pad">
            <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
            <xsl:with-param name="padChar" select="0"/>
            <xsl:with-param name="padVar" select="string(position()-1)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="{concat('item_', $strItemNumber)}">
          <xsl:attribute name="unique_id">
            <xsl:value-of select="$LicenseManagerButtonUniqueId"/>
          </xsl:attribute>
          <xsl:attribute name="contentId">
            <xsl:value-of select="Id"/>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="ButtonName"/>
          </xsl:attribute>
          <xsl:call-template name="BooleanAsInt">
            <xsl:with-param name="resultAttributeName" select="'showBasket'"/>
            <xsl:with-param name="sourcePath" select="DisplayShoppingCart"/>
            <xsl:with-param name="isNegative" select="false()"/>
          </xsl:call-template>
          <xsl:call-template name="ActionTarget">
            <xsl:with-param name="applicationAction" select="current()/ApplicationAction" />
            <xsl:with-param name="customUri" select="current()/CustomUri" />
            <xsl:with-param name="productStoreUri" select="current()/ProductStoreUri" />
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
    </buttons>
  </xsl:template>
  <!--/LicenseNotification-->
  <xsl:template name="Severity">
    <xsl:param name="sourcePath"/>
    <xsl:variable name="severity">
      <xsl:value-of select="$sourcePath"/>
    </xsl:variable>
    <xsl:attribute name="severity">
      <xsl:choose>
        <xsl:when test="$severity='Alarm'">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$severity='Warning'">
          <xsl:value-of select="2"/>
        </xsl:when>
        <xsl:when test="$severity='Information'">
          <xsl:value-of select="3"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="Schedule">
    <xsl:param name="sourcePath"/>
    <Filter>
      <xsl:attribute name="unique_id">
        <xsl:value-of select="$ScheduleUniqueId"/>
      </xsl:attribute>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/LicenseExpiration/DaysToExpiration"/>
        <xsl:with-param name="resultAttributeName" select="'DaysLeft'"/>
      </xsl:call-template>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/LicenseExpiration/DaysAfterExpiration"/>
        <xsl:with-param name="resultAttributeName" select="'DaysAfter'"/>
      </xsl:call-template>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/LicenseExpiration/DaysAfterActivation"/>
        <xsl:with-param name="resultAttributeName" select="'LicUsageDays'"/>
      </xsl:call-template>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/LicenseSubscription/DaysToExpiration"/>
        <xsl:with-param name="resultAttributeName" select="'LicDaysToSubsExp'"/>
      </xsl:call-template>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/LicenseSubscription/DaysAfterExpiration"/>
        <xsl:with-param name="resultAttributeName" select="'LicDaysSinceSubsExp'"/>
      </xsl:call-template>
      <xsl:call-template name="RangeNodeListToAttribute">
        <xsl:with-param name="sourcePath" select="$sourcePath/DateTimeRangeList/DateTimeRange"/>
        <xsl:with-param name="resultAttributeName" select="'ViewDates'"/>
      </xsl:call-template>
      <xsl:call-template name="IncludeExcludeNodeListToAttribute">
        <xsl:with-param name="includeListSourcePath" select="$sourcePath/IncludeLicenseStatusList/LicenseStatus"/>
        <xsl:with-param name="excludeListSourcePath" select="$sourcePath/ExcludeLicenseStatusList/LicenseStatus"/>
        <xsl:with-param name="resultAttributeName" select="'LegalStatus'"/>
      </xsl:call-template>
      <xsl:call-template name="IncludeExcludeNodeListToAttribute">
        <xsl:with-param name="includeListSourcePath" select="$sourcePath/IncludeLicenseTypeList/LicenseType"/>
        <xsl:with-param name="excludeListSourcePath" select="$sourcePath/ExcludeLicenseTypeList/LicenseType"/>
        <xsl:with-param name="resultAttributeName" select="'KeyType'"/>
      </xsl:call-template>
      <xsl:call-template name="IncludeExcludeNodeListToAttribute">
        <xsl:with-param name="includeListSourcePath" select="$sourcePath/IncludeApplicationStatusList/ApplicationStatus"/>
        <xsl:with-param name="excludeListSourcePath" select="$sourcePath/ExcludeApplicationStatusList/ApplicationStatus"/>
        <xsl:with-param name="resultAttributeName" select="'ProductState'"/>
      </xsl:call-template>
      <xsl:call-template name="DateParam">
        <xsl:with-param name="sourcePath" select="$sourcePath/ProviderParamList/ProviderParam"/>
      </xsl:call-template>
      <xsl:call-template name="IntegerParam">
        <xsl:with-param name="sourcePath" select="$sourcePath/ProviderParamList/ProviderParam"/>
      </xsl:call-template>
      <xsl:call-template name="StringParam">
        <xsl:with-param name="sourcePath" select="$sourcePath/ProviderParamList/ProviderParam"/>
      </xsl:call-template>
    </Filter>
  </xsl:template>
  
  <!-- DateParam -->
  <xsl:template name="DateParam">
    <xsl:param name="sourcePath"/>
    <LicAddInfoDate>
    <xsl:for-each select="$sourcePath/DateParam[ExactDateValueRange]/ParamId|$sourcePath/DateParam[ExactDateValue]/ParamIdRange/From|$sourcePath/DateParam[ExactDateValue]/ParamIdRange/To|$sourcePath/DateParam[CurrentDateValue]/ParamIdRange/From|$sourcePath/DateParam[CurrentDateValue]/ParamIdRange/To">
      <xsl:variable name="itemNumber">
        <xsl:call-template name="prepend-pad">
          <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
          <xsl:with-param name="padChar" select="0"/>
          <xsl:with-param name="padVar" select="string(position()-1)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:element name="{concat('item_', $itemNumber)}">
        <xsl:attribute name="unique_id">
          <xsl:value-of select="$FilterDateUniqueId"/>
        </xsl:attribute>
        <!-- ExactDateValueRange -->
        <xsl:if test="name() = 'ParamId'">
          <xsl:call-template name="ExactDateValueRange">
            <xsl:with-param name="sourcePath" select="current()/.."/>
          </xsl:call-template>
        </xsl:if>				
        <!-- ExactDateValue -->
        <xsl:if test="(current()/../../ExactDateValue) and (name() = 'From')">
          <xsl:call-template name="ExactDateValueFrom">
            <xsl:with-param name="sourcePath" select="current()/../.."/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="(current()/../../ExactDateValue) and (name() = 'To')">
          <xsl:call-template name="ExactDateValueTo">
            <xsl:with-param name="sourcePath" select="current()/../.."/>
          </xsl:call-template>
        </xsl:if>
        <!-- CurrentDateValue -->
        <xsl:if test="(current()/../../CurrentDateValue) and (name() = 'From')">
          <xsl:call-template name="CurrentDateValueFrom">
            <xsl:with-param name="sourcePath" select="current()/../.."/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="(current()/../../CurrentDateValue) and (name() = 'To')">
          <xsl:call-template name="CurrentDateValueTo">
            <xsl:with-param name="sourcePath" select="current()/../.."/>
          </xsl:call-template>
        </xsl:if>				
      </xsl:element>
    </xsl:for-each>
    </LicAddInfoDate>
  </xsl:template>
  <xsl:template name="ExactDateValueRange">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamId/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="concat($sourcePath/ExactDateValueRange/From/text(),'-',$sourcePath/ExactDateValueRange/To/text())"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="ExactDateValueFrom">
    <xsl:param name="sourcePath"/>
      <xsl:attribute name="Id">
    <xsl:value-of select="$sourcePath/ParamIdRange/From/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="concat('-',$sourcePath/ExactDateValue/text())"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="ExactDateValueTo">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamIdRange/To/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="concat($sourcePath/ExactDateValue/text(),'-')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="CurrentDateValueFrom">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamIdRange/From/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="'-now'"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="CurrentDateValueTo">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamIdRange/To/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="'now-'"/>
    </xsl:attribute>
  </xsl:template>
  <!-- /DateParam -->

  <!-- IntegerParam -->
  <xsl:template name="IntegerParam">
    <xsl:param name="sourcePath"/>
    <LicAddInfoInt>
    <xsl:for-each select="$sourcePath/IntegerParam">
      <xsl:variable name="itemNumber">
        <xsl:call-template name="prepend-pad">
          <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
          <xsl:with-param name="padChar" select="0"/>
          <xsl:with-param name="padVar" select="string(position()-1)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:element name="{concat('item_', $itemNumber)}">
        <xsl:attribute name="unique_id">
          <xsl:value-of select="$FilterIntegerUniqueId"/>
        </xsl:attribute>
        <xsl:call-template name="ExactIntegerValue">
          <xsl:with-param name="sourcePath" select="current()"/>
        </xsl:call-template>
      </xsl:element>			
    </xsl:for-each>
    </LicAddInfoInt>
  </xsl:template>
  <xsl:template name="ExactIntegerValue">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamId/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="concat($sourcePath/Value/From/text(),'-',$sourcePath/Value/To/text())"/>
    </xsl:attribute>
  </xsl:template>
  <!-- /IntegerParam -->

  <!-- StringParam -->
  <xsl:template name="StringParam">
    <xsl:param name="sourcePath"/>
    <LicAddInfoStr>
    <xsl:for-each select="$sourcePath/StringParam">
      <xsl:variable name="itemNumber">
      <xsl:call-template name="prepend-pad">
        <xsl:with-param name="length" select="$ItemNumberMaxLength"/>
        <xsl:with-param name="padChar" select="0"/>
        <xsl:with-param name="padVar" select="string(position()-1)"/>
      </xsl:call-template>
      </xsl:variable>
      <xsl:element name="{concat('item_', $itemNumber)}">
        <xsl:attribute name="unique_id">
          <xsl:value-of select="$FilterStringUniqueId"/>
        </xsl:attribute>
        <xsl:call-template name="ExactStringValue">
          <xsl:with-param name="sourcePath" select="current()"/>
        </xsl:call-template>
      </xsl:element>			
    </xsl:for-each>
    </LicAddInfoStr>
  </xsl:template>
  <xsl:template name="ExactStringValue">
    <xsl:param name="sourcePath"/>
    <xsl:attribute name="Id">
      <xsl:value-of select="$sourcePath/ParamId/text()"/>
    </xsl:attribute>
    <xsl:attribute name="Value">
      <xsl:value-of select="$sourcePath/Value/text()"/>
    </xsl:attribute>
  </xsl:template>
  <!-- /StringParam -->
  
  <xsl:template name="RangeNodeListToAttribute">
    <xsl:param name="sourcePath"/>
    <xsl:param name="isNegative"/>
    <xsl:param name="resultAttributeName" select="name($sourcePath)"/>
    <xsl:param name="result">
      <xsl:for-each select="$sourcePath">
        <xsl:if test="$isNegative='true'">
          <xsl:value-of select="'!'"/>
        </xsl:if>
        <xsl:if test="position()!=1">
          <xsl:value-of select="','"/>
        </xsl:if>
        <xsl:value-of select="concat(current()/From/text(),'-',current()/To/text())"/>
      </xsl:for-each>
    </xsl:param>
    <xsl:attribute name="{$resultAttributeName}">
      <xsl:value-of select="$result"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="IncludeExcludeNodeListToAttribute">
    <xsl:param name="includeListSourcePath"/>
    <xsl:param name="excludeListSourcePath"/>
    <xsl:param name="resultAttributeName"/>
    <xsl:param name="result">
      <xsl:for-each select="$includeListSourcePath">
        <xsl:if test="position()!=1">
          <xsl:value-of select="';'"/>
        </xsl:if>
        <xsl:value-of select="current()/text()"/>
      </xsl:for-each>
      <xsl:for-each select="$excludeListSourcePath">
        <xsl:if test="position()!=1 or count($includeListSourcePath)>0">
          <xsl:value-of select="';'"/>
        </xsl:if>
        <xsl:value-of select="'!'"/>
        <xsl:value-of select="current()/text()"/>
      </xsl:for-each>
    </xsl:param>
    <xsl:attribute name="{$resultAttributeName}">
      <xsl:value-of select="$result"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="BooleanAsInt">
    <xsl:param name="sourcePath"/>
    <xsl:param name="resultAttributeName"/>
    <xsl:param name="isNegative" select="false()"/>
    <xsl:variable name="sourceValue" select="$sourcePath"/>
    <xsl:variable name="lowerSourceValue" select="translate($sourceValue,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
    <xsl:attribute name="{$resultAttributeName}">
      <xsl:choose>
        <xsl:when test="($lowerSourceValue = 'true' and $isNegative = false()) or ($lowerSourceValue = 'false' and $isNegative = true())">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="prepend-pad">
    <xsl:param name="padChar"/>
    <xsl:param name="padVar"/>
    <xsl:param name="length"/>
    <xsl:choose>
      <xsl:when test="string-length($padVar) &lt; $length">
        <xsl:call-template name="prepend-pad">
          <xsl:with-param name="padChar" select="$padChar"/>
          <xsl:with-param name="padVar" select="concat($padChar,$padVar)"/>
          <xsl:with-param name="length" select="$length"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($padVar,string-length($padVar) - $length + 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
