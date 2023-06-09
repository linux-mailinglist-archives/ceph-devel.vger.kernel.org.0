Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01E729581
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbjFIJiZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241750AbjFIJhk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:37:40 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7242A7681
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:32:46 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5352B3F484
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303121;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bOQiwn81QXGJoZaNfCJ7RNMSLmlLg48W89Fm6SjLuxef1EzvumsdFyguXz6anz+r/
         l73R1q6VV9oUpLCJgUQh62D9UkEAoqzeu/TwdO5s6x/Jwd9vBV0YC2mQJKRsZEjGEE
         EokRHfKN6WHlWzdKgzw0PHXuzQ1KGAlpfScmfBvA0Q8KJWry/JcXiTZgYFQ481NunH
         04EXB+t86TCGLeIDYYlcvnRx2AfH8l4YbOKC7jyCZDS120ilDXbNAiMVJowzlZBuxJ
         FZnp5JSmzhdaYLcOO130h/Uct40ti4+n8+uN5nbod2JOSQ6ej/otDnol9xnrPX8yh9
         AvVVVx0SKc8VQ==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-977c516686aso183454266b.1
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303119; x=1688895119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        b=c2b69wzwc8MYmYcVx0sFoVV4yOr4sAnBlg0z3eefQZNHl6l6cMheXAkgx61TmAWNDZ
         lC4IKYJoxcHf3zAPmm8+t4DeM0G+Iyg3fSfx4uqfoBRCeOYw8bZbMPmyomxDHa5K9CVn
         UN4zhF9WGgozL9zzkaEyi5xG34OUGq9BDJ7IrAkOJfRSGhQ3ccYmzjrz6r5nI/HJ5FyC
         JolTeryC62lkw7B3ZbhJl4QbFVzl+Qt+s9LwNapgzL8Er4vctMbhFhmUj9hNeTfqsWvJ
         iA0wU7FGZLJXeBYaCmixppcXl+lYzdcptUgldaoWAGm94A2hr3uL2/h47zu3Ed0h78uJ
         zoLQ==
X-Gm-Message-State: AC+VfDw8x738olnh+Pz3ZSoEKY77RgpintH9PREqZ9eIkvFJhSOD4CXf
        Q27UGltnXZcOS0zEiAmPhL7WtdSSZKm1GfJ4rPp+gKGQwMCux+L7nY8Iy9jwC2kmeBWeY+G4RLO
        suKzY0NKWhpsjuj8opaalk/msU3YqO+ycvp8JJ7E=
X-Received: by 2002:a17:907:70a:b0:96f:a935:8997 with SMTP id xb10-20020a170907070a00b0096fa9358997mr1328421ejb.12.1686303119323;
        Fri, 09 Jun 2023 02:31:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7KTDPE0tV+H7gY9GZ34++hd2WgdCfXpbS52PAeja+APzcvyP7PE8xa61fw03DjcBadMICTyA==
X-Received: by 2002:a17:907:70a:b0:96f:a935:8997 with SMTP id xb10-20020a170907070a00b0096fa9358997mr1328411ejb.12.1686303119167;
        Fri, 09 Jun 2023 02:31:59 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:31:58 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Seth Forshee <sforshee@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 01/15] fs: export mnt_idmap_get/mnt_idmap_put
Date:   Fri,  9 Jun 2023 11:31:11 +0200
Message-Id: <20230609093125.252186-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These helpers are required to support idmapped mounts in the Cephfs.

Cc: Christian Brauner <brauner@kernel.org>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
v3:
	- EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL as Christoph Hellwig suggested
---
 fs/mnt_idmapping.c            | 2 ++
 include/linux/mnt_idmapping.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index 4905665c47d0..57d1dedf3f8f 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -256,6 +256,7 @@ struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap)
 
 	return idmap;
 }
+EXPORT_SYMBOL_GPL(mnt_idmap_get);
 
 /**
  * mnt_idmap_put - put a reference to an idmapping
@@ -271,3 +272,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap)
 		kfree(idmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mnt_idmap_put);
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index 057c89867aa2..b8da2db4ecd2 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -115,6 +115,9 @@ static inline bool vfsgid_eq_kgid(vfsgid_t vfsgid, kgid_t kgid)
 
 int vfsgid_in_group_p(vfsgid_t vfsgid);
 
+struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
+void mnt_idmap_put(struct mnt_idmap *idmap);
+
 vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns, kuid_t kuid);
 
-- 
2.34.1

