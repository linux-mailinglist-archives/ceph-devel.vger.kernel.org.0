Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632017725A4
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbjHGN2y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjHGN2r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:28:47 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC8A1BC6
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:28:26 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B7BD13F20E
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414882;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kEsiTuUaGvgiZixzSK5tdhGyQohFuGub9EDTjE3KOpKq+YhpJ3pw9pcphgZcg4AJH
         9/JF1ZVM0VrdfSONyEyg9tQNWjNA8ZTdmkvARrN4N0mm7negxE08ztHWwOG11HNV+X
         bcCJ7NdzJiKvXzi/vQ+aGAc2Z2kaMJwLI6FC0Bz5g+C3RCx4aysuh7YyWaSfVW0PMh
         iOq7uU5pRGQdCh9sWJX5+6zn6urjCR73ZJ4oX9vtnxYwmEPBH9QAa7B6a+mLlOzNRw
         CAV3LvCEAlJSeTNqoPl7MGXt2jXYnQlX07tWUbki2bB3I/oUqNoWSIjPqCLf0ScNz9
         F7lsW11lqx4Vg==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5225a8f625dso3359743a12.0
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414882; x=1692019682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        b=TtElqzBtuQ+B3wpX4cjBGYj7ZmTllYbQxJCOMfbbIKS5UTJbRHzsPv4pwrMx7qy1Zn
         6/wxiWOOIMlGKcNmbKTbacvp1Z8d7g5Kxc1TcKkDeFLNrU1j+9qwM0+1riSWhzK2roZP
         4B+VBVFDvVHkzQQe3nUj/dZk/2+7Kd7Sj0WEmVLm/M7g4ZUAGVu6khTV8cklmGRkvLLe
         wj5zo8AqlgpvkzGoYdh2Z1Hwk4bEqfVN8uibFY71x1qZtH78g9EQ0P3uX+zMCM+mgKIj
         ye1mZ72iMubXIq3TjCxpmCB+KJyuomM5YKN3YhRnuZwqHGyDgL1gX1s4VOvgxZArGGhK
         OsKg==
X-Gm-Message-State: AOJu0YyZn2wivXRg0k9tlxY1n/V/J5U6NHyCnaf7iT8pHjf5/BI0eotH
        AOqaSwm+ZdGlKwlr+CB8wXTVzM4/uLAiS2wovhwgs+8EMG0+2/mwUy+WD3csWuJDRXlklinNoQo
        V3iCM9yBYEb4oQ0vaCpb93fpg4AuKraCdY9m+HJM=
X-Received: by 2002:a17:906:1db:b0:993:f2c2:7512 with SMTP id 27-20020a17090601db00b00993f2c27512mr10084636ejj.33.1691414882353;
        Mon, 07 Aug 2023 06:28:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJO/0vqqE3tOHSpFzVew5B2QmVjKhzPumTSIkC7c+m2kty/8ghyCXqQKoZTu6KRcvPeoWfNg==
X-Received: by 2002:a17:906:1db:b0:993:f2c2:7512 with SMTP id 27-20020a17090601db00b00993f2c27512mr10084624ejj.33.1691414882075;
        Mon, 07 Aug 2023 06:28:02 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:01 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Seth Forshee <sforshee@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 01/12] fs: export mnt_idmap_get/mnt_idmap_put
Date:   Mon,  7 Aug 2023 15:26:15 +0200
Message-Id: <20230807132626.182101-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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

