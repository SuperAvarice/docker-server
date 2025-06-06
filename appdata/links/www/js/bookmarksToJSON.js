'use strict'

String.prototype.remove = function (toRemove) {
    if (Array.isArray(toRemove)) {
        return toRemove.reduce((acc, value) => acc.replace(value, ''), this);
    }
    if (typeof toRemove === 'string') {
        return this.replace(toRemove, '');
    }
    return this;
};

const cleanupObject = (obj) => {
    Object.keys(obj).forEach((key) => (obj[key] === undefined ? delete obj[key] : {}));
    return obj;
};

const isFolder = (item) => !!item.match(/<H3.*>.*<\/H3>/);
const isLink = (item) => !!item.match(/<A.*>.*<\/A>/);
const getTitle = (item) => item.match(/<(H3|A).*>(.*)<\/(H3|A)>/)?.[2];
const getIcon = (item) => item.match(/ICON="(.+)"/)?.[1];
const getUrl = (item) => item.match(/HREF="([^"]*)"/)?.[1];

const transformLink = (markup) => {
    let type = 'file';
    if (getUrl(markup) === 'about:blank') {
        type = 'line';
    }
    return cleanupObject({
        type: type,
        text: getTitle(markup),
        icon: getIcon(markup),
        a_attr: {
            href: getUrl(markup),
        },
    });
};

const transformFolder = (markup) => cleanupObject({ type: 'folder', text: getTitle(markup), });

const findItemsAtIndentLevel = (markup, level) => markup.match(new RegExp(`^\\s{${level * 4}}<DT>(.*)[\r\n]`, 'gm'));

const findLinks = (markup, level) => findItemsAtIndentLevel(markup, level).filter(isLink);

const findFolders = (markup, level) => {
    const folders = findItemsAtIndentLevel(markup, level);
    return folders?.map((folder, index) => {
        const isLastOne = index === folders.length - 1;
        return markup.substring(
            markup.indexOf(folder),
            isLastOne ? undefined : markup.indexOf(folders[index + 1]),
        );
    });
};

const findChildren = (markup, level = 1) => {
    if (findItemsAtIndentLevel(markup, level)) {
        const links = findLinks(markup, level);
        const folders = findFolders(markup.remove(links), level);
        return [...(folders || []), ...(links || [])];
    }
};

const processChild = (child, level = 1) => {
    if (isFolder(child)) return processFolder(child, level);
    if (isLink(child)) return transformLink(child);
};

const processFolder = (folder, level) => {
    const children = findChildren(folder, level + 1);
    const state = (getTitle(folder) === 'Bookmarks bar' ? { opened: true } : undefined)
    return cleanupObject({
        ...transformFolder(folder),
        children: children?.map((child) => processChild(child, level + 1))?.filter(Boolean),
        state: state,
    });
};

/**
 * Convert NETSCAPE-Bookmark-file to JSON format
 * @param {string} markup - The content of the bookmarks file
 * @returns The bookmarks in JSON format
 * @see https://github.com/zorapeteri/bookmarks-to-json
 */
const bookmarksToJSON = (markup) => { return findChildren(markup)?.map(child => processChild(child)); };
