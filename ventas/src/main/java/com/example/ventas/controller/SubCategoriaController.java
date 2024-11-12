package com.example.ventas.controller;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.Producto;
import com.example.ventas.entity.SubCategoria;
import com.example.ventas.service.SubCategoriaService;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/subcategoria")
public class SubCategoriaController {
    @Autowired
    private SubCategoriaService subCategoriaService;

    @GetMapping("/subCategoriaPorCategoria/{idCategoria}")
    public ResponseEntity<List<SubCategoria>> listarProductosPorSubCategoria(@PathVariable Integer idCategoria) {
        List<SubCategoria> subCategorias = subCategoriaService.listarPorCategoria(idCategoria);
        return ResponseEntity.ok(subCategorias);
    }

    @GetMapping()
    public ResponseEntity<List<SubCategoria>> list() {
        return ResponseEntity.ok().body(subCategoriaService.listar());
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<SubCategoria>> buscar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) LocalDateTime createdAt,
            @RequestParam(required = false) LocalDateTime updatedAt,
            @RequestParam(required = false) String estado) {

        List<SubCategoria> subCategorias = subCategoriaService.buscar(nombre, createdAt, updatedAt, estado);
        return ResponseEntity.ok().body(subCategorias);
    }

    @PostMapping()
    public ResponseEntity<SubCategoria> save(@RequestBody SubCategoria subCategoria) {
        return ResponseEntity.ok(subCategoriaService.guardar(subCategoria));
    }

    @PutMapping()
    public ResponseEntity<SubCategoria> update(@RequestBody SubCategoria subCategoria) {
        return ResponseEntity.ok(subCategoriaService.actualizar(subCategoria));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SubCategoria> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(subCategoriaService.listarPorId(id).get());
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id) {
        subCategoriaService.eliminarPorId(id);
        return "Eliminacion Correcta";
    }
}