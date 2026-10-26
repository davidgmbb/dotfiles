#!/usr/bin/env bash
# Tests of the cores script beside this one, on a fake 4-core topology (CPUs 2-5, one each).
set -u
T=$(mktemp -d)
export CORES_STATE=$T/state CORES_CONFIG=$T/config CORES_TOPOLOGY="2 3 4 5" CORES_POLL=0.1
unset CORES_HELD CORES CORES_CPUS
c=$(cd "$(dirname "$0")" && pwd)/cores
fail=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fail=1; fi; }
log=$T/log
stamp() { echo "$(date +%s.%N) $*" >> $log; }
export -f stamp; export log

$c reserve 1 2>/dev/null
check "reserve set" '[[ $($c reserve) == 1 ]]'

# Affinity, environment, priority inside a job.
out=$($c -n 2 --title t -- bash -c 'echo "$CORES|$CORES_CPUS|$(taskset -pc $$ | sed "s/.*: //")|$(nproc)|$(( $(ps -o ni= -p $$) ))"' 2>/dev/null)
check "affinity and env ($out)" '[[ $out == "2|3,4|3,4|2|19" ]]'
out=$($c -n 1 --priority normal -- bash -c 'ps -o ni= -p $$' 2>/dev/null | tr -d ' ')
check "priority normal keeps niceness ($out)" '[[ $out == $(nice) ]]'
out=$($c -n 9 -- bash -c 'echo $CORES' 2>/dev/null)
check "request past pool gets pool ($out)" '[[ $out == 3 ]]'
out=$($c --all -- bash -c 'echo $CORES' 2>/dev/null)
check "--all gets pool ($out)" '[[ $out == 3 ]]'

# Nested passthrough: runs at once on the same CPUs, even when the pool is full.
out=$($c --all -- bash -c "$c -n 3 -- bash -c 'echo \$CORES_HELD:\$(taskset -pc \$\$ | sed \"s/.*: //\")'" 2>/dev/null)
check "nested passthrough ($out)" '[[ $out == *:3-5 || $out == *:3,4,5 ]]'

# Bogus CORES_HELD queues normally.
out=$(CORES_HELD=999 $c -n 1 -- bash -c 'echo $CORES_HELD' 2>&1 | tail -1)
check "stale CORES_HELD queues ($out)" '[[ $out =~ ^0+[0-9]+$ ]]'

# FIFO: A holds 2, B wants 2 (waits), C wants 1 (would fit now, but must wait for B).
: > $log
$c -n 2 -- bash -c 'stamp A-start; sleep 1; stamp A-end' 2>/dev/null &
sleep 0.3
$c -n 2 -- bash -c 'stamp B-start; sleep 0.5; stamp B-end' 2>/dev/null &
sleep 0.3
$c -n 1 -- bash -c 'stamp C-start; stamp C-end' 2>/dev/null &
wait
order=$(sort -n $log | awk '{print $2}' | tr '\n' ' ')
check "strict FIFO ($order)" '[[ $order == "A-start A-end B-start "* && $order == *"B-start"*"C-start"* ]]'
# C must start before B ends (1 core is free beside B), proving it's not exclusive.
check "C runs beside B" '[[ $order == "A-start A-end B-start C-start C-end B-end " ]]'

# Status lists running and waiting.
$c --all --title holder -- sleep 1 2>/dev/null &
sleep 0.3
$c -n 1 --title waiter -- true 2>/dev/null &
sleep 0.3
st=$($c status)
check "status shows both" '[[ $st == *holder* && $st == *waiter* && $st == *"0 free"* ]]'
wait

# SIGKILL of a holder frees its cores.
$c --all -- sleep 30 2>/dev/null &
h=$!
sleep 0.3
$c -n 1 -- bash -c 'stamp K-start' 2>/dev/null &
w=$!
sleep 0.3
kill -9 $h
start=$(date +%s.%N); wait $w; end=$(date +%s.%N)
check "killed holder frees cores" 'grep -q K-start $log && awk -v a=$start -v b=$end "BEGIN{exit !(b - a < 2)}"'

# A waiter killed while waiting doesn't block the queue.
$c --all -- sleep 1 2>/dev/null &
sleep 0.2
$c --all -- true 2>/dev/null &
dead=$!
sleep 0.2
$c -n 1 -- bash -c 'stamp D-start' 2>/dev/null &
sleep 0.2
kill -9 $dead
wait
check "killed waiter leaves the queue" 'grep -q D-start $log && [[ -z $(ls $CORES_STATE/waiting) ]]'
check "SIGTERM'd waiter removes its ticket" '
  $c --all -- sleep 1 2>/dev/null & sleep 0.2
  $c -n 1 -- true 2>/dev/null & x=$!; sleep 0.2; kill $x; sleep 0.3
  n=$(ls $CORES_STATE/waiting | wc -l); wait; [[ $n == 0 ]]'

# Orphans: a job that leaves a child running keeps its cores until the child ends.
$c --all -- bash -c 'sleep 1.5 & exit 0' 2>/dev/null
st=$($c status)
check "orphan keeps cores" '[[ $st == *"ended; processes it left"* && $st == *"0 free"* ]]'
sleep 1.6
st=$($c status)
check "orphan's cores come back" '[[ $st == *"3 free"* && $st != *ended* ]]'

# Reserve changes reach waiters live: pool 3 -> 4.
$c reserve 0 2>/dev/null
out=$($c --all -- bash -c 'echo $CORES' 2>/dev/null)
check "away gives the whole machine ($out)" '[[ $out == 4 ]]'
check "reserve can't take every core" '! $c reserve 4 2>/dev/null'

# Exit status passes through; a missing command fails without leaving tickets.
$c -n 1 -- bash -c 'exit 7' 2>/dev/null; s=$?
check "exit status ($s)" '[[ $s == 7 ]]'
$c -n 1 -- /nonexistent 2>/dev/null; s=$?
st=$($c status)
check "missing command ($s)" '[[ $s == 127 && $st == *"4 free"* && $st != *"#"* ]]'

rm -rf $T
exit $fail
