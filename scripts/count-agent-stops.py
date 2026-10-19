# Baseline: main-thread (non-sidechain) transcripts, files modified in window, events with timestamp in window.
# Usage: python3 -I scripts/count-agent-stops.py <start> <end>   (inclusive YYYY-MM-DD)
import json, os, sys, time, collections, datetime
if len(sys.argv)!=3: sys.exit("usage: python3 -I scripts/count-agent-stops.py <start> <end>  (inclusive YYYY-MM-DD)")
root=os.path.expanduser('~/.claude/projects')
start,end=sys.argv[1],sys.argv[2]  # inclusive YYYY-MM-DD
cut=time.mktime(time.strptime(start,'%Y-%m-%d'))
S=collections.Counter(); A=collections.Counter(); C=collections.Counter()
def bucket(d):
    n=os.path.basename(d)
    return 'spacevibe-deck' if n.endswith('spacevibe-deck') else ('tiny-cli' if n.endswith('tiny-cli') else 'other')
for dp,dn,fn in os.walk(root):
    if dp.count(os.sep)-root.count(os.sep)>1: continue
    for f in fn:
        p=os.path.join(dp,f)
        if not f.endswith('.jsonl') or os.path.getmtime(p)<cut: continue
        b=bucket(dp); active=False; seen=set()
        for line in open(p,errors='ignore'):
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
for b in ['spacevibe-deck','tiny-cli','other']:
    s=S[b] or 1; print(f"{b:15} sessions={S[b]:4} AUQ_questions={A[b]:4} ({A[b]/s:.2f}/session)  CanChot={C[b]:4} ({C[b]/s:.2f}/session)")
t=sum(S.values()) or 1; print(f"{'TOTAL':15} sessions={sum(S.values()):4} AUQ_questions={sum(A.values()):4} ({sum(A.values())/t:.2f}/session)  CanChot={sum(C.values()):4} ({sum(C.values())/t:.2f}/session)")
