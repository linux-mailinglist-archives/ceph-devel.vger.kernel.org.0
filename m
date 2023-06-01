Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965E7190B9
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jun 2023 04:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjFACzE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 22:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFACzD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 22:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247FA97
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 19:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685588061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ksHu87aFMEBHIMoatjkPbQFSZ7Jwb6qU80T6hGmTLKE=;
        b=LVVJLS2d4Qja31DsHGTHKtrvKzCc4Thr9i+oj7z0f+7HM/RigS0lTxGP44IYNcI7olke4I
        VNe31vQKkVSkGKEY776AMyEnkyWc3IDE8MKHcYpatpxcvnXww0x5685cVGz+JYL7Mn/WjP
        5oQ0ghuukk61QlfbWOnxZuJ9qkLSvp8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-pXbHNVNIOvWzXNdCcvwZIA-1; Wed, 31 May 2023 22:54:20 -0400
X-MC-Unique: pXbHNVNIOvWzXNdCcvwZIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A67233C0ED40;
        Thu,  1 Jun 2023 02:54:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55D7440C6EC4;
        Thu,  1 Jun 2023 02:54:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] common/rc: skip ceph-fuse when atime is required
Date:   Thu,  1 Jun 2023 10:52:07 +0800
Message-Id: <20230601025207.857009-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Ceph won't maintain the atime, so just skip the tests when the atime
is required.

Fixes: https://tracker.ceph.com/issues/61551
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 37074371..f3b92741 100644
--- a/common/rc
+++ b/common/rc
@@ -4089,7 +4089,7 @@ _require_atime()
 	nfs|afs|cifs|virtiofs)
 		_notrun "atime related mount options have no effect on $FSTYP"
 		;;
-	ceph)
+	ceph|ceph-fuse)
 		_notrun "atime not maintained by $FSTYP"
 		;;
 	esac
-- 
2.40.1

