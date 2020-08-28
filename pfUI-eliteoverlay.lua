pfUI:RegisterModule("EliteOverlay", "vanilla:tbc", function ()
  pfUI.gui.dropdowns.EliteOverlay_positions = {
    "left:" .. T["Left"],
    "right:" .. T["Right"],
    "off:" .. T["Disabled"]
  }

  -- detect current addon path
  local addonpath
  local tocs = { "", "-master", "-tbc", "-wotlk" }
  for _, name in pairs(tocs) do
    local current = string.format("pfUI-eliteoverlay%s", name)
    local _, title = GetAddOnInfo(current)
    if title then
      addonpath = "Interface\\AddOns\\" .. current
      break
    end
  end

  if pfUI.gui.CreateGUIEntry then -- new pfUI
    pfUI.gui.CreateGUIEntry(T["Thirdparty"], T["Elite Overlay"], function()
      pfUI.gui.CreateConfig(pfUI.gui.UpdaterFunctions["target"], T["Select dragon position"], C.EliteOverlay, "position", "dropdown", pfUI.gui.dropdowns.EliteOverlay_positions)
    end)
  else -- old pfUI
    pfUI.gui.tabs.thirdparty.tabs.EliteOverlay = pfUI.gui.tabs.thirdparty.tabs:CreateTabChild("EliteOverlay", true)
    pfUI.gui.tabs.thirdparty.tabs.EliteOverlay:SetScript("OnShow", function()
      if not this.setup then
        local CreateConfig = pfUI.gui.CreateConfig
        local update = pfUI.gui.update
        this.setup = true
      end
    end)
  end

  pfUI:UpdateConfig("EliteOverlay",       nil,         "position",   "right")


  local HookRefreshUnit = pfUI.uf.RefreshUnit
  function pfUI.uf:RefreshUnit(unit, component)
    local pos = string.upper(C.EliteOverlay.position)
    local invert = C.EliteOverlay.position == "right" and 1 or -1
    local unitstr = ( unit.label or "" ) .. ( unit.id or "" )

    local size = unit:GetWidth() / 1.5
    local elite = UnitClassification(unitstr)

    unit.dragonTop = unit.dragonTop or unit:CreateTexture(nil, "OVERLAY")
    unit.dragonBottom = unit.dragonBottom or unit:CreateTexture(nil, "OVERLAY")

    if unitstr == "" or C.EliteOverlay.position == "off" then
      unit.dragonTop:Hide()
      unit.dragonBottom:Hide()
    else
      unit.dragonTop:ClearAllPoints()
      unit.dragonTop:SetWidth(size)
      unit.dragonTop:SetHeight(size)
      unit.dragonTop:SetPoint("TOP"..pos, unit, "TOP"..pos, invert*size/5, size/7)
      unit.dragonTop:SetParent(unit.hp.bar)

      unit.dragonBottom:ClearAllPoints()
      unit.dragonBottom:SetWidth(size)
      unit.dragonBottom:SetHeight(size)
      unit.dragonBottom:SetPoint("BOTTOM"..pos, unit, "BOTTOM"..pos, invert*size/5.2, -size/2.98)
      unit.dragonBottom:SetParent(unit.hp.bar)

      if elite == "worldboss" then
        unit.dragonTop:SetTexture(addonpath.."\\img\\TOP_GOLD_"..pos)
        unit.dragonTop:Show()
        unit.dragonTop:SetVertexColor(.85,.15,.15,1)
        unit.dragonBottom:SetTexture(addonpath.."\\img\\BOTTOM_GOLD_"..pos)
        unit.dragonBottom:Show()
        unit.dragonBottom:SetVertexColor(.85,.15,.15,1)
      elseif elite == "rareelite" then
        unit.dragonTop:SetTexture(addonpath.."\\img\\TOP_GOLD_"..pos)
        unit.dragonTop:Show()
        unit.dragonTop:SetVertexColor(1,1,1,1)
        unit.dragonBottom:SetTexture(addonpath.."\\img\\BOTTOM_GOLD_"..pos)
        unit.dragonBottom:Show()
        unit.dragonBottom:SetVertexColor(1,1,1,1)
      elseif elite == "elite" then
        unit.dragonTop:SetTexture(addonpath.."\\img\\TOP_GOLD_"..pos)
        unit.dragonTop:Show()
        unit.dragonTop:SetVertexColor(.75,.6,0,1)
        unit.dragonBottom:SetTexture(addonpath.."\\img\\BOTTOM_GOLD_"..pos)
        unit.dragonBottom:Show()
        unit.dragonBottom:SetVertexColor(.75,.6,0,1)
      elseif elite == "rare" then
        unit.dragonTop:SetTexture(addonpath.."\\img\\TOP_GRAY_"..pos)
        unit.dragonTop:Show()
        unit.dragonTop:SetVertexColor(.8,.8,.8,1)
        unit.dragonBottom:SetTexture(addonpath.."\\img\\BOTTOM_GRAY_"..pos)
        unit.dragonBottom:Show()
        unit.dragonBottom:SetVertexColor(.8,.8,.8,1)
      else
        unit.dragonTop:Hide()
        unit.dragonBottom:Hide()
      end
    end

    HookRefreshUnit(this, unit, component)
  end
end)
