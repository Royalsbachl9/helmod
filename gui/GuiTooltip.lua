-------------------------------------------------------------------------------
-- Class to help to build GuiTooltip
--
-- @module GuiTooltip
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltip
--
GuiTooltip = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] element
-- @param #table element
-- @return #GuiCell
--
function GuiTooltip:element(element)
  self.m_element = element
  return self
end

-------------------------------------------------------------------------------
-- Get tooltip for container
--
-- @function [parent=#GuiTooltip] container
--
-- @param #lua_product element
-- @param #string container name
--
-- @return #table
--
function GuiTooltip.container(element, container)
  local entity_prototype = EntityPrototype(container)
  local tooltip = {"tooltip.cargo-info", entity_prototype:getLocalisedName()}
  local product_prototype = Product(element)
  local total_tooltip = {"tooltip.cargo-info-element", {"helmod_common.total"}, Format.formatNumberElement(product_prototype:countContainer(element.count, container))}
  if element.limit_count ~= nil then
    local limit_tooltip = {"tooltip.cargo-info-element", {"helmod_common.per-sub-block"}, Format.formatNumberElement(product_prototype:countContainer(element.limit_count, container))}
    table.insert(tooltip, limit_tooltip)
    table.insert(tooltip, total_tooltip)
  else
    table.insert(tooltip, total_tooltip)
    table.insert(tooltip, "")
  end
  return tooltip
end

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltip] create
--
function GuiTooltip:create()
  local tooltip = {""}
  if string.find(self.name[1], "edit[-]") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-edit]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "add[-]") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-add]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "remove[-]") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-remove]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "info[-]") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-info]", " ", "[color=229,229,229]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "set[-]default") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-record]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "apply[-]block") then
    table.insert(self.name, {self.options.tooltip})
    table.insert(tooltip, {"", "[img=helmod-tooltip-play]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "apply[-]line") then
    table.insert(self.name, {self.options.tooltip})
    table.insert(tooltip, {"", "[img=helmod-tooltip-end]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  elseif string.find(self.name[1], "module[-]clear") then
    table.insert(tooltip, {"", "[img=helmod-tooltip-erase]", " ", "[color=255,222,61]", "[font=default-bold]", self.name, "[/font]", "[/color]"})
  else
    table.insert(tooltip, {"", "[img=helmod-tooltip-blank]", " ", "[font=default-bold]", self.name, "[/font]"})
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipElement
--
GuiTooltipElement = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipElement] create
--
function GuiTooltipElement:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    local type = self.m_element.type
    if self.m_element.type == "resource" then type = "entity" end
    table.insert(tooltip, {"", "\n", string.format("[%s=%s]", type, self.m_element.name), " ", "[color=255,230,192]", "[font=default-bold]", Player.getLocalisedName({type=type, name=self.m_element.name}), "[/font]", "[/color]"})
    -- quantity
    local total_count = Format.formatNumberElement(self.m_element.count)
    if self.m_element.limit_count ~= nil then
      local limit_count = Format.formatNumberElement(self.m_element.limit_count)
      table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", "[font=default-bold]", {"helmod_common.quantity"}, ": ", "[/font]", "[/color]", limit_count or 0, "/", total_count})
    else
      table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", "[font=default-bold]", {"helmod_common.quantity"}, ": ", "[/font]", "[/color]", total_count or 0})
    end
    if User.getModGlobalSetting("debug") ~= "none" then
      table.insert(tooltip, {"", "\n", "----------------------"})
      table.insert(tooltip, {"", "\n", "[img=developer]", " ", "Name", ": ", "[font=default-bold]", self.m_element.name or "nil", "[/font]"})
      table.insert(tooltip, {"", "\n", "[img=developer]", " ", "Type", ": ", "[font=default-bold]", self.m_element.type or "nil", "[/font]"})
      table.insert(tooltip, {"", "\n", "[img=developer]", " ", "State", ": ", "[font=default-bold]", self.m_element.state or 0, "[/font]"})
    end
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipFactory
--
GuiTooltipFactory = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipFactory] create
--
function GuiTooltipFactory:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    local type = "item"
    local prototype = ItemPrototype(self.m_element.name)
    table.insert(tooltip, {"", "\n", string.format("[%s=%s]", type, self.m_element.name), " ", "[color=255,230,192]", "[font=default-bold]", prototype:getLocalisedName(), "[/font]", "[/color]"})
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipEnergy
--
GuiTooltipEnergy = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipEnergy] create
--
function GuiTooltipEnergy:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    local power = Format.formatNumberKilo(self.m_element.energy_total or self.m_element.power, "W")
    table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"description.energy-consumption"}, ": ", "[/color]", "[font=default-bold]", power, "[/font]"})
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipBlock
--
GuiTooltipBlock = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipBlock] create
--
function GuiTooltipBlock:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    local quantity = self.m_element.count
    table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"helmod_common.quantity"}, ": ", "[/color]", "[font=default-bold]", quantity, "[/font]"})
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipModule
--
GuiTooltipModule = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipModule] create
--
function GuiTooltipModule:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    local module_prototype = ItemPrototype(self.m_element.name)
    local module = module_prototype:native()
    if module ~= nil then
      table.insert(tooltip, {"", "\n", string.format("[%s=%s]", self.m_element.type, self.m_element.name), " ", "[color=255,230,192]", "[font=default-bold]", module_prototype:getLocalisedName(), "[/font]", "[/color]"})
      local bonus_consumption = Player.getModuleBonus(module.name, "consumption")
      local bonus_speed = Player.getModuleBonus(module.name, "speed")
      local bonus_productivity = Player.getModuleBonus(module.name, "productivity")
      local bonus_pollution = Player.getModuleBonus(module.name, "pollution")

      local bonus_consumption_positive = "+"
      if bonus_consumption <= 0 then bonus_consumption_positive = "" end
      if bonus_consumption ~= 0 then
        table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"description.consumption-bonus"}, ": ", "[/color]", "[font=default-bold]", bonus_consumption_positive, Format.formatPercent(bonus_consumption), "%", "[/font]"})
      end
      local bonus_speed_positive = "+"
      if bonus_speed <= 0 then bonus_speed_positive = "" end
      if bonus_speed ~= 0 then
        table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"description.speed-bonus"}, ": ", "[/color]", "[font=default-bold]", bonus_speed_positive, Format.formatPercent(bonus_speed), "%", "[/font]"})
      end
      local bonus_productivity_positive = "+"
      if bonus_productivity <= 0 then bonus_productivity_positive = "" end
      if bonus_productivity ~= 0 then
        table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"description.productivity-bonus"}, ": ", "[/color]", "[font=default-bold]", bonus_productivity_positive, Format.formatPercent(bonus_productivity), "%", "[/font]"})
      end
      local bonus_pollution_positive = "+"
      if bonus_pollution <= 0 then bonus_pollution_positive = "" end
      if bonus_pollution ~= 0 then
        table.insert(tooltip, {"", "\n", "[img=helmod-tooltip-blank]", " ", "[color=255,230,192]", {"description.pollution-bonus"}, ": ", "[/color]", "[font=default-bold]", bonus_pollution_positive, Format.formatPercent(bonus_pollution), "%", "[/font]"})
      end
    end
  end
  return tooltip
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTooltip] constructor
-- @param #arg name
-- @return #GuiTooltipPriority
--
GuiTooltipPriority = newclass(GuiTooltip,function(base,...)
  GuiTooltip.init(base,...)
  base.classname = "HMGuiTooltip"
end)

-------------------------------------------------------------------------------
-- Create tooltip
--
-- @function [parent=#GuiTooltipModule] create
--
function GuiTooltipPriority:create()
  local tooltip = self._super.create(self)
  if self.m_element then
    for i,priority in pairs(self.m_element) do
      local module_prototype = ItemPrototype(priority.name)
      table.insert(tooltip, {"", "\n", string.format("[%s=%s]", "item", priority.name), " ", "[font=default-bold]", priority.value, " x ", "[/font]", "[color=255,230,192]", module_prototype:getLocalisedName(), "[/color]"})
    end
  end
  return tooltip
end



