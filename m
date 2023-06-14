Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DCD72F1F9
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjFNBdt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjFNBds (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1364B8
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686706379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xG5wWWD6z735c11vhr8mq1ZZPwC+3y7X3HFKvLfw8is=;
        b=O0NXg0XVm36txBlLeBxlyStes142k30PKa2y7Xu6n1sDDn5/xn2S/CU81nO0UQKa9QGu3J
        vqSjXQ/wkKUgyW/XN1CEFcT44BL5b6bOYKsBM9KC2KzCDhg+2TIXWJm829bQGvV0nMZZS+
        sktzGs6rOYHybk/w3vUaxKMPxUlsplM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-Mq62PpoFNrKa5YhQ8ZC4fw-1; Tue, 13 Jun 2023 21:32:55 -0400
X-MC-Unique: Mq62PpoFNrKa5YhQ8ZC4fw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151C7101A53B;
        Wed, 14 Jun 2023 01:32:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29746492CA6;
        Wed, 14 Jun 2023 01:32:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        khiremat@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/6] ceph: print the client global id for debug logs
Date:   Wed, 14 Jun 2023 09:30:19 +0800
Message-Id: <20230614013025.291314-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

V3:
- print the function name as default in the *_client() helpers
- some minor improvment in the log messages.

Xiubo Li (6):
  ceph: add the *_client debug macros support
  ceph: pass the mdsc to several helpers
  ceph: rename _to_client() to _to_fs_client()
  ceph: move mdsmap.h to fs/ceph/
  ceph: add ceph_inode_to_client() helper support
  ceph: print the client global_id in all the debug logs

 fs/ceph/acl.c                       |   6 +-
 fs/ceph/addr.c                      | 307 ++++++-----
 fs/ceph/cache.c                     |   2 +-
 fs/ceph/caps.c                      | 805 ++++++++++++++++------------
 fs/ceph/crypto.c                    |  44 +-
 fs/ceph/debugfs.c                   |  10 +-
 fs/ceph/dir.c                       | 241 +++++----
 fs/ceph/export.c                    |  52 +-
 fs/ceph/file.c                      | 283 ++++++----
 fs/ceph/inode.c                     | 547 +++++++++++--------
 fs/ceph/ioctl.c                     |  21 +-
 fs/ceph/locks.c                     |  60 ++-
 fs/ceph/mds_client.c                | 646 ++++++++++++----------
 fs/ceph/mds_client.h                |   5 +-
 fs/ceph/mdsmap.c                    |  29 +-
 {include/linux => fs}/ceph/mdsmap.h |   5 +-
 fs/ceph/metric.c                    |   5 +-
 fs/ceph/quota.c                     |  29 +-
 fs/ceph/snap.c                      | 199 ++++---
 fs/ceph/super.c                     |  92 ++--
 fs/ceph/super.h                     |  19 +-
 fs/ceph/xattr.c                     | 110 ++--
 include/linux/ceph/ceph_debug.h     |  44 +-
 23 files changed, 2088 insertions(+), 1473 deletions(-)
 rename {include/linux => fs}/ceph/mdsmap.h (92%)

-- 
2.40.1

