Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D936E2AD87B
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgKJORW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 09:17:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729898AbgKJORW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 09:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605017841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PAQsBSQ0Ap88+sVn15coGR7//7cpIu+2qe62yBQkXBw=;
        b=AbOuwypTM5M3MCON5u9HimfyhJQ81Wg1MwfnZTMjN7JNXrwq9TSg9e2um7G8HTGjOU8IZx
        rVXH9LLxx5825ecs6xvhf/Xs6Esf/wF0wEVHm+zoW1m6Kgs/Ko4Yj1wm8TpVU2R+EjYLFP
        DTOziJssuqGv90r2GWRSInVDGRFKhpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-ub8RGFuFNH-NqmObXeUcLw-1; Tue, 10 Nov 2020 09:17:16 -0500
X-MC-Unique: ub8RGFuFNH-NqmObXeUcLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF4676D24F;
        Tue, 10 Nov 2020 14:17:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A48C4149;
        Tue, 10 Nov 2020 14:17:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: add vxattrs to get ids and status debug file support
Date:   Tue, 10 Nov 2020 22:17:01 +0800
Message-Id: <20201110141703.414211-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V3:
- switch ioctl to vxattr.

V2:
- some typo fixings
- switch to use ceph_client_gid() and ceph_client_addr() helpers
- for ioctl cmd will return in text for cluster/client ids

Xiubo Li (2):
  ceph: add status debug file support
  ceph: add ceph.{clusterid/clientid} vxattrs suppport

 fs/ceph/debugfs.c | 20 ++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 fs/ceph/xattr.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

-- 
2.27.0

