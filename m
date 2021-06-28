Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA23B5A2A
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 09:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhF1H6a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 03:58:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232421AbhF1H63 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 03:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624866964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmpWzSnheqcD05HwcO5Bj81xbb6dbI6zzLJ4yExkgSI=;
        b=PsKkKjORr8fK9rAgRncSauaBWBdZ5oiplYlyvja3KoLh4amzbedOtBWozoGgPmuPNWZQY+
        07ZBOoIk4OlZs98rNGyDNj5AG5dZkcFY96ZLs3MzydXR4L/Ur307EV3fxka2AH+x7H/6n+
        H8PA8kgH1u7W7DpNcpsdVyWLb9BEJLk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-9mH1PIrDNt29qDERE8B-9g-1; Mon, 28 Jun 2021 03:56:00 -0400
X-MC-Unique: 9mH1PIrDNt29qDERE8B-9g-1
Received: by mail-pl1-f198.google.com with SMTP id 4-20020a170902c204b0290121d3ad80ecso5442071pll.6
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 00:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dmpWzSnheqcD05HwcO5Bj81xbb6dbI6zzLJ4yExkgSI=;
        b=CBlDgwS56hThiBBgl48Nb8F+kNaq2ClCwag1yhBx09MSXMTl6lp9+Jytw7kicOvaCL
         jJjdYuIDZ+u6KEn1fjMpfn58YI2st1rsAZjlR41Fe1rmHpcolNMw++gYtX/nxdwt+42e
         zLwUpqsu9ExdtznZVxCqKCavPwsBsEtldM+yNExRn2B74/Qf6K6wn0EuqWKcDrvfblBd
         XL6TTQLHgZyHUQ/Xj8AgnT+1XZJpz/AGPyMf/eyt5cdxUnCLlXcgVM7GT7BMizGP48i1
         /y2cD+0OhamRD5MdLnKM2Pcc8PrvBI1UZMdA7DeM/5iBKC35s6VnPKqZvjdkVMRBD6pp
         DHDQ==
X-Gm-Message-State: AOAM533Mm2t5Ihau86L6Qc6lWL2IXWagk68eDMHFVlQGD/VCjrS78M0I
        AWpt1yRIff7gksHaxH2SbTugndZhF8cY2iNoOapooXZf0Pk+NPU18LFyCnY7pmN8rYsawu6rtdr
        wG6AEy6vlohqQPeCtfx9lXA==
X-Received: by 2002:a17:902:bcca:b029:127:a4f2:845c with SMTP id o10-20020a170902bccab0290127a4f2845cmr17592029pls.29.1624866959936;
        Mon, 28 Jun 2021 00:55:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn5dD306QXkuB3Na3cke9XnHcrhjtdXo7ttLNmEFC3JmkUbwcwYCIe8TNgw/hgJc+MtTSiIA==
X-Received: by 2002:a17:902:bcca:b029:127:a4f2:845c with SMTP id o10-20020a170902bccab0290127a4f2845cmr17592021pls.29.1624866959774;
        Mon, 28 Jun 2021 00:55:59 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.6])
        by smtp.gmail.com with ESMTPSA id g123sm8304959pfb.187.2021.06.28.00.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:55:59 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 3/4] ceph: record updated mon_addr on remount
Date:   Mon, 28 Jun 2021 13:25:44 +0530
Message-Id: <20210628075545.702106-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628075545.702106-1-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Note that the new monitors are just shown in /proc/mounts.
Ceph does not (re)connect to new monitors yet.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 84bc06e51680..48493ac372fa 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1250,6 +1250,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
+		kfree(fsc->mount_options->mon_addr);
+		fsc->mount_options->mon_addr = kstrdup(fsopt->mon_addr,
+						       GFP_KERNEL);
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
-- 
2.27.0

