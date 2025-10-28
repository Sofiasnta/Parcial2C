defmodule Movimiento do

  defstruct codigo: "", tipo: nil, cantidad: 0, fecha: ""

  def crear_movimiento(codigo, tipo, cantidad, fecha) do
    %Movimiento{codigo: codigo, tipo: tipo, cantidad: cantidad, fecha: fecha}
  end


  def escribir_movimiento_csv(lista_movimientos, nombre_archivo) do
    headers = "Codigo,Tipo,Cantidad,Fecha\n"

    contenido = Enum.map(lista_movimientos, fn %Movimiento{codigo: codigo, tipo: tipo, cantidad: cantidad, fecha: fecha} -> "#{codigo},#{tipo},#{cantidad},#{fecha}\n"end)
    |> Enum.join()
    File.write(nombre_archivo, headers <> contenido)
  end


  def leer_movimiento_csv(nombre_archivo) do
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        String.split(contenido, "\n", trim: true)
        |> tl()
        |> Enum.map(fn line ->
          case String.split(line, ",", trim: true) do
            ["codigo", "tipo", "cantidad", "fecha"] -> nil
            [codigo, tipo, cantidad, fecha] ->
              %Movimiento{codigo: codigo, tipo: tipo, cantidad: String.to_integer(String.trim(cantidad)), fecha: String.trim(fecha)
              }
            _ -> nil
          end
        end)
        |> Enum.filter(& &1)

      {:error, reason} ->
        IO.puts("Error al leer el archivo: #{reason}")
        []
    end
  end


  def aplicar_movimientos(piezas, movimientos) do
  Enum.map(piezas, fn pieza ->
    movimientos_pieza = Enum.filter(movimientos, fn movimiento -> String.trim(movimiento.codigo) == String.trim(pieza.codigo)end)

    nuevo_stock = Enum.reduce(movimientos_pieza, pieza.stock, fn movimiento, acc -> tipo = String.upcase(String.trim(movimiento.tipo))

    cond do
      tipo == "ENTRADA" -> acc + movimiento.cantidad
      tipo == "SALIDA" -> max(acc - movimiento.cantidad, 0)
      true -> acc
        end
      end)

    %Pieza{pieza | stock: nuevo_stock}
  end)
end

def actualizar_inventario(piezas, movimientos, archivo_salida) do
    piezas_actualizadas = aplicar_movimientos(piezas, movimientos)

    headers = "Codigo,Nombre,Valor,Unidad,Stock\n"
    contenido = Enum.map(piezas_actualizadas, fn %Pieza{codigo: codigo, nombre: nombre, valor: valor, unidad: unidad, stock: stock} -> "#{codigo},#{nombre},#{valor},#{unidad},#{stock}\n"end)
    |> Enum.join()
    case File.write(archivo_salida, headers <> contenido) do
      :ok ->
        IO.puts("Inventario actualizado guardado en #{archivo_salida}")
        {:ok, piezas_actualizadas}

        {:error, reason} ->
        IO.puts("Error al guardar el archivo: #{reason}")
        {:error, reason}
    end
  end

   def total_movido_rango([], _fini, _ffin)do
    0
   end

  def total_movido_rango([movimiento | resto], fini, ffin) do
    if movimiento.fecha >= fini and movimiento.fecha <= ffin do
      movimiento.cantidad + total_movido_rango(resto, fini, ffin)
    else
      total_movido_rango(resto, fini, ffin)
    end
  end






end
