package com.example.ventas.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.example.ventas.entity.Producto;

public interface ProductoService {
    public List<Producto> listar();

    public Producto guardar(Producto producto);

    public Producto actualizar(Producto producto);

    public Optional<Producto> listarPorId(Integer id);

    public void eliminarPorId(Integer id);

    // Otros métodos existentes
    List<Producto> listarPorSubCategoria(Integer idEvento);

    List<Producto> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado);
}
