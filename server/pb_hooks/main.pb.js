onBootstrap((e) => {
    e.next();
});

cronAdd("removeStaleData", "*/1 * * * *", async () => {
    const removeInactiveParticipantsQuery = `
        DELETE FROM participants
        WHERE updated <= datetime('now', '-5 minutes')
    `;

    const removeEmptyRoomsQuery = `
        DELETE FROM rooms
        WHERE id NOT IN (SELECT DISTINCT room FROM participants)
        AND updated <= datetime('now', '-1 day')
    `;

    const db = $app.db();

    const resultParticipants = await db
        .newQuery(removeInactiveParticipantsQuery)
        .execute();

    const resultRooms = await db
        .newQuery(removeEmptyRoomsQuery)
        .execute();

    console.log(`Removed ${resultParticipants.rowsAffected()} participants and ${resultRooms.rowsAffected()} empty rooms.`);
});