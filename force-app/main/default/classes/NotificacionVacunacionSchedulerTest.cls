@isTest
public class NotificacionVacunacionSchedulerTest {

    @isTest
    static void testSchedulerJob() {
        // Crear la instancia del scheduler
        NotificacionVacunacionScheduler scheduler = new NotificacionVacunacionScheduler();
        
        // Programar el job
        String cronExp = '0 0 0 1 1 ?';  // Ejecutar una vez al año
        Test.startTest();
        System.schedule('Notificacion Vacunacion Job', cronExp, scheduler);
        Test.stopTest();
        
        // Verificar que el cron job ha sido programado
        CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE CronJobDetail.Name = 'Notificacion Vacunacion Job' LIMIT 1];
        
        // Asegurarse de que la expresión cron es la correcta
        System.assertEquals('0 0 0 1 1 ?', ct.CronExpression, 'La expresión cron debe ser correcta');
    }
}