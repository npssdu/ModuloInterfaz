/**
 * cliente.js - JavaScript del Sistema de Registro de Clientes
 * Gabinete de Abogados
 * 
 * Funciones:
 * - buscarCliente(): Busca un cliente por código
 * - guardarCliente(): Guarda o actualiza un cliente
 * - mostrarMensaje(): Muestra mensajes de notificación
 */

/**
 * Función para buscar cliente mediante AJAX
 * Se activa al presionar el botón Buscar
 */
function buscarCliente() {
    const codCliente = document.getElementById('codClienteBusqueda').value.trim();
    
    if (!codCliente) {
        mostrarMensaje('Por favor ingrese un código de cliente', 'error');
        return;
    }
    
    // Mostrar indicador de carga
    const btnSearch = document.querySelector('.btn-search');
    const textoOriginal = btnSearch.textContent;
    btnSearch.innerHTML = '<span class="spinner"></span>Buscando...';
    btnSearch.disabled = true;
    
    // Crear formulario para POST
    const formData = new FormData();
    formData.append('codCliente', codCliente);
    formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);
    
    // Realizar consulta AJAX
    fetch(URL_BUSCAR_CLIENTE, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.exito) {
            // Rellenar formulario con datos encontrados
            document.getElementById('codCliente').value = data.datos.codCliente;
            document.getElementById('nomCliente').value = data.datos.nomCliente;
            document.getElementById('apellCliente').value = data.datos.apellCliente;
            document.getElementById('nDocumento').value = data.datos.nDocumento;
            document.getElementById('idTipoDoc').value = data.datos.idTipoDoc;
            
            mostrarMensaje(`Cliente encontrado: ${data.datos.nomCliente} ${data.datos.apellCliente}`, 'info');
        } else {
            mostrarMensaje(data.mensaje, 'error');
        }
    })
    .catch(error => {
        mostrarMensaje('Error en la búsqueda: ' + error, 'error');
        console.error('Error:', error);
    })
    .finally(() => {
        // Restaurar botón
        btnSearch.innerHTML = textoOriginal;
        btnSearch.disabled = false;
    });
}

/**
 * Función para guardar cliente
 * Se activa al presionar botón Guardar
 */
function guardarCliente(event) {
    event.preventDefault();
    
    const codCliente = document.getElementById('codCliente').value.trim();
    const nomCliente = document.getElementById('nomCliente').value.trim();
    const apellCliente = document.getElementById('apellCliente').value.trim();
    const nDocumento = document.getElementById('nDocumento').value.trim();
    const idTipoDoc = document.getElementById('idTipoDoc').value.trim();
    
    // Validaciones cliente-side
    if (!codCliente || !nomCliente || !apellCliente || !nDocumento || !idTipoDoc) {
        mostrarMensaje('Todos los campos son obligatorios', 'error');
        return;
    }
    
    if (codCliente.length > 5) {
        mostrarMensaje('Código de cliente no puede exceder 5 caracteres', 'error');
        return;
    }
    
    if (nomCliente.length > 30 || apellCliente.length > 30) {
        mostrarMensaje('Nombre y apellido no pueden exceder 30 caracteres', 'error');
        return;
    }
    
    if (nDocumento.length > 15) {
        mostrarMensaje('Número de documento no puede exceder 15 caracteres', 'error');
        return;
    }
    
    // Crear formulario para POST
    const formData = new FormData();
    formData.append('codCliente', codCliente);
    formData.append('nomCliente', nomCliente);
    formData.append('apellCliente', apellCliente);
    formData.append('nDocumento', nDocumento);
    formData.append('idTipoDoc', idTipoDoc);
    formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);
    
    // Mostrar indicador de carga
    const btnSave = document.querySelector('.btn-save');
    const textoOriginal = btnSave.textContent;
    btnSave.innerHTML = '<span class="spinner"></span>Guardando...';
    btnSave.disabled = true;
    
    // Realizar guardado mediante AJAX
    fetch(URL_GUARDAR_CLIENTE, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.exito) {
            mostrarMensaje(data.mensaje, 'success');
            document.getElementById('formRegistro').reset();
            document.getElementById('codClienteBusqueda').value = '';
        } else {
            mostrarMensaje(data.mensaje, 'error');
        }
    })
    .catch(error => {
        mostrarMensaje('Error al guardar: ' + error, 'error');
        console.error('Error:', error);
    })
    .finally(() => {
        // Restaurar botón
        btnSave.innerHTML = textoOriginal;
        btnSave.disabled = false;
    });
}

/**
 * Función auxiliar para mostrar mensajes
 */
function mostrarMensaje(mensaje, tipo) {
    const divMensaje = document.getElementById('mensaje');
    divMensaje.textContent = mensaje;
    divMensaje.className = `message ${tipo}`;
    
    // Auto-ocultar después de 5 segundos
    setTimeout(() => {
        divMensaje.className = 'message';
    }, 5000);
}

/**
 * Al cargar la página
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Página cargada - Sistema de Registro de Clientes listo');
});
