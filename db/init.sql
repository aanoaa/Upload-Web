CREATE TABLE upload (
    id           INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    md5          TEXT    NOT NULL,
    fname        TEXT    NOT NULL,
    download     INTEGER NOT NULL DEFAULT 0,
    max_download INTEGER NOT NULL DEFAULT 0
);
