const root = document.getElementById('tags-root');
let pool = [];

function ensurePool(size){
  while(pool.length < size){
    const el = document.createElement('div');
    el.className = 'tag';
    el.innerHTML = `
      <div class="tag-gradient"></div>
      <div class="tag-gloss"></div>
      <div class="icon">★</div>
      <div class="label"></div>
    `;
    root.appendChild(el);
    pool.push(el);
  }
  for(let i=size;i<pool.length;i++){
    pool[i].style.display = 'none';
  }
}

function update(items){
  ensurePool(items.length);
  for(let i=0;i<items.length;i++){
    const it = items[i];
    const el = pool[i];
    el.style.display = 'flex';
    el.style.left = (it.x * 100) + 'vw';
    el.style.top = (it.y * 100) + 'vh';
    el.style.setProperty('--c1', it.c1 || '#7F00FF');
    el.style.setProperty('--c2', it.c2 || '#E100FF');
    const label = el.querySelector('.label');
    label.textContent = it.label || 'Admin';
    const txt = it.txt || [255,255,255,230];
    label.style.color = `rgba(${txt[0]},${txt[1]},${txt[2]},${(txt[3]||230)/255})`;
  }
}

window.addEventListener('message', (e)=>{
  const data = e.data;
  if(data && data.type === 'bp-tags:update'){
    update(data.items || []);
  }
});
