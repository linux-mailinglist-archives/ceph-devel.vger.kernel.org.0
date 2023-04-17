Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBDB6E3D86
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 04:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjDQCmj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 22:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDQCmi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 22:42:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7F71FFE
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 19:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681699311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KbJ6n4UfhhFF14KmQ6w4Essp4HqkF6U7SnLMXZ66cQs=;
        b=F7xi+1e+vHvEsg2EeNjKiFoxxSdN0FOdG5RqQ/l2EJ5gh6F9V9Xf5Acif57Cz9nHtX94ou
        vlXY7vkhn3/Pm5khpA24H5dSoTNsVaj0kQ3j/nAYgjCRXSdu1O2wn/2Hj+MbDu/2oi9ECX
        XrSnHVGV3SFCQaLgfFklWAwZzearDY4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-GSnOc7-yMvuZcK-weXw5kQ-1; Sun, 16 Apr 2023 22:41:47 -0400
X-MC-Unique: GSnOc7-yMvuZcK-weXw5kQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81CDF85A588;
        Mon, 17 Apr 2023 02:41:47 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 987FB728FC;
        Mon, 17 Apr 2023 02:41:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] common/rc: skip ceph when atime is required
Date:   Mon, 17 Apr 2023 10:41:34 +0800
Message-Id: <20230417024134.30560-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Ceph won't maintain the atime, so just skip the tests when the atime
is required.

URL: https://tracker.ceph.com/issues/53844
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 90749343..3238842e 100644
--- a/common/rc
+++ b/common/rc
@@ -3999,6 +3999,9 @@ _require_atime()
 	nfs|cifs|virtiofs)
 		_notrun "atime related mount options have no effect on $FSTYP"
 		;;
+	ceph)
+                _notrun "atime not maintained by $FSTYP"
+		;;
 	esac
 
 }
-- 
2.39.1

