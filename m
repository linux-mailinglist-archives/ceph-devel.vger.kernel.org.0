Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B5529E8D
	for <lists+ceph-devel@lfdr.de>; Tue, 17 May 2022 11:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbiEQJ5P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 May 2022 05:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244686AbiEQJzr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 May 2022 05:55:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48EE314
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 02:55:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ch13so33545556ejb.12
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 02:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pij0rhZ4QwRkVrKTWUPN3ygzEAYj5Yqsxd4fth4csAA=;
        b=noSgd1pNReOTA3bGZCLTSZrNlWW1zy8QfoZRbLjn4UN4o/a2G38aIJkq+91mnLvf6H
         9uSUpLYGGfvcCgrc5yH75SY/IO/exCRshew7lEBd/PNxt1lxsv7bl0uUgbciobkDM+0n
         ajJMZmFfRa3SQe0aFjAYdDNV4Bope0WjRDFpIV3iZs/WOgKg9CwaF8m/5Vyc8Px2kyuk
         W3Jf3OJK0fzf9uYMeyf7BGglkj2HjQ6Sh7fbaRnqkMwtriY5MltyriImWhnIkH5e9Sjk
         7scY0SR1vcCKlQA1ypHypvNb96EppwYOme9q8zFguX5FNpotRKF2c4h9UjiNUJmRflHo
         SFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pij0rhZ4QwRkVrKTWUPN3ygzEAYj5Yqsxd4fth4csAA=;
        b=riQxwzWjtn7i5CxGt0caA90PuSrxremF6C55AlAXSPAGbhdEBt6BAwr94oJ6tq2YVh
         zllQdmgF2kLLJALV3hup2OnfWwktUoLMVrt5J4cf6fjNHqxboHWW8493Ka3VhY53x9KV
         4MwMdSejdknLyvYoBWiDXaa2vc/aaONnYMptZ/0YLkfJP8X+jDZJgM9whItJtqUczvsB
         IoeJM50OVgAZNWioxTYWDRdy3nokX+y5VCH4TR+EfpZQEC0EuDFNlC2eBtOLIG/L+tKz
         GKGCk0rhhgPsoLE2B/KpOFllC0e74aC5tVtqtUHAdoaMlWTUS5pkKXE82rXW/RL/z9nG
         WdWw==
X-Gm-Message-State: AOAM5301979pY4nfbWKkpHc8NIgVwXZJT0olsRsGN0mqkEBiI6X3NBVB
        8YX/WeRNN/16+b4RCS9sD9p0tNbcAPihCw==
X-Google-Smtp-Source: ABdhPJx+vcVdpiCqKd+wI/Fy7/2ba6V/7EsF0kvLgIwp3I52L5MgWuDDV6d7EY95s/2VgfuN02t7cg==
X-Received: by 2002:a17:906:730e:b0:6f4:e9e7:4f4 with SMTP id di14-20020a170906730e00b006f4e9e704f4mr1962894ejc.509.1652781343294;
        Tue, 17 May 2022 02:55:43 -0700 (PDT)
Received: from kwango.local (ip-89-102-68-162.net.upcbroadband.cz. [89.102.68.162])
        by smtp.gmail.com with ESMTPSA id g5-20020a50ee05000000b0042617ba63d0sm6601614eds.90.2022.05.17.02.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:55:42 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: fix misleading ceph_osdc_cancel_request() comment
Date:   Tue, 17 May 2022 11:55:34 +0200
Message-Id: <20220517095534.15288-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

cancel_request() never guaranteed that after its return the OSD
client would be completely done with the OSD request.  The callback
(if specified) can still be invoked and a ref can still be held.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 4b88f2a4a6e2..9d82bb42e958 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4591,8 +4591,13 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 EXPORT_SYMBOL(ceph_osdc_start_request);
 
 /*
- * Unregister a registered request.  The request is not completed:
- * ->r_result isn't set and __complete_request() isn't called.
+ * Unregister request.  If @req was registered, it isn't completed:
+ * r_result isn't set and __complete_request() isn't invoked.
+ *
+ * If @req wasn't registered, this call may have raced with
+ * handle_reply(), in which case r_result would already be set and
+ * __complete_request() would be getting invoked, possibly even
+ * concurrently with this call.
  */
 void ceph_osdc_cancel_request(struct ceph_osd_request *req)
 {
-- 
2.19.2

