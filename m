Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6A4CB56B
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 04:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiCCD1p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 22:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCCD1p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 22:27:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D524111C7DE
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 19:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646278020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4kjrYadggQTD0v8gWEFqGZKXHpqLe9ogNgSRKGPEj2g=;
        b=hctYt1dOQ40qz0TBuwGDz/A2FRbLqzMhL3//BA9YAQOgUfIOkgpH2z7Yo1mpQA95F3UAB5
        5uCmb3yqYnd7zZp9eH7LhN6G5fGZffQBDRi+cMiEOOxKphmIZIqcRPTZ7XRmtCeKR0+Tr8
        WwUP6M4jguGx/JR/RcSeFYeKdGzXRMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-4iwVF7ylOauN1jbeogHODw-1; Wed, 02 Mar 2022 22:26:59 -0500
X-MC-Unique: 4iwVF7ylOauN1jbeogHODw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4A088066F4;
        Thu,  3 Mar 2022 03:26:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFCC8305B5;
        Thu,  3 Mar 2022 03:26:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2] ceph: misc fix for fscrypt
Date:   Thu,  3 Mar 2022 11:26:38 +0800
Message-Id: <20220303032640.521999-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is base on the 'wip-fscrypt' branch in ceph-client.

V4:
- Remove the snapshot name support patches and will leave this to Luis.
- For the first commit to fail the request one, it's hasty to skip the
  corrupt dentries and risky, will improve this later in future.
  For now will fail it directly and propogate the errno to user space.

V3:
- Add more detail comments in the commit comments and code comments.
- Fix some bugs.
- Improved the patches.
- Remove the already merged patch.

V2:
- Fix several bugs, such as for the long snap name encrypt/dencrypt
- Skip double dencypting dentry names for readdir


Xiubo Li (2):
  ceph: fail the request when failing to decode dentry names
  ceph: do not dencrypt the dentry name twice for readdir

 fs/ceph/crypto.h     |  8 +++++
 fs/ceph/dir.c        | 71 ++++++++++++++++++++++++--------------------
 fs/ceph/inode.c      | 20 +++++++++++--
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/mds_client.h |  1 +
 5 files changed, 66 insertions(+), 36 deletions(-)

-- 
2.27.0

