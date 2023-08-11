from functools import wraps
from flask import render_template, session, redirect, url_for, request
from config import app
from flask import flash

# ================================================================================= #
# ===================================== LOGIN ===================================== #
# ================================================================================= #

# Función de verificación de sesión
def verificar_sesion(func):
    def wrapper(*args, **kwargs):
        if 'id_user' in session:
            # El usuario está en sesión, permite el acceso a la ruta
            return func(*args, **kwargs)
        else:
            # El usuario no está en sesión, redirige a la página de inicio de sesión
            return redirect(url_for('login'))

    # Asignar el nombre de la función original al envoltorio
    wrapper.__name__ = func.__name__
    return wrapper

@app.route('/', methods=['GET', 'POST'])
def login():
    from controllers.login.login_controllers import LoginController
    if request.method == 'POST':
        usuario = request.form['usuario']
        contrasena = request.form['contrasena']
        
        login_controller = LoginController(usuario, contrasena)  # Asigna el controlador a una variable
        user = login_controller.LoginUser()  # Utiliza el método login_user()

        if user:
            session['id_user'] = user[0]
            return redirect(url_for('ListClients'))
        else:
            return render_template('/login/login.html', error='Credenciales incorrectas! Por favor, vuelva a ingresarlas.') 
    return render_template('/login/login.html')

@app.route('/logout')
def Logout():
    session.clear()
    return redirect(url_for('login')) 

@app.route('/layout')
@verificar_sesion
def layout():
    return render_template('components/layout.html')

@app.route('/pagina_en_proceso')
def page_proceso():
    return render_template('/login/logout.html')

# ================================================================================== #
# ==================================== CLIENTES ==================================== #
# ================================================================================== #

@app.route('/list_clients')
@verificar_sesion
def ListClients():
    from controllers.clientes.controller_clients import ClientController

    clients_controller = ClientController()
    clients = clients_controller.GetClients()

    return render_template('/clientes/view_clients.html', clients = clients)


@app.route('/addClient', methods = ['GET','POST'])
@verificar_sesion
def AddClient():
    if request.method == 'POST':
        from controllers.clientes.controller_clients import ClientController

        nombre = request.form['nombre']
        apellido = request.form['apellido']
        telefono = request.form.get('telefono', default = 0)
        preferencias = request.form['preferencias']
        condicionesEspeciales = request.form['condiciones']

        clients_controller = ClientController()
        clients_controller.AddClient(nombre, apellido, telefono, preferencias, condicionesEspeciales)
        
        error_messages = clients_controller.error

        if error_messages:
            for error in error_messages:
                flash(f'Error al agregar el cliente: {error}', 'error')
            return render_template('/clientes/view_addClient.html')
        else:
            flash('Cliente agregado exitosamente', 'success')
            return redirect(url_for('ListClients'))
    else:  
        return render_template('/clientes/view_addClient.html')



@app.route('/deleteClient/<int:id>', methods = ['GET'])
@verificar_sesion
def DeleteClient(id):
    from controllers.clientes.controller_clients import ClientController

    clients_controller = ClientController()
    clients_controller.DeleteClient(id)

    return redirect(url_for('ListClients'))


@app.route('/updateClient/<int:id>', methods = ['GET', 'POST'])
@verificar_sesion
def UpdateClient(id):
    from controllers.clientes.controller_clients import ClientController

    clients_controller = ClientController()
    client = clients_controller.get_client_by_id(id)

    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        telefono = request.form.get('telefono', default="")
        fecha = request.form['fecha']
        preferencias = request.form['preferencias']
        condiciones_especiales = request.form['condiciones']

        clients_controller.UpdateClient(id, nombre, apellido, telefono, fecha, preferencias, condiciones_especiales)
        
        error = clients_controller.error
        if error:
            flash(f'Error al actualizar el cliente: {error}', 'error')
            return render_template('/clientes/view_updateClient.html', client=client)
        else:
            flash('Cliente actualizado exitosamente', 'success')
            return redirect(url_for('ListClients'))
    else:
        return render_template('/clientes/view_updateClient.html', client=client)


# ================================================================================== #
# ==================================== USUARIOS ==================================== #
# ================================================================================== #

@app.route('/users')
@verificar_sesion
def ListUsers():
    from controllers.usuarios.controller_users import UserController
    user_controller = UserController()
    user = user_controller.GetUsers()

    return render_template('/usuarios/view_users.html', users=user)


@app.route('/addUser', methods = ['GET','POST'])
@verificar_sesion
def AddUser():
    from controllers.usuarios.controller_users import UserController

    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        dni = request.form['dni']
        telefono = request.form['telefono']
        id_rol = int(request.form['id_rol'])
        usuario = request.form['usuario']
        password = request.form['password']
        user_controller = UserController(nombre = nombre, apellido = apellido, dni = dni, telefono = telefono, idRol = id_rol, usuario = usuario, password = password)
        user_controller.AddUser()

        error_messages = user_controller.error

        if error_messages:
            for error in error_messages:
                flash(f'Error al agregar el usuario: {error}', 'error')
            user_controller = UserController()
            roles = user_controller.get_roles()
            return render_template('/usuarios/view_addUser.html', roles=roles)
        else:
            flash('Usuario agregado exitosamente', 'success')
            return redirect(url_for('ListUsers'))
    else:
        user_controller = UserController()
        roles = user_controller.get_roles()
        return render_template('/usuarios/view_addUser.html', roles=roles)
    

@app.route('/deleteUser/<int:id>', methods = ['GET'])
@verificar_sesion
def DeleteUser(id):
    from controllers.usuarios.controller_users import UserController

    users_controller = UserController(idUsuario = id)
    users_controller.DeleteUser()

    return redirect(url_for('ListUsers'))


@app.route('/updateUser/<int:id>', methods=['GET', 'POST'])
@verificar_sesion
def UpdateUser(id):
    from controllers.usuarios.controller_users import UserController
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        dni = request.form['dni']
        telefono = request.form['telefono']
        id_rol = request.form['id_rol']
        usuario = request.form['usuario']
        password = request.form['password']
        
        users_controller = UserController(nombre=nombre, apellido=apellido, dni=dni, telefono=telefono, idRol=id_rol, idUsuario = id, usuario=usuario, password=password)
        users_controller.UpdateUser()
        print(id)
        

        error_messages = users_controller.error_messages
        if error_messages:
            for message in error_messages:
                flash(f'Error al actualizar el usuario: {message}', 'error')
            roles = users_controller.get_roles()
            user = users_controller.get_user_by_id()
            return render_template('/usuarios/view_updateUser.html', user=user, roles=roles)
        else:
            flash('Usuario actualizado exitosamente', 'success')
            return redirect(url_for('ListUsers'))
    else:
        users_controller = UserController(idUsuario = id)
        roles = users_controller.get_roles()
        user = users_controller.get_user_by_id()
        return render_template('/usuarios/view_updateUser.html', user=user, roles=roles)

@app.route('/disculpa')
@verificar_sesion
def proceso():
    return render_template('/components/pagina_en_proceso.html')
