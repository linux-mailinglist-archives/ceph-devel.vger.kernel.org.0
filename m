Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF165A438A
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Aug 2022 09:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiH2HJh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Aug 2022 03:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiH2HJf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Aug 2022 03:09:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630A44D4CC
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 00:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661756973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=881+7q4/KA5jq6tkPlCSdoExOaZuIBuS6SZqt+cTi8k=;
        b=ZHTlFhBuu6nWhr5lRmLCSeE689oi1A9sIeL05sseI5so7WW2MPUzh7BhhDxnV8dHDi6DFb
        pOI/m/ARuRc5oQM5eT9qEJmO92rl1ow+h2KKMXHWWL6lWrm50VpHrkQ7iTeSO+hfF+8Whv
        9oxFV2r8Bss/bcK2a/PBCFLizRVRW6o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-YTMSRQEEP7qoYeZxYbGNaA-1; Mon, 29 Aug 2022 03:09:28 -0400
X-MC-Unique: YTMSRQEEP7qoYeZxYbGNaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3646A3C01D81;
        Mon, 29 Aug 2022 07:09:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96AE5400E88E;
        Mon, 29 Aug 2022 07:09:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     ddiss@suse.de, zlang@redhat.com, david@fromorbit.com,
        djwong@kernel.org, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph/004: fix the ceph.quota.max_bytes values
Date:   Mon, 29 Aug 2022 15:09:21 +0800
Message-Id: <20220829070921.547074-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Cephfs has required that the quota.max_bytes must be aligned to
4MB if greater than or equal to 4MB, otherwise must align to 4KB.

URL: https://tracker.ceph.com/issues/57321
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 tests/ceph/004 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/ceph/004 b/tests/ceph/004
index dbca713e..124ed1bc 100755
--- a/tests/ceph/004
+++ b/tests/ceph/004
@@ -9,7 +9,7 @@
 #
 #    mkdir files limit
 #    truncate files/file -s 10G
-#    setfattr limit -n ceph.quota.max_bytes -v 1000000
+#    setfattr limit -n ceph.quota.max_bytes -v 1048576
 #    mv files limit/
 #
 # Because we're creating a new file and truncating it, we have Fx caps and thus
@@ -76,9 +76,9 @@ check_Fs_caps()
 }
 
 # set quota to 1m
-$SETFATTR_PROG -n ceph.quota.max_bytes -v 1000000 $dest
+$SETFATTR_PROG -n ceph.quota.max_bytes -v 1048576 $dest
 # set quota to 20g
-$SETFATTR_PROG -n ceph.quota.max_bytes -v 20000000000 $orig2
+$SETFATTR_PROG -n ceph.quota.max_bytes -v 21474836480 $orig2
 
 #
 # The following 2 testcases shall fail with either -EXDEV or -EDQUOT
-- 
2.36.0.rc1

