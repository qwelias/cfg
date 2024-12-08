if ( get_application_name():lower() == 'xdg-desktop-portal-gtk' and get_window_type():lower() == 'window_type_dialog' )
then
    focus_window();
end

-- debug_print("Application: " .. get_application_name():lower())
-- debug_print("Window: " .. get_window_name():lower());
-- debug_print("Window: " .. get_window_type():lower());
