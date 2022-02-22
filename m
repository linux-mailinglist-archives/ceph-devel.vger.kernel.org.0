Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9554BF21E
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 07:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiBVGfM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 01:35:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBVGfL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 01:35:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12C76EC5C5
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 22:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645511685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvoGJ/22HIm6Tt4vklMpb5GuiPPznBVcfgwR6uRoYuo=;
        b=Bq6EUL2TxztDaTbOTVsi9qhQ/DU+kfSu+je+PVQ7zVFV8zNfW9NXcyU1UoJUFB/0rNgTzP
        JAw8VZypO7236U/thOHXXGhspltcUf5AyPPmMYfsW1R0h1ivFHS9lTwrqdquNfHyV/Bv/S
        LRzuyqeyVYIuhDLlZBtAVigcKa8WCxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-Ury_yhEqMK2Eotr32fynOw-1; Tue, 22 Feb 2022 01:34:41 -0500
X-MC-Unique: Ury_yhEqMK2Eotr32fynOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B94F80573C;
        Tue, 22 Feb 2022 06:34:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 572CC5ED21;
        Tue, 22 Feb 2022 06:34:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: remove incorrect and unused CEPH_INO_DOTDOT macro
Date:   Tue, 22 Feb 2022 14:34:32 +0800
Message-Id: <20220222063433.217466-2-xiubli@redhat.com>
In-Reply-To: <20220222063433.217466-1-xiubli@redhat.com>
References: <20220222063433.217466-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Ceph have removed this macro and the 0x3 will be use for global dummy
snaprealm.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_fs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 66db21ac5f0c..f14f9bc290e6 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -29,7 +29,6 @@
 
 #define CEPH_INO_ROOT   1
 #define CEPH_INO_CEPH   2       /* hidden .ceph dir */
-#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */
 
 /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
 #define CEPH_MAX_MON   31
-- 
2.27.0

