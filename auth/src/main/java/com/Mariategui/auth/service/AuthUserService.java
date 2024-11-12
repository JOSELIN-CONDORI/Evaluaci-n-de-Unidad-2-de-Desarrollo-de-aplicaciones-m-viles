package com.Mariategui.auth.service;

import java.time.LocalDateTime;
import java.util.List;

import com.Mariategui.auth.dto.AuthUserDto;
import com.Mariategui.auth.entity.AuthUser;
import com.Mariategui.auth.entity.TokenDto;
import java.util.Optional;

public interface AuthUserService {
    public AuthUser save(AuthUserDto authUserDto);

    public TokenDto login(AuthUserDto authUserDto);

    public TokenDto validate(String token);

    public List<AuthUser> listar();

    public AuthUser actualizar(AuthUser authUser);

    public Optional<AuthUser> listarPorId(Integer id);

    public void eliminarPorId(Integer id);

    // confirmar contraseña
    public boolean isPasswordConfirmed(AuthUserDto authUserDto);

    AuthUserDto getUserData(String email);

    List<AuthUser> buscar(String name, LocalDateTime created_at, LocalDateTime updated_at, String codigo);

}
