pfUI:RegisterModule("EliteOverlay", function ()
  pfUI.gui.dropdowns.EliteOverlay_positions = {
    "left:" .. T["Left"],
    "right:" .. T["Right"],
    "off:" .. T["Disabled"]
  }

  pfUI.gui.tabs.thirdparty.tabs.EliteOverlay = pfUI.gui.tabs.thirdparty.tabs:CreateTabChild("EliteOverlay", true)
  pfUI.gui.tabs.thirdparty.tabs.EliteOverlay:SetScript("OnShow", function()
    if not this.setup then
      local CreateConfig = pfUI.gui.CreateConfig
      local update = pfUI.gui.update
      CreateConfig(update['EliteOverlay'], this, T["Select dragon position"], C.EliteOverlay, "position", "dropdown", pfUI.gui.dropdowns.EliteOverlay_positions)
      this.setup = true
    end
  end)

  pfUI:UpdateConfig("EliteOverlay",       nil,         "position",   "right")

  if C.EliteOverlay.position == "off" then return end

  local HookRefreshUnit = pfUI.uf.RefreshUnit
  function pfUI.uf:RefreshUnit(unit, component)
    local pos = string.upper(C.EliteOverlay.position)
    local invert = C.EliteOverlay.position == "right" and 1 or -1
    local unitstr = ( unit.label or "" ) .. ( unit.id or "" )
    if unitstr == "" then return end

    local size = unit:GetWidth() / 1.5
    local elite = UnitClassification(unitstr)

    if not unit.dragonTop then
      unit.dragonTop = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonTop:SetWidth(size)
      unit.dragonTop:SetHeight(size)
      unit.dragonTop:SetTexture("Interface\\AddOns\\pfUI-eliteoverlay\\TOP"..pos)
      unit.dragonTop:SetPoint("TOP"..pos, unit, "TOP"..pos, invert*size/5, size/7)
      unit.dragonTop:SetParent(unit.hp.bar)
    end

    if not unit.dragonBottom then
      unit.dragonBottom = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonBottom:SetWidth(size)
      unit.dragonBottom:SetHeight(size)
      unit.dragonBottom:SetTexture("Interface\\AddOns\\pfUI-eliteoverlay\\BOTTOM"..pos)
      unit.dragonBottom:SetPoint("BOTTOM"..pos, unit, "BOTTOM"..pos, invert*size/5.2, -size/2.98)
      unit.dragonBottom:SetParent(unit.hp.bar)
    end

    if elite == "worldboss" then
      unit.dragonTop:Show()
      unit.dragonTop:SetVertexColor(1,.8,0,1)
      unit.dragonBottom:Show()
      unit.dragonBottom:SetVertexColor(1,.8,0,1)
    elseif elite == "rareelite" then
      unit.dragonTop:Show()
      unit.dragonTop:SetVertexColor(1,.8,0,1)
      unit.dragonBottom:Show()
      unit.dragonBottom:SetVertexColor(1,.8,0,1)
    elseif elite == "elite" then
      unit.dragonTop:Show()
      unit.dragonTop:SetVertexColor(1,.9,.2,1)
      unit.dragonBottom:Show()
      unit.dragonBottom:SetVertexColor(1,.9,.2,1)
    elseif elite == "rare" then
      unit.dragonTop:Show()
      unit.dragonTop:SetVertexColor(1,1,1,1)
      unit.dragonBottom:Show()
      unit.dragonBottom:SetVertexColor(1,1,1,1)
    else
      unit.dragonTop:Hide()
      unit.dragonBottom:Hide()
    end

    HookRefreshUnit(this, unit, component)
  end
end)
