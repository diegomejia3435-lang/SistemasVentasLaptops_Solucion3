package interfaces;

import modelo.Usuario;

public interface IUsuarioDAO {
    Usuario validar(String correo, String password);
}
