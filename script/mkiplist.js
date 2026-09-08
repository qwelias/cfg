#!/usr/bin/env node
const fs = require('node:fs');
const $ = (cmd, input = '') =>
    console.warn('$>', cmd) ||
    String(require('child_process').execSync(cmd, { input, encoding: 'utf8' }));

const amneziaiplist = '~/Documents/amneziaiplist.json';
const domains = $('cat ~/script/vpnwhite').split('\n').filter(Boolean);

const cidrs = new Set();
const counters = {};

try {
    JSON.parse(fs.readFileSync(amneziaiplist, 'utf8')).map((it) =>
        cidrs.add(it.ip || it.hostname)
    );
} catch (err) {
    console.error(err);
}

for (const d of domains) {
    const res = $(`bash -c 'dig +short ${d} A | grep -E '^[0-9.]+$' | sort -u'`).split('\n').filter(Boolean);
    console.log(res)
    res.map((ip) => cidrs.add(ip));
}

for (const cidr of cidrs) {
    const [ip, net] = cidr.split('/');
    const parts = ip.split('.');
    const net16 = parts[0] + '.' + parts[1];
    const net24 = net16 + '.' + parts[2];
    counters[net16] = counters[net16] || { count: 0, sub: {} };
    counters[net16].count++;
    if (net === '16') counters[net16].count++;

    counters[net16].sub[net24] = counters[net16].sub[net24] ||
        { count: 0, ips: [] };
    counters[net16].sub[net24].count++;
    if (net === '24') counters[net16].sub[net24].count++;
    else counters[net16].sub[net24].ips.push(ip);
}

const out = [];
for (const [net16, cc16] of Object.entries(counters)) {
    if (cc16.count > 1) {
        out.push({ hostname: `fix.${net16}.shit`, ip: `${net16}.0.0/16` });
        console.log(`${net16}.0.0/16`);
        continue;
    }

    for (const [net24, cc24] of Object.entries(cc16.sub)) {
        if (cc24.count > 1) {
            out.push({ hostname: `fix.${net24}.shit`, ip: `${net24}.0/24` });
            console.log(`${net24}.0/24`);
            continue;
        }

        cc24.ips.map((ip) => {
            out.push({ hostname: ip, ip: `${ip}/32` });
            console.log(`${ip}/32`);
        });
    }
}

fs.writeFileSync(amneziaiplist, JSON.stringify(out, null, '  '));
