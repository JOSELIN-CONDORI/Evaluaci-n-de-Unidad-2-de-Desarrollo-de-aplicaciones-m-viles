package com.Mariategui.auth.dto;

import com.Mariategui.auth.entity.AuthUser;

import lombok.Data;

@Data
public class CreateUserResponse {
    private String message;
    private AuthUser user;
}
