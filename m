Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ABE734C48
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 09:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjFSHTv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jun 2023 03:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjFSHTt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Jun 2023 03:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A2E5C
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687159140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JhzHeCwPckycCifZ7RHRUfi9Opf9eEi1LYQRHwW5+HA=;
        b=gwC3OZIALDApW1RlRcjqmMtfejSlBNomjxK9PiOSKa5qQGM3sdwrTKW+sTIMimOIySh1lF
        9Q1vDBIRtSAwk2YjDmjjkUejJraobr4zngqT39a7ThUchaIs6aboaqU0VeRlYNVxh/l6qb
        x7gHQIt7k0RnXkxQPLc7Ymo3zxtAHwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-nqjBMJPeNq2FIK8PMJ1hOQ-1; Mon, 19 Jun 2023 03:17:19 -0400
X-MC-Unique: nqjBMJPeNq2FIK8PMJ1hOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18F74185A792;
        Mon, 19 Jun 2023 07:17:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4841DC1603B;
        Mon, 19 Jun 2023 07:17:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/6] ceph: print the client global id for debug logs
Date:   Mon, 19 Jun 2023 15:14:32 +0800
Message-Id: <20230619071438.7000-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V4:
- s/dout_client()/doutc()/
- Fixed the building errors reported by ceph: print the client global id
for debug logs. Thanks.

Xiubo Li (6):
  ceph: add the *_client debug macros support
  ceph: pass the mdsc to several helpers
  ceph: rename _to_client() to _to_fs_client()
  ceph: move mdsmap.h to fs/ceph/
  ceph: add ceph_inode_to_client() helper support
  ceph: print the client global_id in all the debug logs

 fs/ceph/acl.c                       |   6 +-
 fs/ceph/addr.c                      | 298 ++++++-----
 fs/ceph/cache.c                     |   2 +-
 fs/ceph/caps.c                      | 774 ++++++++++++++++------------
 fs/ceph/crypto.c                    |  41 +-
 fs/ceph/debugfs.c                   |  10 +-
 fs/ceph/dir.c                       | 237 +++++----
 fs/ceph/export.c                    |  49 +-
 fs/ceph/file.c                      | 270 +++++-----
 fs/ceph/inode.c                     | 521 ++++++++++---------
 fs/ceph/ioctl.c                     |  21 +-
 fs/ceph/locks.c                     |  57 +-
 fs/ceph/mds_client.c                | 624 ++++++++++++----------
 fs/ceph/mds_client.h                |   5 +-
 fs/ceph/mdsmap.c                    |  29 +-
 {include/linux => fs}/ceph/mdsmap.h |   5 +-
 fs/ceph/metric.c                    |   5 +-
 fs/ceph/quota.c                     |  29 +-
 fs/ceph/snap.c                      | 192 +++----
 fs/ceph/super.c                     |  92 ++--
 fs/ceph/super.h                     |  19 +-
 fs/ceph/xattr.c                     | 108 ++--
 include/linux/ceph/ceph_debug.h     |  48 +-
 23 files changed, 1976 insertions(+), 1466 deletions(-)
 rename {include/linux => fs}/ceph/mdsmap.h (92%)

-- 
2.40.1

