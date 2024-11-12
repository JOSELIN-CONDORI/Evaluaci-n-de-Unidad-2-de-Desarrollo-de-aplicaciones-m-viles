package com.Mariategui.auth.controller;

import com.Mariategui.auth.dto.AuthResponseDto;
import com.Mariategui.auth.dto.AuthUserDto;
import com.Mariategui.auth.dto.CreateUserResponse;
// import com.Mariategui.auth.dto.LoginResponse;
import com.Mariategui.auth.entity.AuthUser;
import com.Mariategui.auth.entity.TokenDto;
import com.Mariategui.auth.service.AuthUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/auth")
public class AuthUserController {
    @Autowired
    AuthUserService authUserService;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> login(@RequestBody AuthUserDto authUserDto) {
        AuthResponseDto response = new AuthResponseDto();
        TokenDto token = authUserService.login(authUserDto);

        if (token == null) {
            return ResponseEntity.badRequest().build();
        }

        AuthUserDto authenticatedUser = authUserService.getUserData(authUserDto.getEmail()); // Obtener los datos del
                                                                                             // usuario autenticado

        if (authenticatedUser == null) {
            // Manejar el caso en el que no se pueda obtener los datos del usuario
            return ResponseEntity.badRequest().build();
        }

        response.setToken(token.getToken()); // Establecer el token directamente
        response.setUser(authenticatedUser);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/validate")
    public ResponseEntity<TokenDto> validate(@RequestParam String token) {
        TokenDto tokenDto = authUserService.validate(token);
        if (tokenDto == null)
            return ResponseEntity.badRequest().build();
        return ResponseEntity.ok(tokenDto);
    }

    @PostMapping("/create")
    public ResponseEntity<?> create(@RequestBody AuthUserDto authUserDto) {
        if (!authUserService.isPasswordConfirmed(authUserDto)) {
            return ResponseEntity.badRequest().body("Password and confirm password do not match.");
        }

        AuthUser authUser = authUserService.save(authUserDto);
        if (authUser == null) {
            return ResponseEntity.badRequest().build();
        }

        CreateUserResponse response = new CreateUserResponse();
        response.setMessage("User created successfully.");
        response.setUser(authUser);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/list")
    public ResponseEntity<List<AuthUser>> list() {
        List<AuthUser> userList = authUserService.listar();
        return ResponseEntity.ok(userList);
    }

    @GetMapping("/list/buscar")
    public ResponseEntity<List<AuthUser>> buscar(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) LocalDateTime created_at,
            @RequestParam(required = false) LocalDateTime updated_at,
            @RequestParam(required = false) String codigo) {

        List<AuthUser> authUsers = authUserService.buscar(name, created_at, updated_at, codigo);
        return ResponseEntity.ok().body(authUsers);
    }

    @PutMapping()
    public ResponseEntity<AuthUser> update(@RequestBody AuthUserDto authUserDto) {
        Optional<AuthUser> existingUser = authUserService.listarPorId(authUserDto.getId());
        if (!existingUser.isPresent())
            return ResponseEntity.notFound().build();

        AuthUser updatedUser = existingUser.get();

        // Actualiza las propiedades del usuario con los valores proporcionados en
        // authUserDto, excepto la contraseña
        updatedUser.setEmail(authUserDto.getEmail());
        updatedUser.setRole(authUserDto.getRole());
        updatedUser.setName(authUserDto.getName());
        updatedUser.setFoto(authUserDto.getFoto());

        updatedUser.setApellido_m(authUserDto.getApellido_m());
        updatedUser.setApellido_p(authUserDto.getApellido_p());
        updatedUser.setDni(authUserDto.getDni());
        updatedUser.setCodigo(authUserDto.getCodigo());

        // Verifica si la contraseña ha sido modificada y la encripta
        if (!authUserDto.getPassword().equals(existingUser.get().getPassword())) {
            String password = passwordEncoder.encode(authUserDto.getPassword());
            updatedUser.setPassword(password);
        }

        LocalDateTime currentDateTime = LocalDateTime.now();
        updatedUser.setUpdated_at(currentDateTime);

        AuthUser savedUser = authUserService.actualizar(updatedUser);
        CreateUserResponse response = new CreateUserResponse();
        response.setMessage("Usuario actualizado con éxito.");
        response.setUser(savedUser);
        return ResponseEntity.ok(savedUser);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AuthUser> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(authUserService.listarPorId(id).get());
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> delete(@PathVariable Integer id) {
        Optional<AuthUser> existingUser = authUserService.listarPorId(id);
        if (!existingUser.isPresent())
            return ResponseEntity.notFound().build();

        authUserService.eliminarPorId(id);
        return ResponseEntity.ok("User deleted successfully.");
    }
}