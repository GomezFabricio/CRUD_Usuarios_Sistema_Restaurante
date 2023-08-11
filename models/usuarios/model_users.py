from config import mysql

class UserModel():
    
    def __init__(self, dni = 0, nombre = "", apellido = "", telefono = 0, idUsuario = 0, idRol = 0, idPersona = 0, usuario = "", password = ""):
        self.dni = dni
        self.nombre = nombre
        self.apellido = apellido
        self.telefono = telefono
        self.id_usuario = idUsuario
        self.id_rol = idRol
        self.id_persona = idPersona
        self.usuario = usuario
        self.password = password
        self.database = mysql.connection


    def ListUsers(self):
        with self.database.cursor() as cursor:
            sql = "SELECT p.nombre, p.apellido, p.telefono, u.usuario, u.pass, r.rol, p.dni, u.idUsuario FROM usuarios u LEFT JOIN personas p ON p.idPersona = u.idPersona LEFT JOIN roles r ON r.idRol = u.idRol"

            cursor.execute(sql)
            resultados = cursor.fetchall()

        return resultados


    def AddUser(self):

        with self.database.cursor() as cursor:
            sql_insert_persona = "INSERT INTO personas (dni, nombre, apellido, telefono) VALUES (%s, %s, %s, %s)"
            values_persona = (self.dni, self.nombre, self.apellido, self.telefono)
            cursor.execute(sql_insert_persona, values_persona)

            sql_ultimo_id = "SELECT LAST_INSERT_ID()"
            cursor.execute(sql_ultimo_id)
            id_persona = cursor.fetchone()
            self.id_persona = id_persona[0]

            sql_insert_user = "INSERT INTO usuarios (idRol, idPersona, usuario, pass) VALUES (%s, %s, %s, %s)"
            values_users = (self.id_rol, self.id_persona, self.usuario, self.password)
            cursor.execute(sql_insert_user, values_users)

        self.database.commit()


    def DeleteUser(self):
        user = self.get_user_by_id()
        self.id_persona = user[0]

        with self.database.cursor() as cursor:
            sql_delete_user = "DELETE FROM usuarios WHERE idUsuario = %s"
            cursor.execute(sql_delete_user, (self.id_usuario,))

            sql_delete_persona = "DELETE FROM personas WHERE idPersona = %s"
            cursor.execute(sql_delete_persona, (self.id_persona,))
        self.database.commit()


    def UpdateUser(self):
        print(self.nombre)
        print(self.usuario)

        with self.database.cursor() as cursor:
            # Actualizar los datos del usuario en la tabla personas
            sql_update_persona = "UPDATE personas SET dni = %s, nombre = %s, apellido = %s, telefono = %s WHERE idPersona = (SELECT idPersona FROM usuarios WHERE idUsuario = %s)"
            values_persona = (self.dni, self.nombre, self.apellido, self.telefono, self.id_usuario)
            print(values_persona)
            cursor.execute(sql_update_persona, values_persona)

            # Actualizar los datos del usuario en la tabla usuarios
            sql_update_usuario = "UPDATE usuarios SET idRol = %s, usuario = %s, pass = %s WHERE idUsuario = %s"
            values_usuarios = (self.id_rol, self.usuario, self.password, self.id_usuario)
            cursor.execute(sql_update_usuario, values_usuarios)

        self.database.commit()

    
    def get_roles(self):
        with self.database.cursor() as cursor:
            sql_rol = "SELECT * FROM roles"
            cursor.execute(sql_rol)
            rol = cursor.fetchall()
            return rol

    def get_rol_by_id(self):
        with self.database.cursor() as cursor:
            sql_rol = "SELECT * FROM roles WHERE idRol = %s"
            cursor.execute(sql_rol, (self.id_rol,))
            rol = cursor.fetchall()
            return rol       

    def get_user_by_id(self):
        with self.database.cursor() as cursor:
            query = "SELECT p.idPersona, r.rol, u.usuario, u.pass, p.dni, p.nombre, p.apellido, p.telefono, u.idUsuario FROM usuarios u LEFT JOIN personas p ON p.idPersona = u.idPersona LEFT JOIN roles r ON r.idRol = u.idRol WHERE u.idUsuario = %s"
            cursor.execute(query, (self.id_usuario,))
            usuario = cursor.fetchone()

        # Confirmar los cambios en la base de datos.
        self.database.commit()

        # Si el cliente no existe, devolver None
        if usuario is None:
            return None

        # Devolver los datos
        return usuario