Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3565536A916
	for <lists+ceph-devel@lfdr.de>; Sun, 25 Apr 2021 22:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhDYUGX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Apr 2021 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhDYUGX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Apr 2021 16:06:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53089C061574
        for <ceph-devel@vger.kernel.org>; Sun, 25 Apr 2021 13:05:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g5so74541152ejx.0
        for <ceph-devel@vger.kernel.org>; Sun, 25 Apr 2021 13:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5ZXSc4RB1Q7uADHp3BzIP31WCzYQ4X/jnLGwWbpzZM=;
        b=R+5FkgwwpOM3OGlhE3aWPd26n4LxCGEbEJnjq8r0V0dsRodkYkS0LLqUXhkUjZbPnF
         jey72l4Dhy62v4VzNaVr4iQ0ZqXgrQ9kR4t3kpanG6TNMmfNllOQ7R+DxXi38icJNPxJ
         sWH1CL8LjH2jl79d7+JAu6XUun+ZxCnDyZgfSu8InTShW+zSMwd9lqxytuwYfiTvLhNB
         uAYLAyZls+EX4MPYLG1CCDjg9p7oRg6e19PvrqJpdbiHAPDwdNqkIBLIzLqr0/0hWxTP
         u7CBncMntQK1X1Asol1hWwJstXcB5FmN6rXgVYZXD9NC709mJ8nwqISeGxEFD31URG1t
         u+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5ZXSc4RB1Q7uADHp3BzIP31WCzYQ4X/jnLGwWbpzZM=;
        b=PaMYgqNbmcWgQJtpn+eHwXo54Nthe6pIYCOiKvJ8SU2teMreDkWMpAyKMLov12SOJW
         kakfVP6VudeEqyr6nmAj4PBctZ0jQhxcfF3W1wudIcMbowjY7LwtfYTb563gXgcznNp2
         eDiChoR97XZeueRRVaTUOG2Uk2Jh1FoFamnLi4E/a506sRja6rraRo/DqrS4txcQh3Fb
         OlXQP34nqsBEnh5g60iwVEaPmHhVGBocE0zCPJ+j6WlKROQcIeRUqNIf6nPfzGUqxa92
         YAV5Udg+Xb13Q+PhzrxXn7DVe3ufpmKE4uAyReSkcpFH3E7amYmpwHxuSiblAXAWkvG9
         RW/A==
X-Gm-Message-State: AOAM533bUvxgCiTNfPSAxzZ3C/eQKAD4+zmZo864rAhCXlriNQdRuGT6
        TKqwsZEQ58C5hALY5B4R9Ic2EGE+RokHlQ==
X-Google-Smtp-Source: ABdhPJy6MsID7yLSznTSdyFG9s/6w9/9fyYQ/o3OxeCMlnK23+mNt/B//mDhkLnIEMvFgD64jrQ65w==
X-Received: by 2002:a17:906:26c9:: with SMTP id u9mr14939374ejc.520.1619381139034;
        Sun, 25 Apr 2021 13:05:39 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id n14sm10003147ejy.90.2021.04.25.13.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 13:05:38 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Subject: [PATCH] libceph: bump CephXAuthenticate encoding version
Date:   Sun, 25 Apr 2021 22:05:14 +0200
Message-Id: <20210425200514.26581-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A dummy v3 encoding (exactly the same as v2) was introduced so that
the monitors can distinguish broken clients that may not include their
auth ticket in CEPHX_GET_AUTH_SESSION_KEY request on reconnects, thus
failing to prove previous possession of their global_id (one part of
CVE-2021-20288).

The kernel client has always included its auth ticket, so it is
compatible with enforcing mode as is.  However we want to bump the
encoding version to avoid having to authenticate twice on the initial
connect -- all legacy (CephXAuthenticate < v3) are now forced do so in
order to expose insecure global_id reclaim.

Marking for stable since at least for 5.11 and 5.12 it is trivial
(v2 -> v3).

Cc: stable@vger.kernel.org # 5.11+
URL: https://tracker.ceph.com/issues/50452
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/auth_x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index ca44c327bace..79641c4afee9 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -526,7 +526,7 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 		if (ret < 0)
 			return ret;
 
-		auth->struct_v = 2;  /* nautilus+ */
+		auth->struct_v = 3;  /* nautilus+ */
 		auth->key = 0;
 		for (u = (u64 *)enc_buf; u + 1 <= (u64 *)(enc_buf + ret); u++)
 			auth->key ^= *(__le64 *)u;
-- 
2.19.2

