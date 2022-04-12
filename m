Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF86B4FD386
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 11:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiDLJwU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Apr 2022 05:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351921AbiDLH16 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Apr 2022 03:27:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD7A84EF45
        for <ceph-devel@vger.kernel.org>; Tue, 12 Apr 2022 00:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tLz72uflkvVspEGES+NUyiieIMSbQr6IFwFuFbg1X7E=;
        b=cytx4+jOnX5I8gTx5PAcUXCAL9wnr9+7ilpXw2FBVZ/i6LtErk4Q2NHX8tvhpq7uxcWYJT
        XNYiFuLMTZocboXlfRmtloey5Vyv247gX2pwI9PovugdNyR+etcBW1YznTwk72vO41swAj
        MVFAB/6eJeRQqa8GDUSOmDFo32Aqp4c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-q5kF1msqPpSmLDMn8Yef7g-1; Tue, 12 Apr 2022 03:07:53 -0400
X-MC-Unique: q5kF1msqPpSmLDMn8Yef7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B67961C0515F;
        Tue, 12 Apr 2022 07:07:52 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D18B407DEC2;
        Tue, 12 Apr 2022 07:07:51 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/3] ceph: misc fix size truncate for fscrypt
Date:   Tue, 12 Apr 2022 15:07:42 +0800
Message-Id: <20220412070745.22795-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

This series could be squashed into the same previous commit:

e90dc20d37a3 ceph: add truncate size handling support for fscrypt


V3:
- fix possible kunmaping random vaddr bug, thanks Luis.

V2:
- remove the filemap lock related patch.
- fix caps reference leakage



Xiubo Li (3):
  ceph: flush small range instead of the whole map for truncate
  ceph: fix caps reference leakage for fscrypt size truncating
  ceph: fix possible kunmaping random vaddr

 fs/ceph/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
2.36.0.rc1

