package com.Mariategui.auth.service.impl;

import com.Mariategui.auth.dto.AuthUserDto;
import com.Mariategui.auth.entity.AuthUser;
import com.Mariategui.auth.entity.TokenDto;
import com.Mariategui.auth.repository.AuthRepository;
import com.Mariategui.auth.repository.EmailAlreadyExistsException;
import com.Mariategui.auth.security.JwtProvider;
import com.Mariategui.auth.service.AuthUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AuthUserServiceImpl implements AuthUserService {
    @Autowired
    AuthRepository authRepository;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    JwtProvider jwtProvider;

    @Override
    public AuthUserDto getUserData(String email) {
        Optional<AuthUser> user = authRepository.findByEmail(email);
        if (user.isPresent()) {
            AuthUserDto userDto = new AuthUserDto();
            userDto.setId(user.get().getId());
            userDto.setRole(user.get().getRole());
            userDto.setName(user.get().getName());
            userDto.setPassword(user.get().getPassword());
            userDto.setFoto(user.get().getFoto());
            userDto.setApellido_m(user.get().getApellido_m());
            userDto.setApellido_p(user.get().getApellido_p());
            userDto.setDni(user.get().getDni());
            userDto.setCodigo(user.get().getCodigo());
            userDto.setEmail(user.get().getEmail());
            userDto.setCreated_at(user.get().getCreated_at());
            userDto.setUpdated_at(user.get().getUpdated_at());
            // Agregar más asignaciones de campos según sea necesario
            return userDto;
        }
        return null;
    }

    @Override
    public List<AuthUser> buscar(String name, LocalDateTime created_at, LocalDateTime updated_at, String codigo) {
        return authRepository.buscarPorParametros(name, created_at, updated_at, codigo);
    }

    @Override
    public AuthUser save(AuthUserDto authUserDto) {
        Optional<AuthUser> user = authRepository.findByEmail(authUserDto.getEmail());
        if (user.isPresent()) {
            throw new EmailAlreadyExistsException("El correo electrónico ya está registrado.");
        }
        String password = passwordEncoder.encode(authUserDto.getPassword());
        LocalDateTime currentDateTime = LocalDateTime.now(); // Obtén la fecha y hora actual
        AuthUser authUser = AuthUser.builder()
                .name(authUserDto.getName()) // Mapea el nombre
                .role(authUserDto.getRole() != null ? authUserDto.getRole() : "user")
                // .role(authUserDto.getRole()) // Mapea el rol
                .email(authUserDto.getEmail())

                .apellido_m(authUserDto.getApellido_m())
                .apellido_p(authUserDto.getApellido_p())
                .dni(authUserDto.getDni())
                .codigo(authUserDto.getCodigo())

                .foto(authUserDto.getFoto())
                // .created_at(authUserDto.getCreated_at())
                // .updated_at(authUserDto.getUpdated_at())
                .created_at(currentDateTime) // Establece la fecha de creación actual
                .updated_at(currentDateTime) // Establece la fecha de actualización actual
                .password(password)
                .build();

        return authRepository.save(authUser);
    }

    @Override
    public TokenDto login(AuthUserDto authUserDto) {
        Optional<AuthUser> user = authRepository.findByEmail(authUserDto.getEmail());
        if (!user.isPresent())
            return null;
        if (passwordEncoder.matches(authUserDto.getPassword(), user.get().getPassword()))
            return new TokenDto(jwtProvider.createToken(user.get()));
        return null;
    }

    @Override
    public TokenDto validate(String token) {
        if (!jwtProvider.validate(token))
            return null;
        String email = jwtProvider.getEmailFromToken(token);
        if (!authRepository.findByEmail(email).isPresent())
            return null;

        return new TokenDto(token);
    }

    @Override
    public List<AuthUser> listar() {
        return authRepository.findAll();
    }

    @Override
    public AuthUser actualizar(AuthUser authUser) {
        // Buscar un usuario con el nuevo correo electrónico
        Optional<AuthUser> user = authRepository.findByEmail(authUser.getEmail());
        // Verificar si el nuevo correo electrónico ya está registrado
        if (user.isPresent() && user.get().getId() != authUser.getId()) {
            throw new EmailAlreadyExistsException("El nuevo correo electrónico ya está registrado.");
        }
        return authRepository.save(authUser);
    }

    @Override
    public Optional<AuthUser> listarPorId(Integer id) {
        return authRepository.findById(id);
    }

    @Override
    public void eliminarPorId(Integer id) {
        authRepository.deleteById(id);
    }

    // confirmar contraseña
    @Override
    public boolean isPasswordConfirmed(AuthUserDto authUserDto) {
        return authUserDto.getPassword().equals(authUserDto.getConfirmPassword());
    }

}