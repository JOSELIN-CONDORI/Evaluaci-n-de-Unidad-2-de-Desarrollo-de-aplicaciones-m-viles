package com.example.ventas.service.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ventas.entity.Categoria;
import com.example.ventas.repository.CategoriaRepository;
import com.example.ventas.service.CategoriaService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class CategoriaServiceImpl implements CategoriaService {

    @Autowired
    private CategoriaRepository categoriaRepository;

    @Override
    public List<Categoria> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado) {
        return categoriaRepository.buscarPorParametros(nombre, createdAt, updatedAt, estado);
    }

    @Override
    public List<Categoria> listar() {
        return categoriaRepository.findAll();
    }

    @Override
    public Categoria guardar(Categoria categoria) {
        return categoriaRepository.save(categoria);
    }

    @Override
    public Categoria actualizar(Categoria categoria) {
        // Primero, obtén la entidad existente desde la base de datos
        Categoria categoriaExistente = categoriaRepository.findById(categoria.getId())
                .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada"));

        // Solo actualiza los campos que deseas cambiar
        categoriaExistente.setNombre(categoria.getNombre());
        categoriaExistente.setTag(categoria.getTag());
        categoriaExistente.setFoto(categoria.getFoto());
        categoriaExistente.setEstado(categoria.getEstado());
        // No toques createdAt

        // Guarda los cambios
        return categoriaRepository.save(categoriaExistente);
    }

    @Override
    public Optional<Categoria> listarPorId(Integer id) {
        return categoriaRepository.findById(id);
    }

    @Override
    public void eliminarPorId(Integer id) {
        categoriaRepository.deleteById(id);
    }
}
