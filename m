Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB87763899
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbjGZOMG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjGZOLp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:45 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D58F46A9
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:59 -0700 (PDT)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3CE28413C5
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380637;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Mgrx7z6yozfoTxgYHpGQiGQPM71+PsK2RzMgfb8SNzC7G9O2EttikVb8iicd917Rh
         FCUDWAlcs3ns7vp9dvC/LsCpMgtC+6KyA7pDL/3VVgrAztkRmeZ84MgGFgpm6H+m+E
         0QtHQCzVFgRpe6FlWvnP1fT6MS7+e/11P4fl61pGMuuFrkYobc93DGKZ63KkGyi0OQ
         Q8hARDkrUJiBpQdGzSkWWp1sHOQUOkHcYJvripPwF6wFk+SKAOwyCVGEgJEMuyTV+s
         SvElTwRQ6Wu8I+qhRBCSbejshJPMAnC9jsOO5ClCT9cQTuptVr1Hvbxxdm6KBVx+xB
         TBfwipjVyRfcw==
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fb40ec952bso34053115e9.0
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380637; x=1690985437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFNwWvhavDkNrI4eqwez7OWrv+w+Iw1WNhnwQW/Fw7E=;
        b=EgXBHSCu5xDkoLp3VOSiFrGRUIR/6xLsfandj5sYN7zxqVAakJmM/OfGvw5LY5XqBS
         PkafQZyx4L2WZw7qXA7zKZQ/Pek9wlol0o1yXy5cIu/AHiq5i7GiOGsezTFXcZISipkF
         qooompTtPCESPEwDiBWAc6VlJRE/rgc7IKAHPYlhqB//DedwxwLRFwTivDWMMrCOiKBz
         j3PEL1V2TAOgtpW2vMYTxykVZmm1cJ04d+leg7OmTqvHaBi+FDhcQHJ7pbb9hgbLLJ3s
         vkctFiZDYJWlCZBpC0f9WTr3Tjh4C1HYEQb4JyfHCNFCf3CKIRUQ7tRtTfxJBxO4Eusr
         bacg==
X-Gm-Message-State: ABy/qLZE9+Nk6T8ZchbOESdW/ByhyR4uAfGgO4riIe0h/YnXH6DLHpYs
        w36TLl/dT+2k9535Y1ingiH+ep1q/Kv+bSxrGtGSE8VMfSOycA/FadzrWUVeZuMy2JTSDuW7E9e
        EGseTKGi2xc5hpJnoDqgzy67PMQaaUlyEbPMLcR4=
X-Received: by 2002:a05:600c:2299:b0:3fc:1f8:41f1 with SMTP id 25-20020a05600c229900b003fc01f841f1mr1600047wmf.1.1690380636976;
        Wed, 26 Jul 2023 07:10:36 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHkSbP3XBm9fWMpi6nYgn/mk46VMT6r5l6RNjjt4RVJ4wv9+LR91oDtZmjBkGfw247vQ0xNpg==
X-Received: by 2002:a05:600c:2299:b0:3fc:1f8:41f1 with SMTP id 25-20020a05600c229900b003fc01f841f1mr1600034wmf.1.1690380636714;
        Wed, 26 Jul 2023 07:10:36 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:36 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Seth Forshee <sforshee@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/11] fs: export mnt_idmap_get/mnt_idmap_put
Date:   Wed, 26 Jul 2023 16:10:16 +0200
Message-Id: <20230726141026.307690-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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

