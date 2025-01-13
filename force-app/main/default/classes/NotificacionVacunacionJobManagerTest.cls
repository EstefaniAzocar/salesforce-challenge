@isTest
private class NotificacionVacunacionJobManagerTest {

    @isTest static void testCancelarJobProgramado() {
        // Crear un job programado para el test
        String cronExp = '0 0 0 1 1 ?';  // Ejemplo de cron
        NotificacionVacunacionScheduler scheduler = new NotificacionVacunacionScheduler();
        System.schedule('Notificacion Vacunacion Job', cronExp, scheduler);

        // Verificar que el job está programado
        CronTrigger[] jobsBefore = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Notificacion Vacunacion Job'];
        System.assertEquals(1, jobsBefore.size(), 'Debe haber un job programado');

        // Llamar al método para cancelar el job
        Test.startTest();
        NotificacionVacunacionJobManager.cancelarJobProgramado();
        Test.stopTest();

        // Verificar que el job fue cancelado
        CronTrigger[] jobsAfter = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Notificacion Vacunacion Job'];
        System.assertEquals(0, jobsAfter.size(), 'El job debe haber sido cancelado');
    }
}