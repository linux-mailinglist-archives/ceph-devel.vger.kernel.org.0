Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5362136BAB0
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 22:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbhDZU2d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 16:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhDZU2d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 26 Apr 2021 16:28:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA4CC061574
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 13:27:51 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h4so48175797wrt.12
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 13:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dh3Dfo7RRRwxzihGN4yZQkyhebfPruVrAfvT3OWhMAA=;
        b=o6Ey3eAhI4IUHQ8sWXPe8no+02XD2gJhhnadQB3NbIYopFaKTv9ihvA+Yp9G0vWpx7
         SXlNPk+lsihwwkOWaccUHSDFYIqHW3bWiWnTA7hmtIp2d8r1gk1d5JOsBknXVICZAGo4
         JAnsD6mt2XwLNelU+F2/BGHVwekegT4BO8D5WLttdNdyZtiKghyCEr87X+HLj873uDUj
         5ub2l4IWx8+K9fOWOHpHEres7SJdvYmyn0X3YSssHyGTLm8gOvRp+8Otg0YbI7B1gOpE
         9BbQhrzpLL6bfd7olKivtiybH7mZKSMqDNgQ2s7sikqy3j6+xvTXlAnpouO3kWcMUaTY
         d4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dh3Dfo7RRRwxzihGN4yZQkyhebfPruVrAfvT3OWhMAA=;
        b=Byi6RQ7o3Uhihq/OOcOzceZrEa1VYUAM/W/mYSOGN27wk4B4KJoi4FywoxJfg2kORF
         iw0JYHbUy9Wz+bfKCu9LLCTKJ8OGRV3kKqKNGrPphF9oZTfvMTOf0sXRS3y524sRE47d
         8rT3SNQ2LDd9pEr7pb3KKEgqmjD1ZNfLr2ylWpnzTd9yk9j5OUgppYVJnE00fRKTmZlB
         9bCO9K7CcPd+Kh1jabyQdjDS3ueffxigZayEFl5HkKAaUm5nzU4peATg9JPXZ6B1Y6kK
         b2yGpDg45m3iCgcdlsEBQadfG/O0vaK9613IvnEls0xu0lPOI/P29FYMIFy6qkiwXjCr
         4eAg==
X-Gm-Message-State: AOAM533dzSLh6dmYkGIQAEjcs+mapwYLqYRVPZDDUZ840c0qzofXBL22
        TFv0JPg/dPx+LI28gLsp4sGnyAkocsxlxA==
X-Google-Smtp-Source: ABdhPJwngl2c/iW4aRdUV91gyXeUghyoUx6pdAbmlk5K/nUWyZ7SFDy27CC+btxNGeM/lJldvUzTZA==
X-Received: by 2002:adf:84e6:: with SMTP id 93mr24093766wrg.376.1619468870246;
        Mon, 26 Apr 2021 13:27:50 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id m15sm1364103wrx.32.2021.04.26.13.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:27:49 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Subject: [PATCH] libceph: don't set global_id until we get an auth ticket
Date:   Mon, 26 Apr 2021 22:27:59 +0200
Message-Id: <20210426202759.20130-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With the introduction of enforcing mode, setting global_id as soon
as we get it in the first MAuth reply will result in EACCES if the
connection is reset before we get the second MAuth reply containing
an auth ticket -- because on retry we would attempt to reclaim that
global_id with no auth ticket at hand.

Neither ceph_auth_client nor ceph_mon_client depend on global_id
being set ealy, so just delay the setting until we get and process
the second MAuth reply.  While at it, complain if the monitor sends
a zero global_id or changes our global_id as the session is likely
to fail after that.

Cc: stable@vger.kernel.org # needs backporting for < 5.11
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index eb261aa5fe18..de407e8feb97 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
 	}
 }
 
+static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
+{
+	dout("%s global_id %llu\n", __func__, global_id);
+
+	if (!global_id)
+		pr_err("got zero global_id\n");
+
+	if (ac->global_id && global_id != ac->global_id)
+		pr_err("global_id changed from %llu to %llu\n", ac->global_id,
+		       global_id);
+
+	ac->global_id = global_id;
+}
+
 /*
  * setup, teardown.
  */
@@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	payload_end = payload + payload_len;
 
-	if (global_id && ac->global_id != global_id) {
-		dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
-		ac->global_id = global_id;
-	}
-
 	if (ac->negotiating) {
 		/* server does not support our protocols? */
 		if (!protocol && result < 0) {
@@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	ret = ac->ops->handle_reply(ac, result, payload, payload_end,
 				    NULL, NULL, NULL, NULL);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
 		ret = build_request(ac, true, reply_buf, reply_len);
-	else if (ret)
+		goto out;
+	} else if (ret) {
 		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
 		       ceph_auth_proto_name(ac->protocol), result);
+		goto out;
+	}
+
+	set_global_id(ac, global_id);
 
 out:
 	mutex_unlock(&ac->mutex);
@@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	if (global_id && ac->global_id != global_id) {
-		dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
-		     global_id);
-		ac->global_id = global_id;
-	}
-
 	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
 				    session_key, session_key_len,
 				    con_secret, con_secret_len);
+	if (!ret)
+		set_global_id(ac, global_id);
 	mutex_unlock(&ac->mutex);
 	return ret;
 }
-- 
2.19.2

