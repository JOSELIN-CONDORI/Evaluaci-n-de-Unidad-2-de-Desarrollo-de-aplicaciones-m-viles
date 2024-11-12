package com.Mariategui.auth.repository;

import com.Mariategui.auth.entity.AuthUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AuthRepository extends JpaRepository<AuthUser, Integer> {
    Optional<AuthUser> findByEmail(String email);

    @Query("SELECT c FROM AuthUser c WHERE "
            + "(:name IS NULL OR c.name LIKE %:name%) AND "
            + "(:codigo IS NULL OR c.codigo = :codigo) AND "
            + "(:created_at IS NULL OR c.created_at >= :created_at) AND "
            + "(:updated_at IS NULL OR c.updated_at <= :updated_at)")

    List<AuthUser> buscarPorParametros(
            @Param("name") String name,
            @Param("created_at") LocalDateTime created_at,
            @Param("updated_at") LocalDateTime updated_at,
            @Param("codigo") String codigo);
}
