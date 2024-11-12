package com.example.ventas.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.SubCategoria;
import com.example.ventas.repository.SubCategoriaRepository;
import com.example.ventas.service.SubCategoriaService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class SubCategoriaServiceImpl implements SubCategoriaService {

    @Autowired
    private CategoriaServiceImpl categoriaService;

    @Autowired
    private SubCategoriaRepository subCategoriaRepository;

    @Override
    public List<SubCategoria> listar() {
        return subCategoriaRepository.findAll();
    }

    @Override
    public List<SubCategoria> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado) {
        return subCategoriaRepository.buscarPorParametros(nombre, createdAt, updatedAt, estado);
    }

    @Override
    public SubCategoria guardar(SubCategoria subCategoria) {
        return subCategoriaRepository.save(subCategoria);
    }

    // @Override
    // public SubCategoria actualizar(SubCategoria subCategoria) {
    // return subCategoriaRepository.save(subCategoria);
    // }

    @Override
    public SubCategoria actualizar(SubCategoria subCategoria) {
        // Primero, obtén la entidad existente desde la base de datos
        SubCategoria subCategoriaExistente = subCategoriaRepository.findById(subCategoria.getId())
                .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada"));

        // Solo actualiza los campos que deseas cambiar
        subCategoriaExistente.setNombre(subCategoria.getNombre());
        subCategoriaExistente.setTag(subCategoria.getTag());
        subCategoriaExistente.setFoto(subCategoria.getFoto());
        subCategoriaExistente.setEstado(subCategoria.getEstado());
        // No toques createdAt

        // Guarda los cambios
        return subCategoriaRepository.save(subCategoriaExistente);
    }

    @Override
    public Optional<SubCategoria> listarPorId(Integer id) {
        SubCategoria subCategoria = subCategoriaRepository.findById(id).orElse(null);
        if (subCategoria != null) {
            System.out.println("Antes de la petición");
            Optional<Categoria> categoriaOptional = categoriaService
                    .listarPorId(subCategoria.getCategoria().getId());
            if (categoriaOptional.isPresent()) {
                Categoria categoria = categoriaOptional.get();
                subCategoria.setCategoria(categoria);
            }
        }

        return Optional.ofNullable(subCategoria);
    }

    @Override
    public void eliminarPorId(Integer id) {
        subCategoriaRepository.deleteById(id);
    }

    @Override
    public List<SubCategoria> listarPorCategoria(Integer idCategoria) {
        // Obtener la lista de Productos por categoría directamente desde el
        // repositorio
        return subCategoriaRepository.findByCategoriaId(idCategoria);
    }
}
