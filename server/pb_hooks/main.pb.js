onBootstrap((e) => {
    e.next();
});

cronAdd("removeInactiveParticipants", "*/1 * * * *", async () => {

    const now = new Date();
    const fiveMinutesAgo = new Date(now.getTime() - 5 * 60 * 1000).toISOString();

    console.log("cron removeInactiveParticipants older then 5 minutes ago: ", fiveMinutesAgo);

    const participants = await $app.findRecordsByFilter(
        'participants',
        "updated <= '${fiveMinutesAgo}'"
    );

    for (const participant of participants) {
        console.log(`Removing inactive participant: ${participant.id}, ${participant.updated}`);
        await $app.delete(participant);
    }
});