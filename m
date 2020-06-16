Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40D91FAAAC
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgFPIEK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 04:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgFPIEJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 04:04:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480F5C05BD43
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 01:04:09 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id k11so20464525ejr.9
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 01:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CDQ0WhHGM4VPKLvbiSs1JCCOa74rODgNmXBrB9AOcvI=;
        b=rtw4dPH235v7kC4bsaxMjmI5yQ+KTbpd5GSKDNT0Mw34NO/oYFBLRJXGvpEcfaI4AO
         vGCub0JbcLITrFE2YBxP+HLesjfZnCg0TkmhHC1cAp+wbVPZVVsirKxLrih46r+7ZQ7P
         DFsfDfhUNYVRJ/T71V2P6kduvsKZo2QP1lO8ZGVGfXzxFzSdPS7KbIIj/Bp/8dvDvJCP
         P6X0RO0HoayOfjfSdb6esj3aykpm990yfeCVfxkm1cK/1y6HliPphAaCuiddOj0BAHy2
         dHh1g0di5lrbt++Mo1Ah4Qf8sXls2HEGbPRLzBPuZLdKciPHpZS8hGe7+amLUaIk7ZMi
         jtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CDQ0WhHGM4VPKLvbiSs1JCCOa74rODgNmXBrB9AOcvI=;
        b=iiGxChC9v4l8MlKPzfQ6dSE9VsPLSE2vVbj0+ZJ+T51RDu3dafhZtHjYp6CVC6UmmJ
         m94SnBNEYm8Lsfj5/NudNm7ynYpmOrFWo3y5Yq2paggFScxOZGt7gorW+VkXfm9qByCD
         8M821W954EyOIOZPHAsLcv+kfFnBUnkW/1EMcpyZyxS4GY4J7cg8rtXKlDnRFp5lLVm+
         NSdMIFZ9Ot4DC4WW1PWvreTCE8ondPypfTiusoKDYoPeezrzgLCvbVxATPVrU0eOk2Uu
         3Rz2ObPnrfXD1JveIkT3Qg8sDPm1KWKSAuigFjuf8Lqh/F8DLYwFc5G8P33/E4k8zxNl
         T+tw==
X-Gm-Message-State: AOAM531V+RAkEl8FrBJfnaE8eh8JvgH92X+pR0QgWRWYDOQ+fI8QLmVc
        uqZMSLi2/HbGT2IUuUFKTYSLFv4n+1Q=
X-Google-Smtp-Source: ABdhPJwg4Xlt4JYKDf9hoWOg/Kia/gnOjQujYuJxWGX16TH1MOUD6hfNudiVkjFXvsex8749G/a/JA==
X-Received: by 2002:a17:906:66d0:: with SMTP id k16mr1672653ejp.293.1592294647780;
        Tue, 16 Jun 2020 01:04:07 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id dm1sm10614977ejc.99.2020.06.16.01.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:04:07 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] libceph: dump class and method names on method calls
Date:   Tue, 16 Jun 2020 10:04:14 +0200
Message-Id: <20200616080414.15534-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 409d505ff320..2110439f8a24 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -223,6 +223,9 @@ static void dump_request(struct seq_file *s, struct ceph_osd_request *req)
 		if (op->op == CEPH_OSD_OP_WATCH)
 			seq_printf(s, "-%s",
 				   ceph_osd_watch_op_name(op->watch.op));
+		else if (op->op == CEPH_OSD_OP_CALL)
+			seq_printf(s, "-%s/%s", op->cls.class_name,
+				   op->cls.method_name);
 	}
 
 	seq_putc(s, '\n');
-- 
2.19.2

