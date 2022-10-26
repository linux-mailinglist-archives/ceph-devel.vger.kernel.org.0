Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58A260DBD1
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Oct 2022 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiJZHEs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 03:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiJZHEq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 03:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F7E31FAB
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 00:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666767882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ZJOt5EZyvgMRoc5qMVMbl0FkGDc10CeAqs1VEMKmh4=;
        b=Wr084XbfC8C/R8Ee4JgwMBCJ0YVSUA/PhvujE4VXCUcOhZL7BG5iiD747OBVuKopDwgPQO
        5Ck/JaYSaTU2TS4gB/YEMtS3rLucMWnd//ur1yIBh7zTIb2hGqmRfd42IBSLAxYQXQv6MN
        5VUivl5tNiy+xU4+/Q3e7PdWY9ukUps=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1--fllxkTuOcyV3XpzjUFFOw-1; Wed, 26 Oct 2022 03:04:39 -0400
X-MC-Unique: -fllxkTuOcyV3XpzjUFFOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADE8A3C0F7E3;
        Wed, 26 Oct 2022 07:04:38 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 802B21415117;
        Wed, 26 Oct 2022 07:04:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] encrypt: add ceph support
Date:   Wed, 26 Oct 2022 15:04:18 +0800
Message-Id: <20221026070418.259351-3-xiubli@redhat.com>
In-Reply-To: <20221026070418.259351-1-xiubli@redhat.com>
References: <20221026070418.259351-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

For ceph we couldn't use the mkfs to check whether the encryption
is support or not, we need to mount it first and then check the
'set_encpolicy', etc.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 common/encrypt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index fd620c41..e837c9de 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -153,6 +153,23 @@ _scratch_check_encrypted()
 		# erase the UBI volume; reformated automatically on next mount
 		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
 		;;
+	ceph)
+		# Try to mount the filesystem. We need to check whether the encryption
+		# is support or not via the ioctl cmd, such as 'set_encpolicy'.
+		if ! _try_scratch_mount &>>$seqres.full; then
+			_notrun "kernel is unaware of $FSTYP encryption feature," \
+				"or mkfs options are not compatible with encryption"
+		fi
+
+		mkdir $SCRATCH_MNT/tmpdir
+		if _set_encpolicy $SCRATCH_MNT/tmpdir 2>&1 >>$seqres.full | \
+			grep -Eq 'Inappropriate ioctl for device|Operation not supported'
+		then
+			_notrun "kernel does not support $FSTYP encryption"
+		fi
+		rmdir $SCRATCH_MNT/tmpdir
+		_scratch_unmount
+		;;
 	*)
 		_notrun "No encryption support for $FSTYP"
 		;;
-- 
2.31.1

