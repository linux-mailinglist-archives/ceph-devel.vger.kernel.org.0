Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1893E26AF2D
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Sep 2020 23:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgIOVH6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Sep 2020 17:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgIOUdm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Sep 2020 16:33:42 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3682C06178A
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:34 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id b79so765777wmb.4
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=D92hfOund9DV7TYIlYUf6Sy7EStcRmdtW4U0vvxpwuY=;
        b=C5c2pd7eS7VyEgY7+J65TovrBkWgz5jvc790Xt/tFohY7a/e6boqBsBGWRjQAu9b4z
         RboRW5+/RmwK0AG8F0Z3jJsUKSL9jYnW/3PFzcUhHIvQFwxxtauiW3cJTfI4rr/m1a0M
         7E6tq+Td/c+s/+NjdbOwbTxKR1tEFXYpm5q4U+7zwyDkEjLyNGh6CGIVE5a11lg+vPho
         RB70vS+vhiciioliPOmsyQt0WIdwIE2prQu15ZXiPxCupN24imh/9azWtaqEJRCQyGgZ
         lqD73Qi9yEpmq7puOrpN5kJTQArH+kFS16hZCsIVELRwdu8J3g/UzJy9APq5Sq0lByn+
         OwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D92hfOund9DV7TYIlYUf6Sy7EStcRmdtW4U0vvxpwuY=;
        b=a+sxBbiIgWs3gZ2ptAjYSjUfDVCIsXmSs219Jt4o5sY/MpN5U8m80jJ0Z8AJRA/IhB
         sC6CG5xcTpC5ySsPmEpd1f6M5Y2MroP4zwZ7bv5JEkCWUzAVzy2KzyKJiOWt/3UJI18w
         7Xz0ucFNsWDQkh7/7C/Vbwf0Bv19Q9sks6jT7qFwbINKIQERvKueagEtHo5pVyxnz6Qc
         EIVRkXzgnVN25O+yy7IjqPjhcwSSj0S5QCTGagxGRZUb37n91TZgJBMqFU8xx4ty01W4
         XiZybC7hAbp6Q+Zr43Z4fQY0yHPRkk8+ATn17RKt9zh6Kn4zMF1wW7I2obtfLgD5OG3A
         wfQA==
X-Gm-Message-State: AOAM532WiXVg/R8K4bpJgtW4no41Wwc7US2kCNyf1J4xKVrjjwCCGpO6
        BGxmK8+c0WuvmBWKHabh9T46JE+ehNYa7Q==
X-Google-Smtp-Source: ABdhPJwH7C19aeNg9X+pCJdHydsmkIytcJ/2CQmVYZXZMBFdg8pZcFWcf9+0nPs7veZBR9YcRbhGAg==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr1044118wmk.97.1600202013358;
        Tue, 15 Sep 2020 13:33:33 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id q12sm27487250wrs.48.2020.09.15.13.33.32
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 13:33:32 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 2/3] libceph: switch to the new "osd blocklist add" command
Date:   Tue, 15 Sep 2020 22:33:22 +0200
Message-Id: <20200915203323.4688-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200915203323.4688-1-idryomov@gmail.com>
References: <20200915203323.4688-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/mon_client.c | 65 +++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index efcdde471278..32bce480f8e4 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -896,8 +896,8 @@ static void handle_command_ack(struct ceph_mon_client *monc,
 	ceph_msg_dump(msg);
 }
 
-int ceph_monc_blocklist_add(struct ceph_mon_client *monc,
-			    struct ceph_entity_addr *client_addr)
+static int do_mon_command_vargs(struct ceph_mon_client *monc,
+				const char *fmt, va_list ap)
 {
 	struct ceph_mon_generic_request *req;
 	struct ceph_mon_command *h;
@@ -925,28 +925,63 @@ int ceph_monc_blocklist_add(struct ceph_mon_client *monc,
 	h->monhdr.session_mon_tid = 0;
 	h->fsid = monc->monmap->fsid;
 	h->num_strs = cpu_to_le32(1);
-	len = sprintf(h->str, "{ \"prefix\": \"osd blacklist\", \
-		                 \"blacklistop\": \"add\", \
-				 \"addr\": \"%pISpc/%u\" }",
-		      &client_addr->in_addr, le32_to_cpu(client_addr->nonce));
+	len = vsprintf(h->str, fmt, ap);
 	h->str_len = cpu_to_le32(len);
 	send_generic_request(monc, req);
 	mutex_unlock(&monc->mutex);
 
 	ret = wait_generic_request(req);
-	if (!ret)
-		/*
-		 * Make sure we have the osdmap that includes the blocklist
-		 * entry.  This is needed to ensure that the OSDs pick up the
-		 * new blocklist before processing any future requests from
-		 * this client.
-		 */
-		ret = ceph_wait_for_latest_osdmap(monc->client, 0);
-
 out:
 	put_generic_request(req);
 	return ret;
 }
+
+static int do_mon_command(struct ceph_mon_client *monc, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = do_mon_command_vargs(monc, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
+int ceph_monc_blocklist_add(struct ceph_mon_client *monc,
+			    struct ceph_entity_addr *client_addr)
+{
+	int ret;
+
+	ret = do_mon_command(monc,
+			     "{ \"prefix\": \"osd blocklist\", \
+				\"blocklistop\": \"add\", \
+				\"addr\": \"%pISpc/%u\" }",
+			     &client_addr->in_addr,
+			     le32_to_cpu(client_addr->nonce));
+	if (ret == -EINVAL) {
+		/*
+		 * The monitor returns EINVAL on an unrecognized command.
+		 * Try the legacy command -- it is exactly the same except
+		 * for the name.
+		 */
+		ret = do_mon_command(monc,
+				     "{ \"prefix\": \"osd blacklist\", \
+					\"blacklistop\": \"add\", \
+					\"addr\": \"%pISpc/%u\" }",
+				     &client_addr->in_addr,
+				     le32_to_cpu(client_addr->nonce));
+	}
+	if (ret)
+		return ret;
+
+	/*
+	 * Make sure we have the osdmap that includes the blocklist
+	 * entry.  This is needed to ensure that the OSDs pick up the
+	 * new blocklist before processing any future requests from
+	 * this client.
+	 */
+	return ceph_wait_for_latest_osdmap(monc->client, 0);
+}
 EXPORT_SYMBOL(ceph_monc_blocklist_add);
 
 /*
-- 
2.19.2

