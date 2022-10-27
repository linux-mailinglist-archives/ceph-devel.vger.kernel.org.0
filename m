Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C760EE3B
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 05:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiJ0DBD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 23:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiJ0DAw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 23:00:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903FE5FF79
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 20:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666839649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=70NY6HwStTcs5IDeDS+gU1KEuoHq0VNhuQ2FgKPN1rc=;
        b=Ow9+A5RrxrAbuIyg8UZsQoKUWDMALQW3zkx+nAvipVqDldrCxRSiZq6ZRWxcVKimRcj7mX
        2qOqNrzy3VH9P5Im9NbC4ss3x+WrS8uWXpO31yIHLOUQI7XgKpZgV+YfG8GPGU1h+cCTXr
        eu0EaKIZts5idOrEbncbrrqe/Bq3Xio=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-AFGComIWO6-kOlmYVCqeDw-1; Wed, 26 Oct 2022 23:00:44 -0400
X-MC-Unique: AFGComIWO6-kOlmYVCqeDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CCD61C09C8A;
        Thu, 27 Oct 2022 03:00:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C62E1121315;
        Thu, 27 Oct 2022 03:00:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] encrypt: add ceph support
Date:   Thu, 27 Oct 2022 11:00:21 +0800
Message-Id: <20221027030021.296548-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 common/encrypt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 45ce0954..1a77e23b 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
 		# erase the UBI volume; reformated automatically on next mount
 		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
 		;;
+	ceph)
+		_scratch_cleanup_files
+		;;
 	*)
 		_notrun "No encryption support for $FSTYP"
 		;;
-- 
2.31.1

