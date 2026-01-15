# AnimeMash

AnimeMash is a crowd-sourced ranking platform for anime characters, inspired by Facemash. Users vote on head-to-head matchups to determine who is the best, powered by the Elo rating system.

## Features

-   **Elo Rating System**: Fair and dynamic ranking based on 1v1 votes.
-   **Animations**: Smooth transitions and modern UI design.
-   **Authentication**: Google OAuth via Supabase.
-   **Rate Limiting**: Precautions to prevent spam voting.
-   **Responsive**: Works on desktop and mobile.

## Tech Stack

-   **Frontend**: React, TypeScript, Vite, Tailwind CSS
-   **Backend**: Supabase (PostgreSQL, Auth, Edge Functions)
-   **Icons**: Lucide React

## Getting Started

### 1. Prerequisites

-   Node.js (v16+)
-   Supabase Account

### 2. Installation

```bash
git clone <your-repo-url>
cd animemash
npm install
```

### 3. Supabase Setup

1.  Create a new project on [Supabase](https://supabase.com).
2.  Go to the **SQL Editor** and run the following schema:

```sql
-- Create characters table
create table characters (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  series text not null,
  gender text check (gender in ('male', 'female')),
  image_url text,
  elo_rating integer default 1200,
  wins integer default 0,
  losses integer default 0
);

-- Create votes table
create table votes (
  id uuid default gen_random_uuid() primary key,
  winner_id uuid references characters(id),
  loser_id uuid references characters(id),
  user_id uuid,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Enable RLS (Row Level Security)
alter table characters enable row level security;
alter table votes enable row level security;

-- Policies
create policy "Public Read Characters" on characters for select using (true);
create policy "Public Insert Votes" on votes for insert with check (auth.role() = 'authenticated');
```

3.  Copy your Project URL and Anon Key from **Settings > API**.
4.  Create a `.env.local` file in the root directory:

```env
VITE_SUPABASE_URL=your_project_url
VITE_SUPABASE_ANON_KEY=your_anon_key
```

### 4. Google Auth Setup

1.  Go to **Authentication > Providers** in Supabase and enable **Google**.
2.  Set up OAuth credentials in Google Cloud Console.
    *   **Authorized Origins**: `http://localhost:3000` (and `3001` if needed).
    *   **Redirect URI**: `https://<your-project>.supabase.co/auth/v1/callback`
3.  Paste Client ID and Secret into Supabase.

### 5. Running the App

```bash
npm run dev
```

## Adding Characters

### Images
1.  Add images to `public/characters/` (e.g., `naruto.jpg`).
2.  In Supabase Table Editor, set `image_url` to `/characters/naruto.jpg`.

### Data
You can insert characters directly via SQL or the Table Editor:

```sql
insert into characters (name, series, gender, image_url) values
('Naruto Uzumaki', 'Naruto', 'male', '/characters/naruto.jpg'),
('Monkey D. Luffy', 'One Piece', 'male', '/characters/luffy.png');
```

## License

MIT
