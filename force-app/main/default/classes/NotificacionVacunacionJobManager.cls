public class NotificacionVacunacionJobManager {
    public static void cancelarJobProgramado() {
        // Cancelar el job anterior (si existe)
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Notificacion Vacunacion Job'];
        for (CronTrigger job : jobs) {
            System.abortJob(job.Id);
        }
    }
}