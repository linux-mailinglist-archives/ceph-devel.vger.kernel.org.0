Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A194FB0EE
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 02:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiDKAQt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Apr 2022 20:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiDKAQs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 10 Apr 2022 20:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EFE5B870
        for <ceph-devel@vger.kernel.org>; Sun, 10 Apr 2022 17:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649636074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NC6bKQylwTuBz+x9egoFj7mUkcv5FuaenujLHIQ74VU=;
        b=iHYNr+1oix7VxMMI1HyNzpj0XIDP+MS7/gijxMUjZ6aCi+TvGMemAPkYFXx4S2PSWfES1i
        2Wwe08OWNn1SlS5+eAU5LQT6r6LuZFwV0ibaAvjb7DBHTWGKym+5ZHYoyRhU9worisabvJ
        RwogGRLI5/3O7Ba4GIEyd4cn8rvAo6A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-2zTDfEp6MG6h4Axq9KomVA-1; Sun, 10 Apr 2022 20:14:31 -0400
X-MC-Unique: 2zTDfEp6MG6h4Axq9KomVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41E3F1C05ABD;
        Mon, 11 Apr 2022 00:14:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 246CC145B96F;
        Mon, 11 Apr 2022 00:14:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: misc fix size truncate for fscrypt
Date:   Mon, 11 Apr 2022 08:14:24 +0800
Message-Id: <20220411001426.251679-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Hi Jeff,

This series could be squashed into the same previous commit:

e90dc20d37a3 ceph: add truncate size handling support for fscrypt


V2:
- remove the filemap lock related patch.
- fix caps reference leakage


Xiubo Li (2):
  ceph: flush small range instead of the whole map for truncate
  ceph: fix caps reference leakage for fscrypt size truncating

 fs/ceph/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.27.0

