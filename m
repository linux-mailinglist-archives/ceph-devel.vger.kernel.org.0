Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A554CD5E0F
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 11:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfJNJBK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 05:01:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38481 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730544AbfJNJBK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Oct 2019 05:01:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so10020148pfe.5;
        Mon, 14 Oct 2019 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PbTD0I60GSh6vo2clQRoXHKv0wnjYHftDLcQtXDhKQ8=;
        b=HZDLfHIR7a7a6S4ceGXMBLioZ5g2C8evGK0qdnQjAMcoYOMFP87sBeU2tOM+gFn1SN
         nk0e+7ngdgZ22Sut5YK3yzDuuit1cxpUgetxk7rjIlZtwByVE55z8ZgXkh+sLgxUSahc
         MyoUK/ecqm17Ak2Pqt5Pt64joHOTVwwlljuB9fsu5GeROcqqcn3jWDUFCM+wT5vnj90x
         qqQAgzkNTQ3tdlruc49hEmYbfD9PZScqnXwj00sujNKkYW3FKm+3Gt2WnX3uyadXCU9U
         PE3HR61AxoQgkoFuLshnn1oR0AmZsCcHQrEEmzlkZvL7CsDV16qFDqu2NsRbkvIwBlEJ
         dASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PbTD0I60GSh6vo2clQRoXHKv0wnjYHftDLcQtXDhKQ8=;
        b=VVYM7qlWloUHfW6wIcxteyresHEIMvg6GOgYuaB1FIiOz1KAqbfIWENTXMfTaZtxo8
         qCEIhhR/7E77P7jievJwyhbc5J/wLpazQ1b+dhMqPwCTBtDI8jFf/kK1vdbFNGHAlaXQ
         +ownZ1Vzu3qjc/v2HJpLHiPMTjBolWG/DKBLUAPcEi0ERj94oj28sx6CWVjZ843OU4Te
         4As1C+wqsbE196NRdehRzGpMqj7WMOuEA0Z05A7acpaahYj1XacRS5JnP7zCCtsIWpf/
         OzmE0auE4FFIg1AuoFbrxqXal13efKAFMZQqRN0pA+USh8cxkc3XoVLaLHGZTusVuU0A
         MY7g==
X-Gm-Message-State: APjAAAWFPb8bX/TY23BnYgHwqPcZUMumHRvdrW20hjt4KAq3FMogvN2S
        UKw65LC6TKQjgMd8Ih3yQ4Ppz+R6JYc=
X-Google-Smtp-Source: APXvYqw5glUkNF3sk3ZQxU4/KsL6ZW4MrUvH7bkze8fN1Ogp/oNGHPdRApsmzVY3LFDrrizDgPa8dw==
X-Received: by 2002:aa7:96ba:: with SMTP id g26mr32035784pfk.132.1571043669838;
        Mon, 14 Oct 2019 02:01:09 -0700 (PDT)
Received: from MacBook-Pro.jd.com ([111.200.23.6])
        by smtp.googlemail.com with ESMTPSA id e192sm22063103pfh.83.2019.10.14.02.01.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 02:01:09 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] function dispatch should return if mds session does not exist
Date:   Mon, 14 Oct 2019 17:00:59 +0800
Message-Id: <20191014090059.21871-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

we shouldn't call ceph_msg_put, otherwise libceph will pass
invalid pointer to mm.

kernel panic - not syncing: fatal exception
    [5452201.213885] ------------[ cut here ]------------
    [5452201.213889] kernel BUG at mm/slub.c:3901!
    [5452201.213938] invalid opcode: 0000 [#1] SMP PTI
    [5452201.213971] CPU: 35 PID: 3037447 Comm: kworker/35:1 Kdump: loaded Not tainted 4.19.15 #1
    [5452201.214020] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 01/22/2018
    [5452201.214088] Workqueue: ceph-msgr ceph_con_workfn [libceph]
    [5452201.214129] RIP: 0010:kfree+0x15b/0x170
    [5452201.214156] Code: 8b 02 f6 c4 80 75 08 49 8b 42 08 a8 01 74 1b 49 8b 02 31 f6 f6 c4 80 74 05 41 0f b6 72 51 5b 5d 41 5c 4c 89 d7 e9 95 03 f9 ff <0f> 0b 48 83 e8 01 e9 01 ff ff ff 49 83 ea 01 e9 e9 fe ff ff 90 0f
    [5452201.214262] RSP: 0018:ffffb8c3a0607cb0 EFLAGS: 00010246
    [5452201.214296] RAX: ffffeee840000008 RBX: ffff9130c0000000 RCX: 0000000080200016
    [5452201.214339] RDX: 00006f0ec0000000 RSI: 0000000000000000 RDI: ffff9130c0000000
    [5452201.214383] RBP: ffff91107f823970 R08: 0000000000000001 R09: 0000000000000000
    [5452201.214426] R10: ffffeee840000000 R11: 0000000000000001 R12: ffffffffc076c45d
    [5452201.214469] R13: ffff91107f823970 R14: ffff91107f8239e0 R15: ffff91107f823900
    [5452201.214513] FS:  0000000000000000(0000) GS:ffff9110bfbc0000(0000) knlGS:0000000000000000
    [5452201.214562] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [5452201.214598] CR2: 000055993ab29620 CR3: 0000003a1e00a003 CR4: 00000000003606e0
    [5452201.214641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [5452201.214685] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    [5452201.214728] Call Trace:
    [5452201.214759]  ceph_msg_release+0x15d/0x190 [libceph]
    [5452201.214811]  dispatch+0x66/0xa50 [ceph]
    [5452201.214846]  try_read+0x7f3/0x11d0 [libceph]
    [5452201.214878]  ? dequeue_entity+0x37e/0x7e0
    [5452201.214907]  ? pick_next_task_fair+0x291/0x610
    [5452201.214937]  ? dequeue_task_fair+0x5d/0x700
    [5452201.214966]  ? __switch_to+0x8c/0x470
    [5452201.214999]  ceph_con_workfn+0xa2/0x5b0 [libceph]
    [5452201.215033]  process_one_work+0x16b/0x370
    [5452201.215062]  worker_thread+0x49/0x3f0
    [5452201.215089]  kthread+0xf5/0x130
    [5452201.215112]  ? max_active_store+0x80/0x80
    [5452201.215139]  ? kthread_bind+0x10/0x10
    [5452201.215167]  ret_from_fork+0x1f/0x30

Link: https://tracker.ceph.com/issues/42288

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/mds_client.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a8a8f84f3bbf..066358fea347 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4635,7 +4635,7 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 	mutex_lock(&mdsc->mutex);
 	if (__verify_registered_session(mdsc, s) < 0) {
 		mutex_unlock(&mdsc->mutex);
-		goto out;
+		return;
 	}
 	mutex_unlock(&mdsc->mutex);
 
@@ -4672,7 +4672,6 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 		pr_err("received unknown message type %d %s\n", type,
 		       ceph_msg_type_name(type));
 	}
-out:
 	ceph_msg_put(msg);
 }
 
-- 
2.21.0 (Apple Git-122)

