defmodule KanbanLiveviewWeb.PageLive do
  use KanbanLiveviewWeb, :live_view

  def mount(_params, %{"board_id" => board_id}, socket) do
    with {:ok, board} <- KanbanLiveview.Board.find(board_id) do
      KanbanLiveviewWeb.Endpoint.subscribe(topic(board_id))
      {:ok, assign(socket, :board, board)}
    else
      {:error, _reason} ->
        {:ok, redirect(socket, to: "/error")}
    end
  end

  def handle_event("add_card", %{"column" => column_id}, socket) do
    {id, _} = Integer.parse(column_id)
    %KanbanLiveview.Card{column_id: id, content: "Something new"} |> KanbanLiveview.Repo.insert!()
    {:ok, new_board} = KanbanLiveview.Board.find(socket.assigns.board.id)

    KanbanLiveviewWeb.Endpoint.broadcast(topic(new_board.id), "board:updated", new_board)

    {:noreply, assign(socket, :board, new_board)}
  end
alias KanbanLiveview.Card
  def handle_event("delete_card",  %{"card" => card_id}, socket) do
    {id, _} = Integer.parse(card_id)
    Card.delete(id)
    {:ok, new_board} = KanbanLiveview.Board.find(socket.assigns.board.id)

    KanbanLiveviewWeb.Endpoint.broadcast(topic(new_board.id), "board:updated", new_board)

    {:noreply, assign(socket, :board, new_board)}
  end

  def handle_info(%{topic: message_topic, event: "board:updated", payload: board}, socket) do
    cond do
      topic(board.id) == message_topic ->
        {:noreply, assign(socket, :board, KanbanLiveview.Repo.preload(board, columns: :cards))}

      true ->
        {:noreply, socket}
    end
  end

  def topic(board_id) do
    "board:#{board_id}"
  end

  def handle_event("update_card", %{"card" => card_id, "value" => new_content}, socket) do
    {id, _} = Integer.parse(card_id)
    KanbanLiveview.Card.update(id, %{content: new_content})
    {:ok, new_board} = KanbanLiveview.Board.find(socket.assigns.board.id)

    KanbanLiveviewWeb.Endpoint.broadcast(topic(new_board.id), "board:updated", new_board)

    {:noreply, assign(socket, :board, new_board)}
  end
end
