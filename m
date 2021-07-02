Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79D3B9C54
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhGBGvP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 02:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhGBGvO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 02:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew6Icu6BzKoQdwHGglpdhi4SGwI9gfMkWEs4+Pdy7Pk=;
        b=adfn3xGR1xgwl08Psaao+SyBwJQzrQFiWtzRDSmVtMl2EHPQ+aeO2Q/yn38miu8Ny4qHQ4
        mYq0fFdTUkFN6oA3tUX5ZmLar3RZe3Xh+XD0ujaqGh/k9Xil0e22UNjgY7q1u7TdlZhQx3
        QsVKkD2i4olj0/szeNDaltaXesSy2cU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-sThQSYNbNvSQVgtdrVM_gA-1; Fri, 02 Jul 2021 02:48:39 -0400
X-MC-Unique: sThQSYNbNvSQVgtdrVM_gA-1
Received: by mail-pj1-f70.google.com with SMTP id q9-20020a17090a0649b029016ffc6b9665so7423758pje.1
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 23:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ew6Icu6BzKoQdwHGglpdhi4SGwI9gfMkWEs4+Pdy7Pk=;
        b=Ob/raZ5tZqqQGSkKpvIUd95EfkwSysr6FoUeYmnyoEvezSVlsqhvKuYl+IafmnF3yD
         n8jNpMC0sBPLSnXI4CurXyfJBmlRCrtHoLy3WhgHDXixypMa8rgRtLoS2Vcy2hgUj7nM
         Hy2SlNVuRLi9A0E5Vpm7PiRybQhS9gvWYIClty9lnNtuTflse3K/oAIGSGVQJLJZt2i3
         xd9ymy1vUrImh8VJm6qn/GAdEHBmzEYqgyZhM3RbqHXTlvjSCHbo+Zm/HOz9BgdZNqc5
         6NmqYVN1rAPWRo754Tmgps76DB2Gs0wWzKbqTcwe65KCYKNCwmRXnpEzfScxPe+SS6Uf
         tyAg==
X-Gm-Message-State: AOAM5335DpOOlISN0p5lGsRy1Lax4Qr1rFpqb0WvUJ6D05po7mlVEUyB
        lw0FqXFzco2ZIFatvSS6BuVx3BnUGkCoo21NTHGvAsZ4Ua1wBEXgjkmGDk8v/R00H9QMrVpUsxo
        ae5eCE+UnG6zYo6GDqCQICA==
X-Received: by 2002:a17:90a:4a8f:: with SMTP id f15mr13785802pjh.76.1625208518254;
        Thu, 01 Jul 2021 23:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7ej9gQSQD+lgAjPwkUopnE/+rBEcccumw2dXb44uf0zPJ+zjuRQrZHblfgt3rJZkRb/zHBw==
X-Received: by 2002:a17:90a:4a8f:: with SMTP id f15mr13785789pjh.76.1625208518054;
        Thu, 01 Jul 2021 23:48:38 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id o34sm2394364pgm.6.2021.07.01.23.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 23:48:37 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 3/4] ceph: record updated mon_addr on remount
Date:   Fri,  2 Jul 2021 12:18:20 +0530
Message-Id: <20210702064821.148063-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702064821.148063-1-vshankar@redhat.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
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
index 03e5f4bb2b6f..52f03505bb86 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1255,6 +1255,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
+		kfree(fsc->mount_options->mon_addr);
+		fsc->mount_options->mon_addr = fsopt->mon_addr;
+		fsopt->mon_addr = NULL;
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
-- 
2.27.0

