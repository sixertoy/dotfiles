const Main = imports.ui.main;

let activities;

function init()
{
    activities = Main.panel.statusArea['activities'];
}

function enable()
{
    activities.container.hide();
}

function disable()
{
    activities.container.show();
}
