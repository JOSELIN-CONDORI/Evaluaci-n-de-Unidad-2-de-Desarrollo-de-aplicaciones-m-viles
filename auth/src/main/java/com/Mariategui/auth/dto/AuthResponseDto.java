package com.Mariategui.auth.dto;

import com.Mariategui.auth.entity.TokenDto;

import lombok.Data;

@Data
public class AuthResponseDto {
    private String token;
    // private TokenDto token;
    private AuthUserDto user;

    public AuthResponseDto() {
        // Constructor sin argumentos
    }

}
