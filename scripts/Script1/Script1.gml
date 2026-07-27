/**
 * @function ImColor
 * @constructor
 * @context ImGM
 * @desc Creates a GM-side struct for a color to be used with ImGui color editors and pickers.
 * It is used by Color*4 functions. Use .Color to get BGR value for GM functions
 *
 * @example
 * ImColor(c_red);
 * ImColor(c_red, 0.5);
 * ImColor(255, 255, 255);
 * ImColor(128, 255, 255, 0.5);
 * ImColor(c_red | (128 << 24)); Alpha is most-significant byte, basically RGBA int
 *
 */
function ImColor(red, green=undefined, blue=undefined, alpha=1) constructor {
    a = alpha;
    if (blue != undefined) {
        r = red;
        g = green;
        b = blue;
    } else {
        r = color_get_red(red);
        g = color_get_green(red);
        b = color_get_blue(red);

        if (green != undefined) {
            a = green;
        } else {
            /// Feather ignore GM1044
            var high = (red >> 24) & 0xFF;
            if (high > 0) {
                a = high / 0xFF;
            }
        }
    }

    static Color = function() {
        return r | (g << 8) | (b << 16);
    }

    static Alpha = function() {
        return a;
    }
}

/**
 * @function ImGuiWindowClass
 * @constructor
 * @context ImGM
 * @desc Creates a GM-side struct for ImGui window classes
 * It is created and sent to ImGui backend on setting the window class calls.
 *
 */
function ImGuiWindowClass(class_id, parent_viewport_id=undefined, viewport_flags_override_set=ImGuiViewportFlags.None, viewport_flags_override_clear=ImGuiViewportFlags.None) constructor {
    ClassId = class_id;

    if (is_ptr(parent_viewport_id)) {
        parent_viewport_id = ImGui.GetViewPortId(parent_viewport_id);
    }
    ParentViewportId = parent_viewport_id; // -1

    ViewportFlagsOverrideSet = viewport_flags_override_set; // ImGuiViewportFlags.None
    ViewportFlagsOverrideClear = viewport_flags_override_clear; // ImGuiViewportFlags.None

    FocusRouteParentWindowId = undefined; // 0
    TabItemFlagsOverrideSet = undefined; // 0
    DockNodeFlagsOverrideSet = undefined; // 0
    DockingAlwaysTabBar = undefined; // false
    DockingAllowUnclassed = undefined; // true

    /* Unused */
    static Destroy = function() {};
}

/**
 * @function ImGuiSelectionBasicStorage
 * @constructor
 * @context ImGM
 * @desc Creates a GM-side struct for ImGuiSelectionBasicStorage. Use Destroy() when done.
 *
 */
function ImGuiSelectionBasicStorage(size=0, preserve_order=undefined) constructor {
    _Size = size;
    PreserveOrder = preserve_order; // false

	__ptr = ImGui.CreateMultiSelectBasicStorage(self);

    static GetSize = function() {
        _Size = ImGui.SelectionStorageSize(self, undefined);
        return _Size;
    }

    static SetSize = function(set_value=undefined) {
        _Size = ImGui.SelectionStorageSize(self, set_value);
    }

    /// @param {ImGuiMultiSelectIO} ms_io
    static ApplyRequests = function(ms_io) {
		ImGui.SelectionStorageApplyRequests(self, ms_io);
    }

    /// check if an item is in the storage (used with SetNextItemUserStorage(idx))
    /// @param {Any} idx The user data to check
    /// @return {Bool}
    static Contains = function(idx) {
        return ImGui.SelectionStorageContains(self, idx);
    }

    static Destroy = function() {
        ImGui.DestroyMultSelectBasicStorage(self);
    }
}