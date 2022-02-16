Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A184B7D2F
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 03:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbiBPCTG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 21:19:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241446AbiBPCTG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 21:19:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45105C0848
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 18:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644977934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H1G+I+iynVCPcn3IH2nzwq+wlM0afKyzPO8bYFhxQVU=;
        b=bEQBeGNeL3xGGkaQdKHaIjlEsWyixOjJ7EILirM3BbESFuJd8lfNEyrKE09Oo/F6uvQIDB
        2uddEGit7+rzaEzeTvNP70kaACNAcztU9fw6oAObxnGONPK9y8Bft04053/flW6jb0VUDj
        THtaLHrZfZzmV7j+BCY4js2qeLz9at4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-f-XGlIddNL2D2GWJ6TSRYA-1; Tue, 15 Feb 2022 21:18:50 -0500
X-MC-Unique: f-XGlIddNL2D2GWJ6TSRYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E17C7835B4C;
        Wed, 16 Feb 2022 02:18:49 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67BEA1017CF1;
        Wed, 16 Feb 2022 02:18:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: fix cephfs rsync kworker high load issue
Date:   Wed, 16 Feb 2022 10:18:43 +0800
Message-Id: <20220216021845.131852-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- allocate the capsnap memory ourside of ceph_queue_cap_snap() from
Jeff's advice.
- fix the code style and logs to make the logs to be more readable

Xiubo Li (2):
  ceph: allocate capsnap memory outside of ceph_queue_cap_snap()
  ceph: misc fix for code style and logs

 fs/ceph/snap.c | 168 ++++++++++++++++++++++++++-----------------------
 1 file changed, 90 insertions(+), 78 deletions(-)

-- 
2.27.0

