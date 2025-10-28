defmodule Pieza do


  defstruct codigo: "", nombre: "", valor: 0, unidad: "", stock: 0


  def crear_pieza(codigo, nombre, valor, unidad, stock) do
    %Pieza{codigo: codigo, nombre: nombre, valor: valor, unidad: unidad, stock: stock
    }
  end

    def escribir_pieza_csv(piezas, nombre_archivo) do
    headers = "Codigo,Nombre,Valor,Unidad, Stock\n"

    contenido = Enum.map(piezas, fn %Pieza{codigo: codigo, nombre: nombre, valor: valor, unidad: unidad, stock: stock} -> "#{codigo},#{nombre},#{valor},#{unidad}, #{stock}\n"end)
    |> Enum.join()
    File.write(nombre_archivo, headers <> contenido)
  end



   def leer_pieza_csv(nombre_archivo) do
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        piezas =
          contenido
          |> String.split("\n", trim: true)
          |> Enum.drop(1)
          |> Enum.map(fn line ->
            campos = String.split(line, ",", trim: true)

            case campos do
              [codigo, nombre, valor, unidad, stock] ->
                %Pieza{
                  codigo: String.trim(codigo),
                  nombre: String.trim(nombre),
                  valor: String.to_integer(String.trim(valor)),
                  unidad: String.trim(unidad),
                  stock: String.to_integer(String.trim(stock))
                }
              _ ->nil
            end
          end)
          |> Enum.filter(& &1)

        {:ok, piezas}

      {:error, reason} ->
        IO.puts("Error: no se pudo leer el archivo (#{reason})")
        {:error, reason}
    end
  end


  def contar_stock_umbral([], _t)do
    0
  end

  def contar_stock_umbral([%Pieza{stock: stock}|resto], t) do
    if stock < t do
      1 + contar_stock_umbral(resto, t)
    else
      contar_stock_umbral(resto, t)
    end
  end

  def eliminar_duplicados([]) do
    []
  end

  def eliminar_duplicados([cabeza | cola]) do

  cola_filtrada = eliminar_por_codigo(cola, cabeza.codigo)
  [cabeza | eliminar_duplicados(cola_filtrada)]
  end

  def eliminar_por_codigo([], _codigo)do
  []
  end

  def eliminar_por_codigo([pieza | resto], codigo) do
  if pieza.codigo == codigo do
    eliminar_por_codigo(resto, codigo)
  else
    [pieza | eliminar_por_codigo(resto, codigo)]
  end
end

end
