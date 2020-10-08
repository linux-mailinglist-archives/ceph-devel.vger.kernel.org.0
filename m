Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC62287A6D
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Oct 2020 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgJHQ6P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Oct 2020 12:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgJHQ6P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Oct 2020 12:58:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB81C061755
        for <ceph-devel@vger.kernel.org>; Thu,  8 Oct 2020 09:58:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e18so7387679wrw.9
        for <ceph-devel@vger.kernel.org>; Thu, 08 Oct 2020 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRjOi5KwEs3g7OGy/03qH3X+eHomsFQVy91IFixjuPo=;
        b=CbiGAH8rgNSvWaWF+X/Oq5Vn40AaYy6aKgfXXIaNLbbpnHLs27le58pZ/FTH+0/gQs
         TGi8gUzPvxvTKCfl/gCVt9BQNRTrC3tloxVUNNSZ3XTvZODqok97GKxK89YKFoTM+207
         O8AdgNMpKu+/FLbrWLkw12kFrNl2b2GlxK2gPFSAn5XZTA4Wu0coLEqoxR+iSxrvoliG
         yImBRGVBsJJOFCqH3B2xJO9+1baDubPtSXjqtGiimAhUqD3rtm7fPz1bQSus8SYCYEOR
         /GZDYeeZMq9x5AMPytgM2BNdBm4SxDYrf3f+n66+miMdfxwDbCGcV6LdL9w8oFCVWts1
         OQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRjOi5KwEs3g7OGy/03qH3X+eHomsFQVy91IFixjuPo=;
        b=Xho1YPY08KkG6QJMs/gK0rrf/fwpKmJavYN9hYYRI6rat/VktJ3+1YbfAF8yM0D6Zr
         LBES1ZukKMvxf1tK+vgOnqG3bRubCTqylWzVZEONhWmXdZJb25QW7jdQIEMoLIGCnopY
         7HWOqlcOmL+WCzRfyPqP1KTshsvgOAwi1z3SozbSfSCF4gTUU6Q67Lb+aHCWxnHPBdR0
         q755Wu6hx7FvMCL1hMeCAgvyAsn+4uAU7teXSpsqX1ALYpSPWdmEAEggYogEjsDY5uDC
         MLnFoMnUznmw90Clx1ydykrfHjqlcy3e4f8qRnP+HvF9G/OCJXVzJXVWRstmjrvTgFt8
         SKzw==
X-Gm-Message-State: AOAM530EDsglnBGpBwvKNt/m47SY4kHWVT+lu+BLbteqvVPwvMN9ys8J
        d2XC9XVmTEvAvd/LFAH871JrMYD5DSI=
X-Google-Smtp-Source: ABdhPJye9JDMEdP7QeMzXZpqbWpDvOdW6HC1NEMWj+vIFB+v/J6+MsEDcure6e8wQJjjN8UnN6QRKA==
X-Received: by 2002:a5d:44cb:: with SMTP id z11mr10108494wrr.290.1602176293482;
        Thu, 08 Oct 2020 09:58:13 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id 67sm8008149wmb.31.2020.10.08.09.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 09:58:12 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] libceph: clear con->out_msg on Policy::stateful_server faults
Date:   Thu,  8 Oct 2020 18:58:00 +0200
Message-Id: <20201008165800.9494-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

con->out_msg must be cleared on Policy::stateful_server
(!CEPH_MSG_CONNECT_LOSSY) faults.  Not doing so botches the
reconnection attempt, because after writing the banner the
messenger moves on to writing the data section of that message
(either from where it got interrupted by the connection reset or
from the beginning) instead of writing struct ceph_msg_connect.
This results in a bizarre error message because the server
sends CEPH_MSGR_TAG_BADPROTOVER but we think we wrote struct
ceph_msg_connect:

  libceph: mds0 (1)172.21.15.45:6828 socket error on write
  ceph: mds0 reconnect start
  libceph: mds0 (1)172.21.15.45:6829 socket closed (con state OPEN)
  libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch, my 32 != server's 32
  libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch

AFAICT this bug goes back to the dawn of the kernel client.
The reason it survived for so long is that only MDS sessions
are stateful and only two MDS messages have a data section:
CEPH_MSG_CLIENT_RECONNECT (always, but reconnecting is rare)
and CEPH_MSG_CLIENT_REQUEST (only when xattrs are involved).
The connection has to get reset precisely when such message
is being sent -- in this case it was the former.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/47723
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/messenger.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index e9e2763a255f..c1f1f85545c3 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2998,6 +2998,11 @@ static void con_fault(struct ceph_connection *con)
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
 	}
+	if (con->out_msg) {
+		BUG_ON(con->out_msg->con != con);
+		ceph_msg_put(con->out_msg);
+		con->out_msg = NULL;
+	}
 
 	/* Requeue anything that hasn't been acked */
 	list_splice_init(&con->out_sent, &con->out_queue);
-- 
2.19.2

