Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9024D7959
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 03:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiCNC35 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Mar 2022 22:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbiCNC35 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Mar 2022 22:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1CD4117D
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 19:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647224927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1h0+UjwzGjIRwB8kr1uv1yZrCRmt4fjf95r7kiumN2o=;
        b=cY6ESVP8+yYATjOTk3sMxm0d4VvFNtDZkhD6PEUoGc/sUgMvFPBLlIzCvnD5aMIUeKgbKR
        G3UdF5DPLLzhEF2EIcL28GbdkbMY+G9FkVkaPpEHxYi/nxM65Ty5HpotypBOyOhl1CxIwy
        i+LwwP5N0kxw9Gh3+l0JBQjeaMK/4Yw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-yN8fbdx1Nz2Y71iKwJp36g-1; Sun, 13 Mar 2022 22:28:44 -0400
X-MC-Unique: yN8fbdx1Nz2Y71iKwJp36g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41CC929AA2F3;
        Mon, 14 Mar 2022 02:28:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE60C145F971;
        Mon, 14 Mar 2022 02:28:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/4] ceph: dencrypt the dentry names early and once for readdir
Date:   Mon, 14 Mar 2022 10:28:33 +0800
Message-Id: <20220314022837.32303-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


V2:
- Fix the WARN issue reported by Luis, thanks.


Xiubo Li (4):
  ceph: pass the request to parse_reply_info_readdir()
  ceph: add ceph_encode_encrypted_dname() helper
  ceph: dencrypt the dentry names early and once for readdir
  ceph: clean up the ceph_readdir() code

 fs/ceph/crypto.c     |  25 ++++++++---
 fs/ceph/crypto.h     |   2 +
 fs/ceph/dir.c        |  64 +++++++++------------------
 fs/ceph/inode.c      |  37 ++--------------
 fs/ceph/mds_client.c | 101 ++++++++++++++++++++++++++++++++++++-------
 fs/ceph/mds_client.h |   4 +-
 6 files changed, 133 insertions(+), 100 deletions(-)

-- 
2.27.0

