"""Baseline: main-thread (non-sidechain) transcripts, files modified in window, events with timestamp in window.
usage: python3 -I scripts/count-agent-stops.py <start> <end>  (inclusive YYYY-MM-DD)"""
import json, os, sys, time, collections
if len(sys.argv)!=3: sys.exit(__doc__)
root=os.path.expanduser('~/.claude/projects')
start,end=sys.argv[1],sys.argv[2]  # inclusive YYYY-MM-DD
cut=time.mktime(time.strptime(start,'%Y-%m-%d'))
BUCKETS=('spacevibe-deck','tiny-cli')
S=collections.Counter(); A=collections.Counter(); C=collections.Counter()
def bucket(d):
    n=os.path.basename(d)
    return next((k for k in BUCKETS if n.endswith(k)),'other')
for dp,dn,fn in os.walk(root):
    if dp!=root: dn[:]=[]  # main-thread transcripts sit one level down; skip session/subagent dirs
    for f in fn:
        p=os.path.join(dp,f)
        if not f.endswith('.jsonl') or os.path.getmtime(p)<cut: continue
        b=bucket(dp); active=False; seen=set()
        with open(p,errors='ignore') as fh:
            for line in fh:
                if '"assistant"' not in line: continue
                try:o=json.loads(line)
                except:continue
                ts=o.get('timestamp','')[:10]
                if o.get('type')!='assistant' or o.get('isSidechain') or not (start<=ts<=end): continue
                active=True
                for c in o['message'].get('content') or []:
                    if not isinstance(c,dict): continue
                    if c.get('type')=='tool_use' and c.get('name')=='AskUserQuestion':
                        A[b]+=len((c.get('input') or {}).get('questions',[]))
                    if c.get('type')=='text' and '**Cần chốt' in c.get('text',''):
                        k=(o['message'].get('id'),c['text'][:60])
                        if k not in seen: seen.add(k); C[b]+=1
        if active: S[b]+=1
def row(name,s,a,c):
    d=s or 1; print(f"{name:15} sessions={s:4} AUQ_questions={a:4} ({a/d:.2f}/session)  CanChot={c:4} ({c/d:.2f}/session)")
for b in BUCKETS+('other',): row(b,S[b],A[b],C[b])
row('TOTAL',sum(S.values()),sum(A.values()),sum(C.values()))
