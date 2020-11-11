Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0482AE5D5
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 02:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbgKKB3x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 20:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKKB3v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 20:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605058190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QULby5zRWj74lCpMnMEpEXd5zCLdUHoG6vfbLjcEJJs=;
        b=gGV0p3oIozi+zafX1ASJTDnzTuS9Vu+WMtsrXNZDBIBAAJ08x/sFyaOHN3WFGX0QU//sQD
        ZzZx8j82JV4BLsa4TiwBES2o9RdVsjxz7qBSKLADIQBRgDFWdOAXLZ8CfQ1xscVPZUA/Mq
        PcP4sdO8iJ8uhGDR+adeEAbIW+I/oYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-7cQcjPhnOVKrsXP9dL0ryw-1; Tue, 10 Nov 2020 20:29:48 -0500
X-MC-Unique: 7cQcjPhnOVKrsXP9dL0ryw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C158803F6A;
        Wed, 11 Nov 2020 01:29:47 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7D075132;
        Wed, 11 Nov 2020 01:29:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2] ceph: add vxattrs to get ids and status debug file support
Date:   Wed, 11 Nov 2020 09:29:38 +0800
Message-Id: <20201111012940.468289-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V4:
- s/bloclisted/blocklisted/
- rename clientid to client_id
- rename clusterid to cluster_fsid
- rename "inst_str" to "instance"
- rename ceph_vxattrs to ceph_common_vxattrs

V3:
- switch ioctl to vxattr.

V2:
- some typo fixings
- switch to use ceph_client_gid() and ceph_client_addr() helpers
- for ioctl cmd will return in text for cluster/client ids

Xiubo Li (2):
  ceph: add status debug file support
  ceph: add ceph.{cluster_fsid/client_id} vxattrs suppport

 fs/ceph/debugfs.c | 20 ++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 fs/ceph/xattr.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

-- 
2.27.0

