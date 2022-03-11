Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0144D6008
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 11:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbiCKKrN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 05:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiCKKrL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 05:47:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C73A11C2DAF
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 02:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646995567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oh4nDhzAaRc9KrUJsoQ3VukaaeA/wRKhSFT3g/cBNlc=;
        b=Kv/np21Uy9+2aBM1xmKRLrf49ePsziRhieVGIODz2F0b7LJPoHbdHo7cJuT2hHEqpTlHcr
        O+vInQhNU6Hv1izOi6GgS+ki9o/z3D7WzMgVDeI1Pvwklzf1bhwyh7My7DYZJcZAAkOPjj
        D5/Q6aH3pDl00IIXz+VZ/v8OR5ZGjRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-UR4PAB5QOiG1D2URqw5WKw-1; Fri, 11 Mar 2022 05:46:04 -0500
X-MC-Unique: UR4PAB5QOiG1D2URqw5WKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AE901091DA5;
        Fri, 11 Mar 2022 10:46:03 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 797E01057067;
        Fri, 11 Mar 2022 10:46:01 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/4] ceph: dencrypt the dentry names early and once for readdir
Date:   Fri, 11 Mar 2022 18:45:54 +0800
Message-Id: <20220311104558.157283-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This is a new approach to improve the readdir and based the previous
discussion in another thread:

https://patchwork.kernel.org/project/ceph-devel/list/?series=621901

Just start a new thread for this.

As Jeff suggested, this patch series will dentrypt the dentry name
during parsing the readdir data in handle_reply(). And then in both
ceph_readdir_prepopulate() and ceph_readdir() we will use the
dencrypted name directly.

NOTE: we will base64_dencode and dencrypt the names in-place instead
of allocating tmp buffers. For base64_dencode it's safe because the
dencoded string buffer will always be shorter.



Xiubo Li (4):
  ceph: pass the request to parse_reply_info_readdir()
  ceph: add ceph_encode_encrypted_dname() helper
  ceph: dencrypt the dentry names early and once for readdir
  ceph: clean up the ceph_readdir() code

 fs/ceph/crypto.c     |  18 +++++---
 fs/ceph/crypto.h     |   2 +
 fs/ceph/dir.c        |  64 +++++++++------------------
 fs/ceph/inode.c      |  37 ++--------------
 fs/ceph/mds_client.c | 101 ++++++++++++++++++++++++++++++++++++-------
 fs/ceph/mds_client.h |   4 +-
 6 files changed, 127 insertions(+), 99 deletions(-)

-- 
2.27.0

