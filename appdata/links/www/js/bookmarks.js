// $(function () {
function main() {
    $.get('/data/bookmarks.html', function (bookmarks_html) {
        var bookmarks_json = bookmarksToJSON(bookmarks_html);
        $('#container').jstree({
            core: {
                data: bookmarks_json,
                multiple: false,
                themes: {
                    //variant: 'large',
                    icons: true,
                    dots: true,
                    //name: 'default-dark'
                },
                check_callback: function (operation, node, parent, position, more) {
                    if (operation === 'copy_node' || operation === 'move_node') {
                        if (parent.id === '#') {
                            return false; // prevent moving a child above or below the root
                        }
                    }
                    return true; // allow everything else
                }
            },
            contextmenu: {
                select_node: false,
                //items: customMenu()
            },
            types: {
                folder: { icon: '/images/yellow-folder-with-border-closed-16.png' },
                file: { icon: '/images/file-16.png' },
                line: { icon: 'none' },
            },
            plugins: ['types', 'contextmenu', 'unique', 'dnd', 'search']
        });
    });
    $('#container').on('changed.jstree', function (e, data) {
        if (data.hasOwnProperty('node')) {
            var href = data.node.a_attr.href;
            if (href == '#') { // folder
                data.instance.toggle_node(data.node);
            } else { // link
                window.open(href, 'window_' + data.selected);
            }
            data.instance.deselect_all();
        }
    });
    $('#container').on('open_node.jstree', function (e, data) {
        data.instance.set_icon(data.node, '/images/yellow-folder-with-border-open-16.png');
    });
    $('#container').on('close_node.jstree', function (e, data) {
        data.instance.set_icon(data.node, '/images/yellow-folder-with-border-closed-16.png');
    });
    $("#search").submit(function (e) {
        e.preventDefault();
        $("#container").jstree(true).search($("#query").val());
    });
}
// });

function customMenu(node) {
    // The default set of all items
    var items = {
        renameItem: { // The "rename" menu item
            label: "Rename",
            action: function () { }
        },
        deleteItem: { // The "delete" menu item
            label: "Delete",
            action: function () { }
        }
    };

    if ($(node).hasClass("folder")) {
        // Delete the "delete" menu item
        delete items.deleteItem;
    }

    return items;
}

// <!-- <body class="jstree-default-dark"> -->
// var element = document.body;
// element.classList.toggle("jstree-default-dark");
