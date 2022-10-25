Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6296760CF03
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Oct 2022 16:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJYOaw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Oct 2022 10:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiJYOav (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Oct 2022 10:30:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC179F01A5
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 07:30:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m6so12023616pfb.0
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 07:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VpehAOxTrOv12o8hJV+1GFRTnikV+U8rSab3/RnQz9c=;
        b=QBSl8g/hDVHA7jme5VLAr2A1NbvbE7qINC1fTfYgQzzvB/+Pcr5F5nbQ4k5w+/Dck4
         JAqAD/mPcX/pg4xBwr0l2Cp08GF3VPQKaIhXTNw04k29jEvdtTpT5B3CfpLz8aaJeNLm
         uSh5CWEfPlBJ1UB1EbIZunB4IDwsBBewtjIsNgB38ESzXB01DTrqLkLN+bK0vN9L18Jq
         EuYwWKVSk+7gm7LU2mQBGGTHSQauXqdK/QFgAm5ynnXze0bDkEUsxxwimAAhkBR99bNl
         nMowbf4dRhDDCg55IeGUy0IdNYc5fYEaBIceG73Wx/1p75oJXdOfTaqtf8qWBEImhfKB
         zP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VpehAOxTrOv12o8hJV+1GFRTnikV+U8rSab3/RnQz9c=;
        b=RQmwkkNdzwThdAtho6Ot98YRqCt4+gdbidaJp5jlL8nv5W9b29mT3m1rEZvGQhjrzZ
         cWp3szCx1XZEzW/DCLdJZypJdX33iFPgc+E1SW9lsEHdnFbTIW9IVKF2iAle7a/F7fJi
         F+IvniFV23M66MtKiqKR+iZSMGx1ylxgSmwRkvo5S5/i7z+pMLivX0OjOy+FpEyIfP2A
         aCXXTTVn3bDVdZc5cp0QLF/tg2/M+tkeW271u8gciYPkuc4SMWfwVl1jP0rm8LjyDUPE
         R9BjczckqIe4P+sZ1Qb4VIkrAvcZwelqg03QG9XCb99KZQbkmOruJUEVO/IxPgdrmq0R
         mlcQ==
X-Gm-Message-State: ACrzQf1n9XLsuYn9smWouUpxRj0wfeMOIDzheOraczXakrZpExm0mCEW
        EODUXoDKZX4ZjEhikaNTuBQ=
X-Google-Smtp-Source: AMsMyM7E+9MQODty82Sgx3LeuKl/wiii0nkEj8pRYY6dQGKgPFbAD5oH+e7DQl5iryHd1ETgdVWzHw==
X-Received: by 2002:a63:6a03:0:b0:43a:18ce:7473 with SMTP id f3-20020a636a03000000b0043a18ce7473mr34527162pgc.616.1666708247194;
        Tue, 25 Oct 2022 07:30:47 -0700 (PDT)
Received: from DESKTOP-H1VBGGK.localdomain ([119.205.75.155])
        by smtp.gmail.com with ESMTPSA id g13-20020aa796ad000000b0056b8af5d46esm1445575pfk.168.2022.10.25.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 07:30:46 -0700 (PDT)
From:   Minjong Kim <make.dirty.code@gmail.com>
To:     idryomov@gmail.com, xiubli@redhat.com, jlayton@kernel.org,
        ceph-devel@vger.kernel.org
Cc:     Minjong Kim <make.dirty.code@gmail.com>
Subject: [PATCH] libceph: give priority to sockets of MDS clients
Date:   Tue, 25 Oct 2022 23:27:32 +0900
Message-Id: <20221025142731.22636-1-make.dirty.code@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

MDS requests are buffered or dropped when the client's network is saturated.
To alleviate this by giving priority to sockets in MDS.

Signed-off-by: Minjong Kim <make.dirty.code@gmail.com>
---
Hello. I am very new to kernel. I would appreciate it if you could
understand my clumsy process. I'm not sure if I should post this as a
general question, as a patch, or if I should write a comment like this
here, but I'll write a few words.

I've found that at the point where the client network saturates, requests
from MDSs drop significantly. To solve this, I added code to the kernel's
code to tag MDS sockets with IP_TOS.

However, there are some problems caused by my inadequacies.

First, is it okay to use higher-level functions like ip_setsockopt? This
function works fine, but I haven't seen any other kernel code use it. Do I
have to change the code like skb->priority manually? I'm mainly working on
high-level code, so I'm careful about whether I can access these attributes
directly.

Second, IP_TOS seems to be a deprecated option. It seems to be managed
through diffserv these days (though it is compatible with IP_TOS), but I
couldn't find a function to tag dscp directly. In this case, using a
function like ip_setsockopt(..IP_TOS) seems to be a problem, but I couldn't
solve it in my own way.

Third, the benchmarks I conducted seem to have many variables depending on
various computing environments. I think I've done it several times as best
I can, but this may be variable due to my local environment.

Finally, this doesn't seem to be a perfect way to solve the problem. It
seems that MDS packets are still buffered when burst. Also, it seems that
many distributions these days use fq_codel by default, which doesn't
support diffserv. But tagging IP_TOS doesn't seem to get any worse. (since
the filesystem's workload is very small). The next version of fq_codel,
cake, supports it, so there is a possibility that it will be improved.

Thanks for reading this long post. Apart from the shortcomings in my code,
please forgive me for the shortcomings in the kernel contributing process.

 net/ceph/messenger_v1.c | 14 ++++++++++++++
 net/ceph/messenger_v2.c | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 3ddbde87e4d6..bab6ec4af82c 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -6,6 +6,7 @@
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <net/sock.h>
+#include <net/ip.h>
 
 #include <linux/ceph/ceph_features.h>
 #include <linux/ceph/decode.h>
@@ -1423,6 +1424,19 @@ int ceph_con_v1_try_write(struct ceph_connection *con)
 			con->error_msg = "connect error";
 			goto out;
 		}
+
+		if (con->peer_name.type == CEPH_ENTITY_TYPE_MDS) {
+			__u8 tos_mds = 0xb0; // mark as AF32
+
+			ret = ip_setsockopt(con->sock->sk, SOL_IP, IP_TOS,
+			                    KERNEL_SOCKPTR(&tos_mds), 1);
+
+			if (ret) {
+				pr_err("ip_setsockopt failed: %d\n", ret);
+				con->error_msg = "connect error";
+				return ret;
+			}
+		}
 	}
 
 more:
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index cc8ff81a50b7..d87430f333c9 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -3180,6 +3180,19 @@ int ceph_con_v2_try_write(struct ceph_connection *con)
 			con->error_msg = "connect error";
 			return ret;
 		}
+
+		if (con->peer_name.type == CEPH_ENTITY_TYPE_MDS) {
+			__u8 tos_mds = 0xb0; // mark as AF32
+
+			ret = ip_setsockopt(con->sock->sk, SOL_IP, IP_TOS,
+			                    KERNEL_SOCKPTR(&tos_mds), 1);
+
+			if (ret) {
+				pr_err("ip_setsockopt failed: %d\n", ret);
+				con->error_msg = "connect error";
+				return ret;
+			}
+		}
 	}
 
 	if (!iov_iter_count(&con->v2.out_iter)) {
-- 
2.25.1

