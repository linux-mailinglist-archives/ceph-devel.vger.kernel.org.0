Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F9BB9DC
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2019 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394771AbfIWQqA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Sep 2019 12:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389238AbfIWQqA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 12:46:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7482054F;
        Mon, 23 Sep 2019 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569257158;
        bh=r5CDpOHD+y+2mBYeIf4WmjWgpCK4wlji6s8TZCv7H/8=;
        h=Subject:From:To:Cc:Date:From;
        b=nwYb4H4rWZET8yUuzUXjgqEDI8Vzhnw/6PfTHa8srEijkIM6ZvvKDYaZcfeyobzvU
         j07xapw1lFqaHhRR5FWICsqsp+MhySVJWPFCLQk7N+9GrlY/c6/nsBsnaZpGr+75Rr
         uxEbDjrwnEviZKDxilVW4wZpD0wNidClHQs5o4/s=
Message-ID: <12d3b59259ebf2810c866c863445a68ea1f172c6.camel@kernel.org>
Subject: ceph-client/wip-* branch cleanup
From:   Jeff Layton <jlayton@kernel.org>
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        Michael Christie <mchristi@redhat.com>
Date:   Mon, 23 Sep 2019 12:45:56 -0400
Content-Type: multipart/mixed; boundary="=-QJ1kW3N0hasriz6FlaXR"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--=-QJ1kW3N0hasriz6FlaXR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

We have a bunch of branches in the ceph-client tree with the prefix
"wip-" (see attached file) that are all well over a year old.

For consistency with the other jenkins build trees, it would be good to
be able to have it build any branch that starts with "wip-*", but if we
turn that on now, it's going to try to build all of these old branches.

Would anyone have objections to tagging all of these branches with a new
prefix (maybe "legacy-ceph-wip-*") and deleting them? I don't think any
of them are under active development at this point, so I don't think we
need to retain them as branches.

I'll give it a week or so and then do that unless anyone has objections.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

--=-QJ1kW3N0hasriz6FlaXR
Content-Disposition: attachment; filename="ceph-wip-branches.txt"
Content-Type: text/plain; name="ceph-wip-branches.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IGNiOWUzOWQxZjc4M2IxMDc0NzcxNDU4ODAxOTNhODAwNDA4OWRiNTEgKGNlcGgvd2lw
LTM0MzApCkF1dGhvcjogRGF2aWQgWmFmbWFuIDxkYXZpZC56YWZtYW5AaW5rdGFuay5jb20+CkRh
dGU6ICAgTW9uIE5vdiA1IDExOjI2OjU2IDIwMTIgLTA4MDAKY29tbWl0IDc1ZjFmYjk1MmM5YjZk
ZWI5NDg2NGY5YzU0OTAzZWUxODk3N2FiMGUgKEhFQUQgLT4gY2VwaC00MTk5NCwgY2VwaC93aXAt
NDE5OTQpCkF1dGhvcjogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz4KRGF0ZTogICBN
b24gU2VwIDkgMTU6NTg6NTUgMjAxOSAtMDQwMApjb21taXQgOGIwY2NlOTg2MGVjZWVhOGRmODgy
OGY2MWZhYWU0NTIxNTU1ZjNiNSAoY2VwaC93aXAtNzEzOSkKQXV0aG9yOiBJbHlhIERyeW9tb3Yg
PGlseWEuZHJ5b21vdkBpbmt0YW5rLmNvbT4KRGF0ZTogICBUaHUgSmFuIDE2IDE5OjMwOjQ4IDIw
MTQgKzAyMDAKY29tbWl0IGU4NDk1NjhjNTQ1MTRkMWQ2NDg3OWI5MzljOTliMmZmNjAwMjBmZTcg
KGNlcGgvd2lwLTczMTcpCkF1dGhvcjogSm9obiBTcHJheSA8am9obi5zcHJheUByZWRoYXQuY29t
PgpEYXRlOiAgIE1vbiBPY3QgMjAgMTM6MzU6NTAgMjAxNCArMDEwMApjb21taXQgMWUzMjQ3MjY4
NmY3MTBmM2UxMGFmNDUzZTk5N2E1OTYzMDJhMGE3YiAoY2VwaC93aXAtY2VwaGZzKQpBdXRob3I6
IFlhbiwgWmhlbmcgPHp5YW5AcmVkaGF0LmNvbT4KRGF0ZTogICBNb24gSnVuIDYgMTY6MDE6Mzkg
MjAxNiArMDgwMApjb21taXQgNGY5ZWE4NjIzN2I4ZDAwMDVmNTQ2N2ZlODE3YjRmMWYwOTU1MDcy
YyAoY2VwaC93aXAtZGVidWctaW5vZGUtcmVmcykKQXV0aG9yOiBTYWdlIFdlaWwgPHNhZ2VAbmV3
ZHJlYW0ubmV0PgpEYXRlOiAgIFdlZCBOb3YgMiAwNzoxMTo0NiAyMDExIC0wNzAwCmNvbW1pdCA4
OGM5ZDA4MDNjOTEwZGNhNDFkNGQyMDMxMzkxOGZjMzJhNWQ5YjczIChjZXBoL3dpcC1kaXNjYXJk
KQpBdXRob3I6IEFsZXggRWxkZXIgPGVsZGVyQGxpbmFyby5vcmc+CkRhdGU6ICAgU2F0IEFwciAy
NiAxNDoyMTo0NCAyMDE0ICswNDAwCmNvbW1pdCBhNWFhZTllNDk4ZGE0ZjY2NzUzMDgzNzg0N2Yx
MWFhNjliN2MzMzI1IChjZXBoL3dpcC1kaXNjYXJkLXJlYmFzZWQpCkF1dGhvcjogSm9zaCBEdXJn
aW4gPGpvc2guZHVyZ2luQGlua3RhbmsuY29tPgpEYXRlOiAgIE1vbiBBcHIgNyAxNjo1MjowMyAy
MDE0IC0wNzAwCmNvbW1pdCBlNTM2MDMwOTM0YWViZjA0OWZlNmFhZWJjNThkZDM3YWVlZTIxODQw
IChjZXBoL3dpcC1kamYpCkF1dGhvcjogWWFuLCBaaGVuZyA8enlhbkByZWRoYXQuY29tPgpEYXRl
OiAgIFRodSBNYXkgMTkgMTk6MTU6MTkgMjAxNiArMDgwMApjb21taXQgZjAxYWFhMWY4NGUzOWUz
N2JmMmQyNTlhNGY5OTNiOWRlMGRjZDgwZCAoY2VwaC93aXAtZXhjbHVzaXZlLWxvY2spCkF1dGhv
cjogSWx5YSBEcnlvbW92IDxpZHJ5b21vdkBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEF1ZyA4IDIy
OjQ2OjUyIDIwMTYgKzAyMDAKY29tbWl0IDBlNTYzYzUxOTc2NDUwMmIyMzFkMDMwYjczZjM4ODVj
OTFhNzIyYmIgKGNlcGgvd2lwLWZhbmN5LXN0cmlwaW5nKQpBdXRob3I6IElseWEgRHJ5b21vdiA8
aWRyeW9tb3ZAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBGZWIgNyAxMjowOToxMiAyMDE4ICswMTAw
CmNvbW1pdCAwZmI0MTAxMzNjNGFiZjU0MzE0ZWYyMTg5M2ZlOWE2MGE1OWZhZjM1IChjZXBoL3dp
cC1maWxlLWxheW91dDIpCkF1dGhvcjogWWFuLCBaaGVuZyA8enlhbkByZWRoYXQuY29tPgpEYXRl
OiAgIFR1ZSBNYXIgMjkgMTU6MDU6MTggMjAxNiArMDgwMApjb21taXQgNmQ0YmU0NWU1NWEyNzFj
ZDU1YTNlZDM0NDc5ZTI5YjFmODllYTIwNyAoY2VwaC93aXAtZnMtZmlsZWxheW91dCkKQXV0aG9y
OiBZYW4sIFpoZW5nIDx6eWFuQHJlZGhhdC5jb20+CkRhdGU6ICAgU3VuIEZlYiAxNCAxODowNjo0
MSAyMDE2ICswODAwCmNvbW1pdCBhNmM4N2MyYTg1NjA4ZmEyYTc0MjU3ZjVmYmU1NzM2OTAzN2Fl
YzA3IChjZXBoL3dpcC1mcy1maWxlbGF5b3V0MikKQXV0aG9yOiBZYW4sIFpoZW5nIDx6eWFuQHJl
ZGhhdC5jb20+CkRhdGU6ICAgU3VuIEZlYiAxNCAxMTozODoyNSAyMDE2ICswODAwCmNvbW1pdCA1
NWYyY2RjNmQyY2Q5ZDM4MTZjMmFjZTFjMzc0NzUwYjZlMGNlMTdlIChjZXBoL3dpcC1mdXNlKQpB
dXRob3I6IFNhZ2UgV2VpbCA8c2FnZUBpbmt0YW5rLmNvbT4KRGF0ZTogICBGcmkgQXByIDE5IDEw
OjA3OjExIDIwMTMgLTA3MDAKY29tbWl0IDBkMTIzNzkzNDc1ODQ0Yjk5YzI0ODE0MmNjNDUwZmVm
OTQyMTUyOTYgKGNlcGgvd2lwLWdmcC0zLjE4KQpBdXRob3I6IElseWEgRHJ5b21vdiA8aWRyeW9t
b3ZAZ21haWwuY29tPgpEYXRlOiAgIFRodSBKdW4gMjUgMjE6NTM6NDggMjAxNSArMDMwMApjb21t
aXQgMDlkZWNjY2RlMzhkY2FhMTNhYjZkMjI0YzNlNGJiYjg5NmM0YWRjNyAoY2VwaC93aXAtamQt
dGVzdGluZykKQXV0aG9yOiBKb3NlZiBCYWNpayA8amJhY2lrQGZiLmNvbT4KRGF0ZTogICBNb24g
TWFyIDEyIDEyOjAwOjE4IDIwMTggLTA0MDAKY29tbWl0IGUzOGVlNjdiYzg5ZjZmYzQwZDhhMzVl
MjY1YWU4MmEwN2E4ZjM3YmMgKGNlcGgvd2lwLWpsYXl0b24tMTgwNDEpCkF1dGhvcjogSmVmZiBM
YXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT4KRGF0ZTogICBXZWQgTm92IDMwIDE1OjU2OjQ2IDIw
MTYgLTA1MDAKY29tbWl0IGU1NDIxMGU0ZTgzMjAxYmUyZDY0Zjk3YWE4YzI3YjFiZDI4OTlkYWIg
KGNlcGgvd2lwLWpsYXl0b24taW92LWl0ZXIpCkF1dGhvcjogSmVmZiBMYXl0b24gPGpsYXl0b25A
cmVkaGF0LmNvbT4KRGF0ZTogICBXZWQgSmFuIDI1IDA3OjI0OjIzIDIwMTcgLTA1MDAKY29tbWl0
IDBjMmU5ZjdiZDE1MDBkNDZhM2U0YTc2MjI3MGQ0M2U0NmE0Y2ExZjUgKGNlcGgvd2lwLWxheW91
dC1oZWxwZXJzKQpBdXRob3I6IEFsZXggRWxkZXIgPGVsZGVyQGRyZWFtaG9zdC5jb20+CkRhdGU6
ICAgVGh1IE1hciA4IDE2OjUxOjI4IDIwMTIgLTA2MDAKY29tbWl0IDU0ZWNkYTRlYTRhNGJkNmFm
YjA1YjE4MDJkYWUyZTJhYzMzMjYwMTMgKGNlcGgvd2lwLW1kcy1zbmFwLWZhaWxvdmVyKQpBdXRo
b3I6IFlhbiwgWmhlbmcgPHp5YW5AcmVkaGF0LmNvbT4KRGF0ZTogICBUaHUgSnVsIDcgMTU6MjI6
MzggMjAxNiArMDgwMApjb21taXQgMDMxMzk1NDczN2JhNWM1ZDVjOTJkMjFiOGI2MDNiYzhiNWIy
ZjNjMyAoY2VwaC93aXAtby1ub210aW1lKQpBdXRob3I6IFphY2ggQnJvd24gPHphYkB6YWJiby5u
ZXQ+CkRhdGU6ICAgRnJpIE1heSAxNSAxNDoyMzo0OCAyMDE1IC0wNzAwCmNvbW1pdCAxZjZkMWMw
MWIxNGIxODg0Nzk5YWVlYWJiOTY3M2Y4MDAzMmNiZmZmIChjZXBoL3dpcC1vLW5vbXRpbWUtMSkK
QXV0aG9yOiBaYWNoIEJyb3duIDx6YWJAcmVkaGF0LmNvbT4KRGF0ZTogICBXZWQgTWF5IDYgMTU6
MDA6MTIgMjAxNSAtMDcwMApjb21taXQgYjk0OTg2NmQzZDUyODhmOTRlYzhlMTI5YWYyZThkNDRj
OWIyNzBkZiAoY2VwaC93aXAtb2JqZWN0LW1hcCkKQXV0aG9yOiBJbHlhIERyeW9tb3YgPGlkcnlv
bW92QGdtYWlsLmNvbT4KRGF0ZTogICBTYXQgRmViIDIwIDE4OjI2OjU3IDIwMTYgKzAxMDAKY29t
bWl0IGQzMzI1ZTdlN2ZmZTQ2OGRlOGRlMjgxZGJmYTEzNDBmMTk5M2JmMzggKGNlcGgvd2lwLW9s
ZC1yZXBsaWVzKQpBdXRob3I6IEpvc2ggRHVyZ2luIDxqb3NoLmR1cmdpbkBpbmt0YW5rLmNvbT4K
RGF0ZTogICBUaHUgSmFuIDIgMTY6NTg6NTIgMjAxNCAtMDgwMApjb21taXQgZTFjMzZlYTZhNzNk
N2M1MTdlYjk2YWQ0Mzc1NjdjZGE0ZGU5NzFiOCAoY2VwaC93aXAtb3NkLW9wLWNscy1jaGFpbikK
QXV0aG9yOiBEb3VnbGFzIEZ1bGxlciA8ZGZ1bGxlckByZWRoYXQuY29tPgpEYXRlOiAgIEZyaSBB
cHIgMTcgMTM6MTc6MjUgMjAxNSAtMDcwMApjb21taXQgNWNiYmI3OTFkZTM5ZmJlY2YwZTQ2ZWI1
MTkwMWE1MGZkNzEzYjNkZiAoY2VwaC93aXAtcmJkLXJlZnJlc2gtZmVhdHVyZXMpCkF1dGhvcjog
RG91Z2xhcyBGdWxsZXIgPGRvdWdsYXMuZnVsbGVyQGdtYWlsLmNvbT4KRGF0ZTogICBXZWQgQXBy
IDIyIDA3OjIyOjQ1IDIwMTUgLTA3MDAKY29tbWl0IGIzZjEwOTMwYWNiYTRiZDlhODA1OTIxZGNi
OTgwNzA0NzVhMDUyNjEgKGNlcGgvd2lwLXNwbGljZSkKQXV0aG9yOiBJbHlhIERyeW9tb3YgPGlk
cnlvbW92QGdtYWlsLmNvbT4KRGF0ZTogICBTdW4gQXByIDEgMTc6MjA6MzEgMjAxOCArMDIwMApj
b21taXQgNjEwMDAxYWViNDcyMDNhMjg5ZWE5ZjgzMzVjMGY0ZGQ1YTY3NzU0ZiAoY2VwaC93aXAt
dGlnaHRlci10eXBlcykKQXV0aG9yOiBBbGV4IEVsZGVyIDxlbGRlckBkcmVhbWhvc3QuY29tPgpE
YXRlOiAgIEZyaSBBcHIgMjAgMTU6NDI6NDMgMjAxMiAtMDUwMAo=


--=-QJ1kW3N0hasriz6FlaXR--

