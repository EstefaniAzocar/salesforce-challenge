import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAdopcionDetails from '@salesforce/apex/AdopcionController.getAdopcionDetails';
import updateAdopcionState from '@salesforce/apex/AdopcionController.updateAdopcionState';
import { refreshApex } from '@salesforce/apex';

export default class DetallesAdopcion extends LightningElement {
    @api recordId; // ID del registro de adopción
    adopcion; // Almacenar los detalles de la adopción
    isAdopted = false; // Variable para verificar si la adopción es finalizada

    // Llamada a Apex para obtener los detalles de la adopción
    @wire(getAdopcionDetails, { recordId: '$recordId' })
    wiredAdopcion({ error, data }) {
        if (data) {
            this.adopcion = data;
            // Verificar si la adopción es finalizada
            this.isAdopted = this.adopcion.Estado__c === 'Finalizada';  // Asegúrate de que el campo sea Estado__c
        } else if (error) {
            this.showToast('Error', 'Hubo un error al obtener los detalles de la adopción', 'error');
        }
    }

    // Método para cambiar el estado de la adopción
    handleChangeState() {
        const newState = 'Nuevo Estado'; // Puedes reemplazar esto por un valor específico
        updateAdopcionState({ recordId: this.recordId, newState })
            .then(() => {
                this.showToast('Éxito', 'Estado de adopción actualizado', 'success');
                // Refresca los detalles
                return refreshApex(this.adopcion);
            })
            .catch(error => {
                this.showToast('Error', 'Hubo un error al actualizar el estado de la adopción', 'error');
            });
    }

    // Método para mostrar notificaciones (toast)
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
