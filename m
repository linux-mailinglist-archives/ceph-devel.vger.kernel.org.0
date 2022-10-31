Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2486131CE
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Oct 2022 09:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJaIjb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Oct 2022 04:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJaIja (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 31 Oct 2022 04:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F15B22
        for <ceph-devel@vger.kernel.org>; Mon, 31 Oct 2022 01:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667205509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1VBKNsYVeF98wLcvmwVUi6nLxNSU4oyPSq1mvCcwKF0=;
        b=MyFnLV+Jpye8YNnbAMp+y6dN1YEQel5sl2Xu/I+CdU/EYFNhiUz3KDvowyZX1dkIxxAIDy
        9NQlQXCi6emiv0j4KdIhc4ansvkBm0iOnjDP3PwI06I+VotA9piAPZc/IctmnrnqaRd8wP
        vERdjYD/TIgfcNT5iMEnpdjbtFGnrsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-Bt9p7-IjMvuNroHaf1NQrw-1; Mon, 31 Oct 2022 04:38:26 -0400
X-MC-Unique: Bt9p7-IjMvuNroHaf1NQrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D200F10115EF;
        Mon, 31 Oct 2022 08:38:25 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 531052166B29;
        Mon, 31 Oct 2022 08:38:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] encrypt: add ceph support
Date:   Mon, 31 Oct 2022 16:38:19 +0800
Message-Id: <20221031083819.573521-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will enable ceph could run the fscrypt test cases, but not all.
Some of them will be skipped because of not supporting features.

Here will just skip ceph in _scratch_mkfs_encrypted() and in
_require_scratch_encryption() it will try to check "set_encpolicy"
to make sure whether kernel ceph support the encryption or not.

Reviewed-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Add more commit comments.


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

