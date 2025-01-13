public class NotificacionVacunacionScheduler implements Schedulable {

    // Este método es requerido por la interfaz Schedulable
    public void execute(SchedulableContext context) {
        // Primero cancelamos cualquier job programado previamente con el mismo nombre
        NotificacionVacunacionJobManager.cancelarJobProgramado();

        // Creamos la instancia de la clase Batch
        NotificacionVacunas batch = new NotificacionVacunas();
        
        // Ejecutamos el batch
        Database.executeBatch(batch);

        // Programamos el job nuevamente con una expresión cron
        String cronExp = '0 0 0 1 1 ?';  // Ejemplo de expresión cron para programar el job una vez al año
        System.schedule('Notificacion Vacunacion Job', cronExp, this);
    }
}