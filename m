Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752EC1E34D7
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 03:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgE0Bms (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 May 2020 21:42:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725801AbgE0Bms (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 May 2020 21:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590543767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=G+TnoTC7+pqsgRaNWiLgWtxMh3t0rMMQulbRHmwNI9o=;
        b=czf8yY3Sf3sk0WXoPruaKRLo4VAFRGGV8uUl2x/zR3twccQma5TdPrJDiTlC/FndiWCt7H
        SDzPj4gkxP+HIEMqMb6TVHqgzVaFznua/LWpJujl9TEtDtU86yrYsDb4Mx/Vj1LlyNSivt
        iEJ+Np0B8CizXoL3KJsDUm/pYXvkAGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-zN9VViaSNl2Cz_FBRC3d8A-1; Tue, 26 May 2020 21:42:44 -0400
X-MC-Unique: zN9VViaSNl2Cz_FBRC3d8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 951EB107ACF5;
        Wed, 27 May 2020 01:42:43 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7462C60C47;
        Wed, 27 May 2020 01:42:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: fix dead lock and double lock
Date:   Tue, 26 May 2020 21:42:34 -0400
Message-Id: <1590543756-26773-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V2:
- do not check the caps when reconnecting to mds
- switch ceph_async_check_caps() to ceph_async_put_cap_refs()

Changed in V3:
- fix putting the cap refs leak

By adding the put_cap_refs's queue work we can avoid the 'mdsc->mutex' and
'session->s_mutex' double lock issue and also the dead lock issue of them.
There at least 10+ places have the above issues and most of them are caused
by calling the ceph_mdsc_put_request() when releasing the 'req'.

Xiubo Li (2):
  ceph: add ceph_async_put_cap_refs to avoid double lock and deadlock
  ceph: do not check the caps when reconnecting to mds

 fs/ceph/caps.c       | 98 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ceph/dir.c        |  2 +-
 fs/ceph/file.c       |  2 +-
 fs/ceph/inode.c      |  3 ++
 fs/ceph/mds_client.c | 14 +++++---
 fs/ceph/mds_client.h |  3 +-
 fs/ceph/super.h      |  7 ++++
 7 files changed, 110 insertions(+), 19 deletions(-)

-- 
1.8.3.1

