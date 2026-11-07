-- Tabela de presentes do Amigo Secreto da Família (rodada no SQL Editor do Supabase)
create table if not exists public.presentes (
  id uuid primary key default gen_random_uuid(),
  pessoa text not null check (pessoa in ('paulo','leticia','sophia','gerson','nani','paula','grilo')),
  nome text not null check (char_length(nome) between 1 and 120),
  link text not null default '' check (char_length(link) <= 2000 and (link = '' or link ~* '^https?://')),
  obs text not null default '' check (char_length(obs) <= 500),
  foto text not null default '' check (char_length(foto) <= 400000 and (foto = '' or foto like 'data:image/%')),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

alter table public.presentes enable row level security;

-- Sem senha: qualquer pessoa com o link pode ver e editar (pedido do Paulo)
drop policy if exists "todos leem" on public.presentes;
drop policy if exists "todos inserem" on public.presentes;
drop policy if exists "todos alteram" on public.presentes;
drop policy if exists "todos apagam" on public.presentes;
create policy "todos leem"    on public.presentes for select to anon, authenticated using (true);
create policy "todos inserem" on public.presentes for insert to anon, authenticated with check (true);
create policy "todos alteram" on public.presentes for update to anon, authenticated using (true) with check (true);
create policy "todos apagam"  on public.presentes for delete to anon, authenticated using (true);

grant select, insert, update, delete on public.presentes to anon, authenticated;
